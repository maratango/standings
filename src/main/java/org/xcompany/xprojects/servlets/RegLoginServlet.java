package org.xcompany.xprojects.servlets;

import org.apache.commons.lang3.StringUtils;
import org.xcompany.xprojects.entities.User;
import org.xcompany.xprojects.hibernateDao.UserHibernateDao;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class RegLoginServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        PrintWriter writer = resp.getWriter();
//        writer.println("Method GET from AddServlet");

		RequestDispatcher requestDispatcher = req.getRequestDispatcher("/viewlar/regLogin.jsp");
		requestDispatcher.forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// первый вызов doPost(нажатие кнопки на странице произошло)
		req.setAttribute("firstRegLoginCallOver", true);
		//извлекаем-записываем введенные, в поля страницы, значения
		String login = req.getParameter("login");
		String password = req.getParameter("password");
		String mail = req.getParameter("email");
		req.setAttribute("login", login);
		req.setAttribute("password", password);
		req.setAttribute("email", mail);
		// возврат на текущую страницу если логин или пароль пустые
		if (StringUtils.isEmpty(login) || StringUtils.isEmpty(password)) {
			doGet(req, resp);
			return;
		}
		// выполнение запроса в бд и возврат ответа на страницу
		String userRegisterResult = UserHibernateDao.getInstance().create(login, password, mail);
		req.setAttribute("userRegistered", userRegisterResult);
		doGet(req, resp);
	}
}
