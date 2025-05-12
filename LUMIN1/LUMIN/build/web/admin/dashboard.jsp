<%@ include file="../includes/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            background-color: #f5f5f5;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        ul {
            list-style: none;
            padding: 20px;
            margin: 50px auto;
            text-align: center;
        }

        li {
            margin: 15px 0;
        }

        a {
            text-decoration: none;
            color: #2c8e88;
            font-weight: 600;
        }

        a:hover {
            text-decoration: underline;
        }

        .footer {
            background-color: #17252A;
            color: white;
            text-align: center;
            padding: 15px 0;
            margin-top: auto;
            font-size: 0.9rem;
        }

        .footer a {
            color: #ffffff;
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <ul>
        <li><a href="pendingUsers.jsp">Approve Pending Users</a></li>
        <li><a href="allUsers.jsp">View All Users</a></li>
        <li><a href="../index.html">Home</a></li>
    </ul>

    <div class="footer">
        &copy; 2025 LUMIN. All rights reserved. | <a href="../index.html">Back to Home</a>
    </div>

</body>
</html>
