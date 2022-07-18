<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="ru">
    <head>
        <meta charset="UTF-8">
        <title>Турнирная таблица</title>
        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    </head>
    <body class="w3-light-grey">
        <div class="w3-container w3-blue-grey w3-opacity w3-right-align">
            <h1>Турнирная таблица</h1>
        </div>

        <div class="w3-container w3-left-align w3-blue-grey">
            <h2>Вход или регистрация</h2>
        </div>

        <div class="w3-container w3-padding">
            <form method="post" class="w3-selection w3-light-grey w3-padding">
                <label>Логин:
                    <input type="text" name="login"
                        value=
                            <%
                                if (request.getAttribute("login") != null) {
                                    out.print("\"" + request.getAttribute("login") + "\"");
                                } else {
                                    out.print("\"\"");
                                }
                            %>
                        class="w3-input w3-border w3-round-large" style="width: 30%">
                </label>
                <br>
                <label>Пароль:
                    <input type="text" name="password"
                        value=
                            <%
                                if (request.getAttribute("password") != null) {
                                    out.print("\"" + request.getAttribute("password") + "\"");
                                } else {
                                    out.print("\"\"");
                                }
                            %>
                        class="w3-input w3-border w3-round-large" style="width: 30%">
                </label>
                <br>
                <button class="w3-btn w3-green w3-round-large w3-margin-bottom"
                        onclick="location.href='/standings-1.0/'">Войти
                </button>
                <button class="w3-btn w3-green w3-round-large w3-margin-bottom"
                        onclick="location.href='/standings-1.0/'">Войти без логина
                </button>
                <button class="w3-btn w3-green w3-round-large w3-margin-bottom"
                        type="submit"
                        name="buttonChoice" value="registration">Регистрация
                </button>
            </form>
        </div>

        <%
            if (request.getAttribute("firstExistLoginCallOver") != null) {
                if (request.getAttribute("login") == "") {
                    out.println(
                            "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                    "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                    "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                    "<h5>Логин обязателен для заполнения</h5>\n" +
                            "</div>"
                    );
                }
                if (request.getAttribute("password") == "") {
                    out.println(
                            "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                    "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                    "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                    "<h5>Пароль обязателен для заполнения</h5>\n" +
                            "</div>"
                    );
                }
                if (request.getAttribute("userPassed") != null) {
                    if (request.getAttribute("userPassed") == "OK") {
                        out.println(
                                "<div class=\"w3-panel w3-green w3-display-container w3-card-4 w3-round\">\n" +
                                        "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                        "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                        "<h5>Вход выполнен</h5>\n" +
                                "</div>"
                        );
                    }
                    if (request.getAttribute("userPassed") == "UserIsNotExist") {
                        out.println(
                                "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                        "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                        "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                        "<h5>Неверный логин или пароль</h5>\n" +
                                "</div>"
                        );
                    }
                    if (request.getAttribute("userPassed") == "Error") {
                        out.println(
                                "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                        "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                        "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                        "<h5>Произошла системная ошибка</h5>\n" +
                                "</div>"
                        );
                    }
                }
            }
        %>
    </body>
</html>
