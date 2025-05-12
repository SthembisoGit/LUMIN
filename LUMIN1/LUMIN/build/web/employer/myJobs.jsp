<%@ page import="lumin.model.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ include file="../includes/header.jsp" %>
<%@ page session="true" %>

<html>
<head>
    <title>My Posted Jobs</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        a.button {
            display: inline-block;
            margin-top: 20px;
            padding: 8px 16px;
            background-color: #0066cc;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        a.button:hover {
            background-color: #005fa3;
        }
    </style>
</head>
<body>
    <h2>My Posted Jobs</h2>

    <table>
        <thead>
            <tr>
                <th>Job Title</th>
                <th>Salary</th>
                <th>Location</th>
                <th>Expiry Date</th>
                <th>View Applicants</th>
            </tr>
        </thead>
        <tbody>
            <%
                String employerIdStr = (String) session.getAttribute("userId");
                if (employerIdStr != null && !employerIdStr.isEmpty()) {
                    int employerId = Integer.parseInt(employerIdStr);

                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        con = DBConnection.getConnection();
                        String sql = "SELECT JobID, Title, Salary, Location, ExpiryDate FROM Jobs WHERE EmployerID = ?";
                        ps = con.prepareStatement(sql);
                        ps.setInt(1, employerId);
                        rs = ps.executeQuery();

                        // Prepare date format for display
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMM yyyy");

                        while (rs.next()) {
                            int jobId = rs.getInt("JobID");
                            String title = rs.getString("Title");
                            String salary = rs.getString("Salary");
                            String location = rs.getString("Location");
                            Date expiryDate = rs.getDate("ExpiryDate");

                            // Format expiryDate for better readability
                            String formattedDate = expiryDate != null ? sdf.format(expiryDate) : "N/A";
            %>
            <tr>
                <td><%= title %></td>
                <td>R <%= salary %></td>
                <td><%= location %></td>
                <td><%= formattedDate %></td>
                <td><a href="viewApplicants.jsp?jobId=<%= jobId %>" class="button">View Applicants</a></td>
            </tr>
            <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (con != null) con.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            %>
        </tbody>
    </table>

    <a href="post_job.jsp" class="button">Post New Job</a>
</body>
</html>
