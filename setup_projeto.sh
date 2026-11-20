#!/bin/bash
set -e

echo "💎 Configurando PrismKey v1.2.0 Completo (Gboard Themes + Keyvya AI + Lupa + Som/Vibração)..."

rm -rf app gradle build.gradle.kts settings.gradle.kts gradle.properties gradlew gradlew.bat

mkdir -p app/src/main/java/com/prismkey/keyboard/service
mkdir -p app/src/main/java/com/prismkey/keyboard/ui/keyboard
mkdir -p app/src/main/java/com/prismkey/keyboard/ui/theme
mkdir -p app/src/main/java/com/prismkey/keyboard/ai
mkdir -p app/src/main/java/com/prismkey/keyboard/audio
mkdir -p app/src/main/java/com/prismkey/keyboard/data
mkdir -p app/src/test/java/com/prismkey/keyboard
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/xml
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/mipmap-anydpi-v26

# 1. gradle.properties
cat << 'EOF' > gradle.properties
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
android.nonTransitiveRClass=true
EOF

# 2. settings.gradle.kts
cat << 'EOF' > settings.gradle.kts
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "PrismKey"
include(":app")
EOF

# 3. build.gradle.kts
cat << 'EOF' > build.gradle.kts
plugins {
    id("com.android.application") version "8.5.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}
EOF

# 4. app/build.gradle.kts
cat << 'EOF' > app/build.gradle.kts
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.prismkey.keyboard"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.prismkey.keyboard"
        minSdk = 26
        targetSdk = 34
        versionCode = 3
        versionName = "1.2.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
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
}

