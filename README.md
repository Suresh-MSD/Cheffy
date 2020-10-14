# Cheffy User App

## Requirement

- Xcode 11.0
- CocoaPods 1.8.3

## Schemes

This project has two schemes

- Staging: Refer debug configurtion values.
- Release: Refer release configuration values.

## CI

This project uses the AppCentr as CI.

https://appcenter.ms/orgs/Cheffy/apps/Cheffy-iOS/build/branches

- When `dev` branch is updated, CI runs to build stating ipa. The ipa is distributed by using AppCenter distribution feature.
- When `master` branch is updated, CI runs to build production ipa. The ipa is uploaded to iTunes connect.(Not configured yet)
