<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Регистрация | Zelenov Logistics</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <main class="auth-shell">
        <section class="auth-card">
            <div class="brand">
                <span class="brand-mark">Z</span>
                <span>Zelenov Logistics</span>
            </div>
            <p class="eyebrow">Новый пользователь</p>
            <h1>Регистрация</h1>
            <p class="subtitle">Создайте профиль менеджера или водителя для работы с заказами.</p>

            <% if (request.getAttribute("error") != null) { %>
                <p class="error"><%= request.getAttribute("error") %></p>
            <% } %>

            <form class="form-grid" action="MainServlet?action=register" method="post">
                <div>
                    <label for="fullName">ФИО</label>
                    <input id="fullName" type="text" name="fullName" autocomplete="name" required>
                </div>
                <div>
                    <label for="login">Логин</label>
                    <input id="login" type="text" name="login" autocomplete="username" required>
                </div>
                <div>
                    <label for="password">Пароль</label>
                    <input id="password" type="password" name="password" autocomplete="new-password" required>
                </div>
                <div>
                    <label for="role">Должность</label>
                    <select id="role" name="role" required>
                        <option value="manager">Менеджер</option>
                        <option value="driver">Водитель</option>
                    </select>
                </div>
                <button type="submit">Зарегистрироваться</button>
            </form>

            <p class="auth-footer">Уже есть аккаунт? <a href="MainServlet?action=login">Войти</a></p>
        </section>
    </main>
</body>
</html>
