#!/bin/bash -e
flutter pub run build_runner build --delete-conflicting-outputs
dart ./tool/tools_env.dart