<%@ page import="logistics.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!user.getRole().equals("manager") && !user.getRole().equals("admin"))) {
        response.sendRedirect("MainServlet?action=dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Создание заказа | Zelenov Logistics</title>
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
                <p class="eyebrow">Новый заказ</p>
                <h1>Создать заказ на перевозку</h1>
                <p class="subtitle">Опишите задачу так, чтобы менеджеру и водителю было понятно, что нужно перевезти.</p>
            </div>
            <span class="user-badge"><%= user.getRole() %></span>
        </header>

        <section class="panel">
            <form class="form-grid" action="MainServlet?action=createOrder" method="post">
                <div>
                    <label for="description">Описание заказа</label>
                    <textarea id="description" name="description" rows="5" required></textarea>
                </div>
                <div class="actions">
                    <button type="submit">Создать заказ</button>
                    <a class="btn btn-secondary" href="MainServlet?action=dashboard">Назад</a>
                </div>
            </form>
        </section>
    </main>
</body>
</html>
