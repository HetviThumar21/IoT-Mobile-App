plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // 🔥 REQUIRED FOR FIREBASE
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.sundaram.iot.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    defaultConfig {
        applicationId = "com.sundaram.iot.app"
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

/* 🔥🔥 ADD THIS BLOCK 🔥🔥 */
dependencies {

    // 🔥 Firebase BoM (manages versions automatically)
    implementation(platform("com.google.firebase:firebase-bom:34.7.0"))

    // 🔥 Firebase Analytics (required base)
    implementation("com.google.firebase:firebase-analytics")

    // 🔥 Firebase Authentication (Email OTP / Login)
    implementation("com.google.firebase:firebase-auth")
}

flutter {
    source = "../.."
}
