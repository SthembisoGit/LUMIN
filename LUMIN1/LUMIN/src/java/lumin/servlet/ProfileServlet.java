package lumin.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.*;

import lumin.model.DBConnection;

@MultipartConfig
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String regNumber = request.getParameter("regNumber");
        String gender = request.getParameter("gender");
        String race = request.getParameter("race");
        String country = request.getParameter("country");
        String streetName = request.getParameter("streetName");
        String city = request.getParameter("city");
        String suburb = request.getParameter("suburb");
        String province = request.getParameter("province");
        String postalCode = request.getParameter("postalCode");

        String physicalAddress = streetName + ", " + city + ", " + suburb + ", " + province + ", " + postalCode;
        String userRole = (String) session.getAttribute("role");

        Part selfieFile = request.getPart("selfieId");
        String selfiePath = null;

        // --- Upload selfie image as file path ---
        if (selfieFile != null && selfieFile.getSize() > 0) {
            String originalFileName = selfieFile.getSubmittedFileName();
            String safeFileName = userEmail.replaceAll("[^a-zA-Z0-9]", "_") + "_selfie_" + System.currentTimeMillis() + "_" + originalFileName;

            String rootPath = getServletContext().getRealPath("/");
            File savedFile = new File(rootPath, safeFileName);
            try (InputStream input = selfieFile.getInputStream()) {
                Files.copy(input, savedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            selfiePath = safeFileName;
        }

        // --- Upload CV as file path (not BLOB) ---
        Part cvFile = request.getPart("cvFile");
        String resumePath = null;

        if (cvFile != null && cvFile.getSize() > 0 && "applicant".equals(userRole)) {
            String originalFileName = cvFile.getSubmittedFileName();
            String safeFileName = userEmail.replaceAll("[^a-zA-Z0-9]", "_") + "_resume_" + System.currentTimeMillis() + "_" + originalFileName;

            String rootPath = getServletContext().getRealPath("/");
            File savedFile = new File(rootPath, safeFileName);

            try (InputStream input = cvFile.getInputStream()) {
                Files.copy(input, savedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            resumePath = safeFileName;
        }

        try (Connection conn = DBConnection.getConnection()) {
            StringBuilder sql = new StringBuilder("UPDATE Users SET FullName = ?, Gender = ?, Race = ?, Country = ?, Province = ?, PhysicalAddress = ?");

            // ✅ Only add RegNumber if user is employer_business
            if ("employer_business".equalsIgnoreCase(userRole)) {
                if (regNumber != null && !regNumber.trim().isEmpty()) {
                    sql.append(", RegNumber = ?");
                }
            }

            if (selfiePath != null) sql.append(", SelfieIDPath = ?");
            if (resumePath != null) sql.append(", Resume = ?"); // Save file path instead of BLOB

            sql.append(" WHERE Email = ?");

            PreparedStatement stmt = conn.prepareStatement(sql.toString());

            int i = 1;
            stmt.setString(i++, fullName);
            stmt.setString(i++, gender);
            stmt.setString(i++, race);
            stmt.setString(i++, country);
            stmt.setString(i++, province);
            stmt.setString(i++, physicalAddress);

            // ✅ Only set RegNumber if user is employer_business
            if ("employer_business".equalsIgnoreCase(userRole)) {
                if (regNumber != null && !regNumber.trim().isEmpty()) {
                    stmt.setString(i++, regNumber);
                }
            }

            if (selfiePath != null) stmt.setString(i++, selfiePath);
            if (resumePath != null) stmt.setString(i++, resumePath); // Set file path here

            stmt.setString(i, userEmail);

            int updated = stmt.executeUpdate();
            if (updated > 0) {
                // ✅ Update session attributes with fresh values
                session.setAttribute("userName", fullName);
                session.setAttribute("Gender", gender);
                session.setAttribute("Race", race);
                session.setAttribute("Country", country);
                session.setAttribute("Province", province);
                session.setAttribute("PhysicalAddress", physicalAddress);
                if (selfiePath != null) session.setAttribute("selfieIdPath", selfiePath);
                if (resumePath != null) session.setAttribute("Resume", resumePath);

                response.sendRedirect("profile.jsp?success=Profile+updated");
            } else {
                response.sendRedirect("profile.jsp?error=No+changes+made");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=Database+error");
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=File+upload+error");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=Server+error");
        }
    }
}