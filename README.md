# Talkiva

A production-ready Flutter mobile application that helps users practice English using **Speech-to-Text (STT)** and **Text-to-Speech (TTS)** features.

---

## ✨ Features

- 🎤 **Speech to Text** — Convert your voice to text with confidence scoring
- 🔊 **Text to Speech** — Hear natural English voice with adjustable speed, pitch & volume
- 📖 **Practice Mode** — Improve pronunciation with 30+ curated sentences (Beginner / Intermediate / Advanced)
- 💬 **Conversation** — Chat with EnglishBot using voice or text
- 📊 **History** — Track your sessions, scores, and streaks
- 🏠 **Home** — Daily practice sentence, feature grid, and English tips
- 🌙 **Dark / Light Theme** — Toggle and persist across sessions

---

## 🛠 Tech Stack

| Technology | Purpose |
|---|---|
| Flutter 3.x | Cross-platform mobile framework |
| Dart 3.x | Programming language |
| Provider | State management |
| speech_to_text | Voice recognition |
| flutter_tts | Text-to-speech synthesis |
| shared_preferences | Local persistence |
| permission_handler | Runtime permissions |
| flutter_animate | Animations |
| google_fonts | Poppins typography |
| intl | Date/time formatting |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Android Studio / Xcode (for running on devices)

### Setup

```bash
# Clone the repo
git clone https://github.com/azar99ahemad/english-practice-app.git
cd english-practice-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Permissions

**Android** — The following are declared in `AndroidManifest.xml`:
- `RECORD_AUDIO`
- `INTERNET`
- `BLUETOOTH` / `BLUETOOTH_CONNECT`

**iOS** — Added to `Info.plist`:
- `NSMicrophoneUsageDescription`
- `NSSpeechRecognitionUsageDescription`

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/       # Colors, themes, strings
│   ├── utils/           # Permission handler, text comparator
│   └── widgets/         # AnimatedMicButton, CustomAppBar
├── features/
│   ├── speech_to_text/  # STT service, provider, screen
│   ├── text_to_speech/  # TTS service, provider, screen
│   ├── practice_mode/   # Practice repo, provider, screen
│   ├── conversation/    # ChatbotEngine, provider, screen
│   ├── history/         # HistoryRepository, provider, screen
│   └── home/            # HomeScreen
├── main.dart            # App entry point
└── app.dart             # MaterialApp with routing & theme
```

---

## 🏗 Architecture

This app follows **Clean Architecture** with **Provider** for state management:

- **Data layer** — Services and repositories (STTService, TTSService, PracticeRepository, etc.)
- **Presentation layer** — Providers (ChangeNotifier) and Screens
- **Core** — Shared utilities, constants, and reusable widgets

---

## 📸 Screenshots

*Screenshots will be added once the app is run on a device.*

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first.

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