dependencies {
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.4")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.4")
    implementation("androidx.lifecycle:lifecycle-service:2.8.4")
    implementation("androidx.savedstate:savedstate-ktx:1.2.1")
    implementation("androidx.activity:activity-compose:1.9.1")
    implementation(platform("androidx.compose:compose-bom:2024.06.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    implementation("com.google.mlkit:translate:17.0.3")
    implementation("com.google.mlkit:language-id:17.0.5")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.8.1")
    testImplementation("junit:junit:4.13.2")
}
EOF

# 5. Ícone Vetorial Realista de Prisma para o Launcher
cat << 'EOF' > app/src/main/res/drawable/ic_launcher_background.xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#0B1020"
        android:pathData="M0,0h108v108h-108z" />
    <path
        android:fillColor="#1A274A"
        android:pathData="M0,0 L108,0 L108,54 Q54,84 0,54 Z" />
</vector>
EOF

cat << 'EOF' > app/src/main/res/drawable/ic_launcher_foreground.xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#4F86F7"
        android:pathData="M54,22 L82,54 L54,86 L26,54 Z" />
    <path
        android:fillColor="#93C5FD"
        android:pathData="M54,22 L82,54 L54,54 Z" />
    <path
        android:fillColor="#2563EB"
        android:pathData="M26,54 L54,54 L54,86 Z" />
    <path
        android:fillColor="#E0F2FE"
        android:pathData="M54,32 L70,54 L54,54 Z" />
</vector>
EOF

cat << 'EOF' > app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
EOF

cat << 'EOF' > app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
EOF

# 6. AndroidManifest.xml (Com permissão VIBRATE adicionada)
cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
    <uses-permission android:name="android.permission.VIBRATE" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@android:style/Theme.Material.NoActionBar">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:label="@string/app_name"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <service
            android:name=".service.PrismKeyboardService"
            android:label="@string/app_name"
            android:permission="android.permission.BIND_INPUT_METHOD"
            android:exported="true">
            <intent-filter>
                <action android:name="android.view.InputMethod" />
            </intent-filter>
            <meta-data
                android:name="android.view.im"
                android:resource="@xml/method" />
        </service>

        <service
            android:name=".service.PrismaLensAccessibilityService"
            android:label="@string/lens_service_name"
            android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE"
            android:exported="true">
            <intent-filter>
                <action android:name="android.accessibilityservice.AccessibilityService" />
            </intent-filter>
            <meta-data
                android:name="android.accessibilityservice"
                android:resource="@xml/accessibility_service_config" />
        </service>

    </application>
</manifest>
EOF

# 7. XML Resources
cat << 'EOF' > app/src/main/res/values/strings.xml
<resources>
    <string name="app_name">PrismKey</string>
    <string name="lens_service_name">PrismKey - Lupa Flutuante</string>
    <string name="lens_description">Permite que a Lupa Flutuante do PrismKey leia e traduza textos na tela de forma local e privada.</string>
</resources>
EOF

cat << 'EOF' > app/src/main/res/xml/method.xml
<?xml version="1.0" encoding="utf-8"?>
<input-method xmlns:android="http://schemas.android.com/apk/res/android"
    android:settingsActivity="com.prismkey.keyboard.MainActivity"
    android:supportsSwitchingToNextInputMethod="true">
    <subtype
        android:label="Português (Brasil)"
        android:imeSubtypeLocale="pt_BR"
        android:imeSubtypeMode="keyboard" />
</input-method>
EOF

cat << 'EOF' > app/src/main/res/xml/accessibility_service_config.xml
<?xml version="1.0" encoding="utf-8"?>
<accessibility-service xmlns:android="http://schemas.android.com/apk/res/android"
    android:accessibilityEventTypes="typeWindowContentChanged|typeWindowStateChanged"
    android:accessibilityFeedbackType="feedbackGeneric"
    android:accessibilityFlags="flagDefault|flagRetrieveInteractiveWindows"
    android:canRetrieveWindowContent="true"
    android:description="@string/lens_description"
    android:notificationTimeout="100" />
EOF

# 8. PrefsManager.kt (Sincronização em tempo real + múltiplos temas Gboard + som/vibração)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/data/PrefsManager.kt
package com.prismkey.keyboard.data

import android.content.Context
import android.content.SharedPreferences
import java.io.File

enum class PrismThemeMode(val title: String) {
    LIQUID_DARK("Escuro padrão"),
    LIQUID_LIGHT("Claro padrão"),
    SYSTEM_AUTO("Automático do sistema"),
    DYNAMIC_WALLPAPER("Cores dinâmicas"),
    SOLID_COLOR("Cor sólida"),
    CUSTOM_IMAGE("Foto personalizada")
}

data class SolidThemePreset(
    val name: String,
    val bgHex: Long,
    val accentHex: Long,
    val isLight: Boolean
)

val solidThemePresets = listOf(
    SolidThemePreset("Branco Neve", 0xFFF2F4F8, 0xFF2563EB, true),
    SolidThemePreset("Grafite", 0xFF262C36, 0xFF38BDF8, false),
    SolidThemePreset("Azul Prisma", 0xFF172554, 0xFF60A5FA, false),
    SolidThemePreset("Azul Celeste", 0xFF0F2C67, 0xFF93C5FD, false),
    SolidThemePreset("Vermelho Rubi", 0xFF991B1B, 0xFFFCA5A5, false),
    SolidThemePreset("Verde Esmeralda", 0xFF14532D, 0xFF4ADE80, false),
    SolidThemePreset("Roxo Neon", 0xFF3B0764, 0xFFC084FC, false),
    SolidThemePreset("Preto OLED", 0xFF05070A, 0xFF818CF8, false)
)

class PrefsManager(context: Context) {
    private val prefs: SharedPreferences =
        context.getSharedPreferences("prismkey_prefs_v12", Context.MODE_PRIVATE)

    fun registerListener(listener: SharedPreferences.OnSharedPreferenceChangeListener) {
        prefs.registerOnSharedPreferenceChangeListener(listener)
    }

    fun unregisterListener(listener: SharedPreferences.OnSharedPreferenceChangeListener) {
        prefs.unregisterOnSharedPreferenceChangeListener(listener)
    }

    var themeVersion: Long
        get() = prefs.getLong("theme_version", 1L)
        set(value) = prefs.edit().putLong("theme_version", value).apply()

    fun notifyThemeChanged() {
        themeVersion = System.currentTimeMillis()
    }

    var apiKey: String
        get() = prefs.getString("gemini_api_key", "") ?: ""
        set(value) = prefs.edit().putString("gemini_api_key", value.trim()).apply()

    var themeMode: PrismThemeMode
        get() {
            val name = prefs.getString("theme_mode", PrismThemeMode.LIQUID_DARK.name)
            return runCatching { PrismThemeMode.valueOf(name!!) }.getOrDefault(PrismThemeMode.LIQUID_DARK)
        }
        set(value) {
            prefs.edit()
                .putString("theme_mode", value.name)
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var solidColorBgHex: Long
        get() = prefs.getLong("solid_color_bg", 0xFF172554)
        set(value) {
            prefs.edit()
                .putLong("solid_color_bg", value)
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var solidColorAccentHex: Long
        get() = prefs.getLong("solid_color_accent", 0xFF60A5FA)
        set(value) {
            prefs.edit()
                .putLong("solid_color_accent", value)
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var solidColorIsLight: Boolean
        get() = prefs.getBoolean("solid_color_is_light", false)
        set(value) {
            prefs.edit()
                .putBoolean("solid_color_is_light", value)
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var customImagePath: String?
        get() = prefs.getString("custom_image_path", null)
        set(value) {
            prefs.edit()
                .putString("custom_image_path", value)
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var savedCustomThemes: List<String>
        get() {
            val raw = prefs.getString("saved_custom_themes", "") ?: ""
            return raw.split("\n")
                .map { it.trim() }
                .filter { it.isNotEmpty() && File(it).exists() }
                .distinct()
        }
        set(value) {
            val clean = value.filter { it.isNotBlank() }.distinct().take(12)
            prefs.edit()
                .putString("saved_custom_themes", clean.joinToString("\n"))
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    fun addCustomThemePath(path: String) {
        val current = savedCustomThemes.toMutableList()
        current.remove(path)
        current.add(0, path)
        savedCustomThemes = current
        prefs.edit()
            .putString("custom_image_path", path)
            .putString("theme_mode", PrismThemeMode.CUSTOM_IMAGE.name)
            .putLong("theme_version", System.currentTimeMillis())
            .apply()
    }

    fun removeCustomThemePath(path: String) {
        runCatching { File(path).delete() }
        val updated = savedCustomThemes.filter { it != path }
        savedCustomThemes = updated
        if (customImagePath == path) {
            if (updated.isNotEmpty()) {
                customImagePath = updated.first()
            } else {
                customImagePath = null
                themeMode = PrismThemeMode.LIQUID_DARK
            }
        }
    }

    var overlayDimAlpha: Float
        get() = prefs.getFloat("overlay_dim_alpha", 0.36f)
        set(value) {
            prefs.edit()
                .putFloat("overlay_dim_alpha", value.coerceIn(0f, 0.85f))
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var soundEnabled: Boolean
        get() = prefs.getBoolean("sound_enabled", true)
        set(value) {
            prefs.edit()
                .putBoolean("sound_enabled", value)
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var soundVolume: Float
        get() = prefs.getFloat("sound_volume", 0.75f)
        set(value) {
            prefs.edit()
                .putFloat("sound_volume", value.coerceIn(0.05f, 1.0f))
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var vibrationEnabled: Boolean
        get() = prefs.getBoolean("vibration_enabled", true)
        set(value) {
            prefs.edit()
                .putBoolean("vibration_enabled", value)
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var vibrationDurationMs: Int
        get() = prefs.getInt("vibration_duration_ms", 18)
        set(value) {
            prefs.edit()
                .putInt("vibration_duration_ms", value.coerceIn(8, 55))
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    var lensEnabled: Boolean
        get() = prefs.getBoolean("lens_enabled", false)
        set(value) = prefs.edit().putBoolean("lens_enabled", value).apply()

    var targetLangCode: String
        get() = prefs.getString("target_lang_code", "en") ?: "en"
        set(value) = prefs.edit().putString("target_lang_code", value).apply()

    var pendingReplyContext: String
        get() = prefs.getString("pending_reply_context", "") ?: ""
        set(value) {
            prefs.edit()
                .putString("pending_reply_context", value)
                .putLong("theme_version", System.currentTimeMillis())
                .apply()
        }

    fun clearAllLocalData() {
        savedCustomThemes.forEach { runCatching { File(it).delete() } }
        prefs.edit().clear().apply()
        notifyThemeChanged()
    }
}
EOF

# 9. KeyFeedbackEngine.kt (Som Clássico Estilo iPhone / SwiftKey via PCM + Vibração Háptica)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/audio/KeyFeedbackEngine.kt
package com.prismkey.keyboard.audio

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import com.prismkey.keyboard.data.PrefsManager
import java.util.concurrent.Executors
import kotlin.math.PI
import kotlin.math.exp
import kotlin.math.sin

enum class KeySoundType {
    CHAR,
    SPACE_ENTER,
    DELETE
}

class KeyFeedbackEngine(
    private val context: Context,
    private val prefs: PrefsManager
) {
    private val sampleRate = 44100
    private val executor = Executors.newSingleThreadExecutor()

    private val charTracks = ArrayList<AudioTrack>()
    private val spaceTracks = ArrayList<AudioTrack>()
    private val deleteTracks = ArrayList<AudioTrack>()

    private var charIndex = 0
    private var spaceIndex = 0
    private var deleteIndex = 0

    @Volatile
    private var released = false

    private val vibrator: Vibrator? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        (context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager)?.defaultVibrator
    } else {
        @Suppress("DEPRECATION")
        context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
    }

    init {
        executor.execute {
            if (released) return@execute
            val charPcm = synthesizeClickPcm(freqMain = 2350.0, freqSub = 1150.0, durationMs = 11, decay = 9.5)
            val spacePcm = synthesizeClickPcm(freqMain = 1480.0, freqSub = 720.0, durationMs = 14, decay = 7.5)
            val deletePcm = synthesizeClickPcm(freqMain = 1850.0, freqSub = 950.0, durationMs = 10, decay = 10.5)

            repeat(2) {
                createStaticTrack(charPcm)?.let { charTracks.add(it) }
                createStaticTrack(spacePcm)?.let { spaceTracks.add(it) }
                createStaticTrack(deletePcm)?.let { deleteTracks.add(it) }
            }
        }
    }

    fun trigger(type: KeySoundType) {
        if (released) return

        if (prefs.vibrationEnabled) {
            val ms = prefs.vibrationDurationMs.toLong().coerceIn(8L, 55L)
            runCatching {
                if (vibrator?.hasVibrator() == true) {
                    vibrator.vibrate(VibrationEffect.createOneShot(ms, VibrationEffect.DEFAULT_AMPLITUDE))
                }
            }
        }

        if (prefs.soundEnabled) {
            val vol = prefs.soundVolume.coerceIn(0.05f, 1.0f)
            executor.execute {
                if (released) return@execute
                playFromPool(type, vol)
            }
        }
    }

    fun previewClick() {
        val vol = prefs.soundVolume.coerceIn(0.05f, 1.0f)
        executor.execute {
            if (released) return@execute
            playFromPool(KeySoundType.CHAR, vol)
        }
    }

    private fun playFromPool(type: KeySoundType, volume: Float) {
        val track = when (type) {
            KeySoundType.CHAR -> {
                if (charTracks.isEmpty()) return
                val t = charTracks[charIndex % charTracks.size]
                charIndex++
                t
            }
            KeySoundType.SPACE_ENTER -> {
                if (spaceTracks.isEmpty()) return
                val t = spaceTracks[spaceIndex % spaceTracks.size]
                spaceIndex++
                t
            }
            KeySoundType.DELETE -> {
                if (deleteTracks.isEmpty()) return
                val t = deleteTracks[deleteIndex % deleteTracks.size]
                deleteIndex++
                t
            }
        }

        runCatching {
            if (track.state != AudioTrack.STATE_INITIALIZED) return
            if (track.playState == AudioTrack.PLAYSTATE_PLAYING) {
                track.stop()
            }
            track.reloadStaticData()
            track.setVolume(volume)
            track.play()
        }
    }

    private fun createStaticTrack(pcm: ShortArray): AudioTrack? {
        return runCatching {
            val bufferSizeBytes = pcm.size * 2
            val attrs = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ASSISTANCE_SONIFICATION)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()
            val format = AudioFormat.Builder()
                .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                .setSampleRate(sampleRate)
                .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                .build()
            val track = AudioTrack.Builder()
                .setAudioAttributes(attrs)
                .setAudioFormat(format)
                .setBufferSizeInBytes(bufferSizeBytes)
                .setTransferMode(AudioTrack.MODE_STATIC)
                .build()
            if (track.state == AudioTrack.STATE_INITIALIZED) {
                track.write(pcm, 0, pcm.size)
                track
            } else {
                track.release()
                null
            }
        }.getOrNull()
    }

    private fun synthesizeClickPcm(
        freqMain: Double,
        freqSub: Double,
        durationMs: Int,
        decay: Double
    ): ShortArray {
        val totalSamples = (sampleRate * durationMs) / 1000
        val out = ShortArray(totalSamples)
        var seed = 1337L
        for (i in 0 until totalSamples) {
            val t = i.toDouble() / sampleRate
            val progress = i.toDouble() / totalSamples
            val attack = if (i < 16) i.toDouble() / 16.0 else 1.0
            val envelope = attack * exp(-decay * progress)

            // Som seco tipo iPhone / SwiftKey: transiente curto + corpo suave
            seed = (seed * 1103515245L + 12345L) and 0x7fffffffL
            val noise = ((seed.toDouble() / 0x7fffffffL) * 2.0 - 1.0) * exp(-22.0 * progress)

            val tone = 0.52 * sin(2.0 * PI * freqMain * t) +
                0.33 * sin(2.0 * PI * freqSub * t) +
                0.28 * noise

            val sample = (tone * envelope * 26000.0).toInt().coerceIn(-32767, 32767)
            out[i] = sample.toShort()
        }
        return out
    }

    fun release() {
        released = true
        executor.execute {
            (charTracks + spaceTracks + deleteTracks).forEach { track ->
                runCatching {
                    if (track.playState == AudioTrack.PLAYSTATE_PLAYING) track.stop()
                    track.release()
                }
            }
            charTracks.clear()
            spaceTracks.clear()
            deleteTracks.clear()
        }
        executor.shutdown()
    }
}
EOF

# 10. ImageCropper.kt (Decodificação segura + Recorte Pixel-Perfect estilo Gboard)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/ui/theme/ImageCropper.kt
package com.prismkey.keyboard.ui.theme

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.ImageDecoder
import android.graphics.Matrix
import android.graphics.Paint
import android.net.Uri
import android.os.Build
import java.io.File
import java.io.FileOutputStream
import kotlin.math.roundToInt

object ImageCropper {

    fun loadSafeBitmap(context: Context, uri: Uri, maxDim: Int = 1600): Bitmap? {
        return runCatching {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val source = ImageDecoder.createSource(context.contentResolver, uri)
                ImageDecoder.decodeBitmap(source) { decoder, info, _ ->
                    decoder.allocator = ImageDecoder.ALLOCATOR_SOFTWARE
                    val w = info.size.width
                    val h = info.size.height
                    if (w > maxDim || h > maxDim) {
                        val ratio = maxDim.toFloat() / maxOf(w, h).toFloat()
                        decoder.setTargetSize(
                            (w * ratio).roundToInt().coerceAtLeast(1),
                            (h * ratio).roundToInt().coerceAtLeast(1)
                        )
                    }
                }
            } else {
                val boundsOpts = BitmapFactory.Options().apply { inJustDecodeBounds = true }
                context.contentResolver.openInputStream(uri)?.use {
                    BitmapFactory.decodeStream(it, null, boundsOpts)
                }
                var sampleSize = 1
                val largest = maxOf(boundsOpts.outWidth, boundsOpts.outHeight)
                while (largest / sampleSize > maxDim) {
                    sampleSize *= 2
                }
                val decodeOpts = BitmapFactory.Options().apply {
                    inSampleSize = sampleSize
                    inPreferredConfig = Bitmap.Config.ARGB_8888
                }
                context.contentResolver.openInputStream(uri)?.use {
                    BitmapFactory.decodeStream(it, null, decodeOpts)
                }
            }
        }.getOrNull()
    }

    fun cropAndSaveForKeyboard(
        context: Context,
        sourceBitmap: Bitmap,
        cropWidthPx: Float,
        cropHeightPx: Float,
        totalScale: Float,
        offsetX: Float,
        offsetY: Float
    ): String? {
        if (cropWidthPx <= 10f || cropHeightPx <= 10f) return null
        return runCatching {
            val outWidth = 1080
            val outHeight = (outWidth * (cropHeightPx / cropWidthPx)).roundToInt().coerceIn(360, 1200)
            val exportRatio = outWidth.toFloat() / cropWidthPx

            val output = Bitmap.createBitmap(outWidth, outHeight, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(output)
            canvas.drawColor(Color.BLACK)

            val matrix = Matrix()
            matrix.postTranslate(-sourceBitmap.width / 2f, -sourceBitmap.height / 2f)
            matrix.postScale(totalScale * exportRatio, totalScale * exportRatio)
            matrix.postTranslate(
                outWidth / 2f + offsetX * exportRatio,
                outHeight / 2f + offsetY * exportRatio
            )

            val paint = Paint(Paint.ANTI_ALIAS_FLAG or Paint.FILTER_BITMAP_FLAG)
            canvas.drawBitmap(sourceBitmap, matrix, paint)

            val themesDir = File(context.filesDir, "themes")
            if (!themesDir.exists()) themesDir.mkdirs()

            val outFile = File(themesDir, "prism_theme_${System.currentTimeMillis()}.jpg")
            FileOutputStream(outFile).use { fos ->
                output.compress(Bitmap.CompressFormat.JPEG, 92, fos)
            }
            output.recycle()
            outFile.absolutePath
        }.getOrNull()
    }
}
EOF

# 11. WordPredictor.kt (Sugestões consistentes com aprendizado local de palavras)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/data/WordPredictor.kt
package com.prismkey.keyboard.data

object WordPredictor {
    private val learnedWords = LinkedHashSet<String>()

    private val ptDictionary = listOf(
        "abraço", "agora", "ainda", "ajuda", "ajudar", "algo", "alguém", "amanhã", "amigo", "amigos",
        "antes", "aplicativo", "aqui", "assim", "até", "atualização", "atualizar", "bem", "beleza",
        "boa", "bom", "bora", "brasil", "calma", "casa", "celular", "certeza", "certo", "chegar",
        "claro", "código", "coisa", "coisas", "comigo", "como", "conseguir", "consigo", "conta",
        "corrigir", "criar", "cuidado", "curtir", "dados", "demais", "depois", "desde", "desse",
        "dessa", "deu", "dia", "dias", "dica", "diferente", "digitar", "direito", "disso", "dizer",
        "download", "elegante", "então", "entendi", "enviar", "errado", "erro", "escolher", "escrever",
        "espaço", "espera", "esse", "essa", "estão", "estar", "estava", "estou", "exemplo", "faça",
        "faço", "fácil", "falar", "falta", "fazer", "fazendo", "feito", "feliz", "ficar", "ficou",
        "final", "foi", "fonte", "forma", "foto", "funciona", "funcionando", "funcionar", "função",
        "funções", "galera", "galeria", "gente", "geral", "github", "gostei", "grande", "hoje",
        "hora", "ideia", "idioma", "idiomas", "igual", "imagem", "importante", "incrível", "instalar",
        "inteligência", "internet", "isso", "jeito", "junto", "juntos", "legal", "lembrar", "letra",
        "letras", "limpar", "lindo", "linha", "lista", "local", "logo", "lugar", "lupa", "mais",
        "mandar", "mande", "mas", "melhor", "melhorar", "melhorias", "memória", "mensagem", "mesma",
        "mesmo", "meu", "meus", "minha", "minhas", "modo", "momento", "muito", "muitos", "mundo",
        "nada", "não", "nem", "nessa", "nesse", "ninguém", "noite", "nome", "normal", "nossa",
        "nosso", "nova", "novo", "nunca", "obrigado", "offline", "olha", "onde", "online", "opção",
        "opções", "ótimo", "outra", "outro", "padrão", "página", "palavra", "palavras", "papel",
        "para", "parece", "parede", "parte", "passar", "pedir", "pegar", "pelo", "pela", "pensar",
        "perfeito", "pergunta", "permissão", "pessoa", "pessoas", "pode", "podemos", "poder", "ponto",
        "por", "porque", "português", "pouco", "precisa", "preciso", "prismkey", "privacidade", "privado",
        "problema", "projeto", "pronto", "próxima", "próximo", "público", "qual", "qualquer",
        "quando", "quanto", "quase", "quem", "quer", "quero", "rápido", "realmente", "recurso",
        "recursos", "reescrever", "repositório", "responder", "resposta", "sabe", "saber", "sair",
        "salvar", "segredo", "seguir", "segurança", "sem", "semana", "sempre", "senha", "ser",
        "será", "seu", "seus", "sim", "simples", "sistema", "sobre", "só", "somente", "sua", "suas",
        "sugestão", "sugestões", "talvez", "também", "tarde", "teclado", "teclas", "tela", "tema",
        "temas", "tempo", "temos", "tenta", "tentar", "ter", "testar", "teste", "testes", "texto",
        "textos", "tinha", "tipo", "tirar", "toda", "todas", "todo", "todos", "toque", "trabalho",
        "traduzir", "trazer", "tudo", "última", "último", "uma", "usar", "usando", "usuário", "vai",
        "valeu", "vamos", "verdade", "versão", "vez", "vezes", "vibração", "vídeo", "visual", "você",
        "vocês", "voltar", "vou", "zoom"
    )

    fun learnWord(word: String) {
        val clean = word.trim().lowercase()
        if (clean.length >= 3 && clean.all { it.isLetter() }) {
            learnedWords.add(clean)
            if (learnedWords.size > 150) {
                val first = learnedWords.first()
                learnedWords.remove(first)
            }
        }
    }

    fun suggest(currentWord: String): List<String> {
        val clean = currentWord.trim()
        if (clean.isEmpty()) return emptyList()
        val lower = clean.lowercase()
        val lowerNoAccent = stripAccents(lower)
        val isCapitalized = clean.first().isUpperCase()

        val combined = learnedWords.toList().reversed() + ptDictionary
        val exactMatches = combined.filter { it.startsWith(lower) && it != lower }
        val accentMatches = combined.filter {
            stripAccents(it).startsWith(lowerNoAccent) && it != lower && !exactMatches.contains(it)
        }

        return (exactMatches + accentMatches)
            .distinct()
            .take(3)
            .map { word ->
                if (isCapitalized) word.replaceFirstChar { it.uppercase() } else word
            }
    }

    private fun stripAccents(s: String): String {
        return s.replace("á", "a").replace("à", "a").replace("â", "a").replace("ã", "a")
            .replace("é", "e").replace("ê", "e").replace("í", "i")
            .replace("ó", "o").replace("ô", "o").replace("õ", "o")
            .replace("ú", "u").replace("ç", "c")
    }
}
EOF

# 12. HybridAiEngine.kt (Fallback anti-404 + Detecção Automática de Idioma + Novos Modos de Prompt)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/ai/HybridAiEngine.kt
package com.prismkey.keyboard.ai

import com.google.mlkit.common.model.DownloadConditions
import com.google.mlkit.common.model.RemoteModelManager
import com.google.mlkit.nl.languageid.LanguageIdentification
import com.google.mlkit.nl.translate.TranslateLanguage
import com.google.mlkit.nl.translate.TranslateRemoteModel
import com.google.mlkit.nl.translate.Translation
import com.google.mlkit.nl.translate.TranslatorOptions
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL

data class OfflineLangPack(val name: String, val code: String)

data class LensTranslationResult(
    val detectedLanguageCode: String,
    val detectedLanguageName: String,
    val translatedText: String
)

object HybridAiEngine {
    val availableLanguages = listOf(
        OfflineLangPack("Inglês", TranslateLanguage.ENGLISH),
        OfflineLangPack("Espanhol", TranslateLanguage.SPANISH),
        OfflineLangPack("Francês", TranslateLanguage.FRENCH),
        OfflineLangPack("Italiano", TranslateLanguage.ITALIAN),
        OfflineLangPack("Alemão", TranslateLanguage.GERMAN),
        OfflineLangPack("Japonês", TranslateLanguage.JAPANESE)
    )

    private val geminiModelChain = listOf(
        "gemini-2.5-flash",
        "gemini-2.0-flash",
        "gemini-1.5-flash"
    )

    fun languageDisplayName(code: String): String {
        return when (code.lowercase()) {
            "en" -> "Inglês"
            "es" -> "Espanhol"
            "fr" -> "Francês"
            "it" -> "Italiano"
            "de" -> "Alemão"
            "ja" -> "Japonês"
            "pt" -> "Português"
            "ru" -> "Russo"
            "ko" -> "Coreano"
            "zh" -> "Chinês"
            else -> "Automático"
        }
    }

    suspend fun getDownloadedLanguageCodes(): Set<String> = withContext(Dispatchers.IO) {
        try {
            RemoteModelManager.getInstance()
                .getDownloadedModels(TranslateRemoteModel::class.java)
                .await()
                .map { it.language }
                .toSet()
        } catch (e: Exception) {
            emptySet()
        }
    }

    suspend fun downloadLanguagePack(langCode: String): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            val ptModel = TranslateRemoteModel.Builder(TranslateLanguage.PORTUGUESE).build()
            val targetModel = TranslateRemoteModel.Builder(langCode).build()
            val conditions = DownloadConditions.Builder().build()
            RemoteModelManager.getInstance().download(ptModel, conditions).await()
            RemoteModelManager.getInstance().download(targetModel, conditions).await()
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun deleteLanguagePack(langCode: String): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            val model = TranslateRemoteModel.Builder(langCode).build()
            RemoteModelManager.getInstance().deleteDownloadedModel(model).await()
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun translateOffline(
        text: String,
        sourceLang: String = TranslateLanguage.PORTUGUESE,
        targetLang: String = TranslateLanguage.ENGLISH
    ): Result<String> = withContext(Dispatchers.IO) {
        if (text.isBlank()) return@withContext Result.failure(Exception("Digite algum texto para traduzir."))
        if (sourceLang == targetLang) return@withContext Result.success(text)
        try {
            val options = TranslatorOptions.Builder()
                .setSourceLanguage(sourceLang)
                .setTargetLanguage(targetLang)
                .build()
            val translator = Translation.getClient(options)
            translator.downloadModelIfNeeded(DownloadConditions.Builder().build()).await()
            val translated = translator.translate(text).await()
            translator.close()
            Result.success(translated)
        } catch (e: Exception) {
            Result.failure(Exception("Baixe o pacote de ${languageDisplayName(targetLang)} na aba IA & Lupa."))
        }
    }

    suspend fun detectAndTranslateToPortuguese(text: String): Result<LensTranslationResult> = withContext(Dispatchers.IO) {
        if (text.isBlank()) return@withContext Result.failure(Exception("Nenhum texto encontrado na tela."))
        try {
            val rawDetected = runCatching {
                LanguageIdentification.getClient().identifyLanguage(text).await()
            }.getOrDefault("und")

            val mlKitCode = if (rawDetected == "und") {
                TranslateLanguage.ENGLISH
            } else {
                TranslateLanguage.fromLanguageTag(rawDetected) ?: TranslateLanguage.ENGLISH
            }

            val langName = languageDisplayName(mlKitCode)
            if (mlKitCode == TranslateLanguage.PORTUGUESE) {
                return@withContext Result.success(
                    LensTranslationResult(
                        detectedLanguageCode = mlKitCode,
                        detectedLanguageName = "Português",
                        translatedText = text
                    )
                )
            }

            val options = TranslatorOptions.Builder()
                .setSourceLanguage(mlKitCode)
                .setTargetLanguage(TranslateLanguage.PORTUGUESE)
                .build()
            val translator = Translation.getClient(options)
            translator.downloadModelIfNeeded(DownloadConditions.Builder().build()).await()
            val translated = translator.translate(text).await()
            translator.close()

            Result.success(
                LensTranslationResult(
                    detectedLanguageCode = mlKitCode,
                    detectedLanguageName = langName,
                    translatedText = translated
                )
            )
        } catch (e: Exception) {
            Result.failure(Exception("Conecte à internet uma vez ou baixe o idioma em IA & Lupa."))
        }
    }

    suspend fun runCustomCommand(
        apiKey: String,
        fieldText: String,
        command: String
    ): Result<String> {
        val cleanCmd = command.trim()
        if (cleanCmd.isBlank() && fieldText.isBlank()) {
            return Result.failure(Exception("Digite um texto ou comando para a IA."))
        }
        val prompt = if (fieldText.isNotBlank() && cleanCmd.isNotBlank()) {
            "Aplique a seguinte instrução ao texto abaixo e retorne APENAS o texto final resultante, sem explicações:\n\nInstrução: $cleanCmd\n\nTexto:\n$fieldText"
        } else if (cleanCmd.isNotBlank()) {
            "Atenda ao pedido abaixo de forma direta e pronta para envio em mensagem. Retorne APENAS o texto final, sem introduções:\n\n$cleanCmd"
        } else {
            "Melhore a clareza, ortografia e fluidez do texto abaixo mantendo o idioma original. Retorne APENAS o texto melhorado:\n\n$fieldText"
        }
        return executeGeminiPrompt(apiKey, prompt)
    }

    suspend fun runReplyAction(
        apiKey: String,
        contextText: String,
        intentOrShortcut: String,
        tone: String
    ): Result<String> {
        val hasContext = contextText.isNotBlank()
        val hasIntent = intentOrShortcut.isNotBlank()
        if (!hasContext && !hasIntent) {
            return Result.failure(Exception("Escreva o que deseja responder ou toque em um atalho."))
        }
        val prompt = buildString {
            append("Gere uma única resposta pronta para enviar no chat. Retorne APENAS o texto da resposta, sem aspas nem explicações.\n")
            append("Tom obrigatório: $tone.\n")
            if (hasIntent) append("Intenção / Atalho escolhido: $intentOrShortcut.\n")
            if (hasContext) append("Mensagem ou contexto base:\n$contextText\n")
        }
        return executeGeminiPrompt(apiKey, prompt)
    }

    suspend fun runCorrectAction(apiKey: String, inputText: String): Result<String> {
        if (inputText.isBlank()) {
            return Result.failure(Exception("Digite algum texto para corrigir."))
        }
        val prompt = "Corrija a ortografia, gramática, acentuação e pontuação do texto abaixo mantendo exatamente o mesmo tom e idioma. Retorne APENAS o texto corrigido:\n\n$inputText"
        return executeGeminiPrompt(apiKey, prompt)
    }

    suspend fun runRewriteAction(apiKey: String, inputText: String, variation: String): Result<String> {
        if (inputText.isBlank()) {
            return Result.failure(Exception("Digite algum texto no campo antes de reescrever."))
        }
        val prompt = "Reescreva o texto abaixo no estilo \"$variation\", mantendo o mesmo significado e idioma. Retorne APENAS o texto reescrito:\n\n$inputText"
        return executeGeminiPrompt(apiKey, prompt)
    }

    private suspend fun executeGeminiPrompt(apiKey: String, prompt: String): Result<String> = withContext(Dispatchers.IO) {
        if (apiKey.isBlank()) {
            return@withContext Result.failure(Exception("Configure sua Chave API Gemini na aba IA & Lupa."))
        }

        var lastError = "Falha ao conectar com a IA."
        for (model in geminiModelChain) {
            var conn: HttpURLConnection? = null
            try {
                val endpoint = "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=${apiKey.trim()}"
                conn = (URL(endpoint).openConnection() as HttpURLConnection).apply {
                    requestMethod = "POST"
                    setRequestProperty("Content-Type", "application/json; charset=UTF-8")
                    connectTimeout = 15000
                    readTimeout = 22000
                    doOutput = true
                }

                val payload = JSONObject().apply {
                    put("contents", JSONArray().apply {
                        put(JSONObject().apply {
                            put("parts", JSONArray().apply {
                                put(JSONObject().put("text", prompt))
                            })
                        })
                    })
                }

                OutputStreamWriter(conn.outputStream, "UTF-8").use { it.write(payload.toString()) }

                val code = conn.responseCode
                val stream = if (code in 200..299) conn.inputStream else conn.errorStream
                val body = stream?.bufferedReader()?.use { it.readText() } ?: ""

                if (code in 200..299) {
                    val resultText = JSONObject(body)
                        .getJSONArray("candidates")
                        .getJSONObject(0)
                        .getJSONObject("content")
                        .getJSONArray("parts")
                        .getJSONObject(0)
                        .getString("text")
                        .trim()
                    return@withContext Result.success(resultText)
                }

                if (code == 404 || code == 400) {
                    lastError = "Modelo $model indisponível ($code)."
                    continue
                }
                if (code == 401 || code == 403) {
                    return@withContext Result.failure(Exception("Chave API inválida ou sem permissão ($code)."))
                }
                if (code == 429) {
                    return@withContext Result.failure(Exception("Limite temporário da chave API atingido (429)."))
                }
                lastError = "Erro API ($code). Verifique sua chave ou internet."
            } catch (e: Exception) {
                lastError = "Sem conexão com a nuvem. Verifique sua internet."
            } finally {
                conn?.disconnect()
            }
        }
        Result.failure(Exception(lastError))
    }
}
EOF

# 13. SystemStatusHelper.kt
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/data/SystemStatusHelper.kt
package com.prismkey.keyboard.data

import android.accessibilityservice.AccessibilityServiceInfo
import android.content.ComponentName
import android.content.Context
import android.provider.Settings
import android.view.accessibility.AccessibilityManager
import android.view.inputmethod.InputMethodManager
import com.prismkey.keyboard.service.PrismaLensAccessibilityService
import com.prismkey.keyboard.service.PrismKeyboardService

data class PrismSystemStatus(
    val isKeyboardEnabled: Boolean,
    val isKeyboardDefault: Boolean,
    val canDrawOverlays: Boolean,
    val isAccessibilityEnabled: Boolean
)

object SystemStatusHelper {
    fun checkStatus(context: Context): PrismSystemStatus {
        val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        val expectedImeId = ComponentName(context, PrismKeyboardService::class.java).flattenToShortString()
        val expectedImeFullId = ComponentName(context, PrismKeyboardService::class.java).flattenToString()

        val enabledList = imm.enabledInputMethodList.map { it.id }
        val isEnabled = enabledList.any { it == expectedImeId || it == expectedImeFullId || it.contains(context.packageName) }

        val defaultIme = Settings.Secure.getString(context.contentResolver, Settings.Secure.DEFAULT_INPUT_METHOD) ?: ""
        val isDefault = defaultIme == expectedImeId || defaultIme == expectedImeFullId || defaultIme.contains(context.packageName)

        val canOverlay = Settings.canDrawOverlays(context)

        val am = context.getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
        val enabledServices = am.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
        val expectedAccName = ComponentName(context, PrismaLensAccessibilityService::class.java).flattenToShortString()
        val isAccEnabled = enabledServices.any {
            it.id == expectedAccName || it.id.contains(context.packageName)
        }

        return PrismSystemStatus(
            isKeyboardEnabled = isEnabled,
            isKeyboardDefault = isDefault,
            canDrawOverlays = canOverlay,
            isAccessibilityEnabled = isAccEnabled
        )
    }
}
EOF

# 14. PrismKeyboardView.kt (Painéis Expansíveis de IA estilo Keyvya + Som/Vibração + Sincronia Instantânea de Tema)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/ui/keyboard/PrismKeyboardView.kt
package com.prismkey.keyboard.ui.keyboard

import android.content.ClipboardManager
import android.content.Context
import android.graphics.BitmapFactory
import android.os.Build
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Backspace
import androidx.compose.material.icons.automirrored.filled.KeyboardReturn
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Popup
import androidx.compose.ui.window.PopupProperties
import com.google.mlkit.nl.translate.TranslateLanguage
import com.prismkey.keyboard.ai.HybridAiEngine
import com.prismkey.keyboard.audio.KeyFeedbackEngine
import com.prismkey.keyboard.audio.KeySoundType
import com.prismkey.keyboard.data.PrefsManager
import com.prismkey.keyboard.data.PrismThemeMode
import com.prismkey.keyboard.data.WordPredictor
import com.prismkey.keyboard.service.PrismaLensAccessibilityService
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.io.File

private enum class ActiveAiPanel {
    NONE,
    COMMAND,
    REPLY,
    CORRECT,
    REWRITE,
    TRANSLATE
}

private val accentVariants = mapOf(
    "a" to listOf("á", "à", "â", "ã", "ä", "@"),
    "e" to listOf("é", "è", "ê", "ë", "3"),
    "i" to listOf("í", "ì", "î", "ï", "8"),
    "o" to listOf("ó", "ò", "ô", "õ", "ö", "9"),
    "u" to listOf("ú", "ù", "û", "ü", "7"),
    "c" to listOf("ç", "©"),
    "n" to listOf("ñ"),
    "q" to listOf("1", "%"),
    "w" to listOf("2", "~"),
    "r" to listOf("4", "$"),
    "t" to listOf("5", "€"),
    "y" to listOf("6", "^"),
    "p" to listOf("0", "*"),
    "s" to listOf("$", "§"),
    "d" to listOf("#"),
    "g" to listOf("&"),
    "h" to listOf("-"),
    "j" to listOf("+"),
    "k" to listOf("("),
    "l" to listOf(")"),
    "z" to listOf("_"),
    "x" to listOf("\""),
    "v" to listOf(":"),
    "b" to listOf(";"),
    "m" to listOf("?", "!")
)

private val animatedEmojiList = listOf(
    "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣",
    "😊", "😇", "🙂", "😉", "😍", "🥰", "😘", "😋",
    "😎", "🤩", "🥳", "😏", "🤔", "🫡", "🤗", "🤭",
    "🤫", "😮", "🤯", "🥺", "😢", "😭", "😤", "😡",
    "👍", "👎", "👏", "🙌", "🤝", "🙏", "💪", "✌️",
    "🤞", "🤟", "🤘", "👌", "🫶", "❤️", "🧡", "💛",
    "💚", "💙", "💜", "🖤", "🤍", "💔", "❤️‍🔥", "💯",
    "🔥", "✨", "💎", "🚀", "⚡", "🎉", "🏆", "⚽",
    "🎮", "💻", "📱", "🤖", "🧠", "👀", "🎶", "✅"
)

private val quickCommandChips = listOf(
    "Melhorar texto",
    "Resumir",
    "Mais formal",
    "Mais descontraído",
    "Expandir ideia",
    "Transformar em tópicos",
    "Deixar persuasivo",
    "Corrigir e polir"
)

private val replyShortcutChips = listOf(
    "Confirmar / Sim",
    "Agradecer",
    "Recusar educadamente",
    "Respondo em breve",
    "Pedir detalhes",
    "Propor horário",
    "Resposta formal",
    "Resposta positiva",
    "Pedir desculpas",
    "Parabenizar"
)

private val replyToneChips = listOf(
    "Natural e cordial",
    "Profissional e formal",
    "Curto e direto",
    "Descontraído",
    "Empático",
    "Criativo / leve"
)

private val rewriteVariations = listOf(
    "Melhorar",
    "Profissional",
    "Amigável",
    "Casual",
    "Formal",
    "Mais curto",
    "Mais detalhado",
    "Criativo"
)

@Composable
fun PrismKeyboardView(
    prefs: PrefsManager,
    themeSyncVersion: Long,
    feedback: KeyFeedbackEngine,
    onCommitText: (String) -> Unit,
    onDeleteChar: () -> Unit,
    onEnterPressed: () -> Unit,
    onGetCurrentFieldText: () -> String,
    onGetCurrentWordBeforeCursor: () -> String,
    onReplaceWordBeforeCursor: (String, Int) -> Unit,
    onReplaceCurrentFieldText: (String) -> Unit,
    onOpenAppSettings: () -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    val systemDark = isSystemInDarkTheme()

    var isUpper by remember { mutableStateOf(false) }
    var isSymbolMode by remember { mutableStateOf(false) }
    var showEmojiPanel by remember { mutableStateOf(false) }
    var showClipboardPanel by remember { mutableStateOf(false) }
    var showMoreMenu by remember { mutableStateOf(false) }

    var activeAiPanel by remember { mutableStateOf(ActiveAiPanel.NONE) }
    var aiPromptInput by remember { mutableStateOf("") }
    var typingIntoAiInput by remember { mutableStateOf(false) }
    var selectedReplyTone by remember { mutableStateOf(replyToneChips.first()) }
    var selectedTargetLang by remember { mutableStateOf(prefs.targetLangCode) }
    var lensReplyContext by remember { mutableStateOf("") }

    var aiLoading by remember { mutableStateOf(false) }
    var panelMessage by remember { mutableStateOf<String?>(null) }
    var panelIsError by remember { mutableStateOf(false) }
    var localThemeTick by remember { mutableLongStateOf(0L) }

    var currentTypingWord by remember { mutableStateOf("") }
    var forceShowTools by remember { mutableStateOf(false) }

    val combinedThemeKey = themeSyncVersion + localThemeTick

    // Se a Lupa enviou contexto pelo botão "Responder", abre o painel Responder automaticamente
    LaunchedEffect(themeSyncVersion) {
        selectedTargetLang = prefs.targetLangCode
        val pending = prefs.pendingReplyContext
        if (pending.isNotBlank()) {
            lensReplyContext = pending
            prefs.pendingReplyContext = ""
            activeAiPanel = ActiveAiPanel.REPLY
            typingIntoAiInput = true
            panelMessage = "Mensagem capturada pela Lupa carregada!"
            panelIsError = false
        }
    }

    val suggestions = remember(currentTypingWord) {
        WordPredictor.suggest(currentTypingWord)
    }
    val showSuggestionBar =
        activeAiPanel == ActiveAiPanel.NONE &&
            !showEmojiPanel &&
            !showClipboardPanel &&
            currentTypingWord.isNotBlank() &&
            suggestions.isNotEmpty() &&
            !forceShowTools

    val currentTheme = remember(combinedThemeKey) { prefs.themeMode }
    val dimAlpha = remember(combinedThemeKey) { prefs.overlayDimAlpha }
    val solidBgHex = remember(combinedThemeKey) { prefs.solidColorBgHex }
    val solidAccentHex = remember(combinedThemeKey) { prefs.solidColorAccentHex }
    val solidIsLight = remember(combinedThemeKey) { prefs.solidColorIsLight }

    val isLightPalette = when (currentTheme) {
        PrismThemeMode.LIQUID_LIGHT -> true
        PrismThemeMode.SYSTEM_AUTO -> !systemDark
        PrismThemeMode.DYNAMIC_WALLPAPER -> !systemDark
        PrismThemeMode.SOLID_COLOR -> solidIsLight
        else -> false
    }

    val dynamicBg = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        if (systemDark) dynamicDarkColorScheme(context).surfaceContainerHighest
        else dynamicLightColorScheme(context).surfaceContainerLow
    } else {
        if (systemDark) Color(0xFF141824) else Color(0xFFE9EEF5)
    }

    val containerBg = when (currentTheme) {
        PrismThemeMode.LIQUID_DARK -> Color(0xFF0E1117)
        PrismThemeMode.LIQUID_LIGHT -> Color(0xFFECEFF6)
        PrismThemeMode.SYSTEM_AUTO -> if (systemDark) Color(0xFF0E1117) else Color(0xFFECEFF6)
        PrismThemeMode.DYNAMIC_WALLPAPER -> dynamicBg
        PrismThemeMode.SOLID_COLOR -> Color(solidBgHex)
        PrismThemeMode.CUSTOM_IMAGE -> Color(0xFF0E1117)
    }

    val accentColor = when (currentTheme) {
        PrismThemeMode.SOLID_COLOR -> Color(solidAccentHex)
        else -> Color(0xFF8B5CF6)
    }

    val keyBg = when {
        currentTheme == PrismThemeMode.CUSTOM_IMAGE -> Color(0xFF121621).copy(alpha = 0.62f)
        isLightPalette -> Color.White.copy(alpha = 0.92f)
        else -> Color(0xFF1F2636).copy(alpha = 0.88f)
    }

    val panelBg = if (isLightPalette) Color(0xFFF7F8FC) else Color(0xFF151B28)
    val panelTextColor = if (isLightPalette) Color(0xFF161B26) else Color.White
    val keyContentColor = if (isLightPalette) Color(0xFF12161F) else Color.White

    val borderBrush = Brush.verticalGradient(
        if (isLightPalette) {
            listOf(Color.Black.copy(alpha = 0.08f), Color.Black.copy(alpha = 0.04f))
        } else {
            listOf(Color.White.copy(alpha = 0.24f), Color.White.copy(alpha = 0.06f))
        }
    )

    val customBitmap = remember(combinedThemeKey) {
        val path = prefs.customImagePath
        if (currentTheme == PrismThemeMode.CUSTOM_IMAGE && !path.isNullOrBlank() && File(path).exists()) {
            BitmapFactory.decodeFile(path)?.asImageBitmap()
        } else null
    }

    val alphaRows = listOf(
        listOf("q", "w", "e", "r", "t", "y", "u", "i", "o", "p"),
        listOf("a", "s", "d", "f", "g", "h", "j", "k", "l", "ç"),
        listOf("z", "x", "c", "v", "b", "n", "m")
    )
    val symbolRows = listOf(
        listOf("1", "2", "3", "4", "5", "6", "7", "8", "9", "0"),
        listOf("@", "#", "$", "_", "&", "-", "+", "(", ")", "/"),
        listOf("*", "\"", "'", ":", ";", "!", "?")
    )

    fun readFullClipboardUnlimited(): String {
        val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = cm.primaryClip ?: return ""
        if (clip.itemCount == 0) return ""
        return clip.getItemAt(0).coerceToText(context)?.toString() ?: ""
    }

    fun closeAiPanel() {
        activeAiPanel = ActiveAiPanel.NONE
        typingIntoAiInput = false
        panelMessage = null
        panelIsError = false
    }

    fun openAiPanel(panel: ActiveAiPanel) {
        if (activeAiPanel == panel) {
            closeAiPanel()
        } else {
            activeAiPanel = panel
            showEmojiPanel = false
            showClipboardPanel = false
            showMoreMenu = false
            panelMessage = null
            panelIsError = false
            typingIntoAiInput = (panel == ActiveAiPanel.COMMAND || panel == ActiveAiPanel.REPLY)
        }
    }

    fun executeCommandAi(overrideCmd: String? = null) {
        val cmd = (overrideCmd ?: aiPromptInput).trim()
        val fieldText = onGetCurrentFieldText()
        aiLoading = true
        panelMessage = "Gerando com IA..."
        panelIsError = false
        scope.launch {
            val res = HybridAiEngine.runCustomCommand(prefs.apiKey, fieldText, cmd)
            aiLoading = false
            res.onSuccess { out ->
                if (fieldText.isNotBlank()) onReplaceCurrentFieldText(out) else onCommitText(out)
                aiPromptInput = ""
                panelMessage = "✓ Aplicado!"
                panelIsError = false
            }.onFailure { err ->
                panelMessage = err.message ?: "Erro ao executar comando."
                panelIsError = true
            }
        }
    }

    fun executeReplyAi(shortcutOverride: String? = null) {
        val fieldText = onGetCurrentFieldText()
        val baseContext = if (lensReplyContext.isNotBlank()) lensReplyContext else fieldText
        val intentText = shortcutOverride ?: aiPromptInput
        aiLoading = true
        panelMessage = "Criando resposta ($selectedReplyTone)..."
        panelIsError = false
        scope.launch {
            val res = HybridAiEngine.runReplyAction(
                apiKey = prefs.apiKey,
                contextText = baseContext,
                intentOrShortcut = intentText,
                tone = selectedReplyTone
            )
            aiLoading = false
            res.onSuccess { out ->
                if (fieldText.isNotBlank()) onReplaceCurrentFieldText(out) else onCommitText(out)
                aiPromptInput = ""
                lensReplyContext = ""
                panelMessage = "✓ Resposta gerada!"
                panelIsError = false
            }.onFailure { err ->
                panelMessage = err.message ?: "Erro ao gerar resposta."
                panelIsError = true
            }
        }
    }

    fun executeCorrectAi() {
        val fieldText = onGetCurrentFieldText()
        if (fieldText.isBlank()) {
            panelMessage = "Digite algum texto para corrigir."
            panelIsError = true
            return
        }
        aiLoading = true
        panelMessage = "Corrigindo texto..."
        panelIsError = false
        scope.launch {
            val res = HybridAiEngine.runCorrectAction(prefs.apiKey, fieldText)
            aiLoading = false
            res.onSuccess { out ->
                onReplaceCurrentFieldText(out)
                panelMessage = "✓ Texto corrigido!"
                panelIsError = false
            }.onFailure { err ->
                panelMessage = err.message ?: "Erro na correção."
                panelIsError = true
            }
        }
    }

    fun executeRewriteAi(style: String) {
        val fieldText = onGetCurrentFieldText()
        if (fieldText.isBlank()) {
            panelMessage = "Digite algum texto para reescrever."
            panelIsError = true
            return
        }
        aiLoading = true
        panelMessage = "Reescrevendo ($style)..."
        panelIsError = false
        scope.launch {
            val res = HybridAiEngine.runRewriteAction(prefs.apiKey, fieldText, style)
            aiLoading = false
            res.onSuccess { out ->
                onReplaceCurrentFieldText(out)
                panelMessage = "✓ Reescrito ($style)!"
                panelIsError = false
            }.onFailure { err ->
                panelMessage = err.message ?: "Erro ao reescrever."
                panelIsError = true
            }
        }
    }

    fun executeTranslateOffline(targetCode: String) {
        selectedTargetLang = targetCode
        prefs.targetLangCode = targetCode
        val fieldText = onGetCurrentFieldText()
        if (fieldText.isBlank()) {
            panelMessage = "Idioma definido: ${HybridAiEngine.languageDisplayName(targetCode)}. Digite algo para traduzir."
            panelIsError = false
            return
        }
        aiLoading = true
        panelMessage = "Traduzindo offline para ${HybridAiEngine.languageDisplayName(targetCode)}..."
        panelIsError = false
        scope.launch {
            val res = HybridAiEngine.translateOffline(
                text = fieldText,
                sourceLang = TranslateLanguage.PORTUGUESE,
                targetLang = targetCode
            )
            aiLoading = false
            res.onSuccess { out ->
                onReplaceCurrentFieldText(out)
                panelMessage = "✓ Traduzido para ${HybridAiEngine.languageDisplayName(targetCode)}!"
                panelIsError = false
            }.onFailure { err ->
                panelMessage = err.message ?: "Erro ao traduzir offline."
                panelIsError = true
            }
        }
    }

    fun handleKeyPress(typed: String) {
        feedback.trigger(KeySoundType.CHAR)
        if (typingIntoAiInput && (activeAiPanel == ActiveAiPanel.COMMAND || activeAiPanel == ActiveAiPanel.REPLY)) {
            aiPromptInput += typed
            if (isUpper) isUpper = false
            return
        }
        onCommitText(typed)
        if (isUpper) isUpper = false
        val fromField = onGetCurrentWordBeforeCursor()
        currentTypingWord = if (fromField.isNotEmpty()) {
            fromField
        } else if (typed.length == 1 && typed[0].isLetter()) {
            currentTypingWord + typed
        } else {
            ""
        }
        forceShowTools = false
    }

    fun handleSpacePress() {
        feedback.trigger(KeySoundType.SPACE_ENTER)
        if (typingIntoAiInput && (activeAiPanel == ActiveAiPanel.COMMAND || activeAiPanel == ActiveAiPanel.REPLY)) {
            aiPromptInput += " "
            return
        }
        if (currentTypingWord.length >= 3) {
            WordPredictor.learnWord(currentTypingWord)
        }
        onCommitText(" ")
        currentTypingWord = ""
    }

    fun handleBackspacePress() {
        feedback.trigger(KeySoundType.DELETE)
        if (typingIntoAiInput && (activeAiPanel == ActiveAiPanel.COMMAND || activeAiPanel == ActiveAiPanel.REPLY)) {
            if (aiPromptInput.isNotEmpty()) {
                aiPromptInput = aiPromptInput.dropLast(1)
            }
            return
        }
        onDeleteChar()
        currentTypingWord = onGetCurrentWordBeforeCursor()
        forceShowTools = false
    }

    fun handleEnterPress() {
        feedback.trigger(KeySoundType.SPACE_ENTER)
        if (typingIntoAiInput && activeAiPanel == ActiveAiPanel.COMMAND) {
            executeCommandAi()
            return
        }
        if (typingIntoAiInput && activeAiPanel == ActiveAiPanel.REPLY) {
            executeReplyAi()
            return
        }
        onEnterPressed()
        currentTypingWord = ""
    }

    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(containerBg)
    ) {
        if (customBitmap != null) {
            Image(
                bitmap = customBitmap,
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier.matchParentSize()
            )
            Box(
                modifier = Modifier
                    .matchParentSize()
                    .background(Color.Black.copy(alpha = dimAlpha))
            )
        }

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 4.dp, vertical = 6.dp),
            verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            // Barra Superior (Sugestões Dinâmicas OU Ferramentas estilo Keyvya)
            AnimatedContent(
                targetState = showSuggestionBar,
                transitionSpec = { fadeIn() togetherWith fadeOut() },
                label = "TopBarSwitch"
            ) { isSuggesting ->
                if (isSuggesting) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(44.dp)
                            .clip(RoundedCornerShape(12.dp))
                            .background(keyBg)
                            .border(1.dp, borderBrush, RoundedCornerShape(12.dp))
                            .padding(horizontal = 6.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally,
                            modifier = Modifier
                                .clip(RoundedCornerShape(8.dp))
                                .clickable { forceShowTools = true }
                                .padding(horizontal = 8.dp, vertical = 2.dp)
                        ) {
                            Icon(Icons.Default.AutoAwesome, contentDescription = "IA", tint = accentColor, modifier = Modifier.size(16.dp))
                            Text("IA", color = keyContentColor, fontSize = 9.sp, fontWeight = FontWeight.Bold)
                        }

                        VerticalDivider(modifier = Modifier.height(22.dp).padding(horizontal = 4.dp), color = keyContentColor.copy(alpha = 0.2f))

                        suggestions.forEachIndexed { index, word ->
                            Box(
                                modifier = Modifier
                                    .weight(1f)
                                    .fillMaxHeight()
                                    .clickable {
                                        feedback.trigger(KeySoundType.CHAR)
                                        WordPredictor.learnWord(word)
                                        onReplaceWordBeforeCursor("$word ", currentTypingWord.length)
                                        currentTypingWord = ""
                                    },
                                contentAlignment = Alignment.Center
                            ) {
                                Text(
                                    text = word,
                                    color = keyContentColor,
                                    fontSize = 15.sp,
                                    fontWeight = if (index == 0) FontWeight.Bold else FontWeight.Medium,
                                    maxLines = 1,
                                    overflow = TextOverflow.Ellipsis
                                )
                            }
                            if (index < suggestions.lastIndex) {
                                VerticalDivider(modifier = Modifier.height(18.dp), color = keyContentColor.copy(alpha = 0.15f))
                            }
                        }

                        VerticalDivider(modifier = Modifier.height(22.dp).padding(horizontal = 4.dp), color = keyContentColor.copy(alpha = 0.2f))

                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally,
                            modifier = Modifier
                                .clip(RoundedCornerShape(8.dp))
                                .clickable { showMoreMenu = !showMoreMenu }
                                .padding(horizontal = 8.dp, vertical = 2.dp)
                        ) {
                            Icon(Icons.Default.MoreHoriz, contentDescription = "Mais", tint = keyContentColor, modifier = Modifier.size(16.dp))
                            Text("Mais", color = keyContentColor, fontSize = 9.sp)
                        }
                    }
                } else {
                    LazyRow(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(46.dp),
                        horizontalArrangement = Arrangement.spacedBy(5.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        item {
                            TopToolPill(
                                icon = Icons.Default.AutoAwesome,
                                label = "IA",
                                selected = activeAiPanel == ActiveAiPanel.COMMAND,
                                keyBg = keyBg,
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = { openAiPanel(ActiveAiPanel.COMMAND) }
                            )
                        }
                        item {
                            TopToolPill(
                                icon = Icons.Default.ChatBubbleOutline,
                                label = "Responder",
                                selected = activeAiPanel == ActiveAiPanel.REPLY,
                                keyBg = keyBg,
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = { openAiPanel(ActiveAiPanel.REPLY) }
                            )
                        }
                        item {
                            TopToolPill(
                                icon = Icons.Default.Spellcheck,
                                label = "Corrigir",
                                selected = activeAiPanel == ActiveAiPanel.CORRECT,
                                keyBg = keyBg,
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = { openAiPanel(ActiveAiPanel.CORRECT) }
                            )
                        }
                        item {
                            TopToolPill(
                                icon = Icons.Default.Edit,
                                label = "Reescrever",
                                selected = activeAiPanel == ActiveAiPanel.REWRITE,
                                keyBg = keyBg,
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = { openAiPanel(ActiveAiPanel.REWRITE) }
                            )
                        }
                        item {
                            TopToolPill(
                                icon = Icons.Default.Translate,
                                label = "Traduzir",
                                selected = activeAiPanel == ActiveAiPanel.TRANSLATE,
                                keyBg = keyBg,
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = { openAiPanel(ActiveAiPanel.TRANSLATE) }
                            )
                        }
                        item {
                            TopToolPill(
                                icon = Icons.Default.Search,
                                label = "Lupa",
                                selected = prefs.lensEnabled,
                                keyBg = keyBg,
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = {
                                    val next = !prefs.lensEnabled
                                    prefs.lensEnabled = next
                                    if (next) PrismaLensAccessibilityService.instance?.showFloatingLens()
                                    else PrismaLensAccessibilityService.instance?.hideFloatingLens()
                                    localThemeTick++
                                }
                            )
                        }
                        item {
                            TopToolPill(
                                icon = Icons.Default.ContentPaste,
                                label = "Copiados",
                                selected = showClipboardPanel,
                                keyBg = keyBg,
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = {
                                    showClipboardPanel = !showClipboardPanel
                                    showEmojiPanel = false
                                    showMoreMenu = false
                                    closeAiPanel()
                                }
                            )
                        }
                        item {
                            TopToolPill(
                                icon = Icons.Default.MoreHoriz,
                                label = "Mais",
                                selected = showMoreMenu,
                                keyBg = keyBg,
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = {
                                    showMoreMenu = !showMoreMenu
                                    showClipboardPanel = false
                                    showEmojiPanel = false
                                }
                            )
                        }
                    }
                }
            }

            // Painel Expansível de IA (Acima das teclas)
            if (activeAiPanel != ActiveAiPanel.NONE) {
                Surface(
                    shape = RoundedCornerShape(16.dp),
                    color = panelBg,
                    border = BorderStroke(1.dp, accentColor.copy(alpha = 0.35f)),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Column(
                        modifier = Modifier.padding(10.dp),
                        verticalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        val panelTitle = when (activeAiPanel) {
                            ActiveAiPanel.COMMAND -> "IA • Comando IA"
                            ActiveAiPanel.REPLY -> "IA • Responder"
                            ActiveAiPanel.CORRECT -> "IA • Correção"
                            ActiveAiPanel.REWRITE -> "IA • Reescrever"
                            ActiveAiPanel.TRANSLATE -> "IA • Traduzir"
                            ActiveAiPanel.NONE -> ""
                        }

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                Icon(Icons.Default.AutoAwesome, contentDescription = null, tint = accentColor, modifier = Modifier.size(16.dp))
                                Text(panelTitle, color = panelTextColor, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                            }
                            Surface(
                                shape = RoundedCornerShape(12.dp),
                                color = panelTextColor.copy(alpha = 0.1f),
                                modifier = Modifier.clickable { closeAiPanel() }
                            ) {
                                Text(
                                    text = "Fechar",
                                    color = panelTextColor,
                                    fontSize = 11.sp,
                                    fontWeight = FontWeight.Medium,
                                    modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp)
                                )
                            }
                        }

                        if (aiLoading) {
                            LinearProgressIndicator(modifier = Modifier.fillMaxWidth(), color = accentColor)
                        }

                        if (panelMessage != null) {
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clip(RoundedCornerShape(10.dp))
                                    .background(
                                        if (panelIsError) Color(0xFFEF4444).copy(alpha = 0.18f)
                                        else accentColor.copy(alpha = 0.16f)
                                    )
                                    .padding(horizontal = 10.dp, vertical = 6.dp)
                            ) {
                                Text(
                                    text = panelMessage!!,
                                    color = if (panelIsError) Color(0xFFF87171) else panelTextColor,
                                    fontSize = 12.sp
                                )
                            }
                        }

                        when (activeAiPanel) {
                            ActiveAiPanel.COMMAND -> {
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Text("Comando para a IA:", color = panelTextColor.copy(alpha = 0.8f), fontSize = 12.sp)
                                    Surface(
                                        shape = RoundedCornerShape(10.dp),
                                        color = if (typingIntoAiInput) accentColor.copy(alpha = 0.2f) else panelTextColor.copy(alpha = 0.1f),
                                        border = BorderStroke(1.dp, if (typingIntoAiInput) accentColor else Color.Transparent),
                                        modifier = Modifier.clickable { typingIntoAiInput = !typingIntoAiInput }
                                    ) {
                                        Text(
                                            text = if (typingIntoAiInput) "• Teclado ativo na IA" else "Digitar na IA",
                                            color = if (typingIntoAiInput) accentColor else panelTextColor.copy(alpha = 0.7f),
                                            fontSize = 10.sp,
                                            fontWeight = FontWeight.SemiBold,
                                            modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
                                        )
                                    }
                                }

                                Box(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .clip(RoundedCornerShape(10.dp))
                                        .background(panelTextColor.copy(alpha = 0.06f))
                                        .border(
                                            1.5.dp,
                                            if (typingIntoAiInput) accentColor else panelTextColor.copy(alpha = 0.2f),
                                            RoundedCornerShape(10.dp)
                                        )
                                        .clickable { typingIntoAiInput = true }
                                        .padding(horizontal = 10.dp, vertical = 8.dp)
                                ) {
                                    Text(
                                        text = if (aiPromptInput.isEmpty()) "Digite uma instrução ou escolha um atalho abaixo..." else "$aiPromptInput|",
                                        color = if (aiPromptInput.isEmpty()) panelTextColor.copy(alpha = 0.45f) else panelTextColor,
                                        fontSize = 13.sp,
                                        maxLines = 2,
                                        overflow = TextOverflow.Ellipsis
                                    )
                                }

                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    OutlinedButton(
                                        onClick = {
                                            val clip = readFullClipboardUnlimited()
                                            if (clip.isNotBlank()) aiPromptInput += clip
                                        },
                                        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 4.dp),
                                        modifier = Modifier.height(34.dp)
                                    ) {
                                        Text("Colar", color = panelTextColor, fontSize = 12.sp)
                                    }
                                    Button(
                                        onClick = { if (!aiLoading) executeCommandAi() },
                                        colors = ButtonDefaults.buttonColors(containerColor = accentColor),
                                        contentPadding = PaddingValues(horizontal = 18.dp, vertical = 4.dp),
                                        modifier = Modifier.height(34.dp)
                                    ) {
                                        Text("Enviar", color = Color.White, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                                    }
                                }

                                LazyRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                    items(quickCommandChips) { chip ->
                                        AiChip(
                                            label = chip,
                                            selected = false,
                                            textColor = panelTextColor,
                                            accentColor = accentColor,
                                            onClick = { if (!aiLoading) executeCommandAi(chip) }
                                        )
                                    }
                                }
                            }

                            ActiveAiPanel.REPLY -> {
                                if (lensReplyContext.isNotBlank()) {
                                    Text(
                                        text = "Contexto: \"${lensReplyContext.take(70)}\"",
                                        color = accentColor,
                                        fontSize = 11.sp,
                                        maxLines = 1,
                                        overflow = TextOverflow.Ellipsis
                                    )
                                }

                                Box(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .clip(RoundedCornerShape(10.dp))
                                        .background(panelTextColor.copy(alpha = 0.06f))
                                        .border(
                                            1.5.dp,
                                            if (typingIntoAiInput) accentColor else panelTextColor.copy(alpha = 0.2f),
                                            RoundedCornerShape(10.dp)
                                        )
                                        .clickable { typingIntoAiInput = true }
                                        .padding(horizontal = 10.dp, vertical = 8.dp)
                                ) {
                                    Text(
                                        text = if (aiPromptInput.isEmpty()) "O que você deseja responder?" else "$aiPromptInput|",
                                        color = if (aiPromptInput.isEmpty()) panelTextColor.copy(alpha = 0.45f) else panelTextColor,
                                        fontSize = 13.sp,
                                        maxLines = 2,
                                        overflow = TextOverflow.Ellipsis
                                    )
                                }

                                Text("Toque em um atalho para gerar na hora:", color = panelTextColor.copy(alpha = 0.7f), fontSize = 11.sp)
                                LazyRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                    items(replyShortcutChips) { shortcut ->
                                        AiChip(
                                            label = shortcut,
                                            selected = false,
                                            textColor = panelTextColor,
                                            accentColor = accentColor,
                                            onClick = { if (!aiLoading) executeReplyAi(shortcut) }
                                        )
                                    }
                                }

                                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                    Text("Tom:", color = panelTextColor.copy(alpha = 0.7f), fontSize = 11.sp)
                                    LazyRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                        items(replyToneChips) { tone ->
                                            AiChip(
                                                label = tone,
                                                selected = selectedReplyTone == tone,
                                                textColor = panelTextColor,
                                                accentColor = accentColor,
                                                onClick = { selectedReplyTone = tone }
                                            )
                                        }
                                    }
                                }

                                Button(
                                    onClick = { if (!aiLoading) executeReplyAi() },
                                    colors = ButtonDefaults.buttonColors(containerColor = accentColor),
                                    shape = RoundedCornerShape(12.dp),
                                    modifier = Modifier.fillMaxWidth().height(38.dp)
                                ) {
                                    Icon(Icons.Default.AutoAwesome, contentDescription = null, tint = Color.White, modifier = Modifier.size(16.dp))
                                    Spacer(Modifier.width(6.dp))
                                    Text("Gerar Resposta com IA", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 13.sp)
                                }
                            }

                            ActiveAiPanel.CORRECT -> {
                                val preview = onGetCurrentFieldText()
                                Text(
                                    text = if (preview.isBlank()) "Nenhum texto digitado ainda. Digite algo no campo para corrigir."
                                    else "Texto atual: \"${preview.take(100)}\"",
                                    color = panelTextColor.copy(alpha = 0.75f),
                                    fontSize = 12.sp,
                                    maxLines = 2,
                                    overflow = TextOverflow.Ellipsis
                                )
                                Button(
                                    onClick = { if (!aiLoading) executeCorrectAi() },
                                    colors = ButtonDefaults.buttonColors(containerColor = accentColor),
                                    shape = RoundedCornerShape(12.dp),
                                    modifier = Modifier.fillMaxWidth().height(38.dp)
                                ) {
                                    Text("Corrigir agora", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 13.sp)
                                }
                            }

                            ActiveAiPanel.REWRITE -> {
                                Text("Escolha a variação desejada:", color = panelTextColor.copy(alpha = 0.75f), fontSize = 12.sp)
                                LazyRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                    items(rewriteVariations) { style ->
                                        AiChip(
                                            label = style,
                                            selected = false,
                                            textColor = panelTextColor,
                                            accentColor = accentColor,
                                            onClick = { if (!aiLoading) executeRewriteAi(style) }
                                        )
                                    }
                                }
                            }

                            ActiveAiPanel.TRANSLATE -> {
                                Text("Traduzir para qual idioma?", color = panelTextColor.copy(alpha = 0.75f), fontSize = 12.sp)
                                LazyRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                    items(HybridAiEngine.availableLanguages) { pack ->
                                        AiChip(
                                            label = pack.name,
                                            selected = selectedTargetLang == pack.code,
                                            textColor = panelTextColor,
                                            accentColor = accentColor,
                                            onClick = { if (!aiLoading) executeTranslateOffline(pack.code) }
                                        )
                                    }
                                }
                            }

                            ActiveAiPanel.NONE -> {}
                        }
                    }
                }
            }

            if (showMoreMenu) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .background(panelBg)
                        .padding(6.dp),
                    horizontalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    OutlinedButton(
                        onClick = {
                            prefs.soundEnabled = !prefs.soundEnabled
                            localThemeTick++
                        },
                        modifier = Modifier.weight(1f),
                        contentPadding = PaddingValues(4.dp)
                    ) {
                        Text(if (prefs.soundEnabled) "Som: ON" else "Som: OFF", fontSize = 11.sp, color = panelTextColor)
                    }
                    OutlinedButton(
                        onClick = {
                            prefs.vibrationEnabled = !prefs.vibrationEnabled
                            localThemeTick++
                        },
                        modifier = Modifier.weight(1f),
                        contentPadding = PaddingValues(4.dp)
                    ) {
                        Text(if (prefs.vibrationEnabled) "Vibrar: ON" else "Vibrar: OFF", fontSize = 11.sp, color = panelTextColor)
                    }
                    OutlinedButton(
                        onClick = {
                            showMoreMenu = false
                            onOpenAppSettings()
                        },
                        modifier = Modifier.weight(1f),
                        contentPadding = PaddingValues(4.dp)
                    ) {
                        Text("Temas & App", fontSize = 11.sp, color = panelTextColor)
                    }
                }
            }

            // Painel Área de Transferência Ilimitada OU Emojis Animados OU Teclado QWERTY
            if (showClipboardPanel) {
                val fullClip = remember(showClipboardPanel) { readFullClipboardUnlimited() }
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(195.dp)
                        .clip(RoundedCornerShape(14.dp))
                        .background(panelBg)
                        .border(1.dp, borderBrush, RoundedCornerShape(14.dp))
                        .padding(12.dp),
                    verticalArrangement = Arrangement.SpaceBetween
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "📋 Área de Transferência (${fullClip.length} caracteres)",
                            color = panelTextColor,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp
                        )
                        Text(
                            text = "Voltar ao teclado",
                            color = accentColor,
                            fontSize = 12.sp,
                            fontWeight = FontWeight.SemiBold,
                            modifier = Modifier.clickable { showClipboardPanel = false }
                        )
                    }

                    Text(
                        text = if (fullClip.isBlank()) "Nenhum texto copiado no momento." else fullClip.take(260),
                        color = panelTextColor.copy(alpha = 0.8f),
                        fontSize = 12.sp,
                        maxLines = 5,
                        overflow = TextOverflow.Ellipsis
                    )

                    Button(
                        onClick = {
                            if (fullClip.isNotEmpty()) {
                                feedback.trigger(KeySoundType.SPACE_ENTER)
                                onCommitText(fullClip)
                                showClipboardPanel = false
                                currentTypingWord = ""
                            }
                        },
                        enabled = fullClip.isNotEmpty(),
                        colors = ButtonDefaults.buttonColors(containerColor = accentColor),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Icon(Icons.Default.ContentPasteGo, contentDescription = null, modifier = Modifier.size(18.dp))
                        Spacer(Modifier.width(8.dp))
                        Text("Colar Texto Completo Agora")
                    }
                }
            } else if (showEmojiPanel) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(215.dp)
                        .clip(RoundedCornerShape(14.dp))
                        .background(panelBg)
                        .padding(6.dp)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 6.dp, vertical = 2.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Emojis Animados", color = panelTextColor, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                        Text(
                            "ABC",
                            color = accentColor,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp,
                            modifier = Modifier.clickable { showEmojiPanel = false }
                        )
                    }

                    LazyVerticalGrid(
                        columns = GridCells.Fixed(8),
                        modifier = Modifier.weight(1f),
                        contentPadding = PaddingValues(4.dp)
                    ) {
                        items(animatedEmojiList) { emoji ->
                            AnimatedEmojiCell(emoji = emoji) {
                                feedback.trigger(KeySoundType.CHAR)
                                onCommitText(emoji)
                            }
                        }
                    }
                }
            } else {
                val activeRows = if (isSymbolMode) symbolRows else alphaRows

                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    activeRows[0].forEach { raw ->
                        val label = if (!isSymbolMode && isUpper) raw.uppercase() else raw
                        val variants = if (!isSymbolMode) {
                            (accentVariants[raw] ?: emptyList()).map { if (isUpper) it.uppercase() else it }
                        } else emptyList()
                        PrismKeyCap(
                            label = label,
                            subLabel = variants.firstOrNull(),
                            variants = variants,
                            keyBg = keyBg,
                            contentColor = keyContentColor,
                            borderBrush = borderBrush,
                            modifier = Modifier.weight(1f).height(47.dp),
                            onKeyClick = { handleKeyPress(it) }
                        )
                    }
                }

                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    activeRows[1].forEach { raw ->
                        val label = if (!isSymbolMode && isUpper) raw.uppercase() else raw
                        val variants = if (!isSymbolMode) {
                            (accentVariants[raw] ?: emptyList()).map { if (isUpper) it.uppercase() else it }
                        } else emptyList()
                        PrismKeyCap(
                            label = label,
                            subLabel = variants.firstOrNull(),
                            variants = variants,
                            keyBg = keyBg,
                            contentColor = keyContentColor,
                            borderBrush = borderBrush,
                            modifier = Modifier.weight(1f).height(47.dp),
                            onKeyClick = { handleKeyPress(it) }
                        )
                    }
                }

                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    ActionKeyCap(
                        icon = Icons.Default.KeyboardCapslock,
                        isActive = isUpper && !isSymbolMode,
                        activeColor = accentColor,
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        modifier = Modifier.weight(1.35f).height(47.dp),
                        onClick = {
                            feedback.trigger(KeySoundType.CHAR)
                            if (!isSymbolMode) isUpper = !isUpper
                        }
                    )

                    activeRows[2].forEach { raw ->
                        val label = if (!isSymbolMode && isUpper) raw.uppercase() else raw
                        val variants = if (!isSymbolMode) {
                            (accentVariants[raw] ?: emptyList()).map { if (isUpper) it.uppercase() else it }
                        } else emptyList()
                        PrismKeyCap(
                            label = label,
                            subLabel = variants.firstOrNull(),
                            variants = variants,
                            keyBg = keyBg,
                            contentColor = keyContentColor,
                            borderBrush = borderBrush,
                            modifier = Modifier.weight(1f).height(47.dp),
                            onKeyClick = { handleKeyPress(it) }
                        )
                    }

                    ActionKeyCap(
                        icon = Icons.AutoMirrored.Filled.Backspace,
                        isActive = false,
                        activeColor = accentColor,
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        modifier = Modifier.weight(1.35f).height(47.dp),
                        onClick = { handleBackspacePress() }
                    )
                }

                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    Box(
                        modifier = Modifier
                            .weight(1.25f)
                            .height(47.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(keyBg)
                            .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                            .clickable {
                                feedback.trigger(KeySoundType.CHAR)
                                isSymbolMode = !isSymbolMode
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = if (isSymbolMode) "ABC" else "123",
                            color = keyContentColor,
                            fontWeight = FontWeight.SemiBold,
                            fontSize = 13.sp
                        )
                    }

                    Box(
                        modifier = Modifier
                            .weight(1.05f)
                            .height(47.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(keyBg)
                            .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                            .clickable {
                                feedback.trigger(KeySoundType.CHAR)
                                showEmojiPanel = !showEmojiPanel
                                showClipboardPanel = false
                                closeAiPanel()
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.EmojiEmotions,
                            contentDescription = "Emojis",
                            tint = keyContentColor,
                            modifier = Modifier.size(21.dp)
                        )
                    }

                    PrismKeyCap(
                        label = ",",
                        subLabel = null,
                        variants = listOf(";", "!"),
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        borderBrush = borderBrush,
                        modifier = Modifier.weight(0.95f).height(47.dp),
                        onKeyClick = { handleKeyPress(it) }
                    )

                    Box(
                        modifier = Modifier
                            .weight(3.8f)
                            .height(47.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(keyBg)
                            .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                            .clickable { handleSpacePress() },
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "espaço",
                            color = keyContentColor.copy(alpha = 0.7f),
                            fontSize = 13.sp
                        )
                    }

                    PrismKeyCap(
                        label = ".",
                        subLabel = null,
                        variants = listOf("?", "!", ":", "-"),
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        borderBrush = borderBrush,
                        modifier = Modifier.weight(0.95f).height(47.dp),
                        onKeyClick = { handleKeyPress(it) }
                    )

                    Box(
                        modifier = Modifier
                            .weight(1.3f)
                            .height(47.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(accentColor)
                            .clickable { handleEnterPress() },
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.KeyboardReturn,
                            contentDescription = "Enter",
                            tint = Color.White,
                            modifier = Modifier.size(20.dp)
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun TopToolPill(
    icon: ImageVector,
    label: String,
    selected: Boolean,
    keyBg: Color,
    contentColor: Color,
    accentColor: Color,
    onClick: () -> Unit
) {
    Column(
        modifier = Modifier
            .widthIn(min = 58.dp)
            .fillMaxHeight()
            .clip(RoundedCornerShape(12.dp))
            .background(if (selected) accentColor.copy(alpha = 0.22f) else keyBg)
            .border(1.dp, if (selected) accentColor else Color.Transparent, RoundedCornerShape(12.dp))
            .clickable { onClick() }
            .padding(horizontal = 8.dp, vertical = 3.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(
            imageVector = icon,
            contentDescription = label,
            tint = if (selected) accentColor else contentColor,
            modifier = Modifier.size(16.dp)
        )
        Text(
            text = label,
            color = if (selected) accentColor else contentColor,
            fontSize = 9.5.sp,
            fontWeight = if (selected) FontWeight.Bold else FontWeight.Normal,
            maxLines = 1
        )
    }
}

@Composable
private fun AiChip(
    label: String,
    selected: Boolean,
    textColor: Color,
    accentColor: Color,
    onClick: () -> Unit
) {
    Surface(
        shape = RoundedCornerShape(12.dp),
        color = if (selected) accentColor.copy(alpha = 0.2f) else textColor.copy(alpha = 0.08f),
        border = BorderStroke(1.dp, if (selected) accentColor else textColor.copy(alpha = 0.14f)),
        modifier = Modifier.clickable { onClick() }
    ) {
        Text(
            text = label,
            color = if (selected) accentColor else textColor,
            fontSize = 11.5.sp,
            fontWeight = if (selected) FontWeight.Bold else FontWeight.Medium,
            modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp)
        )
    }
}

@Composable
private fun AnimatedEmojiCell(emoji: String, onClick: () -> Unit) {
    val scope = rememberCoroutineScope()
    var bouncing by remember { mutableStateOf(false) }
    val scale by animateFloatAsState(
        targetValue = if (bouncing) 1.45f else 1f,
        animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessMedium),
        label = "EmojiBounce"
    )

    Box(
        modifier = Modifier
            .aspectRatio(1f)
            .clickable {
                bouncing = true
                onClick()
                scope.launch {
                    delay(180)
                    bouncing = false
                }
            },
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = emoji,
            fontSize = 23.sp,
            modifier = Modifier.graphicsLayer {
                scaleX = scale
                scaleY = scale
            }
        )
    }
}

@Composable
private fun ActionKeyCap(
    icon: ImageVector,
    isActive: Boolean,
    activeColor: Color,
    keyBg: Color,
    contentColor: Color,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Box(
        modifier = modifier
            .clip(RoundedCornerShape(10.dp))
            .background(if (isActive) activeColor else keyBg)
            .clickable { onClick() },
        contentAlignment = Alignment.Center
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = if (isActive) Color.White else contentColor,
            modifier = Modifier.size(20.dp)
        )
    }
}

@Composable
private fun PrismKeyCap(
    label: String,
    subLabel: String?,
    variants: List<String>,
    keyBg: Color,
    contentColor: Color,
    borderBrush: Brush,
    modifier: Modifier = Modifier,
    onKeyClick: (String) -> Unit
) {
    var showPopup by remember { mutableStateOf(false) }

    Box(
        modifier = modifier
            .clip(RoundedCornerShape(10.dp))
            .background(keyBg)
            .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
            .pointerInput(label, variants) {
                detectTapGestures(
                    onTap = { onKeyClick(label) },
                    onLongPress = {
                        if (variants.isNotEmpty()) showPopup = true else onKeyClick(label)
                    }
                )
            },
        contentAlignment = Alignment.Center
    ) {
        if (subLabel != null) {
            Text(
                text = subLabel,
                color = contentColor.copy(alpha = 0.45f),
                fontSize = 9.sp,
                modifier = Modifier
                    .align(Alignment.TopEnd)
                    .padding(top = 2.dp, end = 4.dp)
            )
        }

        Text(
            text = label,
            color = contentColor,
            fontSize = 19.sp,
            fontWeight = FontWeight.Medium,
            textAlign = TextAlign.Center
        )

        if (showPopup && variants.isNotEmpty()) {
            Popup(
                alignment = Alignment.TopCenter,
                offset = IntOffset(0, -135),
                onDismissRequest = { showPopup = false },
                properties = PopupProperties(focusable = true)
            ) {
                Surface(
                    shape = RoundedCornerShape(14.dp),
                    color = Color(0xFF1F273B),
                    border = BorderStroke(1.dp, Color(0xFF8B5CF6)),
                    shadowElevation = 12.dp
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 8.dp, vertical = 6.dp),
                        horizontalArrangement = Arrangement.spacedBy(6.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        variants.forEach { variant ->
                            Box(
                                modifier = Modifier
                                    .size(36.dp)
                                    .clip(RoundedCornerShape(8.dp))
                                    .background(Color(0xFF2D3854))
                                    .clickable {
                                        onKeyClick(variant)
                                        showPopup = false
                                    },
                                contentAlignment = Alignment.Center
                            ) {
                                Text(
                                    text = variant,
                                    color = Color.White,
                                    fontSize = 18.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}
EOF

# 15. PrismKeyboardService.kt (Com Sync Instantâneo + KeyFeedbackEngine + Colagem Ilimitada)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/service/PrismKeyboardService.kt
package com.prismkey.keyboard.service

import android.content.Intent
import android.content.SharedPreferences
import android.inputmethodservice.InputMethodService
import android.view.KeyEvent
import android.view.View
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.ExtractedTextRequest
import androidx.compose.runtime.mutableLongStateOf
import androidx.compose.ui.platform.ComposeView
import androidx.lifecycle.*
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistryController
import androidx.savedstate.SavedStateRegistryOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import com.prismkey.keyboard.MainActivity
import com.prismkey.keyboard.audio.KeyFeedbackEngine
import com.prismkey.keyboard.data.PrefsManager
import com.prismkey.keyboard.ui.keyboard.PrismKeyboardView

class PrismKeyboardService : InputMethodService(), LifecycleOwner, ViewModelStoreOwner, SavedStateRegistryOwner {

    private val lifecycleRegistry = LifecycleRegistry(this)
    private val store = ViewModelStore()
    private val savedStateController = SavedStateRegistryController.create(this)
    private lateinit var prefs: PrefsManager
    private lateinit var feedbackEngine: KeyFeedbackEngine

    private val themeSyncVersion = mutableLongStateOf(1L)

    private val prefListener = SharedPreferences.OnSharedPreferenceChangeListener { _, _ ->
        themeSyncVersion.longValue = prefs.themeVersion + System.nanoTime()
    }

    override val lifecycle: Lifecycle get() = lifecycleRegistry
    override val viewModelStore: ViewModelStore get() = store
    override val savedStateRegistry: SavedStateRegistry get() = savedStateController.savedStateRegistry

    override fun onCreate() {
        super.onCreate()
        savedStateController.performRestore(null)
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_CREATE)
        prefs = PrefsManager(this)
        feedbackEngine = KeyFeedbackEngine(this, prefs)
        themeSyncVersion.longValue = prefs.themeVersion
        prefs.registerListener(prefListener)
    }

    override fun onStartInputView(info: EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        themeSyncVersion.longValue = prefs.themeVersion + System.nanoTime()
    }

    override fun onCreateInputView(): View {
        if (lifecycleRegistry.currentState == Lifecycle.State.CREATED) {
            lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_START)
            lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_RESUME)
        }

        val decorView = window?.window?.decorView
        decorView?.let {
            it.setViewTreeLifecycleOwner(this)
            it.setViewTreeViewModelStoreOwner(this)
            it.setViewTreeSavedStateRegistryOwner(this)
        }

        val composeView = ComposeView(this)
        composeView.setViewTreeLifecycleOwner(this)
        composeView.setViewTreeViewModelStoreOwner(this)
        composeView.setViewTreeSavedStateRegistryOwner(this)
        composeView.setContent {
            PrismKeyboardView(
                prefs = prefs,
                themeSyncVersion = themeSyncVersion.longValue,
                feedback = feedbackEngine,
                onCommitText = { text ->
                    commitTextUnlimited(text)
                },
                onDeleteChar = {
                    val ic = currentInputConnection ?: return@PrismKeyboardView
                    val selected = ic.getSelectedText(0)
                    if (!selected.isNullOrEmpty()) {
                        ic.commitText("", 1)
                    } else {
                        ic.deleteSurroundingText(1, 0)
                    }
                },
                onEnterPressed = {
                    sendDownUpKeyEvents(KeyEvent.KEYCODE_ENTER)
                },
                onGetCurrentFieldText = {
                    readCompleteFieldText()
                },
                onGetCurrentWordBeforeCursor = {
                    readWordBeforeCursor()
                },
                onReplaceWordBeforeCursor = { replacement, fallbackLen ->
                    val ic = currentInputConnection ?: return@PrismKeyboardView
                    val word = readWordBeforeCursor()
                    val deleteCount = if (word.isNotEmpty()) word.length else fallbackLen
                    if (deleteCount > 0) {
                        ic.deleteSurroundingText(deleteCount, 0)
                    }
                    ic.commitText(replacement, 1)
                },
                onReplaceCurrentFieldText = { newText ->
                    replaceCompleteFieldText(newText)
                },
                onOpenAppSettings = {
                    val intent = Intent(this, MainActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
                    startActivity(intent)
                }
            )
        }
        return composeView
    }

    private fun commitTextUnlimited(text: String) {
        val ic = currentInputConnection ?: return
        if (text.length <= 4000) {
            ic.commitText(text, 1)
            return
        }
        ic.beginBatchEdit()
        var index = 0
        while (index < text.length) {
            val end = minOf(index + 4000, text.length)
            ic.commitText(text.substring(index, end), 1)
            index = end
        }
        ic.endBatchEdit()
    }

    private fun readWordBeforeCursor(): String {
        val ic = currentInputConnection ?: return ""
        val before = ic.getTextBeforeCursor(40, 0)?.toString() ?: return ""
        return before.takeLastWhile { it.isLetter() }
    }

    private fun readCompleteFieldText(): String {
        val ic = currentInputConnection ?: return ""
        val selected = ic.getSelectedText(0)
        if (!selected.isNullOrBlank()) return selected.toString()

        val extracted = ic.getExtractedText(ExtractedTextRequest(), 0)?.text
        if (!extracted.isNullOrBlank()) return extracted.toString()

        val before = ic.getTextBeforeCursor(10000, 0) ?: ""
        val after = ic.getTextAfterCursor(10000, 0) ?: ""
        return "$before$after".trim()
    }

    private fun replaceCompleteFieldText(newText: String) {
        val ic = currentInputConnection ?: return
        val selected = ic.getSelectedText(0)
        if (!selected.isNullOrBlank()) {
            commitTextUnlimited(newText)
            return
        }
        val beforeLen = ic.getTextBeforeCursor(10000, 0)?.length ?: 0
        val afterLen = ic.getTextAfterCursor(10000, 0)?.length ?: 0
        ic.deleteSurroundingText(beforeLen, afterLen)
        commitTextUnlimited(newText)
    }

    override fun onDestroy() {
        prefs.unregisterListener(prefListener)
        feedbackEngine.release()
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        store.clear()
        super.onDestroy()
    }
}
EOF

# 16. PrismaLensAccessibilityService.kt (Lupa Redesenhada: Idioma Auto + Tradução Imediata + Copiar / Ouvir / Responder)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/service/PrismaLensAccessibilityService.kt
package com.prismkey.keyboard.service

import android.accessibilityservice.AccessibilityService
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.graphics.PixelFormat
import android.provider.Settings
import android.speech.tts.TextToSpeech
import android.view.Gravity
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import android.widget.Toast
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Reply
import androidx.compose.material.icons.automirrored.filled.VolumeUp
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.*
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistryController
import androidx.savedstate.SavedStateRegistryOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import com.prismkey.keyboard.ai.HybridAiEngine
import com.prismkey.keyboard.data.PrefsManager
import kotlinx.coroutines.launch
import java.util.Locale
import kotlin.math.roundToInt

class PrismaLensAccessibilityService : AccessibilityService(), LifecycleOwner, ViewModelStoreOwner, SavedStateRegistryOwner {

    companion object {
        var instance: PrismaLensAccessibilityService? = null
    }

    private val lifecycleRegistry = LifecycleRegistry(this)
    private val store = ViewModelStore()
    private val savedStateController = SavedStateRegistryController.create(this)
    private var windowManager: WindowManager? = null
    private var floatingView: ComposeView? = null
    private var overlayParams: WindowManager.LayoutParams? = null
    private lateinit var prefs: PrefsManager

    private var textToSpeech: TextToSpeech? = null
    private var ttsReady = false

    override val lifecycle: Lifecycle get() = lifecycleRegistry
    override val viewModelStore: ViewModelStore get() = store
    override val savedStateRegistry: SavedStateRegistry get() = savedStateController.savedStateRegistry

    override fun onCreate() {
        super.onCreate()
        instance = this
        savedStateController.performRestore(null)
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_CREATE)
        prefs = PrefsManager(this)
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        textToSpeech = TextToSpeech(this) { status ->
            if (status == TextToSpeech.SUCCESS) {
                val res = textToSpeech?.setLanguage(Locale("pt", "BR"))
                ttsReady = res != TextToSpeech.LANG_MISSING_DATA && res != TextToSpeech.LANG_NOT_SUPPORTED
            }
        }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        if (lifecycleRegistry.currentState == Lifecycle.State.CREATED) {
            lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_START)
            lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_RESUME)
        }
        if (prefs.lensEnabled) {
            showFloatingLens()
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}

    fun showFloatingLens() {
        if (!Settings.canDrawOverlays(this) || floatingView != null) return

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.TOP or Gravity.START
        params.x = 70
        params.y = 380
        overlayParams = params

        val composeView = ComposeView(this)
        composeView.setViewTreeLifecycleOwner(this)
        composeView.setViewTreeViewModelStoreOwner(this)
        composeView.setViewTreeSavedStateRegistryOwner(this)
        composeView.setContent {
            PrismaLensBubbleUI(
                onDrag = { dx: Float, dy: Float ->
                    val lp = overlayParams
                    val view = floatingView
                    if (lp != null && view != null) {
                        lp.x = lp.x + dx.roundToInt()
                        lp.y = lp.y + dy.roundToInt()
                        runCatching { windowManager?.updateViewLayout(view, lp) }
                    }
                },
                onCaptureScreenText = { captureCleanMessageText() },
                onSpeakText = { speakAloud(it) },
                onSendToReply = { originalText ->
                    prefs.pendingReplyContext = originalText
                    Toast.makeText(this, "Enviado para o painel Responder do PrismKey!", Toast.LENGTH_SHORT).show()
                },
                onCloseBubble = {
                    prefs.lensEnabled = false
                    hideFloatingLens()
                }
            )
        }

        floatingView = composeView
        runCatching { windowManager?.addView(composeView, params) }
    }

    fun hideFloatingLens() {
        floatingView?.let {
            runCatching { windowManager?.removeView(it) }
            floatingView = null
        }
    }

    private fun speakAloud(text: String) {
        if (text.isBlank()) return
        if (ttsReady) {
            textToSpeech?.speak(text, TextToSpeech.QUEUE_FLUSH, null, "prism_lens_tts")
        } else {
            Toast.makeText(this, "Motor de voz em Português indisponível.", Toast.LENGTH_SHORT).show()
        }
    }

    private fun captureCleanMessageText(): String {
        val root = rootInActiveWindow ?: return ""
        val collected = mutableListOf<String>()
        val timeRegex = Regex("^\\d{1,2}:\\d{2}$")
        val ignoreSet = setOf("hoje", "ontem", "mensagem", "digite uma mensagem", "online", "lupa ativada", "mais")

        fun traverse(node: AccessibilityNodeInfo?) {
            if (node == null) return
            val txt = node.text?.toString()?.trim()
            if (!txt.isNullOrBlank() &&
                txt.length > 2 &&
                !timeRegex.matches(txt) &&
                !ignoreSet.contains(txt.lowercase())
            ) {
                collected.add(txt)
            }
            for (i in 0 until node.childCount) {
                traverse(node.getChild(i))
            }
        }
        traverse(root)
        return collected.lastOrNull() ?: ""
    }

    override fun onDestroy() {
        instance = null
        hideFloatingLens()
        runCatching {
            textToSpeech?.stop()
            textToSpeech?.shutdown()
        }
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        store.clear()
        super.onDestroy()
    }
}

@Composable
private fun PrismaLensBubbleUI(
    onDrag: (Float, Float) -> Unit,
    onCaptureScreenText: () -> String,
    onSpeakText: (String) -> Unit,
    onSendToReply: (String) -> Unit,
    onCloseBubble: () -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    var expanded by remember { mutableStateOf(false) }
    var capturedText by remember { mutableStateOf("") }
    var detectedLangName by remember { mutableStateOf("Detectando...") }
    var translatedText by remember { mutableStateOf("") }
    var isProcessing by remember { mutableStateOf(false) }

    fun scanAndTranslateNow() {
        val raw = onCaptureScreenText()
        capturedText = raw
        translatedText = ""
        if (raw.isBlank()) {
            detectedLangName = "Indefinido"
            translatedText = "Nenhum texto encontrado na tela atual."
            return
        }
        isProcessing = true
        detectedLangName = "Detectando..."
        scope.launch {
            val res = HybridAiEngine.detectAndTranslateToPortuguese(raw)
            isProcessing = false
            res.onSuccess { data ->
                detectedLangName = data.detectedLanguageName
                translatedText = data.translatedText
            }.onFailure { err ->
                detectedLangName = "Offline"
                translatedText = err.message ?: "Erro ao traduzir."
            }
        }
    }

    Column(
        horizontalAlignment = Alignment.Start,
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Surface(
            shape = CircleShape,
            color = Color(0xFF151C2E).copy(alpha = 0.92f),
            border = BorderStroke(
                1.5.dp,
                Brush.linearGradient(listOf(Color(0xFF7CA4FF), Color(0xFFC084FC)))
            ),
            shadowElevation = 10.dp,
            modifier = Modifier
                .size(54.dp)
                .pointerInput(Unit) {
                    detectDragGestures { change, dragAmount ->
                        change.consume()
                        onDrag(dragAmount.x, dragAmount.y)
                    }
                }
                .clickable {
                    expanded = !expanded
                    if (expanded) scanAndTranslateNow()
                }
        ) {
            Box(contentAlignment = Alignment.Center) {
                Icon(
                    imageVector = Icons.Default.AutoAwesome,
                    contentDescription = "Prisma Lens",
                    tint = Color(0xFFA5C4FF),
                    modifier = Modifier.size(26.dp)
                )
            }
        }

        if (expanded) {
            Surface(
                shape = RoundedCornerShape(22.dp),
                color = Color(0xFFFAF9FE),
                border = BorderStroke(1.dp, Color(0xFFD8C4FA)),
                shadowElevation = 16.dp,
                modifier = Modifier.width(310.dp)
            ) {
                Column(
                    modifier = Modifier.padding(14.dp),
                    verticalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(6.dp),
                            modifier = Modifier.weight(1f)
                        ) {
                            Icon(
                                imageVector = Icons.Default.Language,
                                contentDescription = null,
                                tint = Color(0xFF8B5CF6),
                                modifier = Modifier.size(18.dp)
                            )
                            Text(
                                text = "Idioma detectado: $detectedLangName",
                                color = Color(0xFF1F2430),
                                fontWeight = FontWeight.SemiBold,
                                fontSize = 13.sp,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                        }
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp), verticalAlignment = Alignment.CenterVertically) {
                            Text(
                                text = "Ocultar",
                                color = Color(0xFFDC2626),
                                fontSize = 11.sp,
                                fontWeight = FontWeight.SemiBold,
                                modifier = Modifier.clickable { onCloseBubble() }
                            )
                            Icon(
                                imageVector = Icons.Default.Close,
                                contentDescription = "Fechar",
                                tint = Color(0xFF4B5563),
                                modifier = Modifier
                                    .size(18.dp)
                                    .clickable { expanded = false }
                            )
                        }
                    }

                    // Cartão Original
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            .background(Color.White)
                            .border(1.dp, Color(0xFFE5E7EB), RoundedCornerShape(12.dp))
                            .padding(10.dp),
                        verticalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        Text(
                            text = "Original ($detectedLangName):",
                            color = Color(0xFF6B7280),
                            fontSize = 11.sp
                        )
                        Text(
                            text = if (capturedText.isBlank()) "Toque na bolha em cima de uma conversa." else capturedText,
                            color = Color(0xFF1F2937),
                            fontSize = 14.sp,
                            fontStyle = FontStyle.Italic,
                            maxLines = 4,
                            overflow = TextOverflow.Ellipsis
                        )
                    }

                    // Cartão Tradução em Português
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            .background(Color(0xFFF3E8FF))
                            .border(1.dp, Color(0xFFD8B4FE), RoundedCornerShape(12.dp))
                            .padding(10.dp),
                        verticalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        Text(
                            text = "Tradução em Português:",
                            color = Color(0xFF7C3AED),
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Medium
                        )
                        if (isProcessing) {
                            LinearProgressIndicator(
                                modifier = Modifier.fillMaxWidth(),
                                color = Color(0xFF8B5CF6)
                            )
                        } else {
                            Text(
                                text = if (translatedText.isBlank()) "..." else translatedText,
                                color = Color(0xFF111827),
                                fontSize = 15.sp,
                                fontWeight = FontWeight.Bold,
                                maxLines = 5,
                                overflow = TextOverflow.Ellipsis
                            )
                        }
                    }

                    // 3 Botões Inferiores (Copiar / Ouvir / Responder)
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        Button(
                            onClick = {
                                val toCopy = if (translatedText.isNotBlank()) translatedText else capturedText
                                if (toCopy.isNotBlank()) {
                                    val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                                    cm.setPrimaryClip(ClipData.newPlainText("PrismKey", toCopy))
                                    Toast.makeText(context, "Tradução copiada!", Toast.LENGTH_SHORT).show()
                                }
                            },
                            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF9333EA)),
                            shape = RoundedCornerShape(10.dp),
                            contentPadding = PaddingValues(horizontal = 6.dp, vertical = 6.dp),
                            modifier = Modifier.weight(1f).height(38.dp)
                        ) {
                            Icon(Icons.Default.ContentCopy, contentDescription = null, tint = Color.White, modifier = Modifier.size(14.dp))
                            Spacer(Modifier.width(4.dp))
                            Text("Copiar", color = Color.White, fontSize = 11.sp, maxLines = 1)
                        }

                        OutlinedButton(
                            onClick = {
                                val toRead = if (translatedText.isNotBlank()) translatedText else capturedText
                                onSpeakText(toRead)
                            },
                            border = BorderStroke(1.dp, Color(0xFF9333EA)),
                            shape = RoundedCornerShape(10.dp),
                            contentPadding = PaddingValues(horizontal = 6.dp, vertical = 6.dp),
                            modifier = Modifier.weight(1f).height(38.dp)
                        ) {
                            Icon(Icons.AutoMirrored.Filled.VolumeUp, contentDescription = null, tint = Color(0xFF9333EA), modifier = Modifier.size(15.dp))
                            Spacer(Modifier.width(4.dp))
                            Text("Ouvir", color = Color(0xFF9333EA), fontSize = 11.sp, maxLines = 1)
                        }

                        Button(
                            onClick = {
                                if (capturedText.isNotBlank()) {
                                    onSendToReply(capturedText)
                                    expanded = false
                                }
                            },
                            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF9333EA)),
                            shape = RoundedCornerShape(10.dp),
                            contentPadding = PaddingValues(horizontal = 6.dp, vertical = 6.dp),
                            modifier = Modifier.weight(1f).height(38.dp)
                        ) {
                            Icon(Icons.AutoMirrored.Filled.Reply, contentDescription = null, tint = Color.White, modifier = Modifier.size(15.dp))
                            Spacer(Modifier.width(4.dp))
                            Text("Responder", color = Color.White, fontSize = 11.sp, maxLines = 1)
                        }
                    }
                }
            }
        }
    }
}
EOF

# 17. MainActivity.kt (Galeria de Temas estilo Gboard + Editor Tela Cheia com Grade & Botão Concluído + Som/Vibração)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/MainActivity.kt
package com.prismkey.keyboard

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTransformGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.withTransform
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import com.prismkey.keyboard.ai.HybridAiEngine
import com.prismkey.keyboard.audio.KeyFeedbackEngine
import com.prismkey.keyboard.data.PrefsManager
import com.prismkey.keyboard.data.PrismSystemStatus
import com.prismkey.keyboard.data.PrismThemeMode
import com.prismkey.keyboard.data.SolidThemePreset
import com.prismkey.keyboard.data.SystemStatusHelper
import com.prismkey.keyboard.data.solidThemePresets
import com.prismkey.keyboard.service.PrismaLensAccessibilityService
import com.prismkey.keyboard.ui.theme.ImageCropper
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val prefs = PrefsManager(this)
        setContent {
            MaterialTheme(colorScheme = darkColorScheme(background = Color(0xFF0B0E14))) {
                PrismKeyAppScreen(prefs)
            }
        }
    }
}

@Composable
fun PrismKeyAppScreen(prefs: PrefsManager) {
    val context = LocalContext.current
    val lifecycleOwner = LocalLifecycleOwner.current
    var selectedTab by remember { mutableIntStateOf(0) }
    var status by remember { mutableStateOf(SystemStatusHelper.checkStatus(context)) }
    var pendingCropUri by remember { mutableStateOf<Uri?>(null) }
    var themesRefreshTick by remember { mutableIntStateOf(0) }

    val feedbackPreview = remember { KeyFeedbackEngine(context, prefs) }
    DisposableEffect(Unit) {
        onDispose { feedbackPreview.release() }
    }

    DisposableEffect(lifecycleOwner) {
        val observer = LifecycleEventObserver { _, event ->
            if (event == Lifecycle.Event.ON_RESUME) {
                status = SystemStatusHelper.checkStatus(context)
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose { lifecycleOwner.lifecycle.removeObserver(observer) }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Scaffold(
            containerColor = Color(0xFF0B0E14),
            bottomBar = {
                NavigationBar(containerColor = Color(0xFF141923)) {
                    NavigationBarItem(
                        selected = selectedTab == 0,
                        onClick = { selectedTab = 0 },
                        icon = { Icon(Icons.Default.Home, contentDescription = null) },
                        label = { Text("Início") }
                    )
                    NavigationBarItem(
                        selected = selectedTab == 1,
                        onClick = { selectedTab = 1 },
                        icon = { Icon(Icons.Default.Palette, contentDescription = null) },
                        label = { Text("Temas") }
                    )
                    NavigationBarItem(
                        selected = selectedTab == 2,
                        onClick = { selectedTab = 2 },
                        icon = { Icon(Icons.Default.AutoAwesome, contentDescription = null) },
                        label = { Text("IA & Lupa") }
                    )
                    NavigationBarItem(
                        selected = selectedTab == 3,
                        onClick = { selectedTab = 3 },
                        icon = { Icon(Icons.Default.Shield, contentDescription = null) },
                        label = { Text("Sobre") }
                    )
                }
            }
        ) { innerPadding ->
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(innerPadding)
                    .padding(horizontal = 16.dp)
            ) {
                when (selectedTab) {
                    0 -> HomeTab(status = status, onRefreshStatus = { status = SystemStatusHelper.checkStatus(context) })
                    1 -> AppearanceTab(
                        prefs = prefs,
                        refreshTick = themesRefreshTick,
                        feedbackPreview = feedbackPreview,
                        onPickImageForCrop = { uri -> pendingCropUri = uri },
                        onThemesMutated = { themesRefreshTick++ }
                    )
                    2 -> AiAndLensTab(prefs = prefs, status = status)
                    3 -> AboutAndPrivacyTab(prefs = prefs)
                }
            }
        }

        // Editor de Enquadramento Tela Cheia estilo Gboard
        val cropUri = pendingCropUri
        if (cropUri != null) {
            GboardStyleCropOverlay(
                imageUri = cropUri,
                prefs = prefs,
                onCancel = { pendingCropUri = null },
                onDone = { savedPath ->
                    prefs.addCustomThemePath(savedPath)
                    themesRefreshTick++
                    pendingCropUri = null
                    Toast.makeText(context, "Tema aplicado ao PrismKey!", Toast.LENGTH_SHORT).show()
                }
            )
        }
    }
}

@Composable
private fun GboardStyleCropOverlay(
    imageUri: Uri,
    prefs: PrefsManager,
    onCancel: () -> Unit,
    onDone: (String) -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    var loadedBitmap by remember(imageUri) { mutableStateOf<Bitmap?>(null) }
    var isLoading by remember(imageUri) { mutableStateOf(true) }
    var isSaving by remember { mutableStateOf(false) }

    var containerSize by remember { mutableStateOf(IntSize.Zero) }
    var userScale by remember { mutableFloatStateOf(1f) }
    var offsetX by remember { mutableFloatStateOf(0f) }
    var offsetY by remember { mutableFloatStateOf(0f) }
    var dimAlpha by remember { mutableFloatStateOf(prefs.overlayDimAlpha) }

    LaunchedEffect(imageUri) {
        isLoading = true
        loadedBitmap = withContext(Dispatchers.IO) {
            ImageCropper.loadSafeBitmap(context, imageUri)
        }
        isLoading = false
        if (loadedBitmap == null) {
            Toast.makeText(context, "Não foi possível abrir a imagem selecionada.", Toast.LENGTH_SHORT).show()
            onCancel()
        }
    }

    val imageBitmap = remember(loadedBitmap) { loadedBitmap?.asImageBitmap() }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF0A0C10))
    ) {
        if (isLoading || imageBitmap == null || loadedBitmap == null) {
            CircularProgressIndicator(modifier = Modifier.align(Alignment.Center), color = Color(0xFF8B5CF6))
        } else {
            val bmp = loadedBitmap!!
            val cropW = (containerSize.width * 0.92f).coerceAtLeast(1f)
            val cropH = (cropW / 1.62f).coerceAtMost(containerSize.height * 0.45f).coerceAtLeast(1f)
            val baseScale = maxOf(cropW / bmp.width.toFloat(), cropH / bmp.height.toFloat())
            val totalScale = baseScale * userScale

            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .onSizeChanged { containerSize = it }
                    .pointerInput(Unit) {
                        detectTransformGestures { _, pan, zoom, _ ->
                            userScale = (userScale * zoom).coerceIn(0.6f, 5f)
                            offsetX += pan.x
                            offsetY += pan.y
                        }
                    }
            ) {
                Canvas(modifier = Modifier.fillMaxSize()) {
                    val w = size.width
                    val h = size.height
                    val left = (w - cropW) / 2f
                    val top = (h - cropH) / 2f

                    // Desenha a imagem com zoom e arraste exatos
                    withTransform({
                        translate(left = w / 2f + offsetX, top = h / 2f + offsetY)
                        scale(scaleX = totalScale, scaleY = totalScale, pivot = Offset.Zero)
                        translate(left = -bmp.width / 2f, top = -bmp.height / 2f)
                    }) {
                        drawImage(imageBitmap)
                    }

                    // Escurecimento dentro da grade do teclado (prévia de leitura das teclas)
                    drawRect(
                        color = Color.Black.copy(alpha = dimAlpha),
                        topLeft = Offset(left, top),
                        size = Size(cropW, cropH)
                    )

                    // Máscara escura ao redor da moldura (estilo Gboard)
                    val scrim = Color.Black.copy(alpha = 0.68f)
                    drawRect(color = scrim, topLeft = Offset.Zero, size = Size(w, top))
                    drawRect(color = scrim, topLeft = Offset(0f, top + cropH), size = Size(w, h - (top + cropH)))
                    drawRect(color = scrim, topLeft = Offset(0f, top), size = Size(left, cropH))
                    drawRect(color = scrim, topLeft = Offset(left + cropW, top), size = Size(w - (left + cropW), cropH))

                    // Moldura branca exata do tamanho do teclado
                    drawRect(
                        color = Color.White,
                        topLeft = Offset(left, top),
                        size = Size(cropW, cropH),
                        style = Stroke(width = 4f)
                    )
                }

                // Topo: Botão voltar + instrução estilo Gboard
                Column(
                    modifier = Modifier
                        .align(Alignment.TopCenter)
                        .fillMaxWidth()
                        .padding(top = 42.dp, start = 16.dp, end = 16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        TextButton(onClick = onCancel) {
                            Text("Cancelar", color = Color.White, fontWeight = FontWeight.Medium)
                        }
                        TextButton(onClick = {
                            userScale = 1f
                            offsetX = 0f
                            offsetY = 0f
                        }) {
                            Text("Centralizar", color = Color(0xFFA5C4FF), fontWeight = FontWeight.Medium)
                        }
                    }
                    Text(
                        text = "Faça um gesto de pinça para dimensionar,\narraste para mover",
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Medium,
                        textAlign = TextAlign.Center
                    )
                }

                // Rodapé abaixo da grade: Escurecimento + Botão Concluído
                Column(
                    modifier = Modifier
                        .align(Alignment.BottomCenter)
                        .fillMaxWidth()
                        .padding(horizontal = 24.dp, vertical = 28.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Text(
                        text = "Contraste das teclas (escurecer fundo): ${(dimAlpha * 100).toInt()}%",
                        color = Color.White.copy(alpha = 0.85f),
                        fontSize = 12.sp
                    )
                    Slider(
                        value = dimAlpha,
                        onValueChange = { dimAlpha = it },
                        valueRange = 0.05f..0.75f,
                        colors = SliderDefaults.colors(
                            thumbColor = Color(0xFF93C5FD),
                            activeTrackColor = Color(0xFF60A5FA)
                        )
                    )

                    Button(
                        onClick = {
                            if (isSaving) return@Button
                            isSaving = true
                            prefs.overlayDimAlpha = dimAlpha
                            scope.launch {
                                val savedPath = withContext(Dispatchers.IO) {
                                    ImageCropper.cropAndSaveForKeyboard(
                                        context = context,
                                        sourceBitmap = bmp,
                                        cropWidthPx = cropW,
                                        cropHeightPx = cropH,
                                        totalScale = totalScale,
                                        offsetX = offsetX,
                                        offsetY = offsetY
                                    )
                                }
                                isSaving = false
                                if (savedPath != null) {
                                    onDone(savedPath)
                                } else {
                                    Toast.makeText(context, "Erro ao salvar recorte.", Toast.LENGTH_SHORT).show()
                                }
                            }
                        },
                        shape = RoundedCornerShape(28.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF4F7DF3)),
                        modifier = Modifier
                            .width(190.dp)
                            .height(48.dp)
                    ) {
                        if (isSaving) {
                            CircularProgressIndicator(color = Color.White, modifier = Modifier.size(20.dp), strokeWidth = 2.dp)
                        } else {
                            Icon(Icons.Default.Check, contentDescription = null, tint = Color.White)
                            Spacer(Modifier.width(8.dp))
                            Text("Concluído", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 15.sp)
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun RealisticPrismHeroCard() {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(145.dp)
            .clip(RoundedCornerShape(22.dp))
            .background(
                Brush.linearGradient(
                    colors = listOf(Color(0xFF121B33), Color(0xFF1E2D56), Color(0xFF0E1424))
                )
            )
            .border(
                1.dp,
                Brush.linearGradient(listOf(Color.White.copy(alpha = 0.35f), Color(0xFF5D87F6).copy(alpha = 0.2f))),
                RoundedCornerShape(22.dp)
            )
    ) {
        Canvas(modifier = Modifier.fillMaxSize()) {
            val w = size.width
            val h = size.height

            drawCircle(
                brush = Brush.radialGradient(
                    colors = listOf(Color(0xFF60A5FA).copy(alpha = 0.45f), Color.Transparent),
                    center = Offset(w * 0.80f, h * 0.50f),
                    radius = h * 0.85f
                ),
                center = Offset(w * 0.80f, h * 0.50f),
                radius = h * 0.85f
            )

            val topFacet = Path().apply {
                moveTo(w * 0.80f, h * 0.14f)
                lineTo(w * 0.94f, h * 0.50f)
                lineTo(w * 0.80f, h * 0.50f)
                close()
            }
            drawPath(path = topFacet, brush = Brush.linearGradient(listOf(Color(0xFFE0F2FE), Color(0xFF60A5FA))))

            val leftFacet = Path().apply {
                moveTo(w * 0.80f, h * 0.14f)
                lineTo(w * 0.66f, h * 0.50f)
                lineTo(w * 0.80f, h * 0.50f)
                close()
            }
            drawPath(path = leftFacet, brush = Brush.linearGradient(listOf(Color(0xFF93C5FD), Color(0xFF3B82F6))))

            val bottomLeftFacet = Path().apply {
                moveTo(w * 0.66f, h * 0.50f)
                lineTo(w * 0.80f, h * 0.86f)
                lineTo(w * 0.80f, h * 0.50f)
                close()
            }
            drawPath(path = bottomLeftFacet, brush = Brush.linearGradient(listOf(Color(0xFF2563EB), Color(0xFF1D4ED8))))

            val bottomRightFacet = Path().apply {
                moveTo(w * 0.94f, h * 0.50f)
                lineTo(w * 0.80f, h * 0.86f)
                lineTo(w * 0.80f, h * 0.50f)
                close()
            }
            drawPath(path = bottomRightFacet, brush = Brush.linearGradient(listOf(Color(0xFF818CF8), Color(0xFF4338CA))))
        }

        Column(
            modifier = Modifier
                .align(Alignment.CenterStart)
                .padding(start = 20.dp, end = 120.dp),
            verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            Surface(
                shape = RoundedCornerShape(8.dp),
                color = Color(0xFF3B82F6).copy(alpha = 0.25f),
                border = BorderStroke(1.dp, Color(0xFF60A5FA).copy(alpha = 0.5f))
            ) {
                Text(
                    text = "VERSÃO 1.2.0",
                    color = Color(0xFF93C5FD),
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                )
            }
            Text(text = "PrismKey", color = Color.White, fontSize = 28.sp, fontWeight = FontWeight.ExtraBold)
            Text(
                text = "Teclado inteligente híbrido, rápido e 100% privado.",
                color = Color.White.copy(alpha = 0.78f),
                fontSize = 12.sp
            )
        }
    }
}

@Composable
private fun HomeTab(status: PrismSystemStatus, onRefreshStatus: () -> Unit) {
    val context = LocalContext.current
    var testText by remember { mutableStateOf("") }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(vertical = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        RealisticPrismHeroCard()

        Surface(
            shape = RoundedCornerShape(18.dp),
            color = Color(0xFF161B26),
            border = BorderStroke(
                1.dp,
                if (status.isKeyboardEnabled && status.isKeyboardDefault) Color(0xFF34D399) else Color(0xFFFBBF24)
            )
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                if (status.isKeyboardEnabled && status.isKeyboardDefault) {
                    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        Icon(Icons.Default.CheckCircle, contentDescription = null, tint = Color(0xFF34D399))
                        Column {
                            Text("PrismKey Ativo e Padrão", color = Color.White, fontWeight = FontWeight.Bold)
                            Text("Tudo pronto! Toque abaixo para testar o teclado.", color = Color.White.copy(alpha = 0.7f), fontSize = 12.sp)
                        }
                    }
                } else {
                    Text("Configuração Necessária do PrismKey", color = Color(0xFFFBBF24), fontWeight = FontWeight.Bold)
                    Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        if (!status.isKeyboardEnabled) {
                            Button(
                                onClick = { context.startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS)) },
                                modifier = Modifier.weight(1f)
                            ) {
                                Text("1. Ativar")
                            }
                        }
                        if (!status.isKeyboardDefault) {
                            OutlinedButton(
                                onClick = {
                                    val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                                    imm.showInputMethodPicker()
                                    onRefreshStatus()
                                },
                                modifier = Modifier.weight(1f)
                            ) {
                                Text("2. Definir Padrão", color = Color.White)
                            }
                        }
                    }
                }
            }
        }

        OutlinedTextField(
            value = testText,
            onValueChange = { testText = it },
            placeholder = { Text("Toque aqui para testar o PrismKey...") },
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(14.dp)
        )
    }
}

@Composable
private fun AppearanceTab(
    prefs: PrefsManager,
    refreshTick: Int,
    feedbackPreview: KeyFeedbackEngine,
    onPickImageForCrop: (Uri) -> Unit,
    onThemesMutated: () -> Unit
) {
    var selectedMode by remember(refreshTick) { mutableStateOf(prefs.themeMode) }
    var activeImagePath by remember(refreshTick) { mutableStateOf(prefs.customImagePath) }
    var activeSolidBg by remember(refreshTick) { mutableLongStateOf(prefs.solidColorBgHex) }
    val customThemes = remember(refreshTick) { prefs.savedCustomThemes }

    var dimAlpha by remember(refreshTick) { mutableFloatStateOf(prefs.overlayDimAlpha) }
    var soundEnabled by remember { mutableStateOf(prefs.soundEnabled) }
    var soundVolume by remember { mutableFloatStateOf(prefs.soundVolume) }
    var vibrationEnabled by remember { mutableStateOf(prefs.vibrationEnabled) }
    var vibrationMs by remember { mutableIntStateOf(prefs.vibrationDurationMs) }

    val imagePicker = rememberLauncherForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
        if (uri != null) onPickImageForCrop(uri)
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(vertical = 16.dp),
        verticalArrangement = Arrangement.spacedBy(18.dp)
    ) {
        Text("Tema", color = Color.White, fontSize = 26.sp, fontWeight = FontWeight.Bold)

        // 1. Seção "Meus temas" estilo Gboard
        Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text("Meus temas", color = Color(0xFFB6C4D8), fontSize = 14.sp, fontWeight = FontWeight.SemiBold)

            LazyRow(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                item {
                    Box(
                        modifier = Modifier
                            .size(width = 112.dp, height = 78.dp)
                            .clip(RoundedCornerShape(16.dp))
                            .background(Color(0xFF161D2B))
                            .border(2.dp, Color(0xFF86EFAC), RoundedCornerShape(16.dp))
                            .clickable { imagePicker.launch("image/*") },
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Add,
                            contentDescription = "Adicionar tema",
                            tint = Color(0xFF86EFAC),
                            modifier = Modifier.size(34.dp)
                        )
                    }
                }

                items(customThemes) { path ->
                    val isSelected = selectedMode == PrismThemeMode.CUSTOM_IMAGE && activeImagePath == path
                    val thumb = remember(path) {
                        if (File(path).exists()) BitmapFactory.decodeFile(path)?.asImageBitmap() else null
                    }
                    Box(
                        modifier = Modifier
                            .size(width = 112.dp, height = 78.dp)
                            .clip(RoundedCornerShape(16.dp))
                            .border(
                                width = if (isSelected) 2.5.dp else 1.dp,
                                color = if (isSelected) Color(0xFF86EFAC) else Color.White.copy(alpha = 0.2f),
                                shape = RoundedCornerShape(16.dp)
                            )
                            .clickable {
                                prefs.customImagePath = path
                                prefs.themeMode = PrismThemeMode.CUSTOM_IMAGE
                                selectedMode = PrismThemeMode.CUSTOM_IMAGE
                                activeImagePath = path
                                onThemesMutated()
                            }
                    ) {
                        if (thumb != null) {
                            Image(
                                bitmap = thumb,
                                contentDescription = "Tema salvo",
                                contentScale = ContentScale.Crop,
                                modifier = Modifier.fillMaxSize()
                            )
                        }
                        // Silhueta discreta da barra de espaço estilo Gboard
                        Row(
                            modifier = Modifier
                                .align(Alignment.BottomCenter)
                                .fillMaxWidth()
                                .padding(horizontal = 10.dp, vertical = 6.dp),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Spacer(Modifier.width(12.dp))
                            Box(
                                modifier = Modifier
                                    .width(42.dp)
                                    .height(6.dp)
                                    .clip(RoundedCornerShape(4.dp))
                                    .background(Color.White.copy(alpha = 0.7f))
                            )
                            Box(
                                modifier = Modifier
                                    .size(9.dp)
                                    .clip(CircleShape)
                                    .background(Color(0xFF60A5FA))
                            )
                        }
                        if (isSelected) {
                            Box(
                                modifier = Modifier
                                    .align(Alignment.Center)
                                    .size(30.dp)
                                    .clip(CircleShape)
                                    .background(Color(0xFF86EFAC)),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(Icons.Default.Check, contentDescription = null, tint = Color(0xFF0A1F12), modifier = Modifier.size(18.dp))
                            }
                        } else {
                            Box(
                                modifier = Modifier
                                    .align(Alignment.TopEnd)
                                    .padding(4.dp)
                                    .size(20.dp)
                                    .clip(CircleShape)
                                    .background(Color.Black.copy(alpha = 0.65f))
                                    .clickable {
                                        prefs.removeCustomThemePath(path)
                                        onThemesMutated()
                                    },
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(Icons.Default.Close, contentDescription = "Remover", tint = Color.White, modifier = Modifier.size(13.dp))
                            }
                        }
                    }
                }
            }

            if (selectedMode == PrismThemeMode.CUSTOM_IMAGE && !activeImagePath.isNullOrBlank()) {
                Surface(shape = RoundedCornerShape(14.dp), color = Color(0xFF161B26)) {
                    Column(modifier = Modifier.padding(12.dp)) {
                        Text("Escurecimento da foto no teclado: ${(dimAlpha * 100).toInt()}%", color = Color.White, fontSize = 12.sp)
                        Slider(
                            value = dimAlpha,
                            onValueChange = {
                                dimAlpha = it
                                prefs.overlayDimAlpha = it
                            },
                            valueRange = 0.05f..0.75f
                        )
                    }
                }
            }
        }

        // 2. Seção "Padrão" estilo Gboard
        Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text("Padrão", color = Color(0xFFB6C4D8), fontSize = 14.sp, fontWeight = FontWeight.SemiBold)

            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                GboardPresetCard(
                    title = "Cores dinâmicas",
                    bgColor = Color(0xFFE5E9DC),
                    accentDot = Color(0xFF84A98C),
                    splitDarkHalf = false,
                    selected = selectedMode == PrismThemeMode.DYNAMIC_WALLPAPER,
                    modifier = Modifier.weight(1f),
                    onClick = {
                        prefs.themeMode = PrismThemeMode.DYNAMIC_WALLPAPER
                        selectedMode = PrismThemeMode.DYNAMIC_WALLPAPER
                    }
                )
                GboardPresetCard(
                    title = "Automático",
                    bgColor = Color(0xFFF3F4F6),
                    accentDot = Color(0xFF93C5FD),
                    splitDarkHalf = true,
                    selected = selectedMode == PrismThemeMode.SYSTEM_AUTO,
                    modifier = Modifier.weight(1f),
                    onClick = {
                        prefs.themeMode = PrismThemeMode.SYSTEM_AUTO
                        selectedMode = PrismThemeMode.SYSTEM_AUTO
                    }
                )
                GboardPresetCard(
                    title = "Claro padrão",
                    bgColor = Color(0xFFF4F6FA),
                    accentDot = Color(0xFF2563EB),
                    splitDarkHalf = false,
                    selected = selectedMode == PrismThemeMode.LIQUID_LIGHT,
                    modifier = Modifier.weight(1f),
                    onClick = {
                        prefs.themeMode = PrismThemeMode.LIQUID_LIGHT
                        selectedMode = PrismThemeMode.LIQUID_LIGHT
                    }
                )
            }

            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                GboardPresetCard(
                    title = "Escuro padrão",
                    bgColor = Color(0xFF1A1D24),
                    accentDot = Color(0xFF93C5FD),
                    splitDarkHalf = false,
                    selected = selectedMode == PrismThemeMode.LIQUID_DARK,
                    modifier = Modifier.weight(1f),
                    onClick = {
                        prefs.themeMode = PrismThemeMode.LIQUID_DARK
                        selectedMode = PrismThemeMode.LIQUID_DARK
                    }
                )
                Spacer(Modifier.weight(1f))
                Spacer(Modifier.weight(1f))
            }
        }

        // 3. Seção "Cores" estilo Gboard
        Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text("Cores", color = Color(0xFFB6C4D8), fontSize = 14.sp, fontWeight = FontWeight.SemiBold)

            solidThemePresets.chunked(3).forEach { rowPresets ->
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                    rowPresets.forEach { preset: SolidThemePreset ->
                        val isSel = selectedMode == PrismThemeMode.SOLID_COLOR && activeSolidBg == preset.bgHex
                        GboardPresetCard(
                            title = preset.name,
                            bgColor = Color(preset.bgHex),
                            accentDot = Color(preset.accentHex),
                            splitDarkHalf = false,
                            selected = isSel,
                            modifier = Modifier.weight(1f),
                            onClick = {
                                prefs.solidColorBgHex = preset.bgHex
                                prefs.solidColorAccentHex = preset.accentHex
                                prefs.solidColorIsLight = preset.isLight
                                prefs.themeMode = PrismThemeMode.SOLID_COLOR
                                selectedMode = PrismThemeMode.SOLID_COLOR
                                activeSolidBg = preset.bgHex
                            }
                        )
                    }
                    repeat(3 - rowPresets.size) { Spacer(Modifier.weight(1f)) }
                }
            }
        }

        // 4. Seção Som Clássico (iPhone/SwiftKey) e Vibração Háptica
        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Icon(Icons.Default.GraphicEq, contentDescription = null, tint = Color(0xFF8B5CF6))
                    Text("Som e Vibração ao Digitar", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text("Som ao digitar", color = Color.White, fontWeight = FontWeight.Medium)
                        Text("Clique clássico estilo iPhone / SwiftKey", color = Color.White.copy(alpha = 0.65f), fontSize = 12.sp)
                    }
                    Switch(
                        checked = soundEnabled,
                        onCheckedChange = {
                            soundEnabled = it
                            prefs.soundEnabled = it
                            if (it) feedbackPreview.previewClick()
                        }
                    )
                }

                if (soundEnabled) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Volume do clique: ${(soundVolume * 100).toInt()}%", color = Color.White.copy(alpha = 0.8f), fontSize = 12.sp)
                        TextButton(onClick = { feedbackPreview.previewClick() }) {
                            Text("Testar som", color = Color(0xFF93C5FD), fontSize = 12.sp)
                        }
                    }
                    Slider(
                        value = soundVolume,
                        onValueChange = {
                            soundVolume = it
                            prefs.soundVolume = it
                        },
                        valueRange = 0.1f..1.0f
                    )
                }

                HorizontalDivider(color = Color.White.copy(alpha = 0.1f))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text("Vibração ao tocar", color = Color.White, fontWeight = FontWeight.Medium)
                        Text("Pulso háptico rápido a cada tecla", color = Color.White.copy(alpha = 0.65f), fontSize = 12.sp)
                    }
                    Switch(
                        checked = vibrationEnabled,
                        onCheckedChange = {
                            vibrationEnabled = it
                            prefs.vibrationEnabled = it
                        }
                    )
                }

                if (vibrationEnabled) {
                    Text("Duração da vibração: ${vibrationMs} ms", color = Color.White.copy(alpha = 0.8f), fontSize = 12.sp)
                    Slider(
                        value = vibrationMs.toFloat(),
                        onValueChange = {
                            vibrationMs = it.toInt()
                            prefs.vibrationDurationMs = it.toInt()
                        },
                        valueRange = 8f..50f
                    )
                }
            }
        }
    }
}

@Composable
private fun GboardPresetCard(
    title: String,
    bgColor: Color,
    accentDot: Color,
    splitDarkHalf: Boolean,
    selected: Boolean,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Column(
        modifier = modifier.clickable { onClick() },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(68.dp)
                .clip(RoundedCornerShape(14.dp))
                .background(bgColor)
                .border(
                    width = if (selected) 2.5.dp else 1.dp,
                    color = if (selected) Color(0xFF86EFAC) else Color.White.copy(alpha = 0.15f),
                    shape = RoundedCornerShape(14.dp)
                )
        ) {
            if (splitDarkHalf) {
                Box(
                    modifier = Modifier
                        .fillMaxHeight()
                        .fillMaxWidth(0.5f)
                        .align(Alignment.CenterEnd)
                        .background(Color(0xFF151820))
                )
            }
            // Barra de espaço + botão Enter minimalistas
            Row(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .fillMaxWidth()
                    .padding(horizontal = 10.dp, vertical = 7.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Spacer(Modifier.width(8.dp))
                Box(
                    modifier = Modifier
                        .width(36.dp)
                        .height(5.dp)
                        .clip(RoundedCornerShape(4.dp))
                        .background(Color.Gray.copy(alpha = 0.45f))
                )
                Box(
                    modifier = Modifier
                        .size(8.dp)
                        .clip(CircleShape)
                        .background(accentDot)
                )
            }

            if (selected) {
                Box(
                    modifier = Modifier
                        .align(Alignment.Center)
                        .size(26.dp)
                        .clip(CircleShape)
                        .background(Color(0xFF86EFAC)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.Default.Check, contentDescription = null, tint = Color(0xFF0A1F12), modifier = Modifier.size(16.dp))
                }
            }
        }
        Text(
            text = title,
            color = Color.White.copy(alpha = 0.82f),
            fontSize = 11.sp,
            maxLines = 1,
            textAlign = TextAlign.Center
        )
    }
}

