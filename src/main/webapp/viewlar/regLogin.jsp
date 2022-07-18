<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Турнирная таблица</title>
        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    </head>
    <body class="w3-light-grey">
        <div class="w3-container w3-blue-grey w3-opacity w3-left-align">
            <h1>Регистрация нового пользователя</h1>
        </div>

        <div class="w3-container w3-right-align w3-blue-grey">
            <button class="w3-btn w3-round-large" onclick="location.href='/standings-1.0'">Выйти</button>
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
                <label>E-mail:
                    <input type="text" name="email"
                        value=
                            <%
                                if (request.getAttribute("email") != null) {
                                    out.print("\"" + request.getAttribute("email") + "\"");
                                } else {
                                    out.print("\"\"");
                                }
                            %>
                        class="w3-input w3-border w3-round-large" style="width: 30%">
                </label>
                <br>
                <button type="submit" class="w3-btn w3-green w3-round-large w3-margin-bottom">Регистрация</button>
            </form>
        </div>

        <%
            if (request.getAttribute("firstRegLoginCallOver") != null) {
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
                if (request.getAttribute("userRegistered") != null) {
                    if (request.getAttribute("userRegistered") == "OK") {
                        out.println(
                                "<div class=\"w3-panel w3-green w3-display-container w3-card-4 w3-round\">\n" +
                                        "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                        "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                        "<h5>Пользователь зарегистрирован</h5>\n" +
                                "</div>"
                        );
                    }
                    if (request.getAttribute("userRegistered") == "UserIsExist") {
                        out.println(
                                "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                        "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                        "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                        "<h5>Пользователь с таким логином уже существует</h5>\n" +
                                "</div>"
                        );
                    }
                    if (request.getAttribute("userRegistered") == "Error") {
                        out.println(
                                "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                        "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                        "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                        "<h5>При добавлении пользователя произошла системная ошибка</h5>\n" +
                                "</div>"
                        );
                    }
                }
            }
        %>
    </body>
</html>
