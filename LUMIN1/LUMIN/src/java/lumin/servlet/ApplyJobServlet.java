package lumin.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import lumin.model.DBConnection;

public class ApplyJobServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String userIdStr = (String) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (session == null || userIdStr == null || !role.equals("applicant")) {
            response.sendRedirect("login.jsp");
            return;
        }

        int applicantId = Integer.parseInt(userIdStr);
        int jobId = Integer.parseInt(request.getParameter("jobId"));

        // Get resume path from session
        String resumePath = (String) session.getAttribute("Resume");

        try (Connection conn = DBConnection.getConnection()) {

            // ✅ 1. Check for duplicate application
            String checkSql = "SELECT COUNT(*) FROM applications WHERE jobid = ? AND applicantid = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, jobId);
                checkStmt.setInt(2, applicantId);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    // 🔁 Already applied → redirect with error
                    response.sendRedirect("view_posted_jobs.jsp?error=You+already+applied+for+this+job.");
                    return;
                }
            }

            // ✅ 2. Insert new application
            String insertSql = "INSERT INTO applications (jobid, applicantid, resumepath, submittedat) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, jobId);
                ps.setInt(2, applicantId);
                ps.setString(3, resumePath); // ResumePath is required
                ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));

                ps.executeUpdate();
            }

            // ✅ Success: Redirect to myApplications.jsp
            response.sendRedirect("myApplications.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            // 🔒 Database error: Show message or log
            response.sendRedirect("view_posted_jobs.jsp?error=Database+error:+Could+not+submit+application");
        }
    }
}