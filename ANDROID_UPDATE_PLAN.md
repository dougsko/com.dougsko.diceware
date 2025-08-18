# Android Version Update Plan

## Overview
Comprehensive plan to update the Diceware app to target the latest Android version (API 34/35) and ensure Play Console compatibility.

## Current State Analysis
- **Target SDK**: 29 (Android 10) - Outdated
- **Compile SDK**: 28 (Android 9) - Very outdated
- **Flutter CI**: 1.20.0 - Extremely outdated (3+ years old)
- **Flutter Local**: 3.13.2 - Outdated (2 years old)
- **Android Gradle Plugin**: 3.5.0 - Extremely outdated
- **Gradle Wrapper**: 5.4.1 - Outdated
- **Kotlin**: 1.3.10 - Very outdated

## Target State
- **Target SDK**: 34 (Android 14) or 35 (Android 15)
- **Compile SDK**: 34 or 35 (same as target)
- **Flutter**: Latest stable (3.27.x)
- **Android Gradle Plugin**: 8.7.x (latest)
- **Gradle Wrapper**: 8.10.x (latest)
- **Kotlin**: 2.1.x (latest)

## Phase 1: Preparation & Environment Setup

### 1.1 Pre-Update Backup
- [ ] Create git branch for the update: `git checkout -b android-api-34-update`
- [ ] Tag current working version: `git tag v3.0.5-pre-android-update`
- [ ] Document current app behavior for regression testing

### 1.2 Local Environment Update
- [ ] Update Flutter to latest stable: `flutter upgrade`
- [ ] Update Flutter SDK path in IDE/environment
- [ ] Verify `flutter doctor` shows no issues

### 1.3 Dependency Analysis
- [ ] Run `flutter pub outdated` to see dependency updates
- [ ] Check compatibility of current dependencies with latest Flutter
- [ ] Identify dependencies that may need version updates

## Phase 2: Flutter Framework Update

### 2.1 Update pubspec.yaml
- [ ] Update Flutter SDK constraint: `sdk: ">=3.0.0 <4.0.0"`
- [ ] Update dependencies to latest compatible versions:
  - `flutter_svg: ^2.0.0` (from ^0.18.0)
  - `http: ^1.0.0` (from 0.12.0+3) 
  - `flutter_launcher_icons: ^0.14.0` (from 0.7.4)
  - `cupertino_icons: ^1.0.8` (from ^0.1.3)

### 2.2 Code Migration
- [ ] Run `flutter pub get` and resolve any dependency conflicts
- [ ] Update deprecated API usage (if any)
- [ ] Test basic app functionality locally
- [ ] Fix any compile-time errors

## Phase 3: Android Configuration Update

### 3.1 Update build.gradle (project level)
```gradle
buildscript {
    ext.kotlin_version = '2.1.0'
    repositories {
        google()
        mavenCentral() // Replace jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.7.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral() // Replace jcenter()
    }
}
```

### 3.2 Update build.gradle (app level)
```gradle
android {
    namespace 'com.dougsko.diceware'
    compileSdk 34
    
    defaultConfig {
        applicationId "com.dougsko.diceware"
        minSdkVersion 21  // Consider updating from 16
        targetSdkVersion 34
        versionName flutterVersionName
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    
    kotlinOptions {
        jvmTarget = '1.8'
    }
}
```

### 3.3 Update Gradle Wrapper
- [ ] Update `gradle/wrapper/gradle-wrapper.properties`:
  ```
  distributionUrl=https\://services.gradle.org/distributions/gradle-8.10-all.zip
  ```

### 3.4 Update gradle.properties
```properties
org.gradle.jvmargs=-Xmx4g -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
android.enableR8=true
android.nonTransitiveRClass=true
```

## Phase 4: Compatibility & Testing

### 4.1 Permission Updates
- [ ] Check if new Android versions require additional permissions
- [ ] Update AndroidManifest.xml for any new privacy requirements
- [ ] Add android:exported="true" to main activity if needed

### 4.2 Local Testing
- [ ] Test on Android emulator with API 34
- [ ] Test on physical devices (if available)
- [ ] Verify all app features work correctly:
  - Dice rolling functionality
  - Dictionary loading (gzip decompression)
  - Random.org API calls
  - Clipboard functionality
  - UI rendering and interactions

### 4.3 Performance Testing  
- [ ] Check app startup time
- [ ] Verify dictionary loading performance
- [ ] Test memory usage with new SDK

## Phase 5: CI/CD Update

### 5.1 Update GitHub Actions Workflow
```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.27.0'  # Latest stable
- uses: actions/setup-java@v4
  with:
    java-version: '17'  # Required for latest Android tooling
```

### 5.2 Update Fastlane Configuration
- [ ] Verify Fastlane compatibility with new build tools
- [ ] Test internal deployment pipeline
- [ ] Update any hardcoded version references

## Phase 6: Play Console Preparation

### 6.1 Version Management
- [ ] Run `python increment_version.py` to bump version
- [ ] Update version to indicate major Android update (e.g., 3.1.0)
- [ ] Create release notes mentioning Android compatibility updates

### 6.2 Play Console Requirements
- [ ] Ensure target SDK 34 meets current Play Console requirements
- [ ] Verify app signing configuration still works
- [ ] Check if new privacy declarations are needed

## Phase 7: Deployment

### 7.1 Internal Testing
- [ ] Deploy to internal testing track first
- [ ] Conduct thorough testing on various Android versions
- [ ] Verify app doesn't crash on startup

### 7.2 Staged Rollout
- [ ] Release to small percentage of users initially
- [ ] Monitor crash reports and user feedback
- [ ] Gradually increase rollout percentage

### 7.3 Full Release
- [ ] Once stable, promote to production
- [ ] Update app store description if needed
- [ ] Monitor post-release metrics

## Risk Mitigation

### High Risk Items
1. **Flutter 1.20.0 → 3.27.x**: Major version jump may break functionality
2. **API 29 → 34**: 5 API level jump may require permission changes
3. **Gradle 3.5.0 → 8.7.x**: Build system changes may cause issues

### Rollback Plan
- [ ] Keep v3.0.5 APK ready for emergency rollback
- [ ] Document rollback procedure in Play Console
- [ ] Have git branch ready to revert changes

### Testing Checklist
- [ ] App launches successfully
- [ ] All dice buttons work
- [ ] Dictionary switching works for all languages
- [ ] Random.org API calls succeed
- [ ] Local PRNG works
- [ ] Copy to clipboard functions
- [ ] Clear functionality works
- [ ] Help dialog displays correctly
- [ ] App doesn't crash on device rotation
- [ ] App works on different screen sizes

## Timeline Estimate
- **Phase 1-2**: 1-2 days (Flutter update)
- **Phase 3**: 1 day (Android config update)  
- **Phase 4**: 2-3 days (Testing and fixes)
- **Phase 5**: 1 day (CI/CD update)
- **Phase 6-7**: 1-2 weeks (Deployment and monitoring)

**Total**: 1-2 weeks for safe, phased deployment

## Dependencies on User Input
- Clarification on risk tolerance and timeline
- Access to Play Console for deployment
- Availability for testing and validation
- Decision on minimum SDK version (keep 16 vs upgrade to 21)

## Success Criteria
- [ ] App successfully targets API 34/35
- [ ] All existing functionality preserved
- [ ] No significant performance regression
- [ ] Successfully deployed to Play Console
- [ ] No increase in crash rates
- [ ] Passes Play Console review process