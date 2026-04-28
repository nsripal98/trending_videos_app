# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep model classes
-keep class com.trendvault.app.** { *; }

# Gson / JSON
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**

# OkHttp / Dio
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# WebView
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
}

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# General
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