@Composable
private fun AiAndLensTab(prefs: PrefsManager, status: PrismSystemStatus) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    var apiKeyInput by remember { mutableStateOf(prefs.apiKey) }
    var lensToggle by remember { mutableStateOf(prefs.lensEnabled) }
    var downloadedLangs by remember { mutableStateOf<Set<String>>(emptySet()) }
    var activeTargetLang by remember { mutableStateOf(prefs.targetLangCode) }
    var downloadingCode by remember { mutableStateOf<String?>(null) }

    LaunchedEffect(Unit) {
        downloadedLangs = HybridAiEngine.getDownloadedLanguageCodes()
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(vertical = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text("IA Híbrida & Lupa", color = Color.White, fontSize = 24.sp, fontWeight = FontWeight.Bold)

        Surface(
            shape = RoundedCornerShape(18.dp),
            color = Color(0xFF161B26),
            border = BorderStroke(
                1.dp,
                if (status.canDrawOverlays && status.isAccessibilityEnabled) Color(0xFF34D399) else Color(0xFFFBBF24)
            )
        ) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text("Lupa Flutuante (Prisma Lens)", color = Color.White, fontWeight = FontWeight.Bold)
                        Text("Detecta o idioma, traduz na hora, lê em voz alta e envia para resposta.", color = Color.White.copy(alpha = 0.7f), fontSize = 12.sp)
                    }
                    Switch(
                        checked = lensToggle,
                        onCheckedChange = { checked ->
                            lensToggle = checked
                            prefs.lensEnabled = checked
                            if (checked) PrismaLensAccessibilityService.instance?.showFloatingLens()
                            else PrismaLensAccessibilityService.instance?.hideFloatingLens()
                        }
                    )
                }

                if (status.canDrawOverlays && status.isAccessibilityEnabled) {
                    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                        Icon(Icons.Default.CheckCircle, contentDescription = null, tint = Color(0xFF34D399), modifier = Modifier.size(16.dp))
                        Text("Permissões de Sobreposição e Acessibilidade OK", color = Color(0xFF34D399), fontSize = 12.sp)
                    }
                } else {
                    Text("⚠️ Permissões pendentes:", color = Color(0xFFFBBF24), fontSize = 12.sp)
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        if (!status.canDrawOverlays) {
                            OutlinedButton(
                                onClick = {
                                    val intent = Intent(
                                        Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                        Uri.parse("package:${context.packageName}")
                                    )
                                    context.startActivity(intent)
                                },
                                modifier = Modifier.weight(1f)
                            ) {
                                Text("Sobreposição", color = Color.White, fontSize = 12.sp)
                            }
                        }
                        if (!status.isAccessibilityEnabled) {
                            OutlinedButton(
                                onClick = { context.startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)) },
                                modifier = Modifier.weight(1f)
                            ) {
                                Text("Acessibilidade", color = Color.White, fontSize = 12.sp)
                            }
                        }
                    }
                }
            }
        }

        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Text("IA na Nuvem (Gemini com Fallback Automático)", color = Color.White, fontWeight = FontWeight.Bold)
                OutlinedTextField(
                    value = apiKeyInput,
                    onValueChange = { apiKeyInput = it },
                    label = { Text("Chave API Gemini") },
                    visualTransformation = PasswordVisualTransformation(),
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )
                Button(
                    onClick = {
                        prefs.apiKey = apiKeyInput
                        Toast.makeText(context, "Chave API salva no PrismKey!", Toast.LENGTH_SHORT).show()
                    },
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("Salvar Chave API")
                }
                OutlinedButton(
                    onClick = {
                        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://aistudio.google.com/app/apikey"))
                        context.startActivity(intent)
                    },
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Icon(Icons.Default.VpnKey, contentDescription = null, tint = Color(0xFF7CA4FF))
                    Spacer(Modifier.width(8.dp))
                    Text("Pegue sua Chave API gratuita", color = Color.White)
                }
            }
        }

        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Text("Idiomas Offline (~30 MB cada)", color = Color.White, fontWeight = FontWeight.Bold)
                Text(
                    "Toque em um idioma baixado para defini-lo como padrão (ou escolha na hora pelo teclado).",
                    color = Color.White.copy(alpha = 0.7f),
                    fontSize = 12.sp
                )

                HybridAiEngine.availableLanguages.forEach { pack ->
                    val isInstalled = downloadedLangs.contains(pack.code)
                    val isSelected = activeTargetLang == pack.code
                    val isBusy = downloadingCode == pack.code

                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            .background(if (isSelected) Color(0xFF242F49) else Color(0xFF1F2636))
                            .border(
                                1.dp,
                                if (isSelected) Color(0xFF8B5CF6) else Color.Transparent,
                                RoundedCornerShape(12.dp)
                            )
                            .clickable {
                                activeTargetLang = pack.code
                                prefs.targetLangCode = pack.code
                                Toast.makeText(context, "Idioma padrão: ${pack.name}", Toast.LENGTH_SHORT).show()
                            }
                            .padding(horizontal = 12.dp, vertical = 8.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Column {
                            Text(
                                text = if (isSelected) "${pack.name} (Padrão)" else pack.name,
                                color = Color.White,
                                fontWeight = FontWeight.Medium
                            )
                            Text(
                                if (isInstalled) "Baixado (Pronto offline)" else "Disponível para download",
                                color = if (isInstalled) Color(0xFF34D399) else Color.White.copy(alpha = 0.55f),
                                fontSize = 11.sp
                            )
                        }

                        if (isBusy) {
                            CircularProgressIndicator(modifier = Modifier.size(22.dp), strokeWidth = 2.dp)
                        } else if (isInstalled) {
                            TextButton(onClick = {
                                scope.launch {
                                    downloadingCode = pack.code
                                    HybridAiEngine.deleteLanguagePack(pack.code)
                                    downloadedLangs = HybridAiEngine.getDownloadedLanguageCodes()
                                    downloadingCode = null
                                }
                            }) {
                                Text("Remover", color = Color(0xFFF87171))
                            }
                        } else {
                            Button(
                                onClick = {
                                    scope.launch {
                                        downloadingCode = pack.code
                                        val res = HybridAiEngine.downloadLanguagePack(pack.code)
                                        downloadedLangs = HybridAiEngine.getDownloadedLanguageCodes()
                                        downloadingCode = null
                                        if (res.isFailure) {
                                            Toast.makeText(context, "Erro ao baixar idioma. Verifique a internet.", Toast.LENGTH_SHORT).show()
                                        }
                                    }
                                },
                                contentPadding = PaddingValues(horizontal = 12.dp, vertical = 4.dp)
                            ) {
                                Text("Baixar", fontSize = 12.sp)
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun AboutAndPrivacyTab(prefs: PrefsManager) {
    val context = LocalContext.current
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(vertical = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text("Privacidade & Créditos", color = Color.White, fontSize = 24.sp, fontWeight = FontWeight.Bold)

        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text("🔒 Arquitetura Local-First", color = Color.White, fontWeight = FontWeight.Bold)
                Text(
                    "O PrismKey não possui servidores próprios. Suas configurações, fotos recortadas, áudio sintetizado e modelos offline ficam exclusivamente no seu aparelho.",
                    color = Color.White.copy(alpha = 0.75f),
                    fontSize = 13.sp
                )
                OutlinedButton(
                    onClick = {
                        prefs.clearAllLocalData()
                        Toast.makeText(context, "Dados locais apagados.", Toast.LENGTH_SHORT).show()
                    }
                ) {
                    Text("Apagar dados locais", color = Color(0xFFF87171))
                }
            }
        }

        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                Text("🛠️ Créditos e Inspiração", color = Color.White, fontWeight = FontWeight.Bold)
                Text(
                    "PrismKey v1.2.0 — Desenvolvido por Davi com colaboração de Pedro Paulo.\n\nConstruído de forma independente em Kotlin e Jetpack Compose.",
                    color = Color.White.copy(alpha = 0.8f),
                    fontSize = 13.sp
                )
                Text(
                    "Licença Open Source: GNU GPL-3.0",
                    color = Color(0xFF7CA4FF),
                    fontSize = 12.sp,
                    fontWeight = FontWeight.SemiBold
                )
            }
        }
    }
}
EOF

