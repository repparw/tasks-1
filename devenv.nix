{ pkgs, lib, config, ... }:

let
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "13.0";
    buildToolsVersions = [ "34.0.0" "35.0.0" ];
    platformVersions = [ "34" "35" "36" ];
    includeEmulator = false;
    includeSystemImages = false;
  };
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

  # Environment variables
  env.JAVA_HOME = config.languages.java.jdk.package.home;
  env.ANDROID_SDK_ROOT = "${androidSdk.androidsdk}/libexec/android-sdk";
  env.ANDROID_HOME = "${androidSdk.androidsdk}/libexec/android-sdk";
  
  # Ensure scripts/tasks are available
  scripts.build-app.exec = "./gradlew assembleDebug";
  
  enterShell = ''
    echo "Android Development Environment"
    echo "Java: ${config.languages.java.jdk.package.version}"
    echo "Android SDK: $ANDROID_HOME"
  '';
}
