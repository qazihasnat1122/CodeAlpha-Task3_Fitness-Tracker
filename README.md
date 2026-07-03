# 🏋️ Fitness Tracker App

A simple and modern **Flutter Fitness Tracker App** that helps users manually record and monitor their daily fitness activities. The app provides an easy way to log workouts, track calories burned, and view daily or weekly progress through a clean dashboard.

---

# 📱 Features

### 📊 Dashboard

* View today's workout summary
* Total workout duration
* Total calories burned
* Weekly progress overview
* Progress bars and charts

### 📝 Activity Management

* Add a new fitness activity
* Edit existing activities
* Delete activities with confirmation
* View all recorded activities

### 📈 Progress Tracking

* Daily summary
* Weekly summary
* Calories progress
* Workout statistics
* Graphical charts for weekly activity

### ✅ Validation

* Required field validation
* Positive values only for duration and calories
* Date validation
* User-friendly error messages

---

# 🛠️ Technologies Used

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Provider (State Management)
* Material 3 Design
* fl_chart (Charts)
* intl (Date Formatting)

---

# 📂 Project Structure

```text
lib/
│
├── models/
├── providers/
├── services/
├── screens/
├── widgets/
├── utils/
├── constants/
├── firebase/
└── main.dart
```

---

# 🔥 Firebase Features

* User Registration
* User Login
* Secure Authentication
* Cloud Firestore Database
* User-specific fitness records
* Real-time data updates

---

# 📊 Fitness Activity Information

Each activity stores:

* Exercise Type
* Workout Duration (Minutes)
* Calories Burned
* Date
* User ID

---

# 🚀 Getting Started

## 1. Clone the Repository

```bash
git clone https://github.com/qazihasnat1122/fitness-tracker-app.git
```

## 2. Open the Project

```bash
cd fitness-tracker-app
```

## 3. Install Dependencies

```bash
flutter pub get
```

## 4. Configure Firebase

* Create a Firebase project.
* Enable **Email & Password Authentication**.
* Enable **Cloud Firestore**.
* Run:

```bash
flutterfire configure
```

## 5. Run the Application

```bash
flutter run
```

---

# 📦 Main Dependencies

```yaml
firebase_core
firebase_auth
cloud_firestore
provider
intl
fl_chart
```

---

# 🎯 Main Screens

* Splash Screen
* Login Screen
* Register Screen
* Dashboard
* Activity List
* Add Activity
* Edit Activity
* Profile / Logout

---

# ✅ Implemented Features

* User Authentication
* Firebase Integration
* Dashboard
* Daily Progress
* Weekly Progress
* Add Activity
* Edit Activity
* Delete Activity
* Progress Charts
* Responsive UI
* Material 3 Design

---

# 🔮 Future Improvements

* Dark Mode
* Monthly Statistics
* Workout Reminders
* Custom Fitness Goals
* Google Fit Integration
* Apple Health Integration
* Export Activity Data
* Push Notifications

---

# 👨‍💻 Author

**Hasnat Javed**

GitHub: https://github.com/qazihasnat1122

---

# 📄 License

This project was developed for educational purposes using Flutter and Firebase.
