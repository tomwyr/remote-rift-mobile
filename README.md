# Remote Rift Mobile

Mobile application for **Remote Rift**, an application that lets you queue for League of Legends games from your phone.

<kbd><img width="270" height="600" alt="mobile-1" src="https://github.com/user-attachments/assets/d2fb3804-31ce-4fa6-8263-a1cb8bcd1453" /></kbd>
<kbd><img width="270" height="600" alt="mobile-2" src="https://github.com/user-attachments/assets/266a0a9d-c2a3-4754-a510-b071e4813dae" /></kbd>
<kbd><img width="270" height="600" alt="mobile-3" src="https://github.com/user-attachments/assets/32e55ce2-82aa-4413-abd3-fdf6e495e43d" /></kbd>

## Overview

Remote Rift Mobile is available for Android and iOS. It provides a client interface to the League Client API and communicates with the League Client via the Remote Rift Connector service.

## Architecture

The project is implemented in Flutter, targeting Android and iOS from a single shared codebase.

### Code structure

The project is organized into the following main layers:

- **Data** - Provides model definitions and services for interacting with the Remote Rift Connector API and local device storage.
- **UI** - Contains widgets paired with cubits and state classes, where applicable, to manage feature-specific state and logic.

When launched, the application attempts to connect to the Remote Rift Connector API by resolving its address via mDNS on the local network. If the service is not reachable on the network or the connection is lost, the application attempts to re-establish communication with the Connector service.

### API compatibility

The application requires a minimum Connector API version to function properly. On launch, it compares versions retrieved from the application config and the `/service/info` endpoint. If the API version is too low, users are prompted to update their desktop application.

API changes are assumed to be backward compatible. Any new requirements should be accompanied by a version increase in the application config. To check or modify the current minimum API version, refer to [app_config.dart](./lib/data/app_config.dart).

### Dependencies

This section describes selected third-party packages used throughout the application:

- [bloc](https://pub.dev/packages/bloc) - State management using blocs and cubits, providing clear separation of UI and state logic with minimal boilerplate.

- [slang](https://pub.dev/packages/slang) - Localization via strongly typed code generation from YAML files, with support for advanced translation features.
 
## Usage

To run the application on a mobile device:

1. Download and install the application:
   - **Android**: Download the latest APK from the [GitHub releases page](https://github.com/tomwyr/remote-rift-mobile/releases) and install it on the device. You may need to enable installation from unknown sources in your device settings.
   - **iOS**: Clone the repository, open it in Xcode, and build and run the application locally.
2. Run the Remote Rift Desktop application following the [setup instructions](https://github.com/tomwyr/remote-rift-desktop?tab=readme-ov-file#usage).
3. Start the League of Legends client.
4. Launch the mobile application and wait for the connection to be established.

## Development

To run the project locally:

1. Ensure Flutter is installed.
2. Run `flutter pub get` to install dependencies.
3. Run `dart run slang` to generate localization source files.
4. Run the application using `flutter run` or an IDE.
5. After modifying source files, restart the application or use hot reload.

### Building project

Run `flutter build apk` or `flutter build ios` to compile the application for the target platform.

### Localization

To update localized strings:

1. Edit the YAML files in `lib/i18n`.
2. Run `dart run slang` to regenerate localization code.
3. Reload the application to apply the changes.

## Related Projects

- [Remote Rift Website](https://github.com/tomwyr/remote-rift-website) - A landing page showcasing the application and guiding users on getting started.
- [Remote Rift Connector](https://github.com/tomwyr/remote-rift-connector) - A local service that connects to and communicates with the League Client API.
- [Remote Rift Desktop](https://github.com/tomwyr/remote-rift-desktop) - A desktop application that launches and manages the local connector service.
- [Remote Rift Foundation](https://github.com/tomwyr/remote-rift-foundation) - A set of shared packages containing common UI, utilities, and core logic used across Remote Rift projects.
