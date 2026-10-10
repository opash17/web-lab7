<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.Cookie,java.net.URLDecoder,java.net.URLEncoder,java.time.LocalDateTime,java.time.format.DateTimeFormatter" %>
<%!
    private String cookieValue(Cookie[] cookies, String name) throws Exception {
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) {
                    return URLDecoder.decode(cookie.getValue(), "UTF-8");
                }
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
    request.setCharacterEncoding("UTF-8");
    String savedName = cookieValue(request.getCookies(), "lab7.userName");
    String savedColor = cookieValue(request.getCookies(), "lab7.pageColor");
    if (savedColor.isEmpty()) savedColor = "lightblue";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("userName");
        String color = request.getParameter("pageColor");
        if (name == null || name.trim().isEmpty() || color == null || color.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Заполните имя и выберите цвет страницы");
            return;
        }
        name = name.trim();
        Cookie nameCookie = new Cookie("lab7.userName", URLEncoder.encode(name, "UTF-8"));
        Cookie colorCookie = new Cookie("lab7.pageColor", URLEncoder.encode(color, "UTF-8"));
        nameCookie.setMaxAge(7 * 24 * 60 * 60);
        colorCookie.setMaxAge(7 * 24 * 60 * 60);
        nameCookie.setPath(request.getContextPath() + "/");
        colorCookie.setPath(request.getContextPath() + "/");
        response.addCookie(nameCookie);
        response.addCookie(colorCookie);

        Integer visits = (Integer) session.getAttribute("visitCount");
        session.setAttribute("visitCount", visits == null ? 1 : visits + 1);
        String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm:ss"));
        session.setAttribute("lastVisit", now);
        response.sendRedirect(response.encodeRedirectURL("result.jsp"));
        return;
    }
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Параметры пользователя</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<main>
    <h1>Параметры пользователя</h1>
    <p>Введите имя и выберите цвет страницы. Значения сохраняются в Cookie, а количество обращений и время последнего обращения — в текущей сессии.</p>
    <form method="post" action="index.jsp">
        <label for="userName">Имя пользователя</label>
        <input id="userName" name="userName" type="text" required value="<%= esc(savedName) %>">

        <label for="pageColor">Цвет страницы с результатом</label>
        <select id="pageColor" name="pageColor">
            <option value="lightblue" <%= "lightblue".equals(savedColor) ? "selected" : "" %>>Голубой</option>
            <option value="lightgreen" <%= "lightgreen".equals(savedColor) ? "selected" : "" %>>Зелёный</option>
            <option value="lightyellow" <%= "lightyellow".equals(savedColor) ? "selected" : "" %>>Жёлтый</option>
            <option value="lavender" <%= "lavender".equals(savedColor) ? "selected" : "" %>>Лавандовый</option>
        </select>
        <button type="submit">Показать данные</button>
    </form>
</main>
</body>
</html>
