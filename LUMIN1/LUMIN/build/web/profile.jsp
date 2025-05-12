<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*, java.sql.*" %>

<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");

    // 🔄 Refresh session data from the database using DBConnection
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = lumin.model.DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT * FROM Users WHERE EMAIL = ?");
        ps.setString(1, userEmail);
        rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("userName", rs.getString("FULLNAME"));
            session.setAttribute("role", rs.getString("ROLE"));
            session.setAttribute("Gender", rs.getString("GENDER"));
            session.setAttribute("Race", rs.getString("RACE"));
            session.setAttribute("Country", rs.getString("COUNTRY"));
            session.setAttribute("PhysicalAddress", rs.getString("PHYSICALADDRESS"));
            session.setAttribute("RegNumber", rs.getString("REGNUMBER"));
            session.setAttribute("Resume", rs.getString("RESUME"));  // Resume path
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }

    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("role");
    String gender = (String) session.getAttribute("Gender");
    String race = (String) session.getAttribute("Race");
    String country = (String) session.getAttribute("Country");
    String physicalAddress = (String) session.getAttribute("PhysicalAddress");
    String regNumber = (String) session.getAttribute("RegNumber");
    String resumePath = (String) session.getAttribute("Resume");

    String[] addressParts = {"", "", "", "", ""};
    if (physicalAddress != null && !physicalAddress.isEmpty()) {
        String[] split = physicalAddress.split(",");
        for (int i = 0; i < addressParts.length && i < split.length; i++) {
            addressParts[i] = split[i].trim();
        }
    }

    request.setAttribute("userRole", userRole);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Profile - LUMIN</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f4;
        }
        h2 {
            color: #333;
            font-size: 28px;
            margin-bottom: 20px;
        }
        .profile-container {
            background-color: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto;
        }
        .profile-container div {
            margin: 12px 0;
        }
        .profile-container strong {
            color: #333;
        }
        .profile-container a {
            color: #0066cc;
            text-decoration: none;
        }
        .profile-container a:hover {
            text-decoration: underline;
        }
        .button {
            background-color: #0066cc;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-top: 20px;
        }
        .button:hover {
            background-color: #004d99;
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <h2>Your Profile</h2>

        <div><strong>Full Name:</strong> <%= userName %></div>
        <div><strong>Email:</strong> <%= userEmail %></div>

        <c:if test="${userRole == 'applicant' || userRole == 'employer_individual'}">
            <div><strong>Gender:</strong> <%= gender != null ? gender : "Not specified" %></div>
            <div><strong>Race:</strong> <%= race != null ? race : "Not specified" %></div>
            <div><strong>Country:</strong> <%= country != null ? country : "Not specified" %></div>
        </c:if>

        <div><strong>Street Name:</strong> <%= addressParts[0] %></div>
        <div><strong>City:</strong> <%= addressParts[1] %></div>
        <div><strong>Suburb:</strong> <%= addressParts[2] %></div>
        <div><strong>Province:</strong> <%= addressParts[3] %></div>
        <div><strong>Postal Code:</strong> <%= addressParts[4] %></div>

        <c:if test="${userRole == 'applicant'}">
            <div>
                <strong>CV:</strong>
                <% if (resumePath != null && !resumePath.isEmpty()) { %>
                    <a href="DownloadServlet?type=cv" target="_blank">Download CV</a>
                <% } else { %>
                    <span>No CV uploaded yet.</span>
                <% } %>
            </div>
        </c:if>

        <c:if test="${userRole == 'employer_business'}">
            <div><strong>Business Registration Number:</strong> <%= regNumber %></div>
        </c:if>

        <a href="edit_profile.jsp" class="button">Edit Profile</a>
    </div>
</body>
</html>
