<%@ include file="../includes/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Applicant Dashboard</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0 20px 80px;
        }

        h2 {
            color: #2c8e88;
            margin-top: 30px;
        }

        ul {
            list-style: none;
            padding: 0;
            margin-top: 30px;
        }

        li {
            margin: 15px 0;
        }

        a {
            text-decoration: none;
            font-weight: 600;
            color: #2c8e88;
            font-size: 1.1rem;
        }

        a:hover {
            text-decoration: underline;
        }

        .footer {
            background-color: #17252A;
            color: white;
            text-align: center;
            padding: 15px 0;
            position: fixed;
            bottom: 0;
            width: 100%;
            font-size: 0.9rem;
        }

        .footer a {
            color: #ffffff;
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <h2>? Applicant Dashboard</h2>
    
    <ul>
        <li><a href="/LUMIN/view_posted_jobs.jsp">Browse Jobs</a></li>
        <li><a href="generateCV.jsp">Generate AI CV</a></li>
        <li><a href="/LUMIN/myApplications.jsp">My Applications</a></li>
    </ul>

    <div class="footer">
        &copy; 2025 LUMIN. All rights reserved. | <a href="../index.html">Back to Home</a>
    </div>
</body>
</html>
