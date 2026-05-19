<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web%20|%20Desktop-lightgrey" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
</div>

<br>

<div align="center">
  <h1>🧠 CodeRecall</h1>
  <p><strong>Master Java & C++ through gamified offline practice</strong></p>
  <p>A AndroidFlutter app that helps you solidify your programming fundamentals through quizzes, syntax challenges, output prediction puzzles, and algorithm visualizations — all with zero internet required.</p>
</div>

<br>

## ✨ Features

### 📝 Quiz Mode
Multi-topic, multi-difficulty multiple-choice quizzes covering Java and C++ core concepts. Choose your language, topic, difficulty (Easy / Medium / Hard), and number of questions. Get instant feedback with detailed explanations for every answer.

### ⌨️ Syntax Challenge
Test your knowledge of language syntax by identifying correct code patterns. Perfect for memorizing syntax rules and common idioms.

### 🔮 Output Predictor
Given a code snippet, predict what it will output. Sharpens your ability to trace program execution mentally — a critical skill for technical interviews.

### 📊 Algorithm Visualizer
Watch classic algorithms come to life with step-by-step visualizations:
- **Bubble Sort**
- **Linear Search**
- **Binary Search**
- **Stack** operations
- **Queue** operations

### 🏆 Gamification & Progress
- **XP System** — Earn XP for correct answers (more for harder difficulties)
- **Levels** — Progress through levels with formula-based XP thresholds
- **Daily Streaks** — Stay consistent to build your streak
- **Badges** — Unlock achievements for milestones like quiz count, streaks, perfect scores, topic mastery, and more
- **Topic Mastery** — Track Beginner → Intermediate → Expert progress per topic
- **Detailed Stats** — Quiz history, accuracy rates, weak topics identified

### 🎨 Design
- Dark theme inspired by GitHub's color palette
- JetBrains Mono monospace font for a developer-friendly feel
- Smooth animations, confetti effects, and XP gain feedback
- Fully offline — your data stays on-device via SQLite

<br>

## 🛠 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.11+ |
| **Language** | Dart 3.11+ |
| **State Management** | Provider |
| **Local Database** | SQLite (sqflite) |
| **Local Storage** | SharedPreferences |
| **Fonts** | JetBrains Mono |
| **Animations** | flutter_animate, Lottie |

<br>

## 📱 Screenshots

<!-- Replace these with actual screenshots from your app -->
> _Screenshots coming soon_

<br>

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.11 or higher)
- Dart (bundled with Flutter)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/coderecall.git
cd coderecall

# Install dependencies
flutter pub get

# Run the app
flutter run
```

The app will initialize with a seeded database containing questions, challenges, and badge definitions on first launch.

<br>

## 🎯 How to Play

1. Launch the app and complete the onboarding (choose a username and avatar)
2. From the home screen, pick a practice mode:
   - **Quiz** — Select language, topic, difficulty, and question count
   - **Syntax Challenge** — Sprint through syntax questions against the clock
   - **Output Predictor** — Predict code output from snippets
   - **Algorithm Visualizer** — Watch and learn algorithm behavior
3. Earn XP, track your streaks, collect badges, and level up
4. Review your progress on the Progress and Profile tabs

<br>

## 🏗 Project Structure

```
lib/
├── main.dart                  # App entry point & routing
├── animations/                # Confetti, XP gain, correct/wrong animations
├── constants/                 # Colors, strings, text styles, DB constants
├── controllers/               # State controllers (Provider)
├── database/                  # SQLite database helper & migrations
├── models/                    # Data models (User, Badge, Question, etc.)
├── routes/                    # Route name constants
├── services/                  # Business logic (BadgeService, QuestionService, etc.)
├── utils/                     # Helpers (XP calculator, streak helpers, date utils)
├── views/                     # UI screens
│   ├── splash/                # Splash screen with DB initialization
│   ├── onboarding/            # First-time user setup
│   ├── home/                  # Main hub with bottom navigation
│   ├── quiz/                  # Quiz mode (home, play, results)
│   ├── syntax/                # Syntax challenges
│   ├── output_predictor/      # Output prediction puzzles
│   ├── algorithm/             # Algorithm visualizations
│   ├── progress/              # Detailed progress dashboard
│   └── profile/               # User profile & settings
└── widgets/                   # Reusable UI components
```

<br>

## 🧪 Running Tests

```bash
flutter test
```

<br>

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

<br>

<br>

