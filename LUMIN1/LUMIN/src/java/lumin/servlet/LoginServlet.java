package lumin.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import lumin.model.DBConnection;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password"); // In production: hash this!

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("UserID");
                String role = rs.getString("Role");
                String status = rs.getString("Status");
                String fullName = rs.getString("FullName");

                if ("pending".equalsIgnoreCase(status)) {
                    request.setAttribute("error", "Your account is still pending verification.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                if ("rejected".equalsIgnoreCase(status)) {
                    request.setAttribute("error", "Your account was rejected. Check your email for more info.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                // ✅ Store basic session attributes
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", email);
                session.setAttribute("userName", fullName);
                session.setAttribute("role", role);
                session.setAttribute("userId", String.valueOf(userId));

                // ✅ Load and store extended user data into session
                session.setAttribute("Gender", rs.getString("Gender"));
                session.setAttribute("Race", rs.getString("Race"));
                session.setAttribute("Country", rs.getString("Country"));
                session.setAttribute("PhysicalAddress", rs.getString("PhysicalAddress"));
                session.setAttribute("RegNumber", rs.getString("RegNumber"));
                session.setAttribute("Resume", rs.getString("Resume")); // Resume file path
                session.setAttribute("SelfieImage", rs.getBytes("SelfieImage")); // Optional: if needed
                session.setAttribute("Qualifications", rs.getString("Qualifications"));
                session.setAttribute("SupportingDocs", rs.getString("SupportingDocs"));
                session.setAttribute("StreetName", rs.getString("StreetName"));
                session.setAttribute("City", rs.getString("City"));
                session.setAttribute("Suburb", rs.getString("Suburb"));
                session.setAttribute("PostalCode", rs.getString("PostalCode"));
                session.setAttribute("Province", rs.getString("Province"));

                // ✅ Redirect based on role
                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("admin/dashboard.jsp");
                } else if ("applicant".equalsIgnoreCase(role)) {
                    response.sendRedirect("applicant/dashboard.jsp");
                } else if ("employer_business".equalsIgnoreCase(role) || "employer_individual".equalsIgnoreCase(role)) {
                    response.sendRedirect("employer/dashboard.jsp");
                } else {
                    response.sendRedirect("dashboard.jsp");
                }

            } else {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error occurred. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}