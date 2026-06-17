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
    List<User> drivers = (List<User>) request.getAttribute("drivers");
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Назначение водителя | Zelenov Logistics</title>
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
                <p class="eyebrow">Распределение</p>
                <h1>Назначить водителя на заказ</h1>
                <p class="subtitle">Выберите свободный заказ и сотрудника, который возьмет его в работу.</p>
            </div>
            <span class="user-badge"><%= user.getRole() %></span>
        </header>

        <section class="panel">
            <form class="form-grid" action="MainServlet?action=assignDriver" method="post">
                <div>
                    <label for="orderId">Заказ</label>
                    <select id="orderId" name="orderId" required>
                        <% if (orders != null && !orders.isEmpty()) {
                            for (Order o : orders) { %>
                                <option value="<%= o.getId() %>">№<%= o.getId() %> - <%= o.getDescription() %></option>
                        <%  }
                        } else { %>
                            <option value="">Нет доступных заказов</option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label for="driverId">Водитель</label>
                    <select id="driverId" name="driverId" required>
                        <% if (drivers != null && !drivers.isEmpty()) {
                            for (User d : drivers) { %>
                                <option value="<%= d.getId() %>"><%= d.getFullName() %> (логин: <%= d.getLogin() %>)</option>
                        <%  }
                        } else { %>
                            <option value="">Нет водителей</option>
                        <% } %>
                    </select>
                </div>
                <div class="actions">
                    <button type="submit">Назначить</button>
                    <a class="btn btn-secondary" href="MainServlet?action=dashboard">Назад</a>
                </div>
            </form>
        </section>
    </main>
</body>
</html>
