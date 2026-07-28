plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ✅ C'EST LA LIGNE MANQUANTE QUI CAUSAIT TOUT !
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.kh_support_tech"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // ✅ On dit à Kotlin de compiler en Java 17 pour être cohérent
    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.kh_support_tech"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}