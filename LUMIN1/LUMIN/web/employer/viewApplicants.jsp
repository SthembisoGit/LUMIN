<%@ page import="lumin.model.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ include file="../includes/header.jsp" %>
<%@ page session="true" %>

<%
    String employerIdStr = (String) session.getAttribute("userId");
    String jobIdStr = request.getParameter("jobId");

    if (employerIdStr == null || jobIdStr == null) {
        out.println("<p style='color:red;'>Invalid request.</p>");
        return;
    }

    int employerId = Integer.parseInt(employerIdStr);
    int jobId = Integer.parseInt(jobIdStr);

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    boolean hasResults = false;

    try {
        con = DBConnection.getConnection();

        // Only allow viewing applicants for your own job
        String sql = "SELECT A.ResumePath, U.FullName " +
                     "FROM Applications A " +
                     "JOIN Jobs J ON A.JobID = J.JobID " +
                     "JOIN Users U ON A.ApplicantID = U.UserID " +
                     "WHERE J.EmployerID = ? AND A.JobID = ?";

        ps = con.prepareStatement(sql);
        ps.setInt(1, employerId);
        ps.setInt(2, jobId);

        rs = ps.executeQuery();
%>

<html>
<head>
    <title>View Applicants</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        .no-applicants {
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
        .button {
            display: inline-block;
            margin-top: 20px;
            padding: 8px 16px;
            background-color: #0066cc;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .button:hover {
            background-color: #005fa3;
        }
    </style>
</head>
<body>
    <h2>Applicants for This Job</h2>

    <table>
        <thead>
            <tr>
                <th>Applicant Name</th>
                <th>Resume</th>
            </tr>
        </thead>
        <tbody>
<%
        while (rs.next()) {
            hasResults = true;
            String applicantName = rs.getString("FullName");
            String resumePath = rs.getString("ResumePath");
%>
            <tr>
                <td><%= applicantName %></td>
                <td>
                    <% if (resumePath != null && !resumePath.isEmpty()) { %>
                        <a href="../DownloadServlet?type=applicant_cv&path=<%= resumePath %>" class="resume-link" target="_blank">Download Resume</a>
                    <% } else { %>
                        No resume uploaded
                    <% } %>
                </td>
            </tr>
<%
        }

        if (!hasResults) {
%>
            <tr>
                <td colspan="2">
                    <p class="no-applicants">No applicants have applied for this job yet.</p>
                </td>
            </tr>
<%
        }
%>
        </tbody>
    </table>

    <a href="myJobs.jsp" class="button">Back to Jobs</a>
</body>
</html>

<%
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error loading applicants: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
