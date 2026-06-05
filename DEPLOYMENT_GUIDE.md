# 🚀 Releaf Deployment Guide

এই guide অনুসরণ করে আপনি আপনার Releaf application টি free তে host করতে পারবেন।

---

## 📋 Table of Contents
1. [Railway.app Deployment (Recommended)](#railway-deployment)
2. [Render.com Deployment](#render-deployment)
3. [Important Notes](#important-notes)

---

## 🎯 Railway.app Deployment (Recommended)

### Prerequisites:
- GitHub account
- Railway.app account (GitHub দিয়ে sign up করুন)

### Step 1: GitHub এ Code Push করুন

```bash
# যদি ইতিমধ্যে git initialized না থাকে
git init
git add .
git commit -m "Initial commit for deployment"

# GitHub এ নতুন repository তৈরি করুন, তারপর:
git remote add origin https://github.com/YOUR_USERNAME/releaf.git
git branch -M main
git push -u origin main
```

### Step 2: Railway.app Setup

1. **Railway.app এ যান**: https://railway.app
2. **"Start a New Project"** click করুন
3. **"Deploy from GitHub repo"** select করুন
4. আপনার **Releaf repository** select করুন

### Step 3: PostgreSQL Database Add করুন

1. Project dashboard এ **"+ New"** click করুন
2. **"Database" → "Add PostgreSQL"** select করুন
3. Database automatically provision হবে

### Step 4: Environment Variables Set করুন

Railway dashboard এ আপনার service এ click করে **"Variables"** tab এ যান:

```
SPRING_PROFILES_ACTIVE=prod
DATABASE_URL=${DATABASE_URL}  (Railway automatically এটা set করবে)
APP_BASE_URL=https://your-app-name.railway.app
```

Optional (যদি email functionality চান):
```
MAIL_USERNAME=your-email@outlook.com
MAIL_PASSWORD=your-password
```

### Step 5: Deploy!

- Railway automatically deploy শুরু করবে
- Deployment logs check করুন
- Deploy complete হলে, Railway একটা public URL দিবে
- সেই URL open করলেই আপনার app দেখতে পারবেন! 🎉

### Step 6: Custom Domain (Optional)

Railway এ free subdomain পাবেন: `your-app.railway.app`

Custom domain যোগ করতে:
1. **Settings → Domains** এ যান
2. আপনার domain add করুন
3. DNS records update করুন

---

## 🌐 Render.com Deployment

### Step 1: Render.com এ Sign Up

1. https://render.com এ যান
2. GitHub দিয়ে sign up করুন

### Step 2: New Web Service তৈরি করুন

1. **"New +"** → **"Web Service"** click করুন
2. আপনার GitHub repository connect করুন
3. Releaf repository select করুন

### Step 3: Configure Settings

```
Name: releaf-app
Region: Singapore (closest to Bangladesh)
Branch: main
Build Command: ./gradlew clean build -x test
Start Command: java -Dserver.port=$PORT -Dspring.profiles.active=prod -jar build/libs/*.jar
```

### Step 4: PostgreSQL Database Add করুন

1. Dashboard থেকে **"New +"** → **"PostgreSQL"** select করুন
2. Free tier select করুন
3. Database তৈরি হলে, **Internal Database URL** copy করুন

### Step 5: Environment Variables

Web Service এর **"Environment"** tab এ:

```
SPRING_PROFILES_ACTIVE=prod
DATABASE_URL=<Your PostgreSQL Internal Database URL>
APP_BASE_URL=https://your-app-name.onrender.com
```

### Step 6: Deploy

- **"Create Web Service"** click করুন
- Deployment শুরু হবে (5-10 minutes লাগবে)
- Deploy complete হলে URL access করুন

**⚠️ Note**: Render free tier এ 15 minutes inactivity পর app sleep করে। প্রথম request এ wake up হতে 1-2 minutes লাগতে পারে।

---

## 📝 Important Notes

### Database Migration

Local H2 database থেকে production PostgreSQL এ migrate করার জন্য:

1. **Admin recreate হবে**: Application start হলে automatically admin তৈরি হবে
   - Username: `admin`
   - Password: `admin123`

2. **Users & Data**: Production এ নতুন করে users register করতে হবে

### File Uploads

Production এ file upload এর জন্য cloud storage ব্যবহার করা ভালো:
- AWS S3
- Cloudinary (Free tier: 25GB)
- Imgur API

### Performance Optimization

1. **Hibernate SQL logging** production এ disable করা হয়েছে
2. **Connection pool** optimize করা হয়েছে
3. **DevTools** production এ disable করা হয়েছে

### Security

Production এ যাওয়ার আগে:
1. ✅ Database credentials secure করুন (environment variables)
2. ✅ Admin password change করুন
3. ✅ HTTPS enable করুন (Railway/Render automatically করবে)
4. ✅ H2 console disable করুন (production properties এ already করা আছে)

---

## 🐛 Troubleshooting

### Build Failed?

```bash
# Local এ test করুন
./gradlew clean build -x test
```

### Database Connection Error?

- DATABASE_URL properly set করা আছে কিনা check করুন
- PostgreSQL dependency আছে কিনা verify করুন (`build.gradle`)

### Port Binding Error?

- `server.port=${PORT:8080}` properly set করা আছে কিনা check করুন
- Railway/Render এ PORT environment variable automatically set হয়

### App Logs Check করুন

**Railway**: Dashboard → Service → Logs
**Render**: Dashboard → Service → Logs tab

---

## 📞 Support

যদি কোনো সমস্যা হয়:
1. Deployment logs check করুন
2. GitHub Issues এ post করুন
3. Railway/Render community forum এ ask করুন

---

## 🎉 Success!

Deploy successful হলে আপনার Releaf app এখন publicly accessible!

Share করুন: `https://your-app.railway.app` or `https://your-app.onrender.com`

---

**Made with 🌱 by Your Team**
