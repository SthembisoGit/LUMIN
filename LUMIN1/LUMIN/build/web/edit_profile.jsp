<%@page import="java.io.File"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("role");

    // ✅ Use correct session attribute names matching DB and servlets
    String gender = (String) session.getAttribute("Gender");
    String race = (String) session.getAttribute("Race");
    String country = (String) session.getAttribute("Country");
    String physicalAddress = (String) session.getAttribute("PhysicalAddress");
    String regNumber = (String) session.getAttribute("RegNumber");
    String resumePath = (String) session.getAttribute("Resume");  // ✅ Get resume path

    String[] addressParts = new String[5];
    if (physicalAddress != null && !physicalAddress.isEmpty()) {
        String[] split = physicalAddress.split(",");
        for (int i = 0; i < addressParts.length && i < split.length; i++) {
            addressParts[i] = split[i].trim();
        }
    }
    for (int i = 0; i < addressParts.length; i++) {
        if (addressParts[i] == null) addressParts[i] = "";
    }

    request.setAttribute("userRole", userRole);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile - LUMIN</title>
    <style>
        label { display: inline-block; width: 180px; margin: 8px 0; }
        input[type="text"], input[type="password"] { width: 300px; padding: 4px; }
        input[type="file"] { margin: 8px 0; }
    </style>
</head>
<body>
    <h2>Edit Your Profile</h2>

    <form action="ProfileServlet" method="post" enctype="multipart/form-data">
        <label>Full Name:</label>
        <input type="text" name="fullName" value="<%= userName %>" required><br>

        <label>Password:</label>
        <input type="password" name="password" placeholder="Enter new password"><br>

        <c:if test="${userRole == 'applicant' || userRole == 'employer_individual'}">
            <label>Gender:</label>
            <input type="text" name="gender" value="<%= gender != null ? gender : "" %>"><br>

            <label>Race:</label>
            <input type="text" name="race" value="<%= race != null ? race : "" %>"><br>

            <label>Country:</label>
            <input type="text" name="country" value="<%= country != null ? country : "" %>"><br>
        </c:if>

        <label>Street Name:</label>
        <input type="text" name="streetName" value="<%= addressParts[0] %>" required><br>

        <label>City:</label>
        <input type="text" name="city" value="<%= addressParts[1] %>" required><br>

        <label>Suburb:</label>
        <input type="text" name="suburb" value="<%= addressParts[2] %>" required><br>

        <label>Province:</label>
        <input type="text" name="province" value="<%= addressParts[3] %>" required><br>

        <label>Postal Code:</label>
        <input type="text" name="postalCode" value="<%= addressParts[4] %>" required><br>

        <c:if test="${userRole == 'applicant'}">
            <label>Upload New CV:</label>
            <input type="file" name="cvFile" accept=".pdf,.doc,.docx"><br>

            <% if (resumePath != null && !resumePath.isEmpty()) { %>
                <label>&nbsp;</label>
                <span style="color: green;">Current CV: <%= new File(resumePath).getName() %></span><br>
            <% } else { %>
                <label>&nbsp;</label>
                <span style="color: gray;">No CV uploaded yet.</span><br>
            <% } %>
        </c:if>

        <c:if test="${userRole == 'employer_business'}">
            <label>Business Registration Number:</label>
            <input type="text" name="regNumber" value="<%= regNumber != null ? regNumber : "" %>"><br>
        </c:if>

        <button type="submit">Save Changes</button>
    </form>

    <a href="profile.jsp"><button type="button">Back to Profile</button></a>
</body>
</html>