[app]
title = TrendingVideos
package.name = trendingvideos
package.domain = org.example

source.dir = .
source.include_exts = py,png,jpg,kv,atlas
source.exclude_dirs = tests, bin, venv, .git, .buildozer
source.exclude_patterns = LICENSE,README.md,*.spec,*.md,*.yml,*.github
version = 1.0

requirements = python3,kivy==2.1.0,kivymd==1.1.1,pillow,requests,google-api-python-client,google-auth-httplib2,google-auth-oauthlib,beautifulsoup4,python-dotenv

android.permissions = INTERNET

android.archs = armeabi-v7a
android.api = 31
android.minapi = 21
android.ndk = 25b
android.ndk_api = 21
android.private_storage = True
android.accept_sdk_license = True

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