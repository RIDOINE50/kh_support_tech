pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // ✅ Version stable pour Flutter 3.24 (au lieu de 9.0.1 qui est trop récente)
    id("com.android.application") version "8.1.0" apply false 
    // ✅ Version Kotlin stable (au lieu de 2.3.20)
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false 
}

include(":app")