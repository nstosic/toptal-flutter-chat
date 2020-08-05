[![Codemagic build status](https://api.codemagic.io/apps/5c9fc907581a2d000dec7fda/5c9fc907581a2d000dec7fd9/status_badge.svg)](https://codemagic.io/apps/5c9fc907581a2d000dec7fda/5c9fc907581a2d000dec7fd9/latest_build)

# Toptal Flutter Chat

Cross-platform demo chat client developed using Flutter & Firebase for Toptal Engineering Blog article.

# Build environment

This project is developed to work with `flutter channel stable`. There is no guarantee that it will work on different flutter channels.

# API keys

Note - if you clone this repository and try running the project, it'll fail because I've removed API keys for Facebook and Firebase. Refer to the [Facebook](https://developers.facebook.com/docs/facebook-login/) or [Firebase](https://firebase.google.com/docs/flutter/setup) official documentation for a step-by-step guide to setting up the project.

# V2 refactor pending

As there's an ongoing process of refactoring [FlutterFire](https://github.com/FirebaseExtended/flutterfire/issues/2582) libraries to offer better multi-platform support, I'll also be rewriting this repository to target the latest releases from FlutterFire (after the library refactoring effort is completed) and will add support for macOS and web platforms. I do not have a timeline for this yet, but it likely won't be completed before October.
