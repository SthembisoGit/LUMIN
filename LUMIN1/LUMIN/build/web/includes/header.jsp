<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("/LUMIN/login.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    String role = (String) session.getAttribute("role");
%>

<style>
    .lumin-header {
        background: linear-gradient(90deg, #3AAFA9 0%, #2c8e88 100%);
        color: #fff;
        padding: 12px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-family: 'Poppins', sans-serif;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }

    .lumin-header .left, .lumin-header .right {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .lumin-header a {
        color: #ffffff;
        text-decoration: none;
        font-weight: 500;
        transition: color 0.3s;
    }

    .lumin-header a:hover {
        color: #ffd700;
    }

    .lumin-divider {
        height: 2px;
        background: #2c8e88;
        margin-bottom: 20px;
    }
</style>

<div class="lumin-header">
    <div class="left">
        <span>Welcome, <%= userName %> | Role: <%= role %></span>
        <a href="../profile.jsp">Profile</a>
    </div>
    <div class="right">
        <a href="../login.jsp">Logout</a>
    </div>
</div>
<div class="lumin-divider"></div>
