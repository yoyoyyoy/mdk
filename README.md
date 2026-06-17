## Система управления заказами на перевозку

 


## 📸 Скриншоты

<div align="center">
  <img src="/Screen/Screenshot_1.png" alt="Вход" width="400"/>
  <img src="/Screen/Screenshot_2.png" alt="Регистрация" width="400"/>
</div>

<div align="center">
  <img src="/Screen/Screenshot_3.png" alt="Дашборд менеджера" width="400"/>
  <img src="/Screen/Screenshot_10.png" alt="Дашборд водителя" width="400"/>
</div>

<div align="center">
  <img src="/Screen/Screenshot_4.png" alt="Создание заказа" width="400"/>
  <img src="/Screen/Screenshot_5.png" alt="Назначение водителя" width="400"/>
</div>

<div align="center">
  <img src="/Screen/Screenshot_6.png" alt="Обновление статуса" width="400"/>
  <img src="/Screen/Screenshot_7.png" alt="Отчет" width="400"/>
</div>

<div align="center">
  <img src="/Screen/Screenshot_8.png" alt="Управление пользователями" width="400"/>
  <img src="/Screen/Screenshot_9.png" alt="Подтверждение удаления" width="400"/>
</div>

## ✨ Функциональные возможности

- **Аутентификация и регистрация** (роли: `admin`, `manager`, `driver`)
- **Разграничение доступа**:
  - **Админ**: управление пользователями (просмотр + удаление)
  - **Менеджер**: создание заказов, назначение водителей, просмотр отчета
  - **Водитель**: просмотр назначенных заказов, обновление статуса (`in_progress`, `completed`)
- **Управление заказами**:
  - Создание заказа с описанием
  - Назначение водителя на заказ (меняется статус на `assigned`)
  - Изменение статуса заказа
- **Формирование отчета** по всем заказам (для менеджера/админа)
- **Хранение данных** в MySQL (таблицы `users`, `orders`)
