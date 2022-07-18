package org.xcompany.xprojects.servlets;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.xcompany.xprojects.hibernateDao.UserHibernateDao;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class UserTurnsListServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// извлекаем-записываем логин-пароль
		HttpSession session = req.getSession();
		String login = (String) session.getAttribute("login");
		String password = (String) session.getAttribute("password");

		// выполнение запроса в бд - получение списка турниров пользователя
		Object selectTurnsListResult = UserHibernateDao.getInstance().selectUserTurnsList(login, password);
		if (selectTurnsListResult instanceof String
				&& StringUtils.equals((String) selectTurnsListResult, "Error")) {
			req.setAttribute("selectTurnsIsError", "Error");
		} else if (CollectionUtils.isNotEmpty((List<Object>) selectTurnsListResult)) {
			req.setAttribute("turnsList", selectTurnsListResult);
		}

		RequestDispatcher requestDispatcher = req.getRequestDispatcher("/viewlar/userTurnsList.jsp");
		requestDispatcher.forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// извлекаем логин-пароль из сессии
		HttpSession session = req.getSession();
		String login = (String) session.getAttribute("login");
		String password = (String) session.getAttribute("password");

		//сценарий "добвален новый турнир":
		if (StringUtils.equals(req.getParameter("buttonChoice"), "addNewTurn")) {
			// извлекаем название турнира из запроса к странице
			String newTurnName = req.getParameter("newTurnName");
			if (StringUtils.isNotEmpty(newTurnName)) {
				// выполняем запрос в бд по добавлению нового турнира, записываем результат
				String turnAddResult = UserHibernateDao.getInstance().addNewUserTurnament(newTurnName, login, password);
				req.setAttribute("turnAddResult", turnAddResult);
			}
			// возврат на страницу
			doGet(req, resp);
			return;
		}

		//сценари "удален турнир"
		String turnNameForDelete = req.getParameter("turnNameForDelete");
		if (StringUtils.isNotEmpty(turnNameForDelete)) {
			// выполняем запрос в бд по удалению выбранного турнира
			UserHibernateDao.getInstance().deleteUserTurn(turnNameForDelete, login, password);
			// возврат на страницу
			doGet(req, resp);
			return;
		}

		//сценарий "выбран турнир из списка":
		// извлекаем название турнира из запроса
		String turnName = req.getParameter("turnName");
		// записываем название турнира в сессию
		session.setAttribute("turnName", turnName);

		// переадресация на страницу "Таблица по туринру"
		resp.sendRedirect(req.getContextPath() + "/userTurnsList/turnStandings");
	}
}
