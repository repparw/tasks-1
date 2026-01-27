{ pkgs, lib, config, ... }:

let
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "13.0";
    buildToolsVersions = [ "34.0.0" "35.0.0" ];
    platformVersions = [ "34" "35" "36" ];
    includeEmulator = false;
    includeSystemImages = false;
  };
  devenv-profile = "/home/repparw/code/tasks/.devenv/profile";
in
{
  # https://devenv.sh/languages/
  devenv.root = "/home/repparw/code/tasks";
  languages.java.enable = true;
  languages.java.jdk.package = pkgs.jdk21;

  # Android configuration using pkgs.androidenv instead of languages.android
  # which was causing issues.
  
  # https://devenv.sh/packages/
  packages = with pkgs; [
    androidSdk.androidsdk
    git
    unzip
    wget
    zip
    glibc
    ncurses5
    zlib
    # Libraries from shell.nix
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
    freetype
    fontconfig
  ];

  # Environment variables - Android SDK from devenv profile
  env.ANDROID_SDK_ROOT = lib.mkForce "${devenv-profile}/libexec/android-sdk";
  env.ANDROID_HOME = lib.mkForce "${devenv-profile}/libexec/android-sdk";
  
  # Ensure scripts/tasks are available
  scripts.build-app.exec = "JAVA_HOME=${devenv-profile}/lib/openjdk ANDROID_HOME=${devenv-profile}/libexec/android-sdk ANDROID_SDK_ROOT=${devenv-profile}/libexec/android-sdk ./gradlew assembleDebug";
  scripts.test-app.exec = "JAVA_HOME=${devenv-profile}/lib/openjdk ANDROID_HOME=${devenv-profile}/libexec/android-sdk ANDROID_SDK_ROOT=${devenv-profile}/libexec/android-sdk ./gradlew test";
  scripts.clean-app.exec = "JAVA_HOME=${devenv-profile}/lib/openjdk ANDROID_HOME=${devenv-profile}/libexec/android-sdk ANDROID_SDK_ROOT=${devenv-profile}/libexec/android-sdk ./gradlew clean";
  
  enterShell = ''
    # Add AAPT2 override to gradle.properties if not present
    if ! grep -q "android.aapt2FromMavenOverride" gradle.properties 2>/dev/null; then
      echo "android.aapt2FromMavenOverride=${devenv-profile}/libexec/android-sdk/build-tools/34.0.0/aapt2" >> gradle.properties
    fi
    echo "Android Development Environment"
    echo "Java: ${config.languages.java.jdk.package.version}"
    echo "Android SDK: $ANDROID_HOME"
  '';
}
