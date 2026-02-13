# Development Environment Setup

## Using devenv

This project uses [devenv](https://devenv.sh) for development environment management.

### Setup

Ensure devenv is installed, then enter the development shell:

```bash
devenv shell
```

### Available Commands

Once in the devenv shell:

```bash
# Build debug APK
build-app

# Run tests
test-app

# Clean build artifacts
clean-app

# Manual gradle commands (Java and Android SDK are pre-configured)
./gradlew assembleRelease
./gradlew testDebug
```

### Environment Details

- **Java**: JDK 21 (configured automatically)
- **Android SDK**: Build tools 34.0.0/35.0.0, platforms 34/35/36
- **Environment Variables**: `JAVA_HOME`, `ANDROID_HOME`, `ANDROID_SDK_ROOT` are set automatically

## Troubleshooting

### Android SDK License Issues

If you encounter Android SDK license issues:

```bash
yes | sdkmanager --licenses
```

### devenv not found

Install devenv: https://devenv.sh/getting-started/

Or use the existing profile directly:

```bash
JAVA_HOME=".devenv/profile/lib/openjdk" PATH=".devenv/profile/bin:$PATH" ./gradlew build
```
