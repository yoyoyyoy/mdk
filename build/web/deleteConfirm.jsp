<%@ page import="logistics.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User current = (User) session.getAttribute("user");
    if (current == null || !current.getRole().equals("admin")) {
        response.sendRedirect("MainServlet?action=dashboard");
        return;
    }
    User userToDelete = (User) request.getAttribute("userToDelete");
    if (userToDelete == null) {
        response.sendRedirect("MainServlet?action=manageUsers");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Удаление пользователя | Zelenov Logistics</title>
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
                <p class="eyebrow">Подтверждение</p>
                <h1>Удалить пользователя?</h1>
                <p class="subtitle">Это действие нельзя отменить. Проверьте данные перед удалением.</p>
            </div>
            <span class="user-badge">Администратор</span>
        </header>

        <section class="panel">
            <div class="info-box">
                <p><strong>ФИО:</strong> <%= userToDelete.getFullName() %></p>
                <p><strong>Логин:</strong> <%= userToDelete.getLogin() %></p>
                <p><strong>Роль:</strong> <%= userToDelete.getRole() %></p>
                <p><strong>ID:</strong> <%= userToDelete.getId() %></p>
            </div>
            <p class="subtitle">Вы уверены, что хотите удалить этого пользователя?</p>
            <div class="actions">
                <form action="MainServlet?action=deleteUser" method="post">
                    <input type="hidden" name="id" value="<%= userToDelete.getId() %>">
                    <button type="submit" class="btn-danger">Удалить</button>
                </form>
                <a class="btn btn-secondary" href="MainServlet?action=manageUsers">Отмена</a>
            </div>
        </section>
    </main>
</body>
</html>
