package org.xcompany.xprojects.servlets;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang3.StringUtils;
import org.xcompany.xprojects.entities.fileReader;
import org.xcompany.xprojects.hibernateDao.UserHibernateDao;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

import static java.nio.file.Files.createTempDirectory;

public class TurnStandingsServlet extends HttpServlet {

	static final int fileMaxSize = 100 * 1024;
	static final int memMaxSize = 100 * 1024;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// извлекаем логин-пароль, название турнира из сессии
		HttpSession session = req.getSession();
		String login = (String) session.getAttribute("login");
		String password = (String) session.getAttribute("password");
		String turnName = (String) session.getAttribute("turnName");

		// выполнение запроса в бд - получение отсортированного списка строк "команда, очки, голы и т.д"
		Object turnTable = new UserHibernateDao().selectTurnStandings(turnName, login, password);
		if (turnTable instanceof String
				&& StringUtils.equals((String) turnTable, "Error")) {
			req.setAttribute("selectTurnStandingsIsError", "Error");
		} else {
			req.setAttribute("turnPositions", turnTable);
		}

		// выполнение запроса в бд - получение списка матчей
		Object turnMatchesFromBd = new UserHibernateDao().selectTurnMatches(turnName, login, password);
		if (turnMatchesFromBd instanceof String
				&& StringUtils.equals((String) turnMatchesFromBd, "Error")) {
			req.setAttribute("selectTurnMatchesIsError", "Error");
		} else if (CollectionUtils.isNotEmpty((List<Object[]>) turnMatchesFromBd)) {
			List<Object[]> turnMatches = new ArrayList<>();
			int i = 0;
			for (Object[] matcheFromBd : (List<Object[]>) turnMatchesFromBd) {
				Object[] matche = new Object[2];
				matche[0] = matcheFromBd[1] + " " + matcheFromBd[2] +
						":" + matcheFromBd[4] + " " + matcheFromBd[3];
				matche[1] = matcheFromBd[0];
				turnMatches.add(matche);
			}
			req.setAttribute("turnMatches", turnMatches);
		}

		RequestDispatcher requestDispatcher = req.getRequestDispatcher("turnStandings.jsp");
		requestDispatcher.forward(req, resp);

	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// извлекаем логин-пароль из сессии
		HttpSession session = req.getSession();
		String login = (String) session.getAttribute("login");
		String password = (String) session.getAttribute("password");
		String turnName = (String) session.getAttribute("turnName");

		//сценарий "добвален новый матч":
		if (StringUtils.equals(req.getParameter("buttonChoice"), "addNewMatch")) {
			// извлекаем "данные матча" из запроса к странице
			String newMatchDesc = req.getParameter("newMatchDesc");
			// проверяем "данные матча" на соответствие шаблону
			if (newMatchDesc.matches("^.+\\s\\d{1,2}:\\d{1,2}\\s.+$")) {
				// выполняем запрос в бд по добавлению нового матча, записываем результат
				String matchAddResult = new UserHibernateDao().addNewTurnMatch(newMatchDesc, turnName, login, password);
				req.setAttribute("matchAddResult", matchAddResult);
			} else {
				req.setAttribute("matchAddResult", "matchDescIsInvalid");
			}
			// возврат на страницу
			doGet(req, resp);
			return;
		}

		//сценари "удален матч"
		String matcheIdForDelete = req.getParameter("matcheIdForDelete");
		if (StringUtils.isNotEmpty(matcheIdForDelete)) {
			// выполняем запрос в бд по удалению выбранного турнира
			new UserHibernateDao().deleteTurnMatch(Integer.valueOf(matcheIdForDelete));
			// возврат на страницу
			doGet(req, resp);
			return;
		}

		//сценарий "добвалены новые матчи из файла"(вывод сообщений об ошибках не сделан):
		{
			List<Object[]> matchesFromFile = readFileAndWriteMatchesToBd(req, resp);
			if (CollectionUtils.isNotEmpty(matchesFromFile)) {
				for (Object[] matcheFromFile : matchesFromFile) {
					String newMatchDesc = matcheFromFile[0] + " " + matcheFromFile[1] + ":" +
							matcheFromFile[3] + " " + matcheFromFile[2];
					new UserHibernateDao().addNewTurnMatch(newMatchDesc, turnName, login, password);
				}
			}
			doGet(req, resp);
		}
	}

	public List<Object[]> readFileAndWriteMatchesToBd(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		List<Object[]> matchesFromFile = new ArrayList<>();

		//кодировка запроса и ответа
		resp.setCharacterEncoding("UTF-8");
		req.setCharacterEncoding("UTF-8");
		//сообщаем тип ответа
		resp.setContentType("text/html");
		//временная директория для хранения загруженных файлов
		Path tmpDirectory = createTempDirectory("tmp_");
		//создаём объекты для дальнейшей магии
		DiskFileItemFactory diskFileItemFactory = new DiskFileItemFactory();
		diskFileItemFactory.setRepository(tmpDirectory.toFile());
		diskFileItemFactory.setSizeThreshold(memMaxSize);
		ServletFileUpload upload = new ServletFileUpload(diskFileItemFactory);
		upload.setSizeMax(fileMaxSize);

		//магия с згрузкой файла
		try {
			List fileItems = upload.parseRequest(req);
			Iterator iterator = fileItems.iterator();

			while (iterator.hasNext()) {
				FileItem fileItem = (FileItem) iterator.next();
				if (!fileItem.isFormField()) {
					//создать атрибут fileName запроса и записать в него значение - имя загруженного файла
					String fileName = fileItem.getName();
					if (StringUtils.isEmpty(fileName)) {
						continue;
					}
					req.setAttribute("fileName", fileName);
					//создание временного файла, запись в него загруженного файла
					File file = File.createTempFile("tmp_", ".txt", tmpDirectory.toFile());
					fileItem.write(file);
					//чтение файла и запись результатов в бд
					Scanner sc = new Scanner(file);
					while (sc.hasNext()) {
						Object[] matcheFromFile = new Object[4];
						matcheFromFile[0] = sc.next();
						matcheFromFile[1] = sc.nextInt();
						matcheFromFile[2] = sc.next();
						matcheFromFile[3] = sc.nextInt();
						matchesFromFile.add(matcheFromFile);
					}
					//удаление временного файла(что то не работает)
					file.deleteOnExit();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			//удаление временной директории(что то не работает)
			tmpDirectory.toFile().deleteOnExit();
		}

		return matchesFromFile;
	}
}
