# 🕹️ Super Fly — Flutter + Flame Endless Runner

**Super Fly** is a mobile-first, arcade-style **endless runner** built with **Flutter** and **Flame**.  
It features smooth joystick controls, a fixed camera resolution, reactive **HUD**, **Pause** & **Main Menu** overlays, and a plug-and-play **Top-5 Leaderboard** (local stub with an easy swap to Firestore).

---

## 🚀 Tech Stack

- **Engine / UI:** Flutter + Flame  
- **Overlays:** Flutter widgets layered over the game (HUD, Pause, Main Menu, High Scores)  
- **Reactivity:** `ValueNotifier` → live HUD score updates  
- **(Optional) Backend:** Firebase (Firestore) for cloud leaderboard  
- **Targets:** Web, Android, iOS

---

## ✨ Features

- 🎮 **Joystick Controls** — on-screen stick with tuned margins & priority  
- 🧱 **Obstacle Spawner** — configurable spawn rate, speed, and margins  
- 🖼️ **Background & Ground** — simple, extensible world setup  
- 🧩 **Overlays** — HUD (score + pause), Pause Menu, Main Menu, High Scores  
- 🏆 **Leaderboard** — local Top-5 (in-memory) → swap to Firestore easily  
- 📏 **Virtual Resolution** — camera locked to **400×800** for predictable layout  
- 🌐 **Responsive Web Wrapper** — centers & clips the game inside a gradient frame

---

## 📁 Project Structure

    lib/
    ├─ components/
    │ ├─ background.dart
    │ ├─ ground.dart
    │ ├─ obstacle.dart
    │ └─ player.dart
    ├─ config.dart
    ├─ game.dart # FlyRun (FlameGame): world, scoring, overlays control
    ├─ main.dart # GameWidget + overlayBuilderMap + responsive wrapper
    └─ overlays.dart # HUD, PauseMenu, MainMenu, HighScores + local ScoreService stub

> Assets live under `assets/images/` (see your `pubspec.yaml` for asset registration).

---

## ⚙️ Setup & Run

### 1) Prerequisites
- Flutter SDK installed (`flutter doctor` clean)
- (Optional) Firebase project if you want cloud leaderboard

### 2) Install deps
  
    flutter pub get
    # Web
    flutter run -d chrome
    
    # Android (device or emulator)
    flutter run -d android
    
    # iOS (simulator)
    flutter run -d ios

## 🔧 Configuration
Tune gameplay in lib/config.dart (spawn rate, base speeds, margins).
Camera resolution is fixed in FlyRun.onLoad():

    camera.viewport = FixedResolutionViewport(resolution: Vector2(400, 800));

## 📬 Contact
  - Email: arkaroy839@gmail.com
  - LinkedIn: https://www.linkedin.com/in/arka-roy-ab79a4351/



