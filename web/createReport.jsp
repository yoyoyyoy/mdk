<%@ page import="logistics.User" %>
<%@ page import="logistics.MainServlet.Order" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!user.getRole().equals("manager") && !user.getRole().equals("admin"))) {
        response.sendRedirect("MainServlet?action=dashboard");
        return;
    }
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Отчет по заказам | Zelenov Logistics</title>
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
                <p class="eyebrow">Отчетность</p>
                <h1>Отчет по заказам</h1>
                <p class="subtitle">Сводная таблица всех перевозок с водителями, авторами и текущими статусами.</p>
            </div>
            <span class="user-badge"><%= user.getRole() %></span>
        </header>

        <section class="panel">
            <% if (orders != null && !orders.isEmpty()) { %>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Описание</th>
                                <th>Статус</th>
                                <th>Водитель</th>
                                <th>Создал</th>
                                <th>Дата создания</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order o : orders) { %>
                                <tr>
                                    <td><%= o.getId() %></td>
                                    <td><%= o.getDescription() %></td>
                                    <td><span class="status-pill"><%= o.getStatus() %></span></td>
                                    <td><%= o.getDriverName() != null ? o.getDriverName() : "не назначен" %></td>
                                    <td><%= o.getCreatorName() %></td>
                                    <td><%= o.getCreatedAt() %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="empty-state">Заказов пока нет.</div>
            <% } %>
            <div class="actions">
                <a class="btn btn-secondary" href="MainServlet?action=dashboard">Назад</a>
            </div>
        </section>
    </main>
</body>
</html>
