<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.Cookie,java.net.URLDecoder" %>
<%!
    private String cookieValue(Cookie[] cookies, String name) throws Exception {
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) return URLDecoder.decode(cookie.getValue(), "UTF-8");
            }
        }
        return "";
    }
    private String esc(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<%
    String userName = cookieValue(request.getCookies(), "lab7.userName");
    String pageColor = cookieValue(request.getCookies(), "lab7.pageColor");
    if (pageColor.isEmpty()) pageColor = "white";
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Данные пользователя</title>
    <link rel="stylesheet" href="style.css">
</head>
<body style="background-color: <%= esc(pageColor) %>">
<main>
    <h1>Данные пользователя</h1>
    <p>Здравствуйте, <strong><%= esc(userName) %></strong>.</p>
    <h2>Cookie браузера</h2>
    <table>
        <tr><th>Имя Cookie</th><th>Значение</th></tr>
        <tr><td>lab7.userName</td><td><%= esc(userName) %></td></tr>
        <tr><td>lab7.pageColor</td><td><%= esc(pageColor) %></td></tr>
    </table>
    <h2>Параметры текущей сессии</h2>
    <table>
        <tr><th>Параметр</th><th>Значение</th></tr>
        <tr><td>Количество обращений</td><td><%= session.getAttribute("visitCount") %></td></tr>
        <tr><td>Дата последнего обращения</td><td><%= session.getAttribute("lastVisit") %></td></tr>
        <tr><td>Идентификатор сессии</td><td><%= session.getId() %></td></tr>
    </table>
    <p class="note">Cookie хранится 7 дней. Данные сессии доступны до окончания сессии или 30 минут бездействия.</p>
    <a class="link-button" href="index.jsp">Изменить параметры</a>
</main>
</body>
</html>
