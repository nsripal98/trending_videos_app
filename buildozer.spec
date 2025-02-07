[app]
title = MoneyManager
package.name = moneymanager
package.domain = org.example

source.dir = .
source.include_exts = py,png,jpg,kv,atlas
source.exclude_dirs = tests, bin, venv, .git
source.exclude_patterns = LICENSE,*.spec,*.md
version = 0.1

requirements = python3,kivy==2.1.0,kivymd==1.1.1,pillow

android.permissions = INTERNET, READ_SMS

android.api = 31
android.minapi = 21
android.sdk = 31
android.ndk = 25b
android.ndk_api = 21
android.private_storage = True
android.accept_sdk_license = True
android.arch = armeabi-v7a

android.release_artifact = apk
android.debug_artifact = apk
android.allow_backup = True

p4a.branch = master
p4a.bootstrap = sdl2

android.enable_androidx = True

android.gradle_daemon = True
android.gradle_java_version = 17

orientation = portrait
fullscreen = 0

[buildozer]
log_level = 2
warn_on_root = 1