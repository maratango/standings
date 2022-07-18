<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Турнирная таблица</title>
        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    </head>
    <body class="w3-light-grey">
        <div class="w3-container w3-blue-grey w3-opacity w3-left-align">
            <h1>Список турниров пользователя</h1>
        </div>

        <div class="w3-container w3-right-align w3-blue-grey">
            <button class="w3-btn w3-round-large" onclick="location.href='/standings-1.0'">Выйти</button>
        </div>

        <div class="w3-container w3-left-align w3-light-grey">
            <form method="post">
                <input type="text" name="newTurnName"
                    value =
                        <%
                            if (request.getAttribute("turnAddResult") != "OK" && request.getParameter("newTurnName") != null) {
                                out.print("\"" + request.getParameter("newTurnName") + "\"");
                            } else {
                                out.print("\"\"");
                            }
                        %>
                    class="w3-border" style="width: 30%">
                <button type="submit" name="buttonChoice" value="addNewTurn" class="w3-btn w3-light-blue w3-round-large">Добавить турнир</button>
                <br>
                <%
                    if (request.getAttribute("turnAddResult") != null) {
                        if (request.getAttribute("turnAddResult") == "OK") {
                            out.println(
                                    "<div class=\"w3-panel w3-green w3-display-container w3-card-4 w3-round\">\n" +
                                            "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                            "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                            "<h5>Турнир " + request.getParameter("newTurnName") + " добавлен</h5>\n" +
                                    "</div>"
                            );
                        } else if (request.getAttribute("turnAddResult") == "TurnIsExist") {
                            out.println(
                                    "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                            "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                            "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                            "<h5>Турнир " + request.getParameter("newTurnName") + " уже существует</h5>\n" +
                                    "</div>"
                            );
                        } else if (request.getAttribute("turnAddResult") == "Error") {
                            out.println(
                                    "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                            "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                            "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                            "<h5>При добавлении турнира " + request.getParameter("newTurnName") + " произошла системная ошибка</h5>\n" +
                                    "</div>"
                            );
                        }
                    }
                %>
            </form>
        </div>

        <div class="w3-container">
                <%
                    if (request.getAttribute("selectTurnsIsError") != null) {
                        out.println(
                                "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                        "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                        "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                        "<h5>Произошла системная ошибка</h5>\n" +
                                "</div>"
                        );
                    } else if (request.getAttribute("turnsList") != null) {
                        out.println("<form method=\"post\">\n");
                            List<Object> turnsList = (List<Object>) request.getAttribute("turnsList");
                            for (Object turn : turnsList) {
                                out.println(
                                    "<button class=\"w3-btn w3-hover-blue w3-round-large\"\n" +
                                    "type=\"submit\"" +
                                    "name=\"turnName\" value=\"" + turn + "\">\n" +
                                        turn + "\n" +
                                    "</button>\n"
                                );
                                out.println(
                                    "<button class=\"w3-btn w3-red w3-round-large\"\n" +
                                    "type=\"submit\"" +
                                    "name=\"turnNameForDelete\" value=\"" + turn + "\">\n" +
                                        "Удалить" + "\n" +
                                    "</button>\n" +
                                    "<br>\n" +
                                    "<label>------------------------------------------------------------</label>\n" +
                                    "<br>\n"
                                );
                            }
                        out.println("</form>\n");
                    } else {
                        out.println(
                                "<div class=\"w3-panel w3-gray w3-display-container w3-card-4 w3-round\">\n" +
                                    "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                    "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                    "<h5>У пользователя нет сохранённых турниров</h5>\n" +
                                "</div>"
                        );
                    }
                %>
        </div>

    </body>
</html>