plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.devtools.ksp") version "2.1.0-1.0.29"
    id("com.google.dagger.hilt.android") version "2.51.1"
    id("org.jetbrains.kotlin.plugin.compose") version "2.1.0"
}

buildscript {
    dependencies {
        classpath("org.jetbrains.kotlin.plugin.compose:org.jetbrains.kotlin.plugin.compose.gradle.plugin:2.1.0")
    }
}

android {
    namespace = "com.gbable.widu"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.gbable.widu"
        minSdk = 30
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            // Data Layer 는 패키지명과 서명 인증서가 모두 같아야 앱 사이를 라우팅한다.
            // 폰 앱(app/build.gradle)이 debug 키로 서명되므로 워치도 동일하게 맞춘다.
            // 스토어 배포 시에는 양쪽 모듈을 같은 릴리즈 키스토어로 교체해야 한다.
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.14"
    }
    hilt {
        enableAggregatingTask = false
    }
    testOptions {
        unitTests.isReturnDefaultValues = true
        unitTests.all { it.useJUnitPlatform() }
    }
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.activity:activity:1.10.1")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("androidx.lifecycle:lifecycle-process:2.7.0")

    // Compose
    val composeBom = platform("androidx.compose:compose-bom:2024.05.00")
    implementation(composeBom)
    implementation("androidx.activity:activity-compose:1.10.1")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0")
    implementation("androidx.compose.ui:ui-tooling")
    implementation("androidx.compose.ui:ui-tooling-preview")
    debugImplementation("androidx.compose.ui:ui-tooling")

    // Hilt
    implementation("com.google.dagger:hilt-android:2.51.1")
    ksp("com.google.dagger:hilt-compiler:2.51.1")
    ksp("androidx.hilt:hilt-compiler:1.2.0")
    implementation("androidx.hilt:hilt-navigation-compose:1.2.0")

    // Wear OS
    implementation("androidx.wear:wear:1.3.0")
    implementation("androidx.wear.compose:compose-material:1.4.1")
    implementation("androidx.wear.compose:compose-ui-tooling:1.4.1")
    implementation("androidx.wear:wear-ongoing:1.1.0")

    // Concurrent
    implementation("com.google.guava:guava:33.3.1-android")
    implementation("androidx.concurrent:concurrent-futures-ktx:1.3.0")

    // Health Service
    implementation("androidx.health:health-services-client:1.0.0")

    // Google Mobile Service
    implementation("com.google.android.gms:play-services-wearable:19.0.0")

    // Test
    testImplementation(platform("org.junit:junit-bom:5.11.4"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    testImplementation("io.kotest:kotest-assertions-core-jvm:5.9.1")
    testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test-jvm:1.10.1")
}
