<%@ page import="logistics.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User current = (User) session.getAttribute("user");
    if (current == null || !current.getRole().equals("admin")) {
        response.sendRedirect("MainServlet?action=dashboard");
        return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Пользователи | Zelenov Logistics</title>
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
                <p class="eyebrow">Администрирование</p>
                <h1>Пользователи</h1>
                <p class="subtitle">Список сотрудников, которым доступна система управления перевозками.</p>
            </div>
            <span class="user-badge">Администратор</span>
        </header>

        <section class="panel">
            <% if (users != null && !users.isEmpty()) { %>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>ФИО</th>
                                <th>Логин</th>
                                <th>Роль</th>
                                <th>Действие</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User u : users) { %>
                                <tr>
                                    <td><%= u.getId() %></td>
                                    <td><%= u.getFullName() %></td>
                                    <td><%= u.getLogin() %></td>
                                    <td><span class="role-pill"><%= u.getRole() %></span></td>
                                    <td>
                                        <% if (u.getId() != current.getId()) { %>
                                            <a href="MainServlet?action=showDelete&id=<%= u.getId() %>" class="delete-btn">Удалить</a>
                                        <% } else { %>
                                            <span class="muted">Текущий пользователь</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="empty-state">Пользователей пока нет.</div>
            <% } %>
            <div class="actions">
                <a class="btn btn-secondary" href="MainServlet?action=dashboard">Назад</a>
            </div>
        </section>
    </main>
</body>
</html>
