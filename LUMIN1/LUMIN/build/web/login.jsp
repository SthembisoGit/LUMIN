<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>LUMIN - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            background: #FEFFFF;
            font-family: 'Poppins', sans-serif;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .top-links {
            text-align: center;
            padding: 15px 0;
            background-color: #e6f2f1;
        }

        .top-links a {
            margin: 0 15px;
            color: #2c8e88;
            font-weight: 600;
            text-decoration: none;
        }

        .top-links a:hover {
            text-decoration: underline;
        }

        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .form-box {
            background: linear-gradient(135deg, #DEF2F1, #FEFFFF);
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            max-width: 400px;
            width: 100%;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #2c8e88;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 0.95rem;
        }

        input:focus {
            border-color: #3AAFA9;
            outline: none;
        }

        button {
            width: 100%;
            background: linear-gradient(to right, #3AAFA9, #2c8e88);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
        }

        button:hover {
            background: linear-gradient(to right, #2c8e88, #3AAFA9);
        }

        .error, .success {
            padding: 12px;
            margin-bottom: 15px;
            border-radius: 6px;
            font-weight: 500;
        }

        .error {
            color: #d8000c;
            background-color: #ffbaba;
        }

        .success {
            color: #4f8a10;
            background-color: #dff2bf;
        }

        .form-box p {
            text-align: center;
            margin-top: 15px;
            font-size: 0.95rem;
        }

        .form-box a {
            color: #2c8e88;
            text-decoration: none;
            font-weight: 600;
        }

        .form-box a:hover {
            text-decoration: underline;
        }

        footer {
            background-color: #17252A;
            color: #fff;
            text-align: center;
            padding: 15px 0;
            font-size: 0.9rem;
            margin-top: auto;
        }

        footer a {
            color: #ffffff;
            text-decoration: underline;
        }

        @media screen and (max-width: 480px) {
            .form-box {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<div class="top-links">
    <a href="index.html">🏠 Home</a>
    <a href="register.jsp">Register</a>
</div>

<div class="container">
    <div class="form-box">
        <h2>🔐 Log In to LUMIN</h2>

        <% if (request.getParameter("registered") != null) { %>
            <div class="success">✅ Registration successful. You can now log in.</div>
        <% } %>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>

        <form action="LoginServlet" method="post">
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>

        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>
</div>

<footer>
    &copy; 2025 LUMIN. All rights reserved. | <a href="index.html">Back to Home</a>
</footer>

</body>
</html>
