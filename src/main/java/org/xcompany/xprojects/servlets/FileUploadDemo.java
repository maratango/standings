package org.xcompany.xprojects.servlets;

import jdk.nashorn.internal.objects.annotations.Getter;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.xcompany.xprojects.entities.fileReader;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.util.Iterator;
import java.util.List;

import static java.nio.file.Files.createTempDirectory;

public class FileUploadDemo extends HttpServlet {

	static final int fileMaxSize = 100 * 1024;
	static final int memMaxSize = 100 * 1024;

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        PrintWriter writer = resp.getWriter();
//        writer.println("Method GET from FileUploadDemo");

		RequestDispatcher requestDispatcher = req.getRequestDispatcher("viewlar/fileupload.jsp");
		requestDispatcher.forward(req, resp);

	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		//кодировка запроса и ответа
		resp.setCharacterEncoding("UTF-8");
		req.setCharacterEncoding("UTF-8");

		//сообщаем тип ответа
		resp.setContentType("text/html");

		//получаем объект "писальщик"
		PrintWriter writer = resp.getWriter();

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
					req.setAttribute("fileName", fileName);

					//создание временного файла, запись в него загруженного файла
					File file = File.createTempFile("tmp_", ".txt", tmpDirectory.toFile());
					fileItem.write(file);

					//чтение
					new fileReader().readFileWriteBD(file);

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

		//передаём управление с наполненным запросом и ответом в метод, для вывода вьюхи
		doGet(req, resp);

	}

}
