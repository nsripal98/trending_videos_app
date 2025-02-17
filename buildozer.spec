name: Android APK Build

on: [push, workflow_dispatch]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Install System Dependencies
        run: |
          sudo apt update
          sudo apt install -y autoconf automake libtool build-essential \
          python3-dev python3-pip libffi-dev libssl-dev \
          zlib1g-dev libncurses5-dev libgdbm-dev \
          libnss3-dev libreadline-dev libsqlite3-dev \
          libbz2-dev liblzma-dev openjdk-17-jdk unzip git

      - name: Prepare Environment
        run: |
          python -m pip install --upgrade pip
          pip install buildozer cython virtualenv python-for-android

      - name: Apply Patch to python-for-android
        run: |
          # Fix AC_CONFIG_HEADERS issue
          git clone https://github.com/kivy/python-for-android.git
          cd python-for-android
          sed -i '/AC_CONFIG_HEADERS/d' configure.ac
          ./autogen.sh

      - name: Clean and Build APK
        run: |
          buildozer android clean
          buildozer android debug --verbose

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: android-apk
          path: bin/*.apk
