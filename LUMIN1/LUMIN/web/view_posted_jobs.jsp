<%@ page import="lumin.model.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");
    String userId = (String) session.getAttribute("userId");

    if (role == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean isEmployer = role.equals("employer_business") || role.equals("employer_individual");
    boolean isApplicant = role.equals("applicant");

    int currentPage = 1;
    int jobsPerPage = 5;
    int totalJobs = 0;
    int totalPages = 0;

    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        currentPage = Integer.parseInt(pageParam);
    }

    int offset = (currentPage - 1) * jobsPerPage;

    String locationFilter = request.getParameter("location");
    String titleFilter = request.getParameter("title");
    String salaryFilter = request.getParameter("salary");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<html>
<head>
    <title><%= isApplicant ? "Available Jobs" : "Your Posted Jobs" %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .job-card {
            border: 1px solid #ccc;
            margin: 15px 0;
            padding: 20px;
            border-radius: 8px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .job-title {
            color: #0066cc;
            font-size: 1.5em;
            margin-bottom: 10px;
        }
        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a {
            padding: 10px 20px;
            text-decoration: none;
            color: #0066cc;
            border: 1px solid #ccc;
            margin: 0 5px;
            border-radius: 4px;
        }
        .pagination a:hover {
            background-color: #0066cc;
            color: white;
        }
        .filter-form {
            margin: 20px 0;
            text-align: center;
        }
        .filter-form input {
            padding: 8px;
            margin: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .filter-form input[type="submit"] {
            background-color: #0066cc;
            color: white;
            cursor: pointer;
        }
        .filter-form input[type="submit"]:hover {
            background-color: #004c99;
        }
    </style>
    <script>
        function resetFilters() {
            document.getElementById("title").value = "";
            document.getElementById("location").value = "";
            document.getElementById("salary").value = "";
            document.getElementById("filterForm").submit();
        }
    </script>
</head>
<body>
    <h2><%= isApplicant ? "Available Jobs" : "Your Posted Jobs" %></h2>

    <!-- Filter Form -->
    <form method="get" action="view_posted_jobs.jsp" id="filterForm" class="filter-form">
        <label for="title">Job Title:</label>
        <input type="text" name="title" id="title" value="<%= titleFilter != null ? titleFilter : "" %>">

        <label for="location">Location:</label>
        <input type="text" name="location" id="location" value="<%= locationFilter != null ? locationFilter : "" %>">

        <label for="salary">Salary Min:</label>
        <input type="text" name="salary" id="salary" value="<%= salaryFilter != null ? salaryFilter : "" %>">

        <input type="submit" value="Filter">
        <button type="button" onclick="resetFilters()">Reset Filters</button>
    </form>

<%
    try {
        conn = DBConnection.getConnection();

        // Count jobs
        String countSql = "SELECT COUNT(*) FROM Jobs WHERE Status = 'active'";
        if (locationFilter != null && !locationFilter.isEmpty()) countSql += " AND Location LIKE ?";
        if (titleFilter != null && !titleFilter.isEmpty()) countSql += " AND Title LIKE ?";
        if (salaryFilter != null && !salaryFilter.isEmpty()) countSql += " AND Salary >= ?";

        stmt = conn.prepareStatement(countSql);
        int paramIdx = 1;
        if (locationFilter != null && !locationFilter.isEmpty()) stmt.setString(paramIdx++, "%" + locationFilter + "%");
        if (titleFilter != null && !titleFilter.isEmpty()) stmt.setString(paramIdx++, "%" + titleFilter + "%");
        if (salaryFilter != null && !salaryFilter.isEmpty()) stmt.setString(paramIdx++, salaryFilter);
        rs = stmt.executeQuery();
        if (rs.next()) totalJobs = rs.getInt(1);
        totalPages = (int) Math.ceil(totalJobs / (double) jobsPerPage);

        // Get jobs
        String sql = "SELECT j.*, u.FullName, u.Role FROM Jobs j JOIN Users u ON j.EmployerID = u.UserID WHERE j.Status = 'active'";
        if (locationFilter != null && !locationFilter.isEmpty()) sql += " AND j.Location LIKE ?";
        if (titleFilter != null && !titleFilter.isEmpty()) sql += " AND j.Title LIKE ?";
        if (salaryFilter != null && !salaryFilter.isEmpty()) sql += " AND j.Salary >= ?";
        sql += " ORDER BY j.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        stmt = conn.prepareStatement(sql);
        paramIdx = 1;
        if (locationFilter != null && !locationFilter.isEmpty()) stmt.setString(paramIdx++, "%" + locationFilter + "%");
        if (titleFilter != null && !titleFilter.isEmpty()) stmt.setString(paramIdx++, "%" + titleFilter + "%");
        if (salaryFilter != null && !salaryFilter.isEmpty()) stmt.setString(paramIdx++, salaryFilter);
        stmt.setInt(paramIdx++, offset);
        stmt.setInt(paramIdx++, jobsPerPage);

        rs = stmt.executeQuery();
        while (rs.next()) {
%>
    <div class="job-card">
        <h3 class="job-title"><%= rs.getString("Title") %></h3>
        <p><strong>Location:</strong> <%= rs.getString("Location") %></p>
        <p><strong>Salary:</strong> <%= rs.getString("Salary") %></p>
        <p><strong>Expires:</strong> <%= rs.getDate("ExpiryDate") %></p>

        <% if (isApplicant) { %>
            <p><strong>Posted by:</strong> <%= rs.getString("FullName") %> 
            (<%= rs.getString("Role").replace("employer_", "").replace("_", " ") %>)</p>

            <form method="post" action="ApplyJobServlet" onsubmit="return confirm('Apply for this job?');">
                <input type="hidden" name="jobId" value="<%= rs.getInt("JobID") %>" />
                <button type="submit">Apply Now</button>
            </form>
        <% } %>
    </div>
<%
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!-- Pagination -->
<div class="pagination">
    <% if (currentPage > 1) { %>
        <a href="view_posted_jobs.jsp?page=<%= currentPage - 1 %>">Previous</a>
    <% } %>
    <% if (currentPage < totalPages) { %>
        <a href="view_posted_jobs.jsp?page=<%= currentPage + 1 %>">Next</a>
    <% } %>
</div>

</body>
</html>
