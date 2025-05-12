package lumin.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;

import java.util.HashMap;
import java.util.Map;

public class DownloadServlet extends HttpServlet {

    // Map of allowed download types
    private static final Map<String, String> DOWNLOAD_TYPES = new HashMap<>();

    static {
        DOWNLOAD_TYPES.put("cv", "Resume");
        DOWNLOAD_TYPES.put("selfie", "selfieImage");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "You must be logged in to download files.");
            return;
        }

        String type = request.getParameter("type");
        if (type == null || !DOWNLOAD_TYPES.containsKey(type)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid download type.");
            return;
        }

        String sessionKey = DOWNLOAD_TYPES.get(type);

        // Get file path from session
        String filePath = (String) session.getAttribute(sessionKey);
        if (filePath == null || filePath.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found.");
            return;
        }

        // Build full path
        String realPath = getServletContext().getRealPath("/");
        Path fullPath = Paths.get(realPath, filePath);

        // Check if file exists
        if (!Files.exists(fullPath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File does not exist.");
            return;
        }

        // Set response headers
        String contentType = getServletContext().getMimeType(fullPath.toString());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        response.setContentLength((int) Files.size(fullPath));
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fullPath.getFileName() + "\"");

        // Stream the file content to response
        try (InputStream input = Files.newInputStream(fullPath);
             OutputStream output = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        }
    }
}