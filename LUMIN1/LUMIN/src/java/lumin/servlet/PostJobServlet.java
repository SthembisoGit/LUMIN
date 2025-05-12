package lumin.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

import lumin.model.DBConnection;


public class PostJobServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("role");
        String employerIdStr = (String) session.getAttribute("userId");

        if (session == null || employerIdStr == null ||
            (!"employer_business".equals(role) && !"employer_individual".equals(role))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int employerId = Integer.parseInt(employerIdStr);
        String title = request.getParameter("title");
        String salary = request.getParameter("salary");
        String requirements = request.getParameter("requirements");
        String duties = request.getParameter("duties");
        String location = request.getParameter("location");
        String expiry = request.getParameter("expiryDate");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO Jobs (EmployerID, Title, Salary, Requirements, Duties, Location, ExpiryDate) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, employerId);
            ps.setString(2, title);
            ps.setString(3, salary);
            ps.setString(4, requirements);
            ps.setString(5, duties);
            ps.setString(6, location);
            ps.setDate(7, Date.valueOf(expiry));

            ps.executeUpdate();
            ps.close();

            response.sendRedirect("view_posted_jobs.jsp"); // or confirmation page

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error posting job: " + e.getMessage());
        }
    }
}
