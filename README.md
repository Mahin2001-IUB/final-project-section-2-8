# P002 - AI Language Learning Tutor App

A simple mobile application built with Flutter that provides a dedicated, conversational AI tutor for language learning, powered by the **Google Gemini API**.

The application uses the `provider` package for global state management and adheres to modern Flutter development standards.

## ✨ Features

* **Language Selection:** A dedicated home screen allows the user to select their desired practice language (e.g., English, Spanish, French).
* **AI Chat Interface:** A clean, intuitive chat UI displays real-time messages between the user and the AI tutor.
* **Gemini API Integration:** Utilizes the `gemini-2.5-flash` model for fast, relevant, and language-specific conversational responses.
* **Session Memory:** Chat history is managed centrally using the Provider pattern and is automatically cleared upon exiting the chat screen to ensure a fresh session for the next selected language.
* **Themed UI:** Supports light and dark mode based on the device's system settings.

## 🛠️ Project Requirements

This project successfully implements all the requirements defined in the specification:

| Requirement | Status | Implementation Detail |
| :--- | :--- | :--- |
| **P002:** Home Page Select language | ✅ Complete | Implemented via `home_screen.dart`. |
| Chat Interface (UI) | ✅ Complete | Implemented via `chat_screen.dart` using a custom message bubble widget. |
| API Integration (Send Message) | ✅ Complete | Handled by `ai_service.dart` using the `http` package. |
| **Session Memory** (Provider) | ✅ Complete | Implemented via `ChatProvider` for global state management. |
| Auto-clear Session | ✅ Complete | `ChatProvider.clearSession()` is called on `ChatScreen.dispose()`. |

## 🚀 Getting Started

### 1. Prerequisites

* Flutter SDK installed and configured.
* Android Studio or VS Code with Flutter/Dart extensions.
* A **Gemini API Key**. Get one from [Google AI Studio](https://ai.google.dev/gemini-api/docs/api-key).

### 2. Setup

Clone the repository and install the dependencies:

```bash
git clone [YOUR_REPO_URL]
cd [your-project-folder]
flutter pub get