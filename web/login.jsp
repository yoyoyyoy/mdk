<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вход | Zelenov Logistics</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <main class="auth-shell">
        <section class="auth-card">
            <div class="brand">
                <span class="brand-mark">Z</span>
                <span>Zelenov Logistics</span>
            </div>
            <p class="eyebrow">Рабочий кабинет</p>
            <h1>Вход в систему</h1>
            <p class="subtitle">Введите логин и пароль, чтобы перейти к управлению заказами.</p>

            <% if (request.getAttribute("error") != null) { %>
                <p class="error"><%= request.getAttribute("error") %></p>
            <% } %>

            <form class="form-grid" action="MainServlet?action=login" method="post">
                <div>
                    <label for="login">Логин</label>
                    <input id="login" type="text" name="login" autocomplete="username" required>
                </div>
                <div>
                    <label for="password">Пароль</label>
                    <input id="password" type="password" name="password" autocomplete="current-password" required>
                </div>
                <button type="submit">Войти</button>
            </form>

            <p class="auth-footer">Нет аккаунта? <a href="MainServlet?action=register">Зарегистрироваться</a></p>
        </section>
    </main>
</body>
</html>
