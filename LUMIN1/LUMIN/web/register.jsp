<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>LUMIN - Register</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            background: #FEFFFF;
            font-family: 'Poppins', sans-serif;
            color: #17252A;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        form {
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

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="file"],
        select {
            width: 100%;
            padding: 10px;
            margin: 10px 0 20px;
            border: 1px solid #BFC4BC;
            border-radius: 6px;
            font-size: 0.95rem;
        }

        input:focus, select:focus {
            border-color: #3AAFA9;
            outline: none;
        }

        label {
            font-weight: 500;
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

        #businessFields, #individualFields {
            display: none;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
        }

        .login-link a {
            color: #2c8e88;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
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

        @media screen and (max-width: 480px) {
            form {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<div class="top-links">
    <a href="index.html">🏠 Home</a>
    <a href="login.jsp">Login</a>
</div>

<div class="container">
    <form action="RegisterServlet" method="post" enctype="multipart/form-data">
        <h2>🔐 Create an Account</h2>

        <input type="text" name="fullName" placeholder="Full Name" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>

        <select name="role" required onchange="toggleVerification(this.value)">
            <option value="">Select Role</option>
            <option value="applicant">Applicant</option>
            <option value="employer_business">Employer (Business)</option>
            <option value="employer_individual">Employer (Individual)</option>
        </select>

        <div id="businessFields">
            <input type="text" name="regNumber" placeholder="Business Registration Number">
        </div>

        <div id="individualFields">
            <label>Upload Selfie with ID:</label>
            <input type="file" name="selfieId" accept="image/png, image/jpeg">
        </div>

        <button type="submit">Register</button>

        <div class="login-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </form>
</div>

<footer>
    &copy; 2025 LUMIN. All rights reserved. | <a href="index.html" style="color: #fff; text-decoration: underline;">Back to Home</a>
</footer>

<script>
    function toggleVerification(role) {
        document.getElementById('businessFields').style.display = role === 'employer_business' ? 'block' : 'none';
        document.getElementById('individualFields').style.display = role === 'employer_individual' ? 'block' : 'none';
    }

    document.querySelector('form').addEventListener('submit', function(e) {
        const role = document.querySelector('select[name="role"]').value;
        const fileInput = document.querySelector('input[name="selfieId"]');

        if (role === 'employer_individual' && fileInput && fileInput.files.length > 0) {
            const file = fileInput.files[0];
            const allowedTypes = ['image/jpeg', 'image/png'];
            if (!allowedTypes.includes(file.type)) {
                alert("Only JPG or PNG images are allowed.");
                e.preventDefault();
                return;
            }

            if (file.size > 2 * 1024 * 1024) {
                alert("Image size must be less than 2MB.");
                e.preventDefault();
            }
        }
    });
</script>

</body>
</html>
