package logistics;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/MainServlet")
public class MainServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (action == null) action = "";

        switch (action) {
            case "login":
                forwardTo(request, response, "/login.jsp");
                break;
            case "register":
                forwardTo(request, response, "/register.jsp");
                break;
            case "logout":
                if (session != null) session.invalidate();
                response.sendRedirect("MainServlet?action=login");
                break;
            case "dashboard":
                if (currentUser == null) {
                    response.sendRedirect("MainServlet?action=login");
                } else {
                    forwardTo(request, response, "/dashboard.jsp");
                }
                break;
            case "createOrder":
                if (checkRole(currentUser, "manager", "admin")) {
                    forwardTo(request, response, "/createOrder.jsp");
                } else {
                    response.sendRedirect("MainServlet?action=dashboard");
                }
                break;
            case "assignDriver":
                if (checkRole(currentUser, "manager", "admin")) {
                    request.setAttribute("orders", getOrdersByStatus("created"));
                    request.setAttribute("drivers", getUsersByRole("driver"));
                    forwardTo(request, response, "/assignDriver.jsp");
                } else {
                    response.sendRedirect("MainServlet?action=dashboard");
                }
                break;
            case "updateStatus":
                if (currentUser != null) {
                    List<Order> orders;
                    if ("admin".equals(currentUser.getRole()) || "manager".equals(currentUser.getRole())) {
                        orders = getAllOrders();
                    } else if ("driver".equals(currentUser.getRole())) {
                        orders = getOrdersByDriver(currentUser.getId());
                    } else {
                        orders = new ArrayList<>();
                    }
                    request.setAttribute("orders", orders);
                    forwardTo(request, response, "/updateStatus.jsp");
                } else {
                    response.sendRedirect("MainServlet?action=login");
                }
                break;
            case "createReport":
                if (checkRole(currentUser, "manager", "admin")) {
                    request.setAttribute("orders", getAllOrders());
                    forwardTo(request, response, "/createReport.jsp");
                } else {
                    response.sendRedirect("MainServlet?action=dashboard");
                }
                break;
            case "manageUsers":
                if (checkRole(currentUser, "admin")) {
                    request.setAttribute("users", getAllUsers());
                    forwardTo(request, response, "/manageUsers.jsp");
                } else {
                    response.sendRedirect("MainServlet?action=dashboard");
                }
                break;
            case "showDelete":
                if (checkRole(currentUser, "admin")) {
                    int userId = Integer.parseInt(request.getParameter("id"));
                    User userToDelete = getUserById(userId);
                    if (userToDelete != null) {
                        request.setAttribute("userToDelete", userToDelete);
                        forwardTo(request, response, "/deleteConfirm.jsp");
                    } else {
                        response.sendRedirect("MainServlet?action=manageUsers");
                    }
                } else {
                    response.sendRedirect("MainServlet?action=dashboard");
                }
                break;
            default:
                if (currentUser == null) {
                    response.sendRedirect("MainServlet?action=login");
                } else {
                    response.sendRedirect("MainServlet?action=dashboard");
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (action == null) action = "";

        switch (action) {
            case "login":
                String login = request.getParameter("login");
                String password = request.getParameter("password");
                User user = getUserByLoginPassword(login, password);
                if (user != null) {
                    session = request.getSession();
                    session.setAttribute("user", user);
                    response.sendRedirect("MainServlet?action=dashboard");
                } else {
                    request.setAttribute("error", "Неверный логин или пароль");
                    forwardTo(request, response, "/login.jsp");
                }
                break;

            case "register":
                String newLogin = request.getParameter("login");
                String newPassword = request.getParameter("password");
                String newFullName = request.getParameter("fullName");
                String role = request.getParameter("role");
                if (createUser(newLogin, newPassword, newFullName, role)) {
                    response.sendRedirect("MainServlet?action=login");
                } else {
                    request.setAttribute("error", "Ошибка регистрации: возможно, логин уже занят");
                    forwardTo(request, response, "/register.jsp");
                }
                break;

            case "createOrder":
                if (checkRole(currentUser, "manager", "admin")) {
                    String description = request.getParameter("description");
                    if (description != null && !description.trim().isEmpty()) {
                        createOrder(description, currentUser.getId());
                    }
                    response.sendRedirect("MainServlet?action=dashboard");
                } else {
                    response.sendRedirect("MainServlet?action=dashboard");
                }
                break;

            case "assignDriver":
                if (checkRole(currentUser, "manager", "admin")) {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    int driverId = Integer.parseInt(request.getParameter("driverId"));
                    assignDriver(orderId, driverId);
                    response.sendRedirect("MainServlet?action=dashboard");
                } else {
                    response.sendRedirect("MainServlet?action=dashboard");
                }
                break;

            case "updateStatus":
                if (currentUser != null) {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String status = request.getParameter("status");
                    if ("driver".equals(currentUser.getRole())) {
                        if (isOrderAssignedToDriver(orderId, currentUser.getId())) {
                            updateOrderStatus(orderId, status);
                        }
                    } else if (checkRole(currentUser, "manager", "admin")) {
                        updateOrderStatus(orderId, status);
                    }
                    response.sendRedirect("MainServlet?action=dashboard");
                } else {
                    response.sendRedirect("MainServlet?action=login");
                }
                break;

            case "deleteUser":
                if (checkRole(currentUser, "admin")) {
                    int userId = Integer.parseInt(request.getParameter("id"));
                    deleteUser(userId);
                    response.sendRedirect("MainServlet?action=manageUsers");
                } else {
                    response.sendRedirect("MainServlet?action=dashboard");
                }
                break;

            default:
                response.sendRedirect("MainServlet?action=dashboard");
                break;
        }
    }

    // ---------- ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ----------
    private void forwardTo(HttpServletRequest req, HttpServletResponse resp, String jsp)
            throws ServletException, IOException {
        req.getRequestDispatcher(jsp).forward(req, resp);
    }

    private boolean checkRole(User user, String... allowedRoles) {
        if (user == null) return false;
        for (String role : allowedRoles) {
            if (role.equals(user.getRole())) return true;
        }
        return false;
    }

    // ---------- РАБОТА С БД ----------
    // Теперь только логин+пароль
    private User getUserByLoginPassword(String login, String password) {
        String sql = "SELECT * FROM users WHERE login=? AND password=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, login);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("id"), rs.getString("login"),
                        rs.getString("password"), rs.getString("full_name"),
                        rs.getString("role"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private boolean createUser(String login, String password, String fullName, String role) {
        String sql = "INSERT INTO users (login, password, full_name, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, login);
            stmt.setString(2, password);
            stmt.setString(3, fullName);
            stmt.setString(4, role);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new User(rs.getInt("id"), rs.getString("login"),
                        rs.getString("password"), rs.getString("full_name"),
                        rs.getString("role")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("id"), rs.getString("login"),
                        rs.getString("password"), rs.getString("full_name"),
                        rs.getString("role"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private List<User> getUsersByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new User(rs.getInt("id"), rs.getString("login"),
                        rs.getString("password"), rs.getString("full_name"),
                        rs.getString("role")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private void createOrder(String description, int createdBy) {
        String sql = "INSERT INTO orders (description, created_by) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, description);
            stmt.setInt(2, createdBy);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void assignDriver(int orderId, int driverId) {
        String sql = "UPDATE orders SET driver_id=?, status='assigned' WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, driverId);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private List<Order> getOrdersByStatus(String status) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS driver_name, c.full_name AS creator_name " +
                "FROM orders o " +
                "LEFT JOIN users u ON o.driver_id = u.id " +
                "JOIN users c ON o.created_by = c.id " +
                "WHERE o.status=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setDescription(rs.getString("description"));
                order.setStatus(rs.getString("status"));
                order.setDriverId(rs.getInt("driver_id"));
                order.setCreatedBy(rs.getInt("created_by"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setDriverName(rs.getString("driver_name"));
                order.setCreatorName(rs.getString("creator_name"));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS driver_name, c.full_name AS creator_name " +
                "FROM orders o " +
                "LEFT JOIN users u ON o.driver_id = u.id " +
                "JOIN users c ON o.created_by = c.id";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setDescription(rs.getString("description"));
                order.setStatus(rs.getString("status"));
                order.setDriverId(rs.getInt("driver_id"));
                order.setCreatedBy(rs.getInt("created_by"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setDriverName(rs.getString("driver_name"));
                order.setCreatorName(rs.getString("creator_name"));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Order> getOrdersByDriver(int driverId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS driver_name, c.full_name AS creator_name " +
                "FROM orders o " +
                "LEFT JOIN users u ON o.driver_id = u.id " +
                "JOIN users c ON o.created_by = c.id " +
                "WHERE o.driver_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, driverId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setDescription(rs.getString("description"));
                order.setStatus(rs.getString("status"));
                order.setDriverId(rs.getInt("driver_id"));
                order.setCreatedBy(rs.getInt("created_by"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setDriverName(rs.getString("driver_name"));
                order.setCreatorName(rs.getString("creator_name"));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private boolean isOrderAssignedToDriver(int orderId, int driverId) {
        String sql = "SELECT id FROM orders WHERE id=? AND driver_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.setInt(2, driverId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ---------- ВНУТРЕННИЙ КЛАСС ORDER ----------
    public static class Order {
        private int id;
        private String description;
        private String status;
        private int driverId;
        private int createdBy;
        private Timestamp createdAt;
        private String driverName;
        private String creatorName;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public int getDriverId() { return driverId; }
        public void setDriverId(int driverId) { this.driverId = driverId; }
        public int getCreatedBy() { return createdBy; }
        public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
        public Timestamp getCreatedAt() { return createdAt; }
        public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
        public String getDriverName() { return driverName; }
        public void setDriverName(String driverName) { this.driverName = driverName; }
        public String getCreatorName() { return creatorName; }
        public void setCreatorName(String creatorName) { this.creatorName = creatorName; }
    }
}
