# 🚀 Quick Start Guide

Get Releaf up and running in 5 minutes!

---

## 📋 Prerequisites

Make sure you have these installed:

- ☕ **Java 25** - [Download Here](https://openjdk.org/)
- 🔧 **Git** - [Download Here](https://git-scm.com/)

---

## ⚡ Quick Setup (Local Development)

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/yourusername/Releaf.git
cd Releaf
```

### 2️⃣ Run the Application

**Linux/Mac:**
```bash
./gradlew bootRun
```

**Windows:**
```cmd
gradlew.bat bootRun
```

### 3️⃣ Access the Application

Open your browser and go to:
```
http://localhost:8080
```

**That's it!** 🎉 The app uses H2 in-memory database by default.

---

## 🔑 Default Credentials

### Admin Account
- **Username:** `admin`
- **Password:** `admin123`

### Test User Account
- **Username:** `user`
- **Password:** `user123`

> ⚠️ **Important:** Change these passwords after first login!

---

## 🌐 Deploy to Cloud (Free)

### Option 1: Railway (Recommended)

1. Push code to GitHub
2. Go to [railway.app](https://railway.app)
3. Click "Deploy from GitHub repo"
4. Select your repository
5. Add PostgreSQL database
6. Done! 🎉

### Option 2: Render

1. Push code to GitHub
2. Go to [render.com](https://render.com)
3. Create new Web Service
4. Connect GitHub repo
5. Configure:
   - Build: `./gradlew build -x test`
   - Start: `java -Dserver.port=$PORT -jar build/libs/*.jar`
6. Add PostgreSQL database
7. Set environment variables
8. Deploy! 🚀

**For detailed deployment instructions, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)**

---

## 📁 Project Structure

```
Releaf/
├── src/main/java/           # Java source code
├── src/main/webapp/         # JSP views
├── src/main/resources/      # Configuration files
├── build.gradle             # Dependencies
└── README.md                # Documentation
```

**For complete structure, see [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)**

---

## 🛠️ Common Commands

### Build the Project
```bash
./gradlew build
```

### Run Tests
```bash
./gradlew test
```

### Clean Build
```bash
./gradlew clean build
```

### Create JAR File
```bash
./gradlew bootJar
# Output: build/libs/*.jar
```

---

## 🐛 Troubleshooting

### Port Already in Use?
```bash
# Kill process on port 8080
# Linux/Mac:
lsof -ti:8080 | xargs kill -9

# Windows:
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Permission Denied: ./gradlew?
```bash
# Make gradlew executable
chmod +x gradlew
```

### Build Failed?
```bash
# Clear cache and rebuild
./gradlew clean build --refresh-dependencies
```

### Java Version Issues?
```bash
# Check Java version
java -version

# Should be Java 25 or higher
```

---

## 📚 Next Steps

1. ✅ Login with admin credentials
2. ✅ Change default password
3. ✅ Create some topics and tasks
4. ✅ Register a test user account
5. ✅ Complete a task as user
6. ✅ Review and approve as admin

---

## 🤝 Need Help?

- 📖 Read the [full README](README.md)
- 🚀 Check [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- 🏗️ Review [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)
- 🐛 [Open an Issue](https://github.com/yourusername/Releaf/issues)

---

## 🌟 Features to Explore

### As User
- 📝 Register account
- 🎯 Complete eco-tasks
- 🏆 Earn points
- 📊 Track impact
- 🥇 View leaderboard

### As Admin
- 👥 Manage users
- 📝 Create topics
- ✏️ Add tasks
- ✅ Approve submissions
- 📊 View reports

---

<div align="center">

### 🌱 Happy Coding!

Made with 💚 for a greener planet

**Star ⭐ this repo if you find it useful!**

</div>
