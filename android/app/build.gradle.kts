plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // لازم يكون Flutter plugin بعد Android و Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.project"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.project"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // مؤقتًا نستخدم debug signing علشان تقدر تبني APK وتشغله
            signingConfig = signingConfigs.getByName("debug")
            // اختياري: تفعيل minify لو عايز تصغر حجم الكود
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}
