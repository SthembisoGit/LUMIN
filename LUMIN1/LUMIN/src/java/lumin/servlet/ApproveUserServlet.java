package lumin.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import lumin.model.DBConnection;

@WebServlet("/approveUser") // This makes the servlet available at /approveUser
public class ApproveUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendRedirect("admin/pendingUsers.jsp?error=Missing+user+ID");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE Users SET Status = 'approved' WHERE UserID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(userIdStr));
            int updated = stmt.executeUpdate();

            if (updated > 0) {
                response.sendRedirect("admin/pendingUsers.jsp?success=User+approved");
            } else {
                response.sendRedirect("admin/pendingUsers.jsp?error=No+user+updated");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/pendingUsers.jsp?error=Server+error");
        }
    }
}
