<div align="center">

<p align="center">
  <img src="https://svg-banners.vercel.app/api?type=typeWriter&text1=🌱%20Releaf%20–%20Eco%20Task%20Management%20System&width=800&height=100" alt="Releaf Banner">
</p>


[![License](https://img.shields.io/badge/License-No%20License-red.svg)](https://choosealicense.com/no-permission/)

</div>

**🌱 _Releaf_** – A JSP-based eco-task web app where you unlock topics, complete green challenges, earn points, and track your impact. 🏆

---

## 🖥️ Tech Stack

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![JSP/Servlets](https://img.shields.io/badge/Jakarta%20EE-333333?style=for-the-badge&logo=jakartaee&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)  
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![Gradle](https://img.shields.io/badge/Gradle-02303A?style=for-the-badge&logo=gradle&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)

---

## ✨ Features:

### 👤 User Features
- User registration & login (secure session management)
- Progressive topic unlocking
- Task completion tracking
- Profile picture upload & update
- Points-based gamification

### 🛠️ Admin Features
- Manage topics (create, update, delete)
- Manage tasks for each topic
- View all registered users
- Approve or delete tasks

---

## 📦 Requirements:
- Java 17+ (JDK)
- Apache Tomcat 10+
- MySQL 8+
- Gradle 7+

---

## ⚙️ Installation & Setup:

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/aroyslipk/Releaf.git](https://github.com/aroyslipk/Releaf.git)
    cd Releaf
    ```

## ⚙️ Setup and Deployment Instructions

1. Database Setup
Create a new MySQL database named `releaf_db` by running the following SQL command in your MySQL server:
```
CREATE DATABASE releaf_db;
```
2. Build the Application
Use Gradle to build the project into a deployable .war file by running the following command in the project root directory:
```
./gradlew build
```
  After a successful build, the .war file (e.g., Releaf.war) will be available inside the build/libs/ folder.

3. Access the Application
Open your web browser and navigate to: ( for localhost )
```
http://localhost:8080/Releaf/
```
