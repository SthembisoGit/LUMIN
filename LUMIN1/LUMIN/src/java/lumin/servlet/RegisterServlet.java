package lumin.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

import java.io.*;
import java.sql.*;

import lumin.model.DBConnection;

@MultipartConfig(maxFileSize = 16177215) // up to 16MB file upload
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String regNumber = request.getParameter("regNumber");

        Part selfieFile = request.getPart("selfieId");
        InputStream imageStream = null;

        String status = "applicant".equalsIgnoreCase(role) ? "approved" : "pending";

        if ("employer_individual".equalsIgnoreCase(role) && selfieFile != null && selfieFile.getSize() > 0) {
            imageStream = selfieFile.getInputStream(); // Get the uploaded image stream
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO Users (FullName, Email, Password, Role, Status, RegNumber, SelfieImage) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, password); // 🔒 Hash this in real apps
            stmt.setString(4, role);
            stmt.setString(5, status);
            stmt.setString(6, regNumber != null ? regNumber : null);

            if (imageStream != null) {
                stmt.setBlob(7, imageStream);
            } else {
                stmt.setNull(7, java.sql.Types.BLOB);
            }

            stmt.executeUpdate();
            response.sendRedirect("login.jsp?registered=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=1");
        }
    }
}
