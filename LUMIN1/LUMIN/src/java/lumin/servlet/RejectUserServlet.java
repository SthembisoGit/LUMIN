package lumin.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

import lumin.model.DBConnection;

@WebServlet("/rejectUser") // This makes the servlet available at /rejectUser
public class RejectUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendRedirect("admin/pendingUsers.jsp?error=Missing+user+ID");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // SQL query to update the user's status to rejected
            String sql = "UPDATE Users SET Status = 'rejected' WHERE UserID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(userIdStr));
            int updated = stmt.executeUpdate();

            if (updated > 0) {
                // Optionally: Get the email and send a rejection email here (we'll handle this later)
                
                // Redirect back to pending users page with success message
                response.sendRedirect("admin/pendingUsers.jsp?success=User+rejected");
            } else {
                // In case no update is made, show error
                response.sendRedirect("admin/pendingUsers.jsp?error=No+user+updated");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/pendingUsers.jsp?error=Server+error");
        }
    }
}
