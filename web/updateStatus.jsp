<%@ page import="logistics.User" %>
<%@ page import="logistics.MainServlet.Order" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("MainServlet?action=login");
        return;
    }
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Обновление статуса | Zelenov Logistics</title>
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
                <p class="eyebrow">Статус заказа</p>
                <h1>Обновить статус заказа</h1>
                <p class="subtitle">Отметьте, что заказ уже в работе или полностью выполнен.</p>
            </div>
            <span class="user-badge"><%= user.getRole() %></span>
        </header>

        <section class="panel">
            <form class="form-grid" action="MainServlet?action=updateStatus" method="post">
                <div>
                    <label for="orderId">Заказ</label>
                    <select id="orderId" name="orderId" required>
                        <% if (orders != null && !orders.isEmpty()) {
                            for (Order o : orders) { %>
                                <option value="<%= o.getId() %>">
                                    №<%= o.getId() %> - <%= o.getDescription() %> (статус: <%= o.getStatus() %>)
                                </option>
                        <%  }
                        } else { %>
                            <option value="">Нет доступных заказов</option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label for="status">Новый статус</label>
                    <select id="status" name="status" required>
                        <option value="in_progress">В работе</option>
                        <option value="completed">Выполнен</option>
                    </select>
                </div>
                <div class="actions">
                    <button type="submit">Обновить</button>
                    <a class="btn btn-secondary" href="MainServlet?action=dashboard">Назад</a>
                </div>
            </form>
        </section>
    </main>
</body>
</html>
