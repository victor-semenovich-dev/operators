# Operators

A schedule for PC and video operators in the Gethsemane church.

## Build app

Put a config.json file to the project root and add the TELEGRAM_BOT_API_KEY value.

Android: flutter build apk --release --dart-define-from-file=config.json
iOS: flutter build ipa --release --dart-define-from-file=config.json --export-options-plist ios/ExportOptions.plist
Web: flutter build web --dart-define-from-file=config.json

Web deploy: firebase deploy
