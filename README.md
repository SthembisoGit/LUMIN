LUMIN Job Portal

A Java-based job portal system that allows applicants to apply for jobs, employers to post jobs, and supports resume uploads.

This is the group project repository for LUMIN Job Portal, built using Java Servlets, JSP, and Apache Derby.

Features

- User roles: Applicant, Employer, Admin
- Resume upload & download
- Prevent duplicate job applications
- Role-based access control
- File-based resume storage (instead of storing in database)
- Session-based login system

Technologies Used

Tool/Technology : Purpose
Java Servlets     : Backend logic
JSP               : Frontend pages
Apache Derby      : Database
HTML/CSS/JSTL     : UI design
Git + GitHub      : Version control

Folder Structure

LUMIN-Job-Portal/
Web Pages/
  WEB-INF/
    web.xml
  admin/
  applicant/
  employer/
  includes/
  uploads/resumes/
  index.html
  login.jsp
  profile.jsp
  register.jsp
  view_posted_jobs.jsp
  aos.js

Source Packages/
  lumin.model/
    DBConnection.java
  lumin.servlet/
    LoginServlet.java
    RegisterServlet.java
    ProfileServlet.java
    ApplyJobServlet.java
    DownloadServlet.java
    ... other servlets

Libraries/

How to Run

1. Open terminal or command prompt.
2. Clone the repo:
   git clone https://github.com/SthembisoGit/LUMIN-Job-Portal.git 
3. Import into an IDE like NetBeans or Eclipse.
4. Set up the Apache Derby database with the required tables:
   - Users, Jobs, Applications
5. Configure the database connection in DBConnection.java
6. Deploy and run on a server like Apache Tomcat

Next Steps / To Do

- Fix resume upload path in ProfileServlet
- Fix resume download in viewApplicants.jsp
- Ensure uploaded resumes persist after redeploying
- Make upload path configurable instead of hardcoded
- Test resume download after redeploying the app

License

MIT License – see LICENSE file

Made with love by Your Group
For academic use – Final Year Project (FYP), Capstone, or Assignment Submission

How to Use This Project

1. Prerequisites:
   - Java Development Kit (JDK) installed
   - Apache Tomcat server (or similar servlet container)
   - Apache Derby or another database system
   - NetBeans, Eclipse, or any Java IDE

2. Setup Steps:

   Step 1: Clone the Repository
      Open terminal or command prompt.
      Run this command:
         git clone https://github.com/SthembisoGit/LUMIN-Job-Portal.git 

   Step 2: Import Into Your IDE
      - Open your IDE (e.g., NetBeans, Eclipse).
      - Choose 'Import Project' or 'Open Project'.
      - Select the folder where you cloned the repo.

   Step 3: Set Up the Database
      - Open Apache Derby (or your preferred DB tool).
      - Create the required tables:
         - Users
         - Jobs
         - Applications
      - Update DBConnection.java with your database credentials.

   Step 4: Configure Web Server
      - Make sure Apache Tomcat is added in your IDE.
      - Set the project to use the correct server.
      - Deploy and run the project.

   Step 5: Test the Application
      - Open a browser and go to:
         http://localhost:8080/LUMIN-Job-Portal
      - Try registering a new user.
      - Log in as applicant, employer, or admin.
      - Upload a resume and apply for a job.

3. For Group Members:
   - Always pull the latest changes before starting work:
      git pull origin main
   - After making changes, commit and push:
      git add .
      git commit -m "Description of changes"
      git push origin main

4. Common Issues to Watch For:
   - Resume upload path might need fixing in ProfileServlet.java

   - Make sure the uploads/resumes folder exists on the server
   - If pages don't load, check if web.xml is correctly configured


[Lumin script.txt](https://github.com/user-attachments/files/20176443/Lumin.script.txt)
CREATE TABLE Users (
    UserID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Role VARCHAR(50), -- 'job_seeker', 'employer', 'service_provider'
    Verified BOOLEAN DEFAULT FALSE,
    SelfieIDPath VARCHAR(255), -- for non-business employers
    RegNumber VARCHAR(100),    -- for business verification
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);





 CREATE TABLE Jobs (
    JobID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    EmployerID INT REFERENCES Users(UserID),
    Title VARCHAR(100),
    Salary VARCHAR(50),
    Requirements CLOB,
    Duties CLOB,
    Location VARCHAR(100),
    ExpiryDate DATE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'active' -- 'active', 'expired'
);




CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    JobID INT REFERENCES Jobs(JobID),
    ApplicantID INT REFERENCES Users(UserID),
    SubmittedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ResumePath VARCHAR(255),
    CONSTRAINT UQ_Applicant_Job UNIQUE (JobID, ApplicantID)
);
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    ProviderID INT REFERENCES Users(UserID),
    Title VARCHAR(100),
    Description CLOB,
    PriceRange VARCHAR(100),
    Location VARCHAR(100),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ServiceProofs (
    ProofID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    ServiceID INT REFERENCES Services(ServiceID),
    FilePath VARCHAR(255)
);

ALTER TABLE Users ADD COLUMN Status VARCHAR(50) DEFAULT 'pending';
-- 'pending' or 'approved'


INSERT INTO Users (FullName, Email, Password, Role, Status)
VALUES ('Admin', 'admin@example.com', 'admin123', 'admin', 'approved');

-- Step 1: Drop the old column (if it exists)
ALTER TABLE Users DROP COLUMN SelfieIDPath;

-- Step 2: Add the new column for storing the image blob
ALTER TABLE Users ADD COLUMN SelfieImage BLOB;

ALTER TABLE Users ADD COLUMN Resume VARCHAR(255);

