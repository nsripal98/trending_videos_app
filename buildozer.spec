[app]
title = VideoApp
package.name = videoapp
package.domain = org.test
source.dir = .
source.include_exts = py,png,jpg,kv,atlas
version = 0.1
requirements = python3,kivy
orientation = portrait
osx.python_version = 3
osx.kivy_version = 1.9.1
fullscreen = 0
android.permissions = INTERNET
android.api = 33
android.minapi = 21
android.sdk = 33
android.ndk = 25b
android.ndk_api = 21
android.accept_sdk_license = True
android.gradle_dependencies = org.xerial:sqlite-jdbc:3.36.0
android.add_aars = libs/*.aar
android.add_jars = libs/*.jar
android.add_libs_armeabi_v7a = libs/android/*.so
android.add_libs_arm64_v8a = libs/android/*.so
android.add_libs_x86 = libs/android/*.so
android.add_libs_x86_64 = libs/android/*.so

[buildozer]
log_level = 2
warn_on_root = 1