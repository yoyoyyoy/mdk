<%@ page import="logistics.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("MainServlet?action=login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Панель управления | Zelenov Logistics</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <main class="container app-shell">
        <header class="app-header">
            <div>
                <div class="brand">
                    <span class="brand-mark">Z</span>
                    <span>Zelenov Logistics</span>
                </div>
                <p class="eyebrow">Панель управления</p>
                <h1>Здравствуйте, <%= user.getFullName() %></h1>
                <p class="subtitle">Выберите действие для работы с перевозками, водителями и отчетами.</p>
            </div>
            <span class="user-badge">Роль: <%= user.getRole() %></span>
        </header>

        <section class="panel">
            <nav class="menu" aria-label="Основные действия">
                <a href="MainServlet?action=dashboard">Главная</a>
                <%
                    String role = user.getRole();
                    if (role.equals("manager") || role.equals("admin")) {
                %>
                    <a href="MainServlet?action=createOrder">Создать заказ</a>
                    <a href="MainServlet?action=assignDriver">Назначить водителя</a>
                    <a href="MainServlet?action=createReport">Отчет по заказам</a>
                <%
                    }
                    if (role.equals("driver") || role.equals("manager") || role.equals("admin")) {
                %>
                    <a href="MainServlet?action=updateStatus">Обновить статус</a>
                <%
                    }
                    if (role.equals("admin")) {
                %>
                    <a href="MainServlet?action=manageUsers">Пользователи</a>
                <%
                    }
                %>
                <a href="MainServlet?action=logout">Выйти</a>
            </nav>
        </section>
    </main>
</body>
</html>
