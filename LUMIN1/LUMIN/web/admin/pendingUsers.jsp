<%@ page import="java.sql.*, java.util.Base64, lumin.model.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Users - Admin Panel</title>
    <link rel="stylesheet" href="styles/main.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 0 20px 80px;
            font-family: 'Poppins', sans-serif;
            background: #f9f9f9;
            min-height: 100vh;
            box-sizing: border-box;
        }

        h2 {
            color: #2c8e88;
            margin-top: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
            font-size: 0.95rem;
        }

        th {
            background-color: #DEF2F1;
        }

        a, button {
            font-weight: 600;
            color: #2c8e88;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        form {
            display: inline;
        }

        .footer {
            background-color: #17252A;
            color: white;
            text-align: center;
            padding: 15px 0;
            position: relative;
            bottom: 0;
            width: 100%;
            font-size: 0.9rem;
            margin-top: 60px;
        }

        .footer a {
            color: #ffffff;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h2>⏳ Pending User Approvals</h2>
    <%
        String role = (String) session.getAttribute("role");
        if (role == null || !"admin".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <%
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT UserID, FullName, Email, Role, CreatedAt, RegNumber FROM Users WHERE Status = 'pending'";
            PreparedStatement stmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = stmt.executeQuery();

            if (!rs.isBeforeFirst()) {
    %>
                <p style="color:gray;">✅ No pending users at the moment.</p>
    <%
            } else {
    %>
    <table>
        <tr>
            <th>Full Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Registered On</th>
            <th>Reg. Number</th>
            <th>Selfie with ID</th>
            <th>Actions</th>
        </tr>
        <%
            while (rs.next()) {
                int userId = rs.getInt("UserID");
                String userEmail = rs.getString("Email");
                String userRole = rs.getString("Role");
        %>
        <tr>
            <td><%= rs.getString("FullName") %></td>
            <td><%= userEmail %></td>
            <td><%= userRole %></td>
            <td><%= rs.getTimestamp("CreatedAt") %></td>
            <td><%= "employer_business".equalsIgnoreCase(userRole) ? rs.getString("RegNumber") : "-" %></td>
            <td>
                <%
                    if ("employer_individual".equalsIgnoreCase(userRole)) {
                        try (PreparedStatement imgStmt = conn.prepareStatement("SELECT SelfieImage FROM Users WHERE UserID = ?")) {
                            imgStmt.setInt(1, userId);
                            ResultSet imgRs = imgStmt.executeQuery();
                            if (imgRs.next()) {
                                byte[] imageBytes = imgRs.getBytes("SelfieImage");
                                if (imageBytes != null && imageBytes.length > 0) {
                                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                %>
                                    <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Selfie ID" width="100"/>
                <%
                                } else {
                                    out.print("No image");
                                }
                            }
                        } catch (Exception ex) {
                            out.print("Image error");
                            ex.printStackTrace();
                        }
                    } else {
                        out.print("-");
                    }
                %>
            </td>
            <td>
                <form method="post" action="/LUMIN/approveUser">
                    <input type="hidden" name="userId" value="<%= userId %>">
                    <input type="hidden" name="email" value="<%= userEmail %>">
                    <button type="submit">✅ Approve</button>
                </form>
                <form method="post" action="/LUMIN/rejectUser">
                    <input type="hidden" name="userId" value="<%= userId %>">
                    <input type="hidden" name="email" value="<%= userEmail %>">
                    <button type="submit" onclick="return confirm('Are you sure you want to reject this user?')">❌ Reject</button>
                </form>
            </td>
        </tr>
        <%
            } // end while
        %>
    </table>
    <%
            } // end else
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error loading users: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>

    <br>
    <a href="dashboard.jsp">Back to Admin Dashboard</a> |
    <a href="allUsers.jsp">View All Users</a> |
    <a href="../index.html">🏠 Home</a>

    <div class="footer">
        &copy; 2025 LUMIN. All rights reserved. | <a href="../index.html">Back to Home</a>
    </div>
</body>
</html>
