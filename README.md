<div align="center">

# 🌱 Releaf - Eco Task Management System

<p align="center">
  <img src="https://svg-banners.vercel.app/api?type=typeWriter&text1=🌱%20Releaf%20–%20Eco%20Task%20Management%20System&width=800&height=100" alt="Releaf Banner">
</p>

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://openjdk.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

</div>

> **🌱 _Releaf_** – A modern web application for eco-task management where users unlock topics, complete green challenges, earn points, and track their environmental impact. 🏆

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#️-tech-stack)
- [Getting Started](#-getting-started)
- [Deployment](#-deployment)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)

---

## 🌟 Overview

Releaf is an eco-friendly task management platform that gamifies environmental action. Users progress through topics, complete sustainability challenges, and earn rewards while tracking their positive environmental impact.

---

## ✨ Features

### 👤 User Features
- 🔐 **Secure Authentication** - User registration & login with Spring Security
- 🎯 **Progressive Topics** - Unlock new environmental topics as you progress
- ✅ **Task Tracking** - Complete eco-challenges and track achievements
- 🖼️ **Profile Management** - Upload and update profile pictures
- 🏆 **Gamification** - Earn points and compete on leaderboards
- 📊 **Impact Dashboard** - Visualize your environmental contribution

### 🛠️ Admin Features
- 📝 **Topic Management** - Create, update, and organize topics
- ✏️ **Task Management** - Add and manage tasks for each topic
- 👥 **User Management** - View and manage registered users
- ✔️ **Content Moderation** - Approve or reject user submissions

---

## 🖥️ Tech Stack

### Backend
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.4-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![Java](https://img.shields.io/badge/Java-25-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring Security](https://img.shields.io/badge/Spring%20Security-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white)
![Spring Data JPA](https://img.shields.io/badge/Spring%20Data%20JPA-6DB33F?style=for-the-badge&logo=spring&logoColor=white)

### Frontend
![JSP](https://img.shields.io/badge/Jakarta%20EE-333333?style=for-the-badge&logo=jakartaee&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)

### Database
![H2](https://img.shields.io/badge/H2-0078D7?style=for-the-badge)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)

### Build Tools
![Gradle](https://img.shields.io/badge/Gradle-02303A?style=for-the-badge&logo=gradle&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

---

## 🚀 Getting Started

### Prerequisites

- ☕ **Java 25** or higher ([Download](https://openjdk.org/))
- 📦 **Gradle 8+** (included via wrapper)
- 🔧 **Git** ([Download](https://git-scm.com/))

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Releaf.git
   cd Releaf
   ```

2. **Configure application properties (Optional)**
   
   The application uses H2 in-memory database by default. For production, configure PostgreSQL in `src/main/resources/application.properties`:
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/releaf_db
   spring.datasource.username=your_username
   spring.datasource.password=your_password
   ```

3. **Build the project**
   ```bash
   ./gradlew build
   ```
   *On Windows, use:*
   ```cmd
   gradlew.bat build
   ```

4. **Run the application**
   ```bash
   ./gradlew bootRun
   ```
   *On Windows, use:*
   ```cmd
   gradlew.bat bootRun
   ```

5. **Access the application**
   
   Open your browser and navigate to:
   ```
   http://localhost:8080
   ```

### Default Admin Credentials

- **Username:** `admin`
- **Password:** `admin123`

> ⚠️ **Important:** Change the default admin password after first login!

---

## 🌐 Deployment

### Deploy to Render (Free)

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

2. **Deploy on Render**
   - Visit [Render](https://render.com/)
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Configure:
     - **Build Command:** `./gradlew build`
     - **Start Command:** `java -jar build/libs/*.jar`
     - **Environment:** Add required variables

3. **Set Environment Variables**
   ```
   SPRING_PROFILES_ACTIVE=prod
   DATABASE_URL=<your-postgres-url>
   ```

### Deploy to Railway (Free)

1. **Deploy via GitHub**
   - Visit [Railway](https://railway.app/)
   - Click "New Project" → "Deploy from GitHub repo"
   - Select your repository

2. **Railway will auto-detect Spring Boot** and deploy automatically

### Deploy to Heroku

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed Heroku deployment instructions.

---

## 📁 Project Structure

```
Releaf/
├── src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── config/          # Configuration classes
│   │   │   ├── controller/      # REST & View controllers
│   │   │   ├── dto/             # Data Transfer Objects
│   │   │   ├── entity/          # JPA entities
│   │   │   ├── repository/      # Data repositories
│   │   │   ├── service/         # Business logic
│   │   │   └── DemoApplication.java
│   │   ├── resources/
│   │   │   ├── static/          # CSS, JS, images
│   │   │   └── application.properties
│   │   └── webapp/
│   │       └── WEB-INF/views/   # JSP views
│   └── test/                     # Unit tests
├── gradle/                       # Gradle wrapper files
├── docs/                         # Documentation
├── build.gradle                  # Build configuration
└── README.md                     # This file
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📧 Contact

**Project Maintainer:** [Your Name]

- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

---

<div align="center">

### ⭐ Star this repository if you find it helpful!

Made with 💚 for a greener planet

</div>