# 18. PrismKeyUnitTest.kt (Testes unitários atualizados)
cat << 'EOF' > app/src/test/java/com/prismkey/keyboard/PrismKeyUnitTest.kt
package com.prismkey.keyboard

import com.prismkey.keyboard.ai.HybridAiEngine
import com.prismkey.keyboard.data.WordPredictor
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class PrismKeyUnitTest {
    @Test
    fun testPortugueseAccentSuggestions() {
        val suggestions = WordPredictor.suggest("fac")
        assertEquals(listOf("faça", "faço", "fácil"), suggestions)
    }

    @Test
    fun testCapitalizedSuggestions() {
        val suggestions = WordPredictor.suggest("Fac")
        assertEquals(listOf("Faça", "Faço", "Fácil"), suggestions)
    }

    @Test
    fun testLanguageDisplayNames() {
        assertEquals("Inglês", HybridAiEngine.languageDisplayName("en"))
        assertEquals("Japonês", HybridAiEngine.languageDisplayName("ja"))
    }

    @Test
    fun testEmptyInputReturnsEmpty() {
        assertTrue(WordPredictor.suggest("").isEmpty())
    }
}
EOF

# 19. Auditoria automática de integridade dos arquivos gerados
echo "🔍 Executando auditoria automática de integridade..."
REQUIRED_FILES=(
  "gradle.properties"
  "settings.gradle.kts"
  "build.gradle.kts"
  "app/build.gradle.kts"
  "app/src/main/AndroidManifest.xml"
  "app/src/main/java/com/prismkey/keyboard/MainActivity.kt"
  "app/src/main/java/com/prismkey/keyboard/data/PrefsManager.kt"
  "app/src/main/java/com/prismkey/keyboard/data/WordPredictor.kt"
  "app/src/main/java/com/prismkey/keyboard/data/SystemStatusHelper.kt"
  "app/src/main/java/com/prismkey/keyboard/audio/KeyFeedbackEngine.kt"
  "app/src/main/java/com/prismkey/keyboard/ui/theme/ImageCropper.kt"
  "app/src/main/java/com/prismkey/keyboard/ai/HybridAiEngine.kt"
  "app/src/main/java/com/prismkey/keyboard/ui/keyboard/PrismKeyboardView.kt"
  "app/src/main/java/com/prismkey/keyboard/service/PrismKeyboardService.kt"
  "app/src/main/java/com/prismkey/keyboard/service/PrismaLensAccessibilityService.kt"
  "app/src/test/java/com/prismkey/keyboard/PrismKeyUnitTest.kt"
)
for f in "${REQUIRED_FILES[@]}"; do
  if [ ! -s "$f" ]; then
    echo "❌ ERRO: Arquivo ausente ou vazio: $f"
    exit 1
  fi
done

if grep -rni "privakey" app/src >/dev/null 2>&1; then
  echo "❌ ERRO: Encontrada referência antiga a PrivaKey!"
  exit 1
fi

if ! grep -q "android.permission.VIBRATE" app/src/main/AndroidManifest.xml; then
  echo "❌ ERRO: Permissão VIBRATE ausente no AndroidManifest.xml!"
  exit 1
fi

if ! grep -q "language-id" app/build.gradle.kts; then
  echo "❌ ERRO: Dependência ML Kit language-id ausente!"
  exit 1
fi

echo "✅ Auditoria concluída e estrutura do PrismKey v1.2.0 gerada com sucesso!"
