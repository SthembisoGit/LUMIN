<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || (!role.equals("employer_business") && !role.equals("employer_individual"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Post a New Job</title>
    <link rel="stylesheet" href="styles/main.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0 20px;
        }

        h2 {
            color: #2c8e88;
            margin-top: 30px;
        }

        form {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            margin-top: 30px;
            width: 80%;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        label {
            font-weight: bold;
            margin-bottom: 8px;
            display: block;
        }

        input[type="text"], input[type="date"], textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }

        input[type="submit"] {
            background-color: #2c8e88;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            font-size: 1.1rem;
            cursor: pointer;
            width: 100%;
        }

        input[type="submit"]:hover {
            background-color: #238B7B;
        }

        textarea {
            height: 150px;
            resize: vertical;
        }
    </style>
</head>
<body>

    <h2>Post a New Job</h2>

    <form method="post" action="/LUMIN/PostJobServlet">
        <label>Job Title:</label>
        <input type="text" name="title" required placeholder="Enter the job title"/>

        <label>Salary:</label>
        <input type="text" name="salary" required placeholder="Enter the salary"/>

        <label>Requirements:</label>
        <textarea name="requirements" required placeholder="Enter the job requirements"></textarea>

        <label>Duties:</label>
        <textarea name="duties" required placeholder="Enter the job duties"></textarea>

        <label>Location:</label>
        <input type="text" name="location" required placeholder="Enter the job location"/>

        <label>Expiry Date:</label>
        <input type="date" name="expiryDate" required/>

        <input type="submit" value="Post Job"/>
    </form>

</body>
</html>
