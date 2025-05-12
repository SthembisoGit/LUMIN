<%@ page import="lumin.model.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
   // HttpSession session = request.getSession(false);
    String userIdStr = (String) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");

    if (session == null || userIdStr == null || !role.equals("applicant")) {
        response.sendRedirect("login.jsp");
        return;
    }

    int applicantId = Integer.parseInt(userIdStr);

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<html>
<head>
    <title>My Job Applications</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f7f7f7;
        }
        h2 {
            color: #333;
        }
        .application-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .application-card p {
            margin: 8px 0;
        }
        .no-applications {
            color: gray;
            font-style: italic;
        }
        .resume-link {
            color: #0066cc;
            text-decoration: none;
        }
        .resume-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h2>? My Job Applications</h2>

    <%
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT a.ApplicationID, a.SubmittedAt, a.ResumePath, j.Title, u.FullName AS EmployerName " +
                         "FROM Applications a " +
                         "JOIN Jobs j ON a.JobID = j.JobID " +
                         "JOIN Users u ON j.EmployerID = u.UserID " +
                         "WHERE a.ApplicantID = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, applicantId);
            rs = stmt.executeQuery();
            
            boolean hasApplications = false;

            while (rs.next()) {
                hasApplications = true;
                int applicationId = rs.getInt("ApplicationID");
                String jobTitle = rs.getString("Title");
                String employerName = rs.getString("EmployerName");
                Timestamp submittedAt = rs.getTimestamp("SubmittedAt");
                String resumePath = rs.getString("ResumePath");
    %>

    <div class="application-card">
        <p><strong>Job:</strong> <%= jobTitle %></p>
        <p><strong>Employer:</strong> <%= employerName %></p>
        <p><strong>Applied on:</strong> <%= submittedAt %></p>

        <% if (resumePath != null && !resumePath.isEmpty()) { %>
            <p><strong>Resume:</strong> 
               <a href="DownloadServlet?type=cv" class="resume-link">Download Resume</a>
            </p>
        <% } else { %>
            <p><strong>Resume:</strong> No resume found.</p>
        <% } %>
    </div>

    <%
            }

            if (!hasApplications) {
    %>
        <p class="no-applications">You have not applied to any jobs yet.</p>
    <%
            }

        } catch (Exception e) {
            out.println("<p style='color:red;'>Error loading applications: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    %>

    <a href="view_posted_jobs.jsp"><button>? Browse Jobs</button></a>
</body>
</html>