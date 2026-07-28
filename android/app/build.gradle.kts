plugins {
    id("com.android.application")
    // Le plugin Flutter Gradle doit être appliqué après les plugins Android et Kotlin.
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

    defaultConfig {
        // TODO: Spécifiez votre propre ID d'application unique
        applicationId = "com.example.kh_support_tech"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Ajoutez votre propre configuration de signature pour la version release.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// ✅ LE BLOC PROBLÉMATIQUE A ÉTÉ SUPPRIMÉ ICI

flutter {
    source = "../.."
}