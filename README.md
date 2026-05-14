# ProTool

ProTool is a productivity application designed to help you organize your daily life efficiently. With an intuitive interface, you can manage your tasks, stay motivated with daily mantras, and streamline your workflow.

## Features

*   **Task Management**: Create, edit, and delete tasks.
*   **Prioritization**: Organize tasks into Normal, Important, and Urgent priority levels, complete with color-coding.
*   **Drag & Drop Reordering**: Easily reorder tasks by dragging them up or down the list.
*   **Multiselect Actions**: Select multiple tasks at once to perform bulk deletions.
*   **Daily Mantras**: Start your day right with motivational mantras.
*   **Authentication**: Secure email/password and Google Sign-in integration using Firebase.
*   **Real-time Sync**: Tasks are backed by Firebase Cloud Firestore, ensuring your data is always up-to-date across devices.

## Screenshots

Below are screenshots of the main application screens:

### Authentication Screen
<!-- Replace the path below with an actual screenshot image of the Auth Screen -->
![Auth Screen Placeholder](assets/screenshots/auth_screen.png)

### Home Screen
<!-- Replace the path below with an actual screenshot image of the Home Screen -->
![Home Screen Placeholder](assets/screenshots/home_screen.png)

### Tasks Screen
<!-- Replace the path below with an actual screenshot image of the Tasks Screen -->
![Tasks Screen Placeholder](assets/screenshots/tasks_screen.png)

### Mantra Screen
<!-- Replace the path below with an actual screenshot image of the Mantra Screen -->
![Mantra Screen Placeholder](assets/screenshots/mantra_screen.png)

## Getting Started

Follow these steps to set up the project locally on your machine.

### Prerequisites

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version recommended)
*   [Dart SDK](https://dart.dev/get-dart)
*   An IDE like [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) with Flutter plugins installed.
*   A Firebase project.

### Setup Instructions

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/protool.git
    cd protool
    ```

2.  **Install Dependencies:**
    Run the following command to fetch all required packages:
    ```bash
    flutter pub get
    ```

3.  **Firebase Configuration:**
    This project uses Firebase for Authentication and Firestore. You must connect the app to your own Firebase project.
    
    *   **Option A (Firebase CLI - Recommended):**
        Run the FlutterFire CLI command to automatically configure your project for all platforms:
        ```bash
        flutterfire configure
        ```
    *   **Option B (Manual Setup):**
        *   **Android:** Download the `google-services.json` file from your Firebase console and place it in the `android/app/` directory.
        *   **iOS/macOS:** Download the `GoogleService-Info.plist` file and place it within your Xcode project using Xcode.

4.  **Run the App:**
    Connect a physical device or start an emulator/simulator, then run:
    ```bash
    flutter run
    ```

## Project Structure

*   `lib/models/`: Data models representing the structure of objects like `Task`.
*   `lib/screens/`: The main UI screens of the application (`auth_screen`, `home_screen`, `tasks_screen`, `mantra_screen`).
*   `lib/services/`: Logic for external API calls, database interactions (`firestore_service`), and authentication (`auth_service`).
*   `lib/widgets/`: Reusable UI components used across different screens (e.g., `task_dialog`, `common_widgets`).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
