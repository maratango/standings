package org.xcompany.xprojects.servlets;

import org.apache.commons.lang3.StringUtils;
import org.xcompany.xprojects.hibernateDao.UserHibernateDao;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ExistLoginServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		RequestDispatcher requestDispatcher = req.getRequestDispatcher("/index.jsp");
		requestDispatcher.forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// кнопка Регистрация нажата, переадресация на страницу регистрации пользователя
		if (StringUtils.equals(req.getParameter("buttonChoice"), "registration")) {
			resp.sendRedirect(req.getContextPath() + "/regLogin");
			return;
		}

		// первое нажатие кнопки, кроме "Регистрация", на странице произошло
		req.setAttribute("firstExistLoginCallOver", true);

		// извлекаем-записываем введенные, в поля страницы, значения
		String login = req.getParameter("login");
		String password = req.getParameter("password");
		req.setAttribute("login", login);
		req.setAttribute("password", password);

		// возврат на текущую страницу если логин или пароль пустые
		if (StringUtils.isEmpty(login) || StringUtils.isEmpty(password)) {
			doGet(req, resp);
			return;
		}

		// выполнение запроса в бд - получение результата проверки существования логина-пароля
		String userPassResult = UserHibernateDao.getInstance().checkAndPass(login, password);
		req.setAttribute("userPassed", userPassResult);

		// возврат на текущую страницу, если такого логина-пароля не нашлось или произошла ошибка при запросе в бд
		if (StringUtils.equals(userPassResult, "UserIsNotExist")
				|| StringUtils.equals(userPassResult, "Error")) {
			doGet(req, resp);
			return;
		}

		//запоним логин-пароль в параметрах сессии, чтоб были доступны на странице переадресации
		HttpSession session = req.getSession();
		session.setAttribute("login", login);
		session.setAttribute("password", password);
		// переадресация на страницу "список турниров пользотваеля", если проверка логина-пароля успешна
		resp.sendRedirect(req.getContextPath() + "/userTurnsList");

	}
}
