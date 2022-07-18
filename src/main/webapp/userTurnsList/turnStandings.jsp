<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Турнирная таблица</title>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body class="w3-light-grey">
<div class="w3-container w3-blue-grey w3-opacity w3-right-align">
    <h1>Чемпионат по футболу</h1>
</div>
<div class="w3-container w3-grey w3-opacity w3-right-align w3-padding">
    <button class="w3-btn w3-round-large" onclick="location.href='/standings-1.0/userTurnsList'">Назад</button>
    <button class="w3-btn w3-round-large" onclick="location.href='/standings-1.0'">На главную</button>
</div>
<div class="w3-container w3-center w3-margin-bottom w3-padding">
    <div class="w3-card-4">
        <div class="w3-container w3-light-blue">
            <h2>
                Турнирная таблица
            </h2>
        </div>
        <%
            if (request.getAttribute("selectTurnStandingsIsError") != null) {
                out.println(
                    "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                        "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                        "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                        "<h5>При запросе турнирной таблицы произошла системная ошибка</h5>\n" +
                    "</div>"
                );
            } else {
                out.println(
                        "\t\t<table border=\"2\" frame=\"border\" rules=\"all\" cellspacing=\"1\" cellpadding=\"2\" summary=\"Турнирная таблица АПЛ\">\n" +
                                "\t\t\t<col width=\"2%\">\n" +
                                "\t\t\t<col width=\"26%\">\n" +
                                "\t\t\t<col span=\"8\" width=\"9%\" bgcolor=\"#add8e6\">\n" +
                                "\t\t\t<tr>\n" +
                                "\t\t\t\t<th>место</th><th>команда</th><th>матчи</th><th>очки</th><th>победы</th><th>ничьи</th><th>поражения</th><th>голы забитые</th><th>голы пропущенные</th><th>разница голов</th>\t\t\t\n" +
                                "\t\t\t</tr>"
                );

                //запоминаем атрибут запроса turnPositions - список объектов "строки результата селекта"
                List<Object[]> turnTable = (List<Object[]>) request.getAttribute("turnPositions");
                int pos = 0;

                for (Object[] s : turnTable) {
                    pos++;
                    out.println(
                            "\t\t\t<tr>\n" +
                            "\t\t\t\t<td>" + pos + "</td>\n" +
                            "\t\t\t\t<td>" + s[0] + "</td>\n" +
                            "\t\t\t\t<td>" + s[1] + "</td>\n" +
                            "\t\t\t\t<td>" + s[2] + "</td>\n" +
                            "\t\t\t\t<td>" + s[3] + "</td>\n" +
                            "\t\t\t\t<td>" + s[4] + "</td>\n" +
                            "\t\t\t\t<td>" + s[5] + "</td>\n" +
                            "\t\t\t\t<td>" + s[6] + "</td>\n" +
                            "\t\t\t\t<td>" + s[7] + "</td>\n" +
                            "\t\t\t\t<td>" + s[8] + "</td>\n" +
                            "\t\t\t</tr>"
                    );
                }
                out.println("\t\t</table>");
            }
        %>
    </div>
</div>

<div class="w3-container w3-left-align w3-light-grey">
    <div class="w3-container w3-left-align w3-light-green">
        <label>Добавление матчей:</label>
    </div>
    <div class="w3-container w3-left-align w3-light-grey">
        <form method="post">
            <input type="text" name="newMatchDesc"
                value =
                    <%
                        if (request.getAttribute("matchAddResult") != "OK" && request.getParameter("newMatchDesc") != null) {
                            out.print("\"" + request.getParameter("newMatchDesc") + "\"");
                        } else {
                            out.print("\"\"");
                        }
                    %>
                class="w3-border" style="width: 30%">
            <button type="submit" name="buttonChoice" value="addNewMatch" class="w3-btn w3-light-blue w3-round-large">Добавить матч</button>
        </form>
        <form method="post" enctype="multipart/form-data">
            <input type="file" name="loadfile" style="width: 30%">
            <button type="submit" class="w3-btn w3-blue w3-round-large">Добавить матчи из файла</button>
        </form>

        <%
            if (request.getAttribute("matchAddResult") != null) {
                if (request.getAttribute("matchAddResult") == "OK") {
                    out.println(
                            "<div class=\"w3-panel w3-green w3-display-container w3-card-4 w3-round\">\n" +
                                    "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                    "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                    "<h5>Матч '" + request.getParameter("newMatchDesc") + "' добавлен</h5>\n" +
                            "</div>"
                    );
                } else if (request.getAttribute("matchAddResult") == "matchDescIsInvalid") {
                    out.println(
                            "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                    "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                    "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                    "<h5>Матч '" + request.getParameter("newMatchDesc") + "' не соответствует шаблону 'команда_1 голы_1:голы_2 команда_2'</h5>\n" +
                            "</div>"
                    );
                } else if (request.getAttribute("matchAddResult") == "Error") {
                    out.println(
                            "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                    "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                    "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                    "<h5>При добавлении матча '" + request.getParameter("newMatchDesc") + "' произошла системная ошибка</h5>\n" +
                            "</div>"
                    );
                }
            }

            if(request.getAttribute("fileName") != null) {
                out.println("<div class=\"w3-panel w3-green w3-display-container w3-card-4 w3-round\">\n" +
                        "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                        "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                        "<h5>Матчи из файла '" + request.getAttribute("fileName") + "' добавлены!</h5>\n" +
                        "</div>");
            }
        %>
    </div>

    <div class="w3-container">
        <div class="w3-container w3-left-align w3-light-green">
            <label>Матчи турнира:</label>
        </div>
        <br>
        <div class="w3-container w3-left-align w3-light-grey">
            <%
                if (request.getAttribute("selectTurnMatchesIsError") != null) {
                    out.println(
                            "<div class=\"w3-panel w3-red w3-display-container w3-card-4 w3-round\">\n" +
                                    "<span onclick=\"this.parentElement.style.display='none'\"\n" +
                                    "class=\"w3-button w3-margin-right w3-display-right w3-round-large w3-hover-green w3-border w3-border-green w3-hover-border-grey\">×</span>\n" +
                                    "<h5>При запросе матчей турнира произошла системная ошибка</h5>\n" +
                            "</div>"
                    );
                } else if (request.getAttribute("turnMatches") != null) {
                    out.println("<form method=\"post\">\n");
                        List<Object[]> turnMatches = (List<Object[]>) request.getAttribute("turnMatches");
                        for (Object[] matcheDesc : turnMatches) {
                            out.println(
                                "<label>" + matcheDesc[0] + "</label>\n"
                            );
                            out.println(
                                "<button class=\"w3-btn w3-red w3-round-large\"\n" +
                                "type=\"submit\"" +
                                "name=\"matcheIdForDelete\" value=\"" + matcheDesc[1] + "\">\n" +
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
                                "<h5>У турнира нет сохранённых матчей</h5>\n" +
                            "</div>"
                    );
                }
            %>
        </div>
    </div>

</div>
</body>
</html>