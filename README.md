# Remote Rift Mobile

Mobile application for **Remote Rift**, an application that lets you queue for League of Legends games from your phone.

## Overview

Remote Rift Mobile is available for Android and iOS. It provides a client interface to the League Client API and communicates with the League Client via the Remote Rift Connector service.

## Architecture

The project is implemented in Flutter, targeting Android and iOS from a single shared codebase.

### Code structure

The project is organized into the following main layers:

- **Data** - Provides model definitions and services for interacting with the Remote Rift Connector API and local device storage.
- **UI** - Contains widgets paired with cubits and state classes, where applicable, to manage feature-specific state and logic.

When launched, the application attempts to connect to the Remote Rift Connector API using the address configured in the settings panel. If the address changes or the connection is lost, the application attempts to re-establish communication with the Connector service.

### Dependencies

This section describes selected third-party packages relevant to the application architecture:

**State management** - Implemented using the [bloc](https://pub.dev/packages/bloc) package and cubits, providing clear separation of UI and state logic with minimal boilerplate.

**Localization** - Leverages the [slang](https://pub.dev/packages/slang) package, which generates strongly typed localization code from YAML files while supporting advanced translation features.

## Usage

To run the application on a mobile device:

1. Download and install the application:
   - **Android**: Download the latest APK from the [GitHub releases page](https://github.com/tomwyr/remote-rift-mobile/releases) and install it on the device. You may need to enable installation from unknown sources in your device settings.
   - **iOS**: Clone the repository, open it in Xcode, and build and run the application locally.
2. Run the Remote Rift Connector following the [setup instructions](https://github.com/tomwyr/remote-rift-connector?tab=readme-ov-file#usage).
3. Start the League of Legends client.
4. Launch the mobile application and wait for the connection to be established.

## Development

To run the project locally:

1. Ensure Flutter is installed.
2. Run `flutter pub get` to install dependencies.
3. Run `dart run slang` to generate localization source files.
4. Run the application using `flutter run` or an IDE.
5. After modifying source files, restart the application or use hot reload.

### Localization

To update localized strings:

1. Edit the YAML files in `lib/i18n`.
2. Run `dart run slang` to regenerate localization code.
3. Reload the application to apply the changes.

## Related Projects

- [Remote Rift Website](https://github.com/tomwyr/remote-rift-website) — A landing page showcasing the application and guiding users on getting started.
- [Remote Rift Connector](https://github.com/tomwyr/remote-rift-connector) — A local service that connects to and communicates with the League Client API.
- [Remote Rift Desktop](https://github.com/tomwyr/remote-rift-desktop) — A desktop application that launches and manages the local connector service.
