package lumin.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import lumin.model.DBConnection;

public class MyJobsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String employerIdStr = (String) session.getAttribute("userId");
        
        if (session == null || employerIdStr == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int employerId = Integer.parseInt(employerIdStr);
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT JobID, Title, Salary, Location, ExpiryDate FROM Jobs WHERE EmployerID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, employerId);
            ResultSet rs = ps.executeQuery();

            request.setAttribute("jobs", rs);  // Store the ResultSet in request attribute
            request.getRequestDispatcher("/myJobs.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error fetching jobs: " + e.getMessage());
        }
    }
}
