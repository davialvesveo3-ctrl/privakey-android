#!/bin/bash
set -e

echo "💎 Configurando PrismKey v1.4.0 (Parte 1/2: Base, Áudio SoundPool, Emoji Kitchen, IA Local & 13 Idiomas)..."

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
org.gradle.jvmargs=-Xmx3072m -Dfile.encoding=UTF-8
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
        versionCode = 4
        versionName = "1.4.0"
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
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
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
    implementation("com.google.mediapipe:tasks-genai:0.10.14")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.8.1")
    testImplementation("junit:junit:4.13.2")
}
EOF

# 5. Ícone Vetorial de Prisma
cat << 'EOF' > app/src/main/res/drawable/ic_launcher_background.xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path android:fillColor="#0B1020" android:pathData="M0,0h108v108h-108z" />
    <path android:fillColor="#1A274A" android:pathData="M0,0 L108,0 L108,54 Q54,84 0,54 Z" />
</vector>
EOF

cat << 'EOF' > app/src/main/res/drawable/ic_launcher_foreground.xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path android:fillColor="#4F86F7" android:pathData="M54,22 L82,54 L54,86 L26,54 Z" />
    <path android:fillColor="#93C5FD" android:pathData="M54,22 L82,54 L54,54 Z" />
    <path android:fillColor="#2563EB" android:pathData="M26,54 L54,54 L54,86 Z" />
    <path android:fillColor="#E0F2FE" android:pathData="M54,32 L70,54 L54,54 Z" />
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

# 6. AndroidManifest.xml (RECORD_AUDIO + Speech Queries + FileProvider Emoji Kitchen + OpenCL Snapdragon)
cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />

    <queries>
        <intent>
            <action android:name="android.speech.RecognitionService" />
        </intent>
    </queries>

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@android:style/Theme.Material.NoActionBar">

        <uses-native-library android:name="libOpenCL.so" android:required="false" />
        <uses-native-library android:name="libOpenCL-car.so" android:required="false" />
        <uses-native-library android:name="libOpenCL-pixel.so" android:required="false" />

        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="${applicationId}.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
        </provider>

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

# 7. Recursos XML
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

cat << 'EOF' > app/src/main/res/xml/file_paths.xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <cache-path name="emoji_kitchen_cache" path="emoji_kitchen/" />
</paths>
EOF

# 8. PrefsManager.kt (Todas as configurações da v1.4.0 sincronizadas em tempo real)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/data/PrefsManager.kt
package com.prismkey.keyboard.data

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONObject
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

enum class ToolbarToolId(val label: String, val fixed: Boolean = false) {
    IA("IA", fixed = true),
    RESPONDER("Responder"),
    CORRIGIR("Corrigir"),
    REESCREVER("Reescrever"),
    TRADUZIR("Traduzir"),
    LUPA("Lupa"),
    COPIADOS("Copiados"),
    KITCHEN("Kitchen")
}

class PrefsManager(context: Context) {
    private val prefs: SharedPreferences =
        context.getSharedPreferences("prismkey_prefs_v14", Context.MODE_PRIVATE)

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

    private fun bump(editor: SharedPreferences.Editor) {
        editor.putLong("theme_version", System.currentTimeMillis()).apply()
    }

    // --- Temas & Bordas ---
    var themeMode: PrismThemeMode
        get() {
            val name = prefs.getString("theme_mode", PrismThemeMode.LIQUID_DARK.name)
            return runCatching { PrismThemeMode.valueOf(name!!) }.getOrDefault(PrismThemeMode.LIQUID_DARK)
        }
        set(value) = bump(prefs.edit().putString("theme_mode", value.name))

    var showKeyBorders: Boolean
        get() = prefs.getBoolean("show_key_borders", true)
        set(value) = bump(prefs.edit().putBoolean("show_key_borders", value))

    var solidColorBgHex: Long
        get() = prefs.getLong("solid_color_bg", 0xFF172554)
        set(value) = bump(prefs.edit().putLong("solid_color_bg", value))

    var solidColorAccentHex: Long
        get() = prefs.getLong("solid_color_accent", 0xFF60A5FA)
        set(value) = bump(prefs.edit().putLong("solid_color_accent", value))

    var solidColorIsLight: Boolean
        get() = prefs.getBoolean("solid_color_is_light", false)
        set(value) = bump(prefs.edit().putBoolean("solid_color_is_light", value))

    var customImagePath: String?
        get() = prefs.getString("custom_image_path", null)
        set(value) = bump(prefs.edit().putString("custom_image_path", value))

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
            bump(prefs.edit().putString("saved_custom_themes", clean.joinToString("\n")))
        }

    fun addCustomThemePath(path: String) {
        val current = savedCustomThemes.toMutableList()
        current.remove(path)
        current.add(0, path)
        savedCustomThemes = current
        bump(
            prefs.edit()
                .putString("custom_image_path", path)
                .putString("theme_mode", PrismThemeMode.CUSTOM_IMAGE.name)
        )
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
        get() = prefs.getFloat("overlay_dim_alpha", 0.34f)
        set(value) = bump(prefs.edit().putFloat("overlay_dim_alpha", value.coerceIn(0f, 0.85f)))

    // --- Layout & Digitação Avançada ---
    var keyboardHeightScale: Float
        get() = prefs.getFloat("keyboard_height_scale", 1.0f).coerceIn(1.0f, 1.4f)
        set(value) = bump(prefs.edit().putFloat("keyboard_height_scale", value.coerceIn(1.0f, 1.4f)))

    var keyTextScale: Float
        get() = prefs.getFloat("key_text_scale", 1.0f).coerceIn(0.85f, 1.35f)
        set(value) = bump(prefs.edit().putFloat("key_text_scale", value.coerceIn(0.85f, 1.35f)))

    var showNumberRow: Boolean
        get() = prefs.getBoolean("show_number_row", false)
        set(value) = bump(prefs.edit().putBoolean("show_number_row", value))

    var gestureTypingEnabled: Boolean
        get() = prefs.getBoolean("gesture_typing_enabled", true)
        set(value) = bump(prefs.edit().putBoolean("gesture_typing_enabled", value))

    var autoCorrectionEnabled: Boolean
        get() = prefs.getBoolean("auto_correction_enabled", true)
        set(value) = bump(prefs.edit().putBoolean("auto_correction_enabled", value))

    var autoCapitalizeEnabled: Boolean
        get() = prefs.getBoolean("auto_capitalize_enabled", true)
        set(value) = bump(prefs.edit().putBoolean("auto_capitalize_enabled", value))

    var reviewVoiceDictation: Boolean
        get() = prefs.getBoolean("review_voice_dictation", false)
        set(value) = bump(prefs.edit().putBoolean("review_voice_dictation", value))

    var spaceNeighborKey: String
        get() = prefs.getString("space_neighbor_key", "EMOJI") ?: "EMOJI"
        set(value) = bump(prefs.edit().putString("space_neighbor_key", value))

    var enabledToolbarTools: List<ToolbarToolId>
        get() {
            val defaultList = listOf(
                ToolbarToolId.IA,
                ToolbarToolId.RESPONDER,
                ToolbarToolId.CORRIGIR,
                ToolbarToolId.REESCREVER,
                ToolbarToolId.TRADUZIR,
                ToolbarToolId.LUPA,
                ToolbarToolId.COPIADOS,
                ToolbarToolId.KITCHEN
            )
            val raw = prefs.getString("enabled_toolbar_tools", null) ?: return defaultList
            val parsed = raw.split(",")
                .mapNotNull { name -> runCatching { ToolbarToolId.valueOf(name.trim()) }.getOrNull() }
                .distinct()
                .toMutableList()
            if (!parsed.contains(ToolbarToolId.IA)) parsed.add(0, ToolbarToolId.IA)
            return parsed
        }
        set(value) {
            val clean = value.toMutableList()
            if (!clean.contains(ToolbarToolId.IA)) clean.add(0, ToolbarToolId.IA)
            bump(prefs.edit().putString("enabled_toolbar_tools", clean.distinct().joinToString(",") { it.name }))
        }

    // --- Som (SoundPool) & Vibração ---
    var soundEnabled: Boolean
        get() = prefs.getBoolean("sound_enabled", true)
        set(value) = bump(prefs.edit().putBoolean("sound_enabled", value))

    var soundVolume: Float
        get() = prefs.getFloat("sound_volume", 0.85f)
        set(value) = bump(prefs.edit().putFloat("sound_volume", value.coerceIn(0.05f, 1.0f)))

    var vibrationEnabled: Boolean
        get() = prefs.getBoolean("vibration_enabled", true)
        set(value) = bump(prefs.edit().putBoolean("vibration_enabled", value))

    var vibrationDurationMs: Int
        get() = prefs.getInt("vibration_duration_ms", 18)
        set(value) = bump(prefs.edit().putInt("vibration_duration_ms", value.coerceIn(8, 55)))

    // --- IA Local Offline + Fallback Nuvem + Lupa ---
    var preferLocalAi: Boolean
        get() = prefs.getBoolean("prefer_local_ai", true)
        set(value) = bump(prefs.edit().putBoolean("prefer_local_ai", value))

    var localModelPath: String?
        get() = prefs.getString("local_model_path", null)
        set(value) = bump(prefs.edit().putString("local_model_path", value))

    var localModelUrl: String
        get() = prefs.getString(
            "local_model_url",
            "https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task"
        ) ?: ""
        set(value) = prefs.edit().putString("local_model_url", value.trim()).apply()

    var apiKey: String
        get() = prefs.getString("gemini_api_key", "") ?: ""
        set(value) = prefs.edit().putString("gemini_api_key", value.trim()).apply()

    var lensEnabled: Boolean
        get() = prefs.getBoolean("lens_enabled", false)
        set(value) = prefs.edit().putBoolean("lens_enabled", value).apply()

    var targetLangCode: String
        get() = prefs.getString("target_lang_code", "en") ?: "en"
        set(value) = prefs.edit().putString("target_lang_code", value).apply()

    var pendingReplyContext: String
        get() = prefs.getString("pending_reply_context", "") ?: ""
        set(value) = bump(prefs.edit().putString("pending_reply_context", value))

    // --- Snippets / Atalhos Pessoais ---
    var personalSnippets: Map<String, String>
        get() {
            val raw = prefs.getString("personal_snippets_json", null)
            if (raw.isNullOrBlank()) {
                return linkedMapOf(
                    "/oi" to "Olá! Tudo bem por aí?",
                    "/obg" to "Muito obrigado pela atenção!",
                    "/aguarde" to "Já estou vendo isso e te respondo em instantes."
                )
            }
            return runCatching {
                val obj = JSONObject(raw)
                val map = LinkedHashMap<String, String>()
                val keys = obj.keys()
                while (keys.hasNext()) {
                    val k = keys.next()
                    map[k] = obj.optString(k, "")
                }
                map
            }.getOrDefault(emptyMap())
        }
        set(value) {
            val obj = JSONObject()
            value.forEach { (k, v) ->
                val cleanKey = k.trim()
                if (cleanKey.isNotEmpty() && v.isNotBlank()) {
                    obj.put(cleanKey, v.trim())
                }
            }
            bump(prefs.edit().putString("personal_snippets_json", obj.toString()))
        }

    fun addSnippet(trigger: String, expansion: String) {
        val current = personalSnippets.toMutableMap()
        val key = trigger.trim().lowercase()
        if (key.isNotEmpty() && expansion.isNotBlank()) {
            current[key] = expansion.trim()
            personalSnippets = current
        }
    }

    fun removeSnippet(trigger: String) {
        val current = personalSnippets.toMutableMap()
        current.remove(trigger)
        personalSnippets = current
    }

    fun clearAllLocalData() {
        savedCustomThemes.forEach { runCatching { File(it).delete() } }
        localModelPath?.let { runCatching { File(it).delete() } }
        prefs.edit().clear().apply()
        notifyThemeChanged()
    }
}
EOF

# 9. KeyFeedbackEngine.kt (SoundPool + WAV Real em Disco — 100% compatível com HyperOS/MIUI + Vibração)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/audio/KeyFeedbackEngine.kt
package com.prismkey.keyboard.audio

import android.content.Context
import android.media.AudioAttributes
import android.media.SoundPool
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import com.prismkey.keyboard.data.PrefsManager
import java.io.File
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
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

    private val soundPool: SoundPool = SoundPool.Builder()
        .setMaxStreams(6)
        .setAudioAttributes(
            AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ASSISTANCE_SONIFICATION)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()
        )
        .build()

    @Volatile private var charSoundId = 0
    @Volatile private var spaceSoundId = 0
    @Volatile private var deleteSoundId = 0
    @Volatile private var loadedIds = mutableSetOf<Int>()
    @Volatile private var released = false

    private val vibrator: Vibrator? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        (context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager)?.defaultVibrator
    } else {
        @Suppress("DEPRECATION")
        context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
    }

    init {
        soundPool.setOnLoadCompleteListener { _, sampleId, status ->
            if (status == 0) loadedIds.add(sampleId)
        }

        executor.execute {
            if (released) return@execute
            runCatching {
                val charWav = ensureWavFile("prism_tock_char_v14.wav", 2420.0, 1180.0, 16, 8.2)
                val spaceWav = ensureWavFile("prism_tock_space_v14.wav", 1420.0, 690.0, 20, 6.8)
                val delWav = ensureWavFile("prism_tock_del_v14.wav", 1880.0, 920.0, 14, 9.0)

                charSoundId = soundPool.load(charWav.absolutePath, 1)
                spaceSoundId = soundPool.load(spaceWav.absolutePath, 1)
                deleteSoundId = soundPool.load(delWav.absolutePath, 1)
            }
        }
    }

    fun trigger(type: KeySoundType) {
        if (released) return

        if (prefs.vibrationEnabled) {
            val ms = prefs.vibrationDurationMs.toLong().coerceIn(8L, 55L)
            vibrateMs(ms)
        }

        if (prefs.soundEnabled) {
            val vol = prefs.soundVolume.coerceIn(0.05f, 1.0f)
            val id = when (type) {
                KeySoundType.CHAR -> charSoundId
                KeySoundType.SPACE_ENTER -> spaceSoundId
                KeySoundType.DELETE -> deleteSoundId
            }
            if (id != 0 && loadedIds.contains(id)) {
                runCatching { soundPool.play(id, vol, vol, 1, 0, 1.0f) }
            }
        }
    }

    fun triggerLightTick() {
        if (released || !prefs.vibrationEnabled) return
        vibrateMs(10L)
    }

    fun previewClick() {
        if (released) return
        val vol = prefs.soundVolume.coerceIn(0.1f, 1.0f)
        if (charSoundId != 0 && loadedIds.contains(charSoundId)) {
            runCatching { soundPool.play(charSoundId, vol, vol, 1, 0, 1.0f) }
        }
        if (prefs.vibrationEnabled) {
            vibrateMs(prefs.vibrationDurationMs.toLong().coerceIn(8L, 55L))
        }
    }

    private fun vibrateMs(ms: Long) {
        runCatching {
            if (vibrator?.hasVibrator() == true) {
                vibrator.vibrate(VibrationEffect.createOneShot(ms, VibrationEffect.DEFAULT_AMPLITUDE))
            }
        }
    }

    private fun ensureWavFile(
        fileName: String,
        freqMain: Double,
        freqSub: Double,
        durationMs: Int,
        decay: Double
    ): File {
        val file = File(context.cacheDir, fileName)
        if (file.exists() && file.length() > 44) return file

        val totalSamples = (sampleRate * durationMs) / 1000
        val pcmBytes = ByteArray(totalSamples * 2)
        val bb = ByteBuffer.wrap(pcmBytes).order(ByteOrder.LITTLE_ENDIAN)

        var seed = 4242L
        for (i in 0 until totalSamples) {
            val t = i.toDouble() / sampleRate
            val progress = i.toDouble() / totalSamples
            val attack = if (i < 14) i.toDouble() / 14.0 else 1.0
            val envelope = attack * exp(-decay * progress)

            seed = (seed * 1103515245L + 12345L) and 0x7fffffffL
            val noise = ((seed.toDouble() / 0x7fffffffL) * 2.0 - 1.0) * exp(-18.0 * progress)

            val wave = 0.56 * sin(2.0 * PI * freqMain * t) +
                0.34 * sin(2.0 * PI * freqSub * t) +
                0.30 * noise

            val sample = (wave * envelope * 30000.0).toInt().coerceIn(-32767, 32767).toShort()
            bb.putShort(sample)
        }

        val dataSize = pcmBytes.size
        val header = ByteBuffer.allocate(44).order(ByteOrder.LITTLE_ENDIAN).apply {
            put("RIFF".toByteArray())
            putInt(36 + dataSize)
            put("WAVE".toByteArray())
            put("fmt ".toByteArray())
            putInt(16)
            putShort(1) // PCM
            putShort(1) // Mono
            putInt(sampleRate)
            putInt(sampleRate * 2)
            putShort(2)
            putShort(16)
            put("data".toByteArray())
            putInt(dataSize)
        }.array()

        FileOutputStream(file).use { fos ->
            fos.write(header)
            fos.write(pcmBytes)
        }
        return file
    }

    fun release() {
        released = true
        runCatching { soundPool.release() }
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

# 11. WordPredictor.kt (Sugestões + Correção Automática + Digitação por Gestos / Swipe + Snippets)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/data/WordPredictor.kt
package com.prismkey.keyboard.data

object WordPredictor {
    private val learnedWords = LinkedHashSet<String>()

    private val commonTypos = mapOf(
        "vc" to "você",
        "vcs" to "vocês",
        "tb" to "também",
        "tbm" to "também",
        "pq" to "porque",
        "nao" to "não",
        "entao" to "então",
        "tambem" to "também",
        "voce" to "você",
        "ate" to "até",
        "ja" to "já",
        "so" to "só",
        "esta" to "está",
        "estao" to "estão",
        "sera" to "será",
        "faca" to "faça",
        "faco" to "faço",
        "facil" to "fácil",
        "codigo" to "código",
        "funcao" to "função",
        "funcoes" to "funções",
        "opcao" to "opção",
        "opcoes" to "opções",
        "otimo" to "ótimo",
        "rapido" to "rápido",
        "incrivel" to "incrível",
        "portugues" to "português",
        "ingles" to "inglês",
        "frances" to "francês",
        "japones" to "japonês",
        "chines" to "chinês",
        "alemao" to "alemão",
        "arabe" to "árabe",
        "vibracao" to "vibração",
        "versao" to "versão",
        "atualizacao" to "atualização",
        "sugestao" to "sugestão",
        "sugestoes" to "sugestões",
        "correcao" to "correção",
        "digitacao" to "digitação",
        "maiuscula" to "maiúscula",
        "padrao" to "padrão",
        "numero" to "número",
        "numeros" to "números",
        "amanha" to "amanhã",
        "alguem" to "alguém",
        "ninguem" to "ninguém",
        "porem" to "porém",
        "alem" to "além"
    )

    private val ptDictionary = listOf(
        "abraço", "agora", "ainda", "ajuda", "ajudar", "algo", "alguém", "amanhã", "amigo", "amigos",
        "antes", "aplicativo", "aqui", "assim", "até", "atualização", "atualizar", "bem", "beleza",
        "boa", "bom", "bora", "brasil", "calma", "casa", "celular", "certeza", "certo", "chegar",
        "claro", "código", "coisa", "coisas", "comigo", "como", "conseguir", "consigo", "conta",
        "corrigir", "criar", "cuidado", "curtir", "dados", "demais", "depois", "desde", "desse",
        "dessa", "deu", "dia", "dias", "dica", "diferente", "digitar", "digitação", "direito", "disso",
        "dizer", "download", "elegante", "emoji", "então", "entendi", "enviar", "errado", "erro",
        "escolher", "escrever", "espaço", "espera", "esse", "essa", "estão", "estar", "estava",
        "estou", "exemplo", "faça", "faço", "fácil", "falar", "falta", "fazer", "fazendo", "feito",
        "feliz", "ficar", "ficou", "final", "foi", "fonte", "forma", "foto", "funciona", "funcionando",
        "funcionar", "função", "funções", "galera", "galeria", "gente", "geral", "gesto", "gestos",
        "github", "gostei", "grande", "hoje", "hora", "ideia", "idioma", "idiomas", "igual", "imagem",
        "importante", "incrível", "instalar", "inteligência", "internet", "isso", "jeito", "junto",
        "juntos", "kitchen", "legal", "lembrar", "letra", "letras", "limpar", "lindo", "linha", "lista",
        "local", "logo", "lugar", "lupa", "mais", "mandar", "mande", "mas", "melhor", "melhorar",
        "melhorias", "memória", "mensagem", "mesma", "mesmo", "meu", "meus", "microfone", "minha",
        "minhas", "modo", "momento", "muito", "muitos", "mundo", "nada", "não", "nem", "nessa",
        "nesse", "ninguém", "noite", "nome", "normal", "nossa", "nosso", "nova", "novo", "número",
        "números", "nunca", "obrigado", "offline", "olha", "onde", "online", "opção", "opções", "ótimo",
        "outra", "outro", "padrão", "página", "palavra", "palavras", "papel", "para", "parece", "parede",
        "parte", "passar", "pedir", "pegar", "pelo", "pela", "pensar", "perfeito", "pergunta", "permissão",
        "pessoa", "pessoas", "pode", "podemos", "poder", "ponto", "por", "porque", "português", "pouco",
        "precisa", "preciso", "prismkey", "privacidade", "privado", "problema", "projeto", "pronto",
        "próxima", "próximo", "público", "qual", "qualquer", "quando", "quanto", "quase", "quem", "quer",
        "quero", "rápido", "realmente", "recurso", "recursos", "reescrever", "repositório", "responder",
        "resposta", "sabe", "saber", "sair", "salvar", "segredo", "seguir", "segurança", "sem", "semana",
        "sempre", "senha", "ser", "será", "seu", "seus", "sim", "simples", "sistema", "sobre", "só",
        "som", "somente", "sua", "suas", "sugestão", "sugestões", "talvez", "tamanho", "também", "tarde",
        "teclado", "teclas", "tela", "tema", "temas", "tempo", "temos", "tenta", "tentar", "ter",
        "testar", "teste", "testes", "texto", "textos", "tinha", "tipo", "tirar", "toda", "todas",
        "todo", "todos", "toque", "trabalho", "traduzir", "trazer", "tudo", "última", "último", "uma",
        "usar", "usando", "usuário", "vai", "valeu", "vamos", "verdade", "versão", "vez", "vezes",
        "vibração", "vídeo", "visual", "você", "vocês", "voltar", "vou", "voz", "zoom"
    )

    fun learnWord(word: String) {
        val clean = word.trim().lowercase()
        if (clean.length >= 3 && clean.all { it.isLetter() }) {
            learnedWords.add(clean)
            if (learnedWords.size > 200) {
                val first = learnedWords.first()
                learnedWords.remove(first)
            }
        }
    }

    fun autoCorrectWord(word: String): String? {
        val clean = word.trim()
        if (clean.length < 2) return null
        val lower = clean.lowercase()
        val fixed = commonTypos[lower] ?: return null
        return if (clean.first().isUpperCase()) fixed.replaceFirstChar { it.uppercase() } else fixed
    }

    fun findSnippet(currentToken: String, snippets: Map<String, String>): String? {
        val clean = currentToken.trim().lowercase()
        if (clean.isEmpty()) return null
        return snippets[clean]
    }

    fun suggest(currentWord: String, snippets: Map<String, String> = emptyMap()): List<String> {
        val clean = currentWord.trim()
        if (clean.isEmpty()) return emptyList()

        val snippetHit = findSnippet(clean, snippets)
        if (snippetHit != null) return listOf(snippetHit)

        val lower = clean.lowercase()
        val lowerNoAccent = stripAccents(lower)
        val isCapitalized = clean.first().isUpperCase()

        val combined = learnedWords.toList().reversed() + ptDictionary
        val typoFix = commonTypos[lower]
        val exactMatches = combined.filter { it.startsWith(lower) && it != lower }
        val accentMatches = combined.filter {
            stripAccents(it).startsWith(lowerNoAccent) && it != lower && !exactMatches.contains(it)
        }

        val ordered = buildList {
            if (typoFix != null && typoFix != lower) add(typoFix)
            addAll(exactMatches)
            addAll(accentMatches)
        }.distinct().take(3)

        return ordered.map { word ->
            if (isCapitalized) word.replaceFirstChar { it.uppercase() } else word
        }
    }

    /**
     * Reconhece palavras deslizadas por gesto (Swipe / Glide Typing) comparando
     * a sequência de letras percorridas com o dicionário em Português.
     */
    fun predictFromGlidePath(rawPath: String, capitalize: Boolean = false): String? {
        val path = stripAccents(rawPath.lowercase()).filter { it.isLetter() }
        if (path.length < 2) return null

        val firstChar = path.first()
        val lastChar = path.last()
        val combined = (learnedWords.toList().reversed() + ptDictionary).distinct()

        var bestWord: String? = null
        var bestScore = -1

        for (word in combined) {
            val norm = stripAccents(word.lowercase())
            if (norm.length < 2) continue
            if (norm.first() != firstChar || norm.last() != lastChar) continue

            // Verifica se todas as letras da palavra aparecem na ordem dentro do rastro do gesto
            var pIdx = 0
            var matched = true
            for (ch in norm) {
                val found = path.indexOf(ch, pIdx)
                if (found == -1) {
                    matched = false
                    break
                }
                pIdx = found
            }
            if (matched) {
                val lengthDiff = kotlin.math.abs(norm.length - path.length)
                val score = 100 - lengthDiff * 5 + norm.length * 2
                if (score > bestScore) {
                    bestScore = score
                    bestWord = word
                }
            }
        }

        return bestWord?.let { w ->
            if (capitalize) w.replaceFirstChar { it.uppercase() } else w
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

# 12. EmojiKitchenEngine.kt (Biblioteca Completa de Emotes + Emoji Kitchen Real com Fallback Offline)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/data/EmojiKitchenEngine.kt
package com.prismkey.keyboard.data

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.Shader
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileOutputStream
import java.net.HttpURLConnection
import java.net.URL

data class EmojiCategory(
    val id: String,
    val icon: String,
    val title: String,
    val emojis: List<String>
)

data class KitchenResult(
    val stickerFile: File,
    val isOfficialKitchen: Boolean
)

object EmojiKitchenEngine {

    val kitchenMixableEmojis = listOf(
        "😀", "😂", "😍", "🥰", "😎", "🤩", "🥳", "🤔", "🤯", "🥺", "😢", "😭",
        "😡", "🤬", "😱", "😴", "🤮", "🤠", "🤡", "👻", "💀", "👽", "🤖", "💩",
        "🔥", "✨", "💎", "❤️", "💔", "💯", "⚡", "🌈", "🌙", "☀️", "⭐", "❄️",
        "🐶", "🐱", "🦁", "🐸", "🐵", "🦄", "🐉", "🦖", "🦋", "🐙", "🦈", "🐢",
        "🍕", "🍔", "🌮", "🍩", "🍉", "🍓", "🥑", "☕", "👑", "⚽", "🎮", "🚀"
    )

    val fullEmojiCategories = listOf(
        EmojiCategory(
            id = "smileys",
            icon = "😀",
            title = "Rostos",
            emojis = listOf(
                "😀", "😃", "😄", "😁", "😆", "😅", "🤣", "😂", "🙂", "🙃", "😉", "😊",
                "😇", "🥰", "😍", "🤩", "😘", "😗", "😚", "😙", "🥲", "😋", "😛", "😜",
                "🤪", "😝", "🤑", "🤗", "🤭", "🫢", "🤫", "🤔", "🫡", "🤐", "🤨", "😐",
                "😑", "😶", "😏", "😒", "🙄", "😬", "🤥", "😌", "😔", "😪", "🤤", "😴",
                "😷", "🤒", "🤕", "🤢", "🤮", "🤧", "🥵", "🥶", "🥴", "😵", "🤯", "🤠",
                "🥳", "🥸", "😎", "🤓", "🧐", "😕", "😟", "🙁", "😮", "😯", "😲", "😳",
                "🥺", "🥹", "😦", "😧", "😨", "😰", "😥", "😢", "😭", "😱", "😖", "😣",
                "😞", "😓", "😩", "😫", "🥱", "😤", "😡", "😠", "🤬", "😈", "👿", "💀",
                "☠️", "💩", "🤡", "👹", "👺", "👻", "👽", "👾", "🤖"
            )
        ),
        EmojiCategory(
            id = "gestures",
            icon = "👍",
            title = "Gestos",
            emojis = listOf(
                "👋", "🤚", "🖐️", "✋", "🖖", "👌", "🤌", "🤏", "✌️", "🤞", "🫰", "🤟",
                "🤘", "🤙", "👈", "👉", "👆", "👇", "☝️", "👍", "👎", "✊", "👊", "🤛",
                "🤜", "👏", "🙌", "🫶", "👐", "🤲", "🤝", "🙏", "✍️", "💅", "💪", "🦾",
                "👀", "👁️", "🧠", "🫀", "🗣️", "👤", "👥", "🫂", "🕺", "💃", "🏃", "🧘"
            )
        ),
        EmojiCategory(
            id = "hearts",
            icon = "❤️",
            title = "Corações",
            emojis = listOf(
                "❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💔", "❤️‍🔥", "❤️‍🩹",
                "❣️", "💕", "💞", "💓", "💗", "💖", "💘", "💝", "💟", "💌", "💋", "💯",
                "💢", "💥", "💫", "💦", "💨", "💬", "💭", "💤", "✨", "🌟", "⭐", "🔥"
            )
        ),
        EmojiCategory(
            id = "animals",
            icon = "🦁",
            title = "Animais",
            emojis = listOf(
                "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁",
                "🐮", "🐷", "🐸", "🐵", "🙈", "🙉", "🙊", "🐔", "🐧", "🐦", "🦅", "🦉",
                "🐺", "🐗", "🐴", "🦄", "🐝", "🦋", "🐌", "🐞", "🐢", "🐍", "🦎", "🦖",
                "🦕", "🐙", "🦑", "🦀", "🐡", "🐠", "🐟", "🐬", "🐳", "🐋", "🦈", "🐊",
                "🐉", "🌵", "🌲", "🌳", "🌴", "🌹", "🌺", "🌻", "🌼", "🌸", "🍀", "🍁"
            )
        ),
        EmojiCategory(
            id = "food",
            icon = "🍕",
            title = "Comida",
            emojis = listOf(
                "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍒", "🍑", "🥭",
                "🍍", "🥥", "🥝", "🍅", "🥑", "🥦", "🌽", "🥕", "🍟", "🍕", "🌭", "🍔",
                "🥪", "🌮", "🌯", "🍗", "🍖", "🥩", "🥓", "🍳", "🥞", "🧇", "🧀", "🍝",
                "🍜", "🍣", "🍤", "🍦", "🍩", "🍪", "🎂", "🍰", "🧁", "🍫", "🍿", "☕",
                "🧋", "🥤", "🧃", "🍺", "🥂", "🍾"
            )
        ),
        EmojiCategory(
            id = "objects",
            icon = "🎮",
            title = "Objetos",
            emojis = listOf(
                "⚽", "🏀", "🏈", "⚾", "🎾", "🏐", "🎱", "🏓", "🥊", "🏆", "🥇", "🥈",
                "🥉", "🏅", "🎮", "🕹️", "🎲", "🧩", "♟️", "🎯", "🎸", "🎧", "🎤", "🎬",
                "📱", "💻", "⌨️", "🖥️", "🖨️", "🖱️", "🔋", "🔌", "💡", "🔦", "💎", "👑",
                "🔑", "🔒", "🔓", "🛠️", "⚙️", "🚀", "🛸", "✈️", "🚗", "🏎️", "🏍️", "⚡",
                "🌈", "☀️", "🌙", "☁️", "⛈️", "❄️", "🎉", "🎊", "🎁", "🎈", "✅", "❌"
            )
        )
    )

    private val kitchenDates = listOf(
        "20231113", "20230803", "20230301", "20221101",
        "20220815", "20220506", "20210831", "20210521",
        "20210218", "20201001"
    )

    private fun emojiToCodePointString(emoji: String, stripFe0f: Boolean): String {
        val cps = mutableListOf<String>()
        var i = 0
        while (i < emoji.length) {
            val cp = emoji.codePointAt(i)
            i += Character.charCount(cp)
            if (stripFe0f && cp == 0xFE0F) continue
            cps.add("u" + cp.toString(16).lowercase())
        }
        return cps.joinToString("-")
    }

    suspend fun getOrCreateKitchenSticker(
        context: Context,
        emoji1: String,
        emoji2: String
    ): KitchenResult = withContext(Dispatchers.IO) {
        val cacheDir = File(context.cacheDir, "emoji_kitchen").apply { if (!exists()) mkdirs() }
        val key1 = emojiToCodePointString(emoji1, true)
        val key2 = emojiToCodePointString(emoji2, true)
        val cacheFile = File(cacheDir, "ek_${key1}_${key2}.png")

        if (cacheFile.exists() && cacheFile.length() > 1000) {
            return@withContext KitchenResult(cacheFile, isOfficialKitchen = true)
        }

        val candidates = buildList {
            val pairs = listOf(
                emojiToCodePointString(emoji1, true) to emojiToCodePointString(emoji2, true),
                emojiToCodePointString(emoji2, true) to emojiToCodePointString(emoji1, true),
                emojiToCodePointString(emoji1, false) to emojiToCodePointString(emoji2, false),
                emojiToCodePointString(emoji2, false) to emojiToCodePointString(emoji1, false)
            ).distinct()

            for (date in kitchenDates) {
                for ((a, b) in pairs) {
                    add("https://www.gstatic.com/android/keyboard/emojikitchen/$date/$a/${a}_$b.png")
                }
            }
        }

        for (urlStr in candidates) {
            var conn: HttpURLConnection? = null
            try {
                conn = (URL(urlStr).openConnection() as HttpURLConnection).apply {
                    requestMethod = "GET"
                    connectTimeout = 2500
                    readTimeout = 3000
                }
                if (conn.responseCode == 200) {
                    val bytes = conn.inputStream.use { it.readBytes() }
                    if (bytes.size > 500 && BitmapFactory.decodeByteArray(bytes, 0, bytes.size) != null) {
                        FileOutputStream(cacheFile).use { it.write(bytes) }
                        return@withContext KitchenResult(cacheFile, isOfficialKitchen = true)
                    }
                }
            } catch (_: Exception) {
                // Tenta próximo bucket ou cai para o gerador local offline
            } finally {
                conn?.disconnect()
            }
        }

        // Fallback local garantido (funciona 100% offline mesmo sem internet!)
        val offlineFile = File(cacheDir, "ek_local_${key1}_${key2}.png")
        renderOfflineMashupPng(emoji1, emoji2, offlineFile)
        KitchenResult(offlineFile, isOfficialKitchen = false)
    }

    private fun renderOfflineMashupPng(emoji1: String, emoji2: String, targetFile: File) {
        val size = 512
        val bmp = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bmp)

        val bgPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            shader = LinearGradient(
                0f, 0f, size.toFloat(), size.toFloat(),
                intArrayOf(Color.parseColor("#3B82F6"), Color.parseColor("#8B5CF6"), Color.parseColor("#EC4899")),
                null,
                Shader.TileMode.CLAMP
            )
            alpha = 46
        }
        canvas.drawCircle(size / 2f, size / 2f, size * 0.44f, bgPaint)

        val mainPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            textSize = 270f
            textAlign = Paint.Align.CENTER
        }
        canvas.drawText(emoji1, size * 0.43f, size * 0.62f, mainPaint)

        val badgePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            textSize = 165f
            textAlign = Paint.Align.CENTER
        }
        canvas.drawText(emoji2, size * 0.68f, size * 0.80f, badgePaint)

        FileOutputStream(targetFile).use { fos ->
            bmp.compress(Bitmap.CompressFormat.PNG, 95, fos)
        }
        bmp.recycle()
    }
}
EOF

# 13. HybridAiEngine.kt (13 Idiomas Offline + IA Local MediaPipe/LiteRT + Fallback Gemini Cloud)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/ai/HybridAiEngine.kt
package com.prismkey.keyboard.ai

import android.content.Context
import android.net.Uri
import com.google.mediapipe.tasks.genai.llminference.LlmInference
import com.google.mlkit.common.model.DownloadConditions
import com.google.mlkit.common.model.RemoteModelManager
import com.google.mlkit.nl.languageid.LanguageIdentification
import com.google.mlkit.nl.translate.TranslateLanguage
import com.google.mlkit.nl.translate.TranslateRemoteModel
import com.google.mlkit.nl.translate.Translation
import com.google.mlkit.nl.translate.TranslatorOptions
import com.prismkey.keyboard.data.PrefsManager
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL

data class OfflineLangPack(
    val name: String,
    val code: String,
    val approxSizeMb: String
)

data class LensTranslationResult(
    val detectedLanguageCode: String,
    val detectedLanguageName: String,
    val translatedText: String
)

object HybridAiEngine {
    val availableLanguages = listOf(
        OfflineLangPack("Inglês", TranslateLanguage.ENGLISH, "~30 MB"),
        OfflineLangPack("Espanhol", TranslateLanguage.SPANISH, "~30 MB"),
        OfflineLangPack("Francês", TranslateLanguage.FRENCH, "~30 MB"),
        OfflineLangPack("Alemão", TranslateLanguage.GERMAN, "~30 MB"),
        OfflineLangPack("Italiano", TranslateLanguage.ITALIAN, "~30 MB"),
        OfflineLangPack("Japonês", TranslateLanguage.JAPANESE, "~35 MB"),
        OfflineLangPack("Chinês", TranslateLanguage.CHINESE, "~40 MB"),
        OfflineLangPack("Russo", TranslateLanguage.RUSSIAN, "~32 MB"),
        OfflineLangPack("Indonésio", TranslateLanguage.INDONESIAN, "~30 MB"),
        OfflineLangPack("Turco", TranslateLanguage.TURKISH, "~30 MB"),
        OfflineLangPack("Vietnamita", TranslateLanguage.VIETNAMESE, "~30 MB"),
        OfflineLangPack("Árabe", TranslateLanguage.ARABIC, "~32 MB"),
        OfflineLangPack("Coreano", TranslateLanguage.KOREAN, "~35 MB")
    )

    private val geminiModelChain = listOf(
        "gemini-2.5-flash",
        "gemini-2.0-flash",
        "gemini-1.5-flash"
    )

    private val llmMutex = Mutex()
    private var activeLlm: LlmInference? = null
    private var loadedModelPath: String? = null

    fun isLocalModelInstalled(prefs: PrefsManager): Boolean {
        val path = prefs.localModelPath ?: return false
        val file = File(path)
        return file.exists() && file.length() > 1_000_000L
    }

    fun getLocalModelSizeMb(prefs: PrefsManager): Long {
        val path = prefs.localModelPath ?: return 0L
        val file = File(path)
        return if (file.exists()) file.length() / (1024L * 1024L) else 0L
    }

    suspend fun downloadLocalModel(
        context: Context,
        prefs: PrefsManager,
        modelUrl: String,
        onProgress: (Int) -> Unit
    ): Result<String> = withContext(Dispatchers.IO) {
        var conn: HttpURLConnection? = null
        try {
            val cleanUrl = modelUrl.trim()
            if (!cleanUrl.startsWith("http")) {
                return@withContext Result.failure(Exception("URL inválida para o modelo local."))
            }
            val modelsDir = File(context.filesDir, "models").apply { if (!exists()) mkdirs() }
            val tempFile = File(modelsDir, "prism_llm_downloading.tmp")
            val finalFile = File(modelsDir, "prism_local_llm.task")

            conn = (URL(cleanUrl).openConnection() as HttpURLConnection).apply {
                instanceFollowRedirects = true
                connectTimeout = 20000
                readTimeout = 30000
            }
            val code = conn.responseCode
            if (code !in 200..299) {
                return@withContext Result.failure(Exception("Servidor recusou o download (HTTP $code). Você também pode importar um arquivo .task/.bin local."))
            }

            val totalBytes = conn.contentLengthLong
            var downloaded = 0L
            var lastPercent = -1

            conn.inputStream.use { input ->
                FileOutputStream(tempFile).use { output ->
                    val buffer = ByteArray(32 * 1024)
                    while (true) {
                        val read = input.read(buffer)
                        if (read == -1) break
                        output.write(buffer, 0, read)
                        downloaded += read
                        if (totalBytes > 0) {
                            val pct = ((downloaded * 100L) / totalBytes).toInt().coerceIn(0, 99)
                            if (pct != lastPercent) {
                                lastPercent = pct
                                withContext(Dispatchers.Main) { onProgress(pct) }
                            }
                        }
                    }
                }
            }

            if (finalFile.exists()) finalFile.delete()
            tempFile.renameTo(finalFile)
            releaseLocalLlm()
            prefs.localModelPath = finalFile.absolutePath
            withContext(Dispatchers.Main) { onProgress(100) }
            Result.success(finalFile.absolutePath)
        } catch (e: Exception) {
            Result.failure(Exception("Falha no download do modelo local: ${e.message ?: "verifique a conexão."}"))
        } finally {
            conn?.disconnect()
        }
    }

    suspend fun importLocalModelFromUri(
        context: Context,
        prefs: PrefsManager,
        uri: Uri,
        onProgress: (Int) -> Unit
    ): Result<String> = withContext(Dispatchers.IO) {
        try {
            val modelsDir = File(context.filesDir, "models").apply { if (!exists()) mkdirs() }
            val finalFile = File(modelsDir, "prism_local_llm.task")
            val tempFile = File(modelsDir, "prism_llm_import.tmp")

            val pfd = context.contentResolver.openAssetFileDescriptor(uri, "r")
            val totalBytes = pfd?.length ?: -1L
            pfd?.close()

            var copied = 0L
            var lastPercent = -1
            context.contentResolver.openInputStream(uri)?.use { input ->
                FileOutputStream(tempFile).use { output ->
                    val buffer = ByteArray(64 * 1024)
                    while (true) {
                        val read = input.read(buffer)
                        if (read == -1) break
                        output.write(buffer, 0, read)
                        copied += read
                        if (totalBytes > 0) {
                            val pct = ((copied * 100L) / totalBytes).toInt().coerceIn(0, 99)
                            if (pct != lastPercent) {
                                lastPercent = pct
                                withContext(Dispatchers.Main) { onProgress(pct) }
                            }
                        }
                    }
                }
            } ?: return@withContext Result.failure(Exception("Não foi possível ler o arquivo selecionado."))

            if (finalFile.exists()) finalFile.delete()
            tempFile.renameTo(finalFile)
            releaseLocalLlm()
            prefs.localModelPath = finalFile.absolutePath
            withContext(Dispatchers.Main) { onProgress(100) }
            Result.success(finalFile.absolutePath)
        } catch (e: Exception) {
            Result.failure(Exception("Erro ao importar modelo local: ${e.message}"))
        }
    }

    suspend fun deleteLocalModel(prefs: PrefsManager) = withContext(Dispatchers.IO) {
        releaseLocalLlm()
        prefs.localModelPath?.let { runCatching { File(it).delete() } }
        prefs.localModelPath = null
    }

    suspend fun releaseLocalLlm() {
        llmMutex.withLock {
            runCatching { activeLlm?.close() }
            activeLlm = null
            loadedModelPath = null
        }
    }

    private suspend fun executeLocalLlmPrompt(
        context: Context,
        modelPath: String,
        prompt: String
    ): Result<String> = withContext(Dispatchers.IO) {
        llmMutex.withLock {
            try {
                if (activeLlm == null || loadedModelPath != modelPath) {
                    runCatching { activeLlm?.close() }
                    val options = LlmInference.LlmInferenceOptions.builder()
                        .setModelPath(modelPath)
                        .setMaxTokens(512)
                        .build()
                    activeLlm = LlmInference.createFromOptions(context.applicationContext, options)
                    loadedModelPath = modelPath
                }
                val raw = activeLlm?.generateResponse(prompt)?.trim() ?: ""
                if (raw.isBlank()) {
                    Result.failure(Exception("A IA local não gerou resposta."))
                } else {
                    Result.success(raw)
                }
            } catch (e: Exception) {
                runCatching { activeLlm?.close() }
                activeLlm = null
                loadedModelPath = null
                Result.failure(Exception("Erro na IA local offline: ${e.message ?: "verifique o arquivo .task/.bin."}"))
            }
        }
    }

    fun languageDisplayName(code: String): String {
        return when (code.lowercase()) {
            "en" -> "Inglês"
            "es" -> "Espanhol"
            "fr" -> "Francês"
            "de" -> "Alemão"
            "it" -> "Italiano"
            "ja" -> "Japonês"
            "zh" -> "Chinês"
            "ru" -> "Russo"
            "id" -> "Indonésio"
            "tr" -> "Turco"
            "vi" -> "Vietnamita"
            "ar" -> "Árabe"
            "ko" -> "Coreano"
            "pt" -> "Português"
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
        } catch (_: Exception) {
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
        } catch (_: Exception) {
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
                    LensTranslationResult(mlKitCode, "Português", text)
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

            Result.success(LensTranslationResult(mlKitCode, langName, translated))
        } catch (_: Exception) {
            Result.failure(Exception("Conecte à internet uma vez ou baixe o idioma em IA & Lupa."))
        }
    }

    suspend fun runCustomCommand(
        context: Context,
        prefs: PrefsManager,
        fieldText: String,
        command: String
    ): Result<String> {
        val cleanCmd = command.trim()
        if (cleanCmd.isBlank() && fieldText.isBlank()) {
            return Result.failure(Exception("Digite um texto ou comando para a IA."))
        }
        val prompt = if (fieldText.isNotBlank() && cleanCmd.isNotBlank()) {
            "Aplique a instrução ao texto abaixo e responda APENAS com o texto final, sem comentários:\nInstrução: $cleanCmd\nTexto: $fieldText"
        } else if (cleanCmd.isNotBlank()) {
            "Responda de forma direta e pronta para envio em mensagem. Retorne APENAS o texto final:\n$cleanCmd"
        } else {
            "Melhore a clareza, ortografia e fluidez do texto abaixo mantendo o mesmo idioma. Retorne APENAS o texto melhorado:\n$fieldText"
        }
        return runHybridPrompt(context, prefs, prompt)
    }

    suspend fun runReplyAction(
        context: Context,
        prefs: PrefsManager,
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
            append("Crie uma única resposta pronta para enviar no chat. Retorne APENAS o texto da resposta, sem aspas nem explicações.\n")
            append("Tom: $tone.\n")
            if (hasIntent) append("Intenção: $intentOrShortcut.\n")
            if (hasContext) append("Mensagem recebida:\n$contextText\n")
        }
        return runHybridPrompt(context, prefs, prompt)
    }

    suspend fun runCorrectAction(
        context: Context,
        prefs: PrefsManager,
        inputText: String
    ): Result<String> {
        if (inputText.isBlank()) {
            return Result.failure(Exception("Digite algum texto para corrigir."))
        }
        val prompt = "Corrija ortografia, acentuação, gramática e pontuação do texto abaixo mantendo exatamente o mesmo idioma e sentido. Retorne APENAS o texto corrigido:\n$inputText"
        return runHybridPrompt(context, prefs, prompt)
    }

    suspend fun runRewriteAction(
        context: Context,
        prefs: PrefsManager,
        inputText: String,
        variation: String
    ): Result<String> {
        if (inputText.isBlank()) {
            return Result.failure(Exception("Digite algum texto no campo antes de reescrever."))
        }
        val prompt = "Reescreva o texto abaixo no estilo \"$variation\", mantendo o mesmo idioma e significado. Retorne APENAS o texto reescrito:\n$inputText"
        return runHybridPrompt(context, prefs, prompt)
    }

    private suspend fun runHybridPrompt(
        context: Context,
        prefs: PrefsManager,
        prompt: String
    ): Result<String> {
        val localPath = prefs.localModelPath
        val hasLocal = !localPath.isNullOrBlank() && File(localPath).exists() && File(localPath).length() > 1_000_000L

        if (prefs.preferLocalAi && hasLocal) {
            val localRes = executeLocalLlmPrompt(context, localPath!!, prompt)
            if (localRes.isSuccess) return localRes
            if (prefs.apiKey.isBlank()) return localRes
        }

        if (prefs.apiKey.isNotBlank()) {
            return executeGeminiCloudPrompt(prefs.apiKey, prompt)
        }

        if (hasLocal) {
            return executeLocalLlmPrompt(context, localPath!!, prompt)
        }

        return Result.failure(
            Exception("Baixe o cérebro da IA Local Offline na aba IA & Lupa (ou configure uma Chave Gemini opcional).")
        )
    }

    private suspend fun executeGeminiCloudPrompt(apiKey: String, prompt: String): Result<String> = withContext(Dispatchers.IO) {
        var lastError = "Falha ao conectar com a IA na nuvem."
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
                    return@withContext Result.failure(Exception("Chave API inválida ($code)."))
                }
                if (code == 429) {
                    return@withContext Result.failure(Exception("Limite da chave API atingido (429)."))
                }
                lastError = "Erro API ($code)."
            } catch (_: Exception) {
                lastError = "Sem internet para IA na nuvem. Use a IA Local Offline na aba IA & Lupa."
            } finally {
                conn?.disconnect()
            }
        }
        Result.failure(Exception(lastError))
    }
}
EOF

# 14. SystemStatusHelper.kt (Teclado, Sobreposição, Acessibilidade e Microfone)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/data/SystemStatusHelper.kt
package com.prismkey.keyboard.data

import android.Manifest
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.provider.Settings
import android.view.accessibility.AccessibilityManager
import android.view.inputmethod.InputMethodManager
import androidx.core.content.ContextCompat
import com.prismkey.keyboard.service.PrismaLensAccessibilityService
import com.prismkey.keyboard.service.PrismKeyboardService

data class PrismSystemStatus(
    val isKeyboardEnabled: Boolean,
    val isKeyboardDefault: Boolean,
    val canDrawOverlays: Boolean,
    val isAccessibilityEnabled: Boolean,
    val hasMicrophonePermission: Boolean
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

        val hasMic = ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED

        return PrismSystemStatus(
            isKeyboardEnabled = isEnabled,
            isKeyboardDefault = isDefault,
            canDrawOverlays = canOverlay,
            isAccessibilityEnabled = isAccEnabled,
            hasMicrophonePermission = hasMic
        )
    }
}
EOF
echo "💎 Configurando PrismKey v1.4.0 (Parte 2/2: Teclado Completo, Emoji Kitchen, Gestos, Voz, Lupa, App & Auditoria)..."

# 15. PrismKeyboardView.kt (Emoji Kitchen + Slide-to-Select + Glide Typing + Microfone + Trackpad + Backspace Inteligente + Menu Mais Completo)
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
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.awaitEachGesture
import androidx.compose.foundation.gestures.awaitFirstDown
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
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
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.input.pointer.positionChange
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.layout.boundsInRoot
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.layout.positionInRoot
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
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
import com.prismkey.keyboard.data.EmojiKitchenEngine
import com.prismkey.keyboard.data.PrefsManager
import com.prismkey.keyboard.data.PrismThemeMode
import com.prismkey.keyboard.data.ToolbarToolId
import com.prismkey.keyboard.data.WordPredictor
import com.prismkey.keyboard.service.PrismaLensAccessibilityService
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.io.File
import kotlin.math.roundToInt

private enum class ActiveAiPanel {
    NONE,
    COMMAND,
    REPLY,
    CORRECT,
    REWRITE,
    TRANSLATE
}

private enum class ActiveMoreSubPanel {
    NONE,
    MENU,
    CUSTOMIZE_BAR,
    RESIZE,
    EXTRAS_SNIPPETS
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
    isVoiceListening: Boolean,
    voicePartialText: String,
    voiceReviewText: String,
    voiceStatusMessage: String?,
    onToggleVoiceDictation: () -> Unit,
    onAcceptVoiceReview: (String) -> Unit,
    onDismissVoiceReview: () -> Unit,
    onCommitText: (String) -> Unit,
    onCommitSticker: (File, String) -> Boolean,
    onDeleteChar: () -> Unit,
    onDeletePreviousWord: () -> String,
    onMoveCursor: (Int) -> Unit,
    onEnterPressed: () -> Unit,
    onGetCurrentFieldText: () -> String,
    onGetCurrentWordBeforeCursor: () -> String,
    onReplaceWordBeforeCursor: (String, Int) -> Unit,
    onReplaceCurrentFieldText: (String) -> Unit,
    onShouldAutoCapitalize: () -> Boolean,
    onOpenAppSettings: () -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    val density = LocalDensity.current
    val systemDark = isSystemInDarkTheme()

    var isUpper by remember { mutableStateOf(prefs.autoCapitalizeEnabled && onShouldAutoCapitalize()) }
    var isCapsLock by remember { mutableStateOf(false) }
    var isSymbolMode by remember { mutableStateOf(false) }
    var showEmojiPanel by remember { mutableStateOf(false) }
    var emojiPanelKitchenMode by remember { mutableStateOf(false) }
    var selectedEmojiCatIndex by remember { mutableIntStateOf(0) }
    var showClipboardPanel by remember { mutableStateOf(false) }
    var moreSubPanel by remember { mutableStateOf(ActiveMoreSubPanel.NONE) }

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
    var lastAutoCorrectedPair by remember { mutableStateOf<Pair<String, String>?>(null) }

    // Estado Emoji Kitchen
    var kitchenEmoji1 by remember { mutableStateOf("😀") }
    var kitchenEmoji2 by remember { mutableStateOf("🔥") }
    var kitchenSelectingSlot by remember { mutableIntStateOf(1) }
    var kitchenStickerFile by remember { mutableStateOf<File?>(null) }
    var kitchenLoading by remember { mutableStateOf(false) }
    var kitchenStatus by remember { mutableStateOf<String?>(null) }

    val combinedThemeKey = themeSyncVersion + localThemeTick

    LaunchedEffect(themeSyncVersion) {
        selectedTargetLang = prefs.targetLangCode
        if (prefs.autoCapitalizeEnabled && !isCapsLock) {
            isUpper = onShouldAutoCapitalize()
        }
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

    LaunchedEffect(showEmojiPanel, emojiPanelKitchenMode, kitchenEmoji1, kitchenEmoji2) {
        if (showEmojiPanel && emojiPanelKitchenMode) {
            kitchenLoading = true
            kitchenStatus = null
            val res = EmojiKitchenEngine.getOrCreateKitchenSticker(context, kitchenEmoji1, kitchenEmoji2)
            kitchenStickerFile = res.stickerFile
            kitchenLoading = false
            kitchenStatus = if (res.isOfficialKitchen) "Emoji Kitchen Oficial" else "Fusão Local Offline"
        }
    }

    val personalSnippets = remember(combinedThemeKey) { prefs.personalSnippets }
    val enabledTools = remember(combinedThemeKey) { prefs.enabledToolbarTools }
    val showKeyBorders = remember(combinedThemeKey) { prefs.showKeyBorders }
    val heightScale = remember(combinedThemeKey) { prefs.keyboardHeightScale }
    val textScale = remember(combinedThemeKey) { prefs.keyTextScale }
    val showNumberRow = remember(combinedThemeKey) { prefs.showNumberRow }
    val gestureTypingEnabled = remember(combinedThemeKey) { prefs.gestureTypingEnabled }
    val spaceNeighborKey = remember(combinedThemeKey) { prefs.spaceNeighborKey }

    val keyHeight = (46f * heightScale).dp
    val numberRowHeight = (36f * heightScale).dp
    val keyFontSp = (18.5f * textScale).sp

    val suggestions = remember(currentTypingWord, personalSnippets) {
        WordPredictor.suggest(currentTypingWord, personalSnippets)
    }
    val showSuggestionBar =
        activeAiPanel == ActiveAiPanel.NONE &&
            moreSubPanel == ActiveMoreSubPanel.NONE &&
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
        !showKeyBorders -> Color.Transparent
        currentTheme == PrismThemeMode.CUSTOM_IMAGE -> Color(0xFF121621).copy(alpha = 0.58f)
        isLightPalette -> Color.White.copy(alpha = 0.92f)
        else -> Color(0xFF1F2636).copy(alpha = 0.88f)
    }

    val actionKeyBg = when {
        !showKeyBorders -> Color.White.copy(alpha = if (isLightPalette) 0.25f else 0.10f)
        currentTheme == PrismThemeMode.CUSTOM_IMAGE -> Color(0xFF1A2133).copy(alpha = 0.70f)
        isLightPalette -> Color(0xFFDCE2EE)
        else -> Color(0xFF283146).copy(alpha = 0.90f)
    }

    val panelBg = if (isLightPalette) Color(0xFFF7F8FC) else Color(0xFF151B28)
    val panelTextColor = if (isLightPalette) Color(0xFF161B26) else Color.White
    val keyContentColor = if (isLightPalette && currentTheme != PrismThemeMode.CUSTOM_IMAGE) Color(0xFF12161F) else Color.White

    val borderBrush = Brush.verticalGradient(
        if (!showKeyBorders) {
            listOf(Color.Transparent, Color.Transparent)
        } else if (isLightPalette) {
            listOf(Color.Black.copy(alpha = 0.09f), Color.Black.copy(alpha = 0.04f))
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

    val numberRowKeys = listOf("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
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
            moreSubPanel = ActiveMoreSubPanel.NONE
            panelMessage = null
            panelIsError = false
            typingIntoAiInput = (panel == ActiveAiPanel.COMMAND || panel == ActiveAiPanel.REPLY)
        }
    }

    fun executeCommandAi(overrideCmd: String? = null) {
        val cmd = (overrideCmd ?: aiPromptInput).trim()
        val fieldText = onGetCurrentFieldText()
        aiLoading = true
        panelMessage = if (HybridAiEngine.isLocalModelInstalled(prefs)) "IA Local processando offline..." else "Gerando com IA..."
        panelIsError = false
        scope.launch {
            val res = HybridAiEngine.runCustomCommand(context, prefs, fieldText, cmd)
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
                context = context,
                prefs = prefs,
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
            val res = HybridAiEngine.runCorrectAction(context, prefs, fieldText)
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
            val res = HybridAiEngine.runRewriteAction(context, prefs, fieldText, style)
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
        lastAutoCorrectedPair = null
        if (typingIntoAiInput && (activeAiPanel == ActiveAiPanel.COMMAND || activeAiPanel == ActiveAiPanel.REPLY)) {
            aiPromptInput += typed
            if (isUpper && !isCapsLock) isUpper = false
            return
        }
        onCommitText(typed)
        if (isUpper && !isCapsLock) isUpper = false

        val fromField = onGetCurrentWordBeforeCursor()
        currentTypingWord = if (fromField.isNotEmpty()) {
            fromField
        } else if (typed.length == 1 && (typed[0].isLetter() || typed[0] == '/' || typed[0] == '@')) {
            currentTypingWord + typed
        } else {
            ""
        }
        forceShowTools = false
    }

    fun handleGlideWord(rawPath: String) {
        val predicted = WordPredictor.predictFromGlidePath(rawPath, capitalize = isUpper || isCapsLock)
        if (predicted != null) {
            feedback.trigger(KeySoundType.SPACE_ENTER)
            if (typingIntoAiInput && (activeAiPanel == ActiveAiPanel.COMMAND || activeAiPanel == ActiveAiPanel.REPLY)) {
                aiPromptInput += "$predicted "
            } else {
                onCommitText("$predicted ")
                WordPredictor.learnWord(predicted)
                currentTypingWord = ""
            }
            if (isUpper && !isCapsLock) isUpper = false
        }
    }

    fun handleSpacePress() {
        feedback.trigger(KeySoundType.SPACE_ENTER)
        if (typingIntoAiInput && (activeAiPanel == ActiveAiPanel.COMMAND || activeAiPanel == ActiveAiPanel.REPLY)) {
            aiPromptInput += " "
            return
        }

        val currentWord = onGetCurrentWordBeforeCursor().ifEmpty { currentTypingWord }
        val snippetHit = WordPredictor.findSnippet(currentWord, personalSnippets)
        if (snippetHit != null) {
            onReplaceWordBeforeCursor("$snippetHit ", currentWord.length)
            currentTypingWord = ""
            lastAutoCorrectedPair = null
            return
        }

        if (prefs.autoCorrectionEnabled && currentWord.length >= 2) {
            val fixed = WordPredictor.autoCorrectWord(currentWord)
            if (fixed != null && fixed != currentWord) {
                onReplaceWordBeforeCursor("$fixed ", currentWord.length)
                WordPredictor.learnWord(fixed)
                lastAutoCorrectedPair = currentWord to fixed
                currentTypingWord = ""
                return
            }
        }

        if (currentWord.length >= 3) {
            WordPredictor.learnWord(currentWord)
        }
        lastAutoCorrectedPair = null
        onCommitText(" ")
        currentTypingWord = ""
        if (prefs.autoCapitalizeEnabled && !isCapsLock) {
            isUpper = onShouldAutoCapitalize()
        }
    }

    fun handleBackspacePress() {
        feedback.trigger(KeySoundType.DELETE)
        if (typingIntoAiInput && (activeAiPanel == ActiveAiPanel.COMMAND || activeAiPanel == ActiveAiPanel.REPLY)) {
            if (aiPromptInput.isNotEmpty()) {
                aiPromptInput = aiPromptInput.dropLast(1)
            }
            return
        }

        // Desfaz correção automática se apagar logo após o espaço
        val undoPair = lastAutoCorrectedPair
        if (undoPair != null) {
            val (orig, fixed) = undoPair
            onReplaceWordBeforeCursor(orig, fixed.length + 1)
            lastAutoCorrectedPair = null
            currentTypingWord = orig
            return
        }

        onDeleteChar()
        currentTypingWord = onGetCurrentWordBeforeCursor()
        forceShowTools = false
        if (prefs.autoCapitalizeEnabled && !isCapsLock && currentTypingWord.isEmpty()) {
            isUpper = onShouldAutoCapitalize()
        }
    }

    fun handleEnterPress() {
        feedback.trigger(KeySoundType.SPACE_ENTER)
        lastAutoCorrectedPair = null
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
        if (prefs.autoCapitalizeEnabled && !isCapsLock) {
            isUpper = true
        }
    }

    // Estado unificado de Gestos das Teclas Alfabéticas (Tap + Slide-to-Select + Swipe/Glide Typing)
    val keyBoundsMap = remember { mutableStateMapOf<String, Rect>() }
    var gridOriginInRoot by remember { mutableStateOf(Offset.Zero) }
    var gridWidthPx by remember { mutableFloatStateOf(1f) }
    var pressedLetterKey by remember { mutableStateOf<String?>(null) }
    var slidePopupOpen by remember { mutableStateOf(false) }
    var slidePopupVariants by remember { mutableStateOf<List<String>>(emptyList()) }
    var slidePopupSelectedIndex by remember { mutableIntStateOf(0) }
    var slidePopupAnchorCenterX by remember { mutableFloatStateOf(0f) }
    var slidePopupAnchorTopY by remember { mutableFloatStateOf(0f) }
    var slidePopupReversed by remember { mutableStateOf(false) }
    var glideTrail by remember { mutableStateOf<List<Offset>>(emptyList()) }

    LaunchedEffect(isSymbolMode, showNumberRow, heightScale) {
        keyBoundsMap.clear()
    }

    val latestIsUpper by rememberUpdatedState(isUpper)
    val latestIsSymbolMode by rememberUpdatedState(isSymbolMode)
    val latestGestureEnabled by rememberUpdatedState(gestureTypingEnabled)
    val latestOnKeyPress by rememberUpdatedState(::handleKeyPress)
    val latestOnGlideCommit by rememberUpdatedState(::handleGlideWord)

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
            verticalArrangement = Arrangement.spacedBy(5.dp)
        ) {
            // Faixa de Ditado por Voz (Ouvindo ou Revisão antes de inserir)
            if (isVoiceListening || voiceReviewText.isNotBlank() || !voiceStatusMessage.isNullOrBlank()) {
                Surface(
                    shape = RoundedCornerShape(12.dp),
                    color = panelBg,
                    border = BorderStroke(1.dp, if (isVoiceListening) Color(0xFFEF4444) else accentColor),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Column(
                        modifier = Modifier.padding(horizontal = 10.dp, vertical = 8.dp),
                        verticalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        if (isVoiceListening) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                    Icon(Icons.Default.Mic, contentDescription = null, tint = Color(0xFFEF4444), modifier = Modifier.size(18.dp))
                                    Text(
                                        text = if (voicePartialText.isBlank()) "Ouvindo... fale agora" else voicePartialText,
                                        color = panelTextColor,
                                        fontSize = 13.sp,
                                        maxLines = 2,
                                        overflow = TextOverflow.Ellipsis
                                    )
                                }
                                Text(
                                    text = "Parar",
                                    color = Color(0xFFEF4444),
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Bold,
                                    modifier = Modifier.clickable { onToggleVoiceDictation() }
                                )
                            }
                        } else if (voiceReviewText.isNotBlank()) {
                            Text("Revisar ditado:", color = accentColor, fontSize = 11.sp, fontWeight = FontWeight.Bold)
                            Text(voiceReviewText, color = panelTextColor, fontSize = 13.sp, maxLines = 3, overflow = TextOverflow.Ellipsis)
                            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                OutlinedButton(
                                    onClick = { onDismissVoiceReview() },
                                    contentPadding = PaddingValues(horizontal = 10.dp, vertical = 2.dp),
                                    modifier = Modifier.height(32.dp)
                                ) {
                                    Text("Descartar", color = panelTextColor, fontSize = 11.sp)
                                }
                                Button(
                                    onClick = { onAcceptVoiceReview(voiceReviewText) },
                                    colors = ButtonDefaults.buttonColors(containerColor = accentColor),
                                    contentPadding = PaddingValues(horizontal = 12.dp, vertical = 2.dp),
                                    modifier = Modifier.height(32.dp)
                                ) {
                                    Text("Inserir", color = Color.White, fontSize = 11.sp, fontWeight = FontWeight.Bold)
                                }
                            }
                        } else if (!voiceStatusMessage.isNullOrBlank()) {
                            Text(voiceStatusMessage, color = Color(0xFFF87171), fontSize = 12.sp)
                        }
                    }
                }
            }

            // Sub-Painéis do Menu "Mais (...)" estilo Keyvya (Engrenagem / Personalizar Barra / Tamanho 100%-140% / Extras)
            when (moreSubPanel) {
                ActiveMoreSubPanel.MENU -> {
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
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                    MoreIconButton(
                                        icon = Icons.Default.Settings,
                                        contentDesc = "Configurações",
                                        accent = accentColor,
                                        textColor = panelTextColor,
                                        onClick = {
                                            moreSubPanel = ActiveMoreSubPanel.NONE
                                            onOpenAppSettings()
                                        }
                                    )
                                    MoreIconButton(
                                        icon = Icons.Default.Edit,
                                        contentDesc = "Personalizar Barra",
                                        accent = accentColor,
                                        textColor = panelTextColor,
                                        onClick = { moreSubPanel = ActiveMoreSubPanel.CUSTOMIZE_BAR }
                                    )
                                    MoreIconButton(
                                        icon = Icons.Default.Height,
                                        contentDesc = "Tamanho do Teclado",
                                        accent = accentColor,
                                        textColor = panelTextColor,
                                        onClick = { moreSubPanel = ActiveMoreSubPanel.RESIZE }
                                    )
                                    MoreIconButton(
                                        icon = Icons.Default.Extension,
                                        contentDesc = "Snippets & Kitchen",
                                        accent = accentColor,
                                        textColor = panelTextColor,
                                        onClick = { moreSubPanel = ActiveMoreSubPanel.EXTRAS_SNIPPETS }
                                    )
                                }
                                IconButton(
                                    onClick = { moreSubPanel = ActiveMoreSubPanel.NONE },
                                    modifier = Modifier.size(32.dp)
                                ) {
                                    Icon(Icons.Default.Close, contentDescription = "Fechar", tint = panelTextColor)
                                }
                            }

                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(6.dp)
                            ) {
                                OutlinedButton(
                                    onClick = {
                                        prefs.soundEnabled = !prefs.soundEnabled
                                        localThemeTick++
                                    },
                                    modifier = Modifier.weight(1f).height(34.dp),
                                    contentPadding = PaddingValues(4.dp)
                                ) {
                                    Text(if (prefs.soundEnabled) "Som: ON" else "Som: OFF", fontSize = 11.sp, color = panelTextColor)
                                }
                                OutlinedButton(
                                    onClick = {
                                        prefs.vibrationEnabled = !prefs.vibrationEnabled
                                        localThemeTick++
                                    },
                                    modifier = Modifier.weight(1f).height(34.dp),
                                    contentPadding = PaddingValues(4.dp)
                                ) {
                                    Text(if (prefs.vibrationEnabled) "Vibrar: ON" else "Vibrar: OFF", fontSize = 11.sp, color = panelTextColor)
                                }
                                OutlinedButton(
                                    onClick = {
                                        prefs.showKeyBorders = !prefs.showKeyBorders
                                        localThemeTick++
                                    },
                                    modifier = Modifier.weight(1f).height(34.dp),
                                    contentPadding = PaddingValues(4.dp)
                                ) {
                                    Text(if (prefs.showKeyBorders) "Bordas: ON" else "Bordas: OFF", fontSize = 11.sp, color = panelTextColor)
                                }
                            }
                        }
                    }
                }

                ActiveMoreSubPanel.CUSTOMIZE_BAR -> {
                    Surface(
                        shape = RoundedCornerShape(16.dp),
                        color = panelBg,
                        border = BorderStroke(1.dp, accentColor.copy(alpha = 0.45f)),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column(
                            modifier = Modifier.padding(10.dp),
                            verticalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(
                                    "Sua barra: toque em Remover ou Adicionar",
                                    color = panelTextColor,
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Medium
                                )
                                Surface(
                                    shape = RoundedCornerShape(12.dp),
                                    color = accentColor.copy(alpha = 0.22f),
                                    border = BorderStroke(1.dp, accentColor),
                                    modifier = Modifier.clickable { moreSubPanel = ActiveMoreSubPanel.NONE }
                                ) {
                                    Text(
                                        "Pronto",
                                        color = panelTextColor,
                                        fontSize = 12.sp,
                                        fontWeight = FontWeight.Bold,
                                        modifier = Modifier.padding(horizontal = 12.dp, vertical = 5.dp)
                                    )
                                }
                            }

                            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                items(ToolbarToolId.entries) { tool ->
                                    val isAdded = enabledTools.contains(tool)
                                    Column(
                                        horizontalAlignment = Alignment.CenterHorizontally,
                                        verticalArrangement = Arrangement.spacedBy(4.dp),
                                        modifier = Modifier.width(68.dp)
                                    ) {
                                        Box(
                                            modifier = Modifier
                                                .fillMaxWidth()
                                                .height(48.dp)
                                                .clip(RoundedCornerShape(12.dp))
                                                .background(
                                                    if (tool.fixed) accentColor
                                                    else panelTextColor.copy(alpha = if (isAdded) 0.12f else 0.05f)
                                                )
                                                .border(
                                                    1.dp,
                                                    if (isAdded) accentColor.copy(alpha = 0.6f) else panelTextColor.copy(alpha = 0.18f),
                                                    RoundedCornerShape(12.dp)
                                                ),
                                            contentAlignment = Alignment.Center
                                        ) {
                                            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                                Icon(
                                                    imageVector = iconForTool(tool),
                                                    contentDescription = tool.label,
                                                    tint = if (tool.fixed) Color.White else panelTextColor,
                                                    modifier = Modifier.size(16.dp)
                                                )
                                                Text(
                                                    text = tool.label,
                                                    color = if (tool.fixed) Color.White else panelTextColor,
                                                    fontSize = 9.5.sp,
                                                    maxLines = 1
                                                )
                                            }
                                        }

                                        if (tool.fixed) {
                                            Text("Fixo", color = panelTextColor.copy(alpha = 0.6f), fontSize = 10.sp)
                                        } else {
                                            Surface(
                                                shape = RoundedCornerShape(8.dp),
                                                color = if (isAdded) Color(0xFFDC2626) else Color(0xFF16A34A),
                                                modifier = Modifier
                                                    .fillMaxWidth()
                                                    .clickable {
                                                        val updated = enabledTools.toMutableList()
                                                        if (isAdded) updated.remove(tool) else updated.add(tool)
                                                        prefs.enabledToolbarTools = updated
                                                        localThemeTick++
                                                    }
                                            ) {
                                                Text(
                                                    text = if (isAdded) "Remover" else "Adicionar",
                                                    color = Color.White,
                                                    fontSize = 10.sp,
                                                    fontWeight = FontWeight.Bold,
                                                    textAlign = TextAlign.Center,
                                                    modifier = Modifier.padding(vertical = 4.dp)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                ActiveMoreSubPanel.RESIZE -> {
                    Surface(
                        shape = RoundedCornerShape(16.dp),
                        color = panelBg,
                        border = BorderStroke(1.dp, accentColor.copy(alpha = 0.45f)),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column(
                            modifier = Modifier.padding(10.dp),
                            verticalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Surface(
                                    shape = RoundedCornerShape(12.dp),
                                    color = panelTextColor.copy(alpha = 0.1f),
                                    border = BorderStroke(1.dp, panelTextColor.copy(alpha = 0.25f)),
                                    modifier = Modifier.clickable {
                                        prefs.keyboardHeightScale = 1.0f
                                        localThemeTick++
                                    }
                                ) {
                                    Text(
                                        "Padrão",
                                        color = panelTextColor,
                                        fontSize = 12.sp,
                                        fontWeight = FontWeight.SemiBold,
                                        modifier = Modifier.padding(horizontal = 12.dp, vertical = 5.dp)
                                    )
                                }

                                Text(
                                    "Tamanho do teclado (${(heightScale * 100).roundToInt()}%)",
                                    color = panelTextColor,
                                    fontSize = 12.5.sp,
                                    fontWeight = FontWeight.Bold
                                )

                                Surface(
                                    shape = RoundedCornerShape(12.dp),
                                    color = accentColor.copy(alpha = 0.22f),
                                    border = BorderStroke(1.dp, accentColor),
                                    modifier = Modifier.clickable { moreSubPanel = ActiveMoreSubPanel.NONE }
                                ) {
                                    Text(
                                        "Pronto",
                                        color = panelTextColor,
                                        fontSize = 12.sp,
                                        fontWeight = FontWeight.Bold,
                                        modifier = Modifier.padding(horizontal = 12.dp, vertical = 5.dp)
                                    )
                                }
                            }

                            // Régua graduada de 100% a 140% estilo Keyvya
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(54.dp)
                                    .clip(RoundedCornerShape(12.dp))
                                    .background(accentColor.copy(alpha = 0.12f))
                                    .border(1.dp, accentColor.copy(alpha = 0.4f), RoundedCornerShape(12.dp))
                                    .pointerInput(Unit) {
                                        detectHorizontalDragGestures { change, _ ->
                                            change.consume()
                                            val frac = (change.position.x / size.width.toFloat()).coerceIn(0f, 1f)
                                            prefs.keyboardHeightScale = 1.0f + frac * 0.4f
                                            localThemeTick++
                                        }
                                    }
                                    .pointerInput(Unit) {
                                        detectTapGestures { offset ->
                                            val frac = (offset.x / size.width.toFloat()).coerceIn(0f, 1f)
                                            prefs.keyboardHeightScale = 1.0f + frac * 0.4f
                                            localThemeTick++
                                        }
                                    }
                            ) {
                                Canvas(modifier = Modifier.fillMaxSize().padding(horizontal = 14.dp, vertical = 8.dp)) {
                                    val ticks = 20
                                    for (i in 0..ticks) {
                                        val x = (size.width / ticks) * i
                                        val isMajor = i % 5 == 0
                                        val tickH = if (isMajor) size.height * 0.65f else size.height * 0.35f
                                        drawLine(
                                            color = panelTextColor.copy(alpha = if (isMajor) 0.55f else 0.28f),
                                            start = Offset(x, size.height),
                                            end = Offset(x, size.height - tickH),
                                            strokeWidth = if (isMajor) 3f else 2f
                                        )
                                    }
                                    val norm = ((heightScale - 1.0f) / 0.4f).coerceIn(0f, 1f)
                                    val indicatorX = size.width * norm
                                    drawLine(
                                        color = accentColor,
                                        start = Offset(indicatorX, 0f),
                                        end = Offset(indicatorX, size.height),
                                        strokeWidth = 6f,
                                        cap = StrokeCap.Round
                                    )
                                }
                                Surface(
                                    shape = RoundedCornerShape(8.dp),
                                    color = panelBg.copy(alpha = 0.92f),
                                    border = BorderStroke(1.dp, accentColor),
                                    modifier = Modifier.align(Alignment.TopCenter).padding(top = 4.dp)
                                ) {
                                    Text(
                                        text = "${(heightScale * 100).roundToInt()}%",
                                        color = panelTextColor,
                                        fontSize = 11.sp,
                                        fontWeight = FontWeight.Bold,
                                        modifier = Modifier.padding(horizontal = 8.dp, vertical = 1.dp)
                                    )
                                }
                            }
                        }
                    }
                }

                ActiveMoreSubPanel.EXTRAS_SNIPPETS -> {
                    Surface(
                        shape = RoundedCornerShape(16.dp),
                        color = panelBg,
                        border = BorderStroke(1.dp, accentColor.copy(alpha = 0.45f)),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column(
                            modifier = Modifier.padding(10.dp),
                            verticalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text("⚡ Atalhos Rápidos (Snippets)", color = panelTextColor, fontSize = 12.5.sp, fontWeight = FontWeight.Bold)
                                Text(
                                    "Fechar",
                                    color = accentColor,
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Bold,
                                    modifier = Modifier.clickable { moreSubPanel = ActiveMoreSubPanel.NONE }
                                )
                            }
                            if (personalSnippets.isEmpty()) {
                                Text("Cadastre atalhos como /pix na aba Temas do app.", color = panelTextColor.copy(alpha = 0.7f), fontSize = 11.sp)
                            } else {
                                LazyRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                    items(personalSnippets.entries.toList()) { (trigger, expansion) ->
                                        AiChip(
                                            label = "$trigger → ${expansion.take(18)}",
                                            selected = false,
                                            textColor = panelTextColor,
                                            accentColor = accentColor,
                                            onClick = {
                                                feedback.trigger(KeySoundType.SPACE_ENTER)
                                                onCommitText("$expansion ")
                                                moreSubPanel = ActiveMoreSubPanel.NONE
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    }
                }

                ActiveMoreSubPanel.NONE -> {}
            }

            // Barra Superior (Sugestões Dinâmicas OU Ferramentas Personalizáveis)
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
                            .background(if (showKeyBorders) keyBg else panelBg.copy(alpha = 0.85f))
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
                                    fontSize = 14.5.sp,
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
                                .clickable {
                                    moreSubPanel = if (moreSubPanel == ActiveMoreSubPanel.NONE) ActiveMoreSubPanel.MENU else ActiveMoreSubPanel.NONE
                                }
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
                        items(enabledTools) { tool ->
                            val isSelected = when (tool) {
                                ToolbarToolId.IA -> activeAiPanel == ActiveAiPanel.COMMAND
                                ToolbarToolId.RESPONDER -> activeAiPanel == ActiveAiPanel.REPLY
                                ToolbarToolId.CORRIGIR -> activeAiPanel == ActiveAiPanel.CORRECT
                                ToolbarToolId.REESCREVER -> activeAiPanel == ActiveAiPanel.REWRITE
                                ToolbarToolId.TRADUZIR -> activeAiPanel == ActiveAiPanel.TRANSLATE
                                ToolbarToolId.LUPA -> prefs.lensEnabled
                                ToolbarToolId.COPIADOS -> showClipboardPanel
                                ToolbarToolId.KITCHEN -> showEmojiPanel && emojiPanelKitchenMode
                            }
                            TopToolPill(
                                icon = iconForTool(tool),
                                label = tool.label,
                                selected = isSelected,
                                keyBg = if (showKeyBorders) keyBg else panelBg.copy(alpha = 0.72f),
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = {
                                    when (tool) {
                                        ToolbarToolId.IA -> openAiPanel(ActiveAiPanel.COMMAND)
                                        ToolbarToolId.RESPONDER -> openAiPanel(ActiveAiPanel.REPLY)
                                        ToolbarToolId.CORRIGIR -> openAiPanel(ActiveAiPanel.CORRECT)
                                        ToolbarToolId.REESCREVER -> openAiPanel(ActiveAiPanel.REWRITE)
                                        ToolbarToolId.TRADUZIR -> openAiPanel(ActiveAiPanel.TRANSLATE)
                                        ToolbarToolId.LUPA -> {
                                            val next = !prefs.lensEnabled
                                            prefs.lensEnabled = next
                                            if (next) PrismaLensAccessibilityService.instance?.showFloatingLens()
                                            else PrismaLensAccessibilityService.instance?.hideFloatingLens()
                                            localThemeTick++
                                        }
                                        ToolbarToolId.COPIADOS -> {
                                            showClipboardPanel = !showClipboardPanel
                                            showEmojiPanel = false
                                            moreSubPanel = ActiveMoreSubPanel.NONE
                                            closeAiPanel()
                                        }
                                        ToolbarToolId.KITCHEN -> {
                                            val openKitchen = !(showEmojiPanel && emojiPanelKitchenMode)
                                            showEmojiPanel = openKitchen
                                            emojiPanelKitchenMode = openKitchen
                                            showClipboardPanel = false
                                            moreSubPanel = ActiveMoreSubPanel.NONE
                                            closeAiPanel()
                                        }
                                    }
                                }
                            )
                        }

                        item {
                            TopToolPill(
                                icon = Icons.Default.MoreHoriz,
                                label = "Mais",
                                selected = moreSubPanel != ActiveMoreSubPanel.NONE,
                                keyBg = if (showKeyBorders) keyBg else panelBg.copy(alpha = 0.72f),
                                contentColor = keyContentColor,
                                accentColor = accentColor,
                                onClick = {
                                    moreSubPanel = if (moreSubPanel == ActiveMoreSubPanel.NONE) ActiveMoreSubPanel.MENU else ActiveMoreSubPanel.NONE
                                    showClipboardPanel = false
                                    showEmojiPanel = false
                                    closeAiPanel()
                                }
                            )
                        }
                    }
                }
            }

            // Painel Expansível de IA (IA Local Offline / Fallback Nuvem + 13 Idiomas)
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
                            ActiveAiPanel.TRANSLATE -> "IA • Traduzir (13 Idiomas)"
                            ActiveAiPanel.NONE -> ""
                        }

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                Icon(Icons.Default.AutoAwesome, contentDescription = null, tint = accentColor, modifier = Modifier.size(16.dp))
                                Text(panelTitle, color = panelTextColor, fontWeight = FontWeight.Bold, fontSize = 13.5.sp)
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
                                        text = if (aiPromptInput.isEmpty()) "Digite uma instrução ou escolha um atalho..." else "$aiPromptInput|",
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
                                    modifier = Modifier.fillMaxWidth().height(36.dp)
                                ) {
                                    Icon(Icons.Default.AutoAwesome, contentDescription = null, tint = Color.White, modifier = Modifier.size(16.dp))
                                    Spacer(Modifier.width(6.dp))
                                    Text("Gerar Resposta com IA", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 12.5.sp)
                                }
                            }

                            ActiveAiPanel.CORRECT -> {
                                val preview = onGetCurrentFieldText()
                                Text(
                                    text = if (preview.isBlank()) "Nenhum texto digitado ainda."
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
                                    modifier = Modifier.fillMaxWidth().height(36.dp)
                                ) {
                                    Text("Corrigir agora", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 12.5.sp)
                                }
                            }

                            ActiveAiPanel.REWRITE -> {
                                Text("Escolha a variação:", color = panelTextColor.copy(alpha = 0.75f), fontSize = 12.sp)
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
                                Text("Traduzir offline para:", color = panelTextColor.copy(alpha = 0.75f), fontSize = 12.sp)
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

            // Área Principal: Copiados OU Emojis + Emoji Kitchen OU Teclado QWERTY
            if (showClipboardPanel) {
                val fullClip = remember(showClipboardPanel) { readFullClipboardUnlimited() }
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(210.dp)
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
                            text = "📋 Copiados (${fullClip.length} caracteres)",
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
                        Text("Colar Texto Completo")
                    }
                }
            } else if (showEmojiPanel) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(255.dp)
                        .clip(RoundedCornerShape(14.dp))
                        .background(panelBg)
                        .padding(6.dp),
                    verticalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    // Alternador Emojis Completos vs Emoji Kitchen
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                            AiChip(
                                label = "😀 Emojis",
                                selected = !emojiPanelKitchenMode,
                                textColor = panelTextColor,
                                accentColor = accentColor,
                                onClick = { emojiPanelKitchenMode = false }
                            )
                            AiChip(
                                label = "✨ Emoji Kitchen",
                                selected = emojiPanelKitchenMode,
                                textColor = panelTextColor,
                                accentColor = accentColor,
                                onClick = { emojiPanelKitchenMode = true }
                            )
                        }
                        Text(
                            "ABC",
                            color = accentColor,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp,
                            modifier = Modifier
                                .clickable { showEmojiPanel = false }
                                .padding(horizontal = 6.dp)
                        )
                    }

                    if (emojiPanelKitchenMode) {
                        // Barra de Mistura Emoji Kitchen
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(12.dp))
                                .background(panelTextColor.copy(alpha = 0.06f))
                                .padding(horizontal = 10.dp, vertical = 6.dp),
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                Box(
                                    modifier = Modifier
                                        .size(40.dp)
                                        .clip(RoundedCornerShape(10.dp))
                                        .background(if (kitchenSelectingSlot == 1) accentColor.copy(alpha = 0.25f) else Color.Transparent)
                                        .border(1.5.dp, if (kitchenSelectingSlot == 1) accentColor else panelTextColor.copy(alpha = 0.2f), RoundedCornerShape(10.dp))
                                        .clickable { kitchenSelectingSlot = 1 },
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text(kitchenEmoji1, fontSize = 22.sp)
                                }
                                Text("+", color = panelTextColor, fontWeight = FontWeight.Bold)
                                Box(
                                    modifier = Modifier
                                        .size(40.dp)
                                        .clip(RoundedCornerShape(10.dp))
                                        .background(if (kitchenSelectingSlot == 2) accentColor.copy(alpha = 0.25f) else Color.Transparent)
                                        .border(1.5.dp, if (kitchenSelectingSlot == 2) accentColor else panelTextColor.copy(alpha = 0.2f), RoundedCornerShape(10.dp))
                                        .clickable { kitchenSelectingSlot = 2 },
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text(kitchenEmoji2, fontSize = 22.sp)
                                }
                                Text("=", color = panelTextColor, fontWeight = FontWeight.Bold)
                            }

                            val stickerBmp = remember(kitchenStickerFile) {
                                kitchenStickerFile?.takeIf { it.exists() }?.let { BitmapFactory.decodeFile(it.absolutePath)?.asImageBitmap() }
                            }

                            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                Box(
                                    modifier = Modifier
                                        .size(54.dp)
                                        .clip(RoundedCornerShape(12.dp))
                                        .background(panelTextColor.copy(alpha = 0.08f))
                                        .clickable {
                                            val file = kitchenStickerFile
                                            if (file != null && file.exists()) {
                                                feedback.trigger(KeySoundType.SPACE_ENTER)
                                                val sent = onCommitSticker(file, "$kitchenEmoji1$kitchenEmoji2")
                                                kitchenStatus = if (sent) "Figurinha enviada!" else "App não aceita figurinha; emojis inseridos!"
                                            }
                                        },
                                    contentAlignment = Alignment.Center
                                ) {
                                    if (kitchenLoading) {
                                        CircularProgressIndicator(modifier = Modifier.size(22.dp), strokeWidth = 2.dp, color = accentColor)
                                    } else if (stickerBmp != null) {
                                        Image(bitmap = stickerBmp, contentDescription = "Emoji Kitchen", modifier = Modifier.size(48.dp))
                                    }
                                }

                                Button(
                                    onClick = {
                                        val file = kitchenStickerFile
                                        if (file != null && file.exists()) {
                                            feedback.trigger(KeySoundType.SPACE_ENTER)
                                            val sent = onCommitSticker(file, "$kitchenEmoji1$kitchenEmoji2")
                                            kitchenStatus = if (sent) "Enviado!" else "Inserido como texto!"
                                        }
                                    },
                                    enabled = !kitchenLoading && kitchenStickerFile != null,
                                    colors = ButtonDefaults.buttonColors(containerColor = accentColor),
                                    contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp),
                                    modifier = Modifier.height(34.dp)
                                ) {
                                    Text("Enviar", color = Color.White, fontSize = 11.5.sp, fontWeight = FontWeight.Bold)
                                }
                            }
                        }

                        if (kitchenStatus != null) {
                            Text(
                                text = "$kitchenStatus • Toque nos emojis abaixo para misturar",
                                color = panelTextColor.copy(alpha = 0.65f),
                                fontSize = 10.5.sp
                            )
                        }

                        LazyVerticalGrid(
                            columns = GridCells.Fixed(8),
                            modifier = Modifier.weight(1f),
                            contentPadding = PaddingValues(2.dp)
                        ) {
                            items(EmojiKitchenEngine.kitchenMixableEmojis) { em ->
                                AnimatedEmojiCell(emoji = em) {
                                    feedback.trigger(KeySoundType.CHAR)
                                    if (kitchenSelectingSlot == 1) {
                                        kitchenEmoji1 = em
                                        kitchenSelectingSlot = 2
                                    } else {
                                        kitchenEmoji2 = em
                                        kitchenSelectingSlot = 1
                                    }
                                }
                            }
                        }
                    } else {
                        // Categorias completas de Emojis
                        LazyRow(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                            items(EmojiKitchenEngine.fullEmojiCategories.indices.toList()) { idx ->
                                val cat = EmojiKitchenEngine.fullEmojiCategories[idx]
                                AiChip(
                                    label = "${cat.icon} ${cat.title}",
                                    selected = selectedEmojiCatIndex == idx,
                                    textColor = panelTextColor,
                                    accentColor = accentColor,
                                    onClick = { selectedEmojiCatIndex = idx }
                                )
                            }
                        }
                        val activeCat = EmojiKitchenEngine.fullEmojiCategories.getOrElse(selectedEmojiCatIndex) {
                            EmojiKitchenEngine.fullEmojiCategories.first()
                        }
                        LazyVerticalGrid(
                            columns = GridCells.Fixed(8),
                            modifier = Modifier.weight(1f),
                            contentPadding = PaddingValues(2.dp)
                        ) {
                            items(activeCat.emojis) { emoji ->
                                AnimatedEmojiCell(emoji = emoji) {
                                    feedback.trigger(KeySoundType.CHAR)
                                    onCommitText(emoji)
                                }
                            }
                        }
                    }
                }
            } else {
                // Linha Fixa de Números (quando ativada no app)
                if (showNumberRow && !isSymbolMode) {
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                        numberRowKeys.forEach { num ->
                            Box(
                                modifier = Modifier
                                    .weight(1f)
                                    .height(numberRowHeight)
                                    .clip(RoundedCornerShape(9.dp))
                                    .background(keyBg)
                                    .border(1.dp, borderBrush, RoundedCornerShape(9.dp))
                                    .clickable { handleKeyPress(num) },
                                contentAlignment = Alignment.Center
                            ) {
                                Text(
                                    text = num,
                                    color = keyContentColor,
                                    fontSize = (15f * textScale).sp,
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        }
                    }
                }

                val activeRows = if (isSymbolMode) symbolRows else alphaRows

                // Grade Alfabética com Controlador Unificado (Tap + Slide-to-Select Acentos + Digitação por Gestos)
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .onGloballyPositioned { coords ->
                            gridOriginInRoot = coords.positionInRoot()
                            gridWidthPx = coords.size.width.toFloat().coerceAtLeast(1f)
                        }
                        .pointerInput(Unit) {
                            val swipeThresholdPx = with(density) { 26.dp.toPx() }
                            val variantSlotPx = with(density) { 40.dp.toPx() }

                            awaitEachGesture {
                                val down = awaitFirstDown(requireUnconsumed = true)
                                val rootDown = down.position + gridOriginInRoot
                                val startKey = keyBoundsMap.entries.firstOrNull { it.value.contains(rootDown) }?.key
                                    ?: return@awaitEachGesture

                                down.consume()
                                pressedLetterKey = startKey

                                val variants = if (!latestIsSymbolMode) {
                                    (accentVariants[startKey] ?: emptyList()).map {
                                        if (latestIsUpper) it.uppercase() else it
                                    }
                                } else emptyList()

                                var isGliding = false
                                val glideLetters = StringBuilder()

                                val longPressJob = scope.launch {
                                    delay(300)
                                    if (!isGliding && variants.isNotEmpty()) {
                                        val keyRect = keyBoundsMap[startKey]
                                        slidePopupReversed = down.position.x > gridWidthPx * 0.58f
                                        slidePopupVariants = variants
                                        slidePopupSelectedIndex = 0
                                        slidePopupAnchorCenterX = ((keyRect?.center?.x ?: rootDown.x) - gridOriginInRoot.x)
                                        slidePopupAnchorTopY = ((keyRect?.top ?: rootDown.y) - gridOriginInRoot.y)
                                        slidePopupOpen = true
                                        feedback.triggerLightTick()
                                    }
                                }

                                while (true) {
                                    val event = awaitPointerEvent()
                                    val change = event.changes.firstOrNull { it.id == down.id } ?: break
                                    if (!change.pressed) break
                                    change.consume()

                                    if (slidePopupOpen) {
                                        val dx = change.position.x - down.position.x
                                        val directedDx = if (slidePopupReversed) -dx else dx
                                        val step = (directedDx / variantSlotPx).roundToInt()
                                        val newIdx = step.coerceIn(0, (slidePopupVariants.size - 1).coerceAtLeast(0))
                                        if (newIdx != slidePopupSelectedIndex) {
                                            slidePopupSelectedIndex = newIdx
                                            feedback.triggerLightTick()
                                        }
                                    } else {
                                        val dist = (change.position - down.position).getDistance()
                                        if (!isGliding && latestGestureEnabled && !latestIsSymbolMode && dist > swipeThresholdPx) {
                                            isGliding = true
                                            longPressJob.cancel()
                                            pressedLetterKey = null
                                            glideLetters.append(startKey)
                                            glideTrail = listOf(down.position, change.position)
                                        }
                                        if (isGliding) {
                                            glideTrail = (glideTrail + change.position).takeLast(48)
                                            val rootPos = change.position + gridOriginInRoot
                                            val hitNow = keyBoundsMap.entries.firstOrNull { it.value.contains(rootPos) }?.key
                                            if (hitNow != null && (glideLetters.isEmpty() || glideLetters.last().toString() != hitNow)) {
                                                glideLetters.append(hitNow)
                                            }
                                        }
                                    }
                                }

                                longPressJob.cancel()

                                if (slidePopupOpen) {
                                    val chosen = slidePopupVariants.getOrNull(slidePopupSelectedIndex) ?: startKey
                                    latestOnKeyPress(chosen)
                                } else if (isGliding) {
                                    latestOnGlideCommit(glideLetters.toString())
                                } else {
                                    val outChar = if (!latestIsSymbolMode && latestIsUpper) startKey.uppercase() else startKey
                                    latestOnKeyPress(outChar)
                                }

                                pressedLetterKey = null
                                slidePopupOpen = false
                                glideTrail = emptyList()
                            }
                        }
                ) {
                    Column(
                        modifier = Modifier.fillMaxWidth(),
                        verticalArrangement = Arrangement.spacedBy(5.dp)
                    ) {
                        // Linha 1 (QWERTYUIOP)
                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                            activeRows[0].forEach { raw ->
                                val label = if (!isSymbolMode && isUpper) raw.uppercase() else raw
                                val sub = if (!isSymbolMode) accentVariants[raw]?.firstOrNull() else null
                                KeyVisualCap(
                                    label = label,
                                    subLabel = sub,
                                    isPressed = pressedLetterKey == raw,
                                    keyBg = keyBg,
                                    accentColor = accentColor,
                                    contentColor = keyContentColor,
                                    borderBrush = borderBrush,
                                    fontSize = keyFontSp,
                                    modifier = Modifier
                                        .weight(1f)
                                        .height(keyHeight)
                                        .onGloballyPositioned { keyBoundsMap[raw] = it.boundsInRoot() }
                                )
                            }
                        }

                        // Linha 2 (ASDFGHJKLÇ)
                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                            activeRows[1].forEach { raw ->
                                val label = if (!isSymbolMode && isUpper) raw.uppercase() else raw
                                val sub = if (!isSymbolMode) accentVariants[raw]?.firstOrNull() else null
                                KeyVisualCap(
                                    label = label,
                                    subLabel = sub,
                                    isPressed = pressedLetterKey == raw,
                                    keyBg = keyBg,
                                    accentColor = accentColor,
                                    contentColor = keyContentColor,
                                    borderBrush = borderBrush,
                                    fontSize = keyFontSp,
                                    modifier = Modifier
                                        .weight(1f)
                                        .height(keyHeight)
                                        .onGloballyPositioned { keyBoundsMap[raw] = it.boundsInRoot() }
                                )
                            }
                        }

                        // Linha 3 (Shift + ZXCVBNM + Backspace Inteligente)
                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                            // Shift (Toque alterna Maiúscula / Duplo toque trava Caps Lock)
                            Box(
                                modifier = Modifier
                                    .weight(1.35f)
                                    .height(keyHeight)
                                    .clip(RoundedCornerShape(10.dp))
                                    .background(if ((isUpper || isCapsLock) && !isSymbolMode) accentColor else actionKeyBg)
                                    .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                                    .pointerInput(isSymbolMode) {
                                        detectTapGestures(
                                            onTap = {
                                                feedback.trigger(KeySoundType.CHAR)
                                                if (!isSymbolMode) {
                                                    if (isCapsLock) {
                                                        isCapsLock = false
                                                        isUpper = false
                                                    } else {
                                                        isUpper = !isUpper
                                                    }
                                                }
                                            },
                                            onDoubleTap = {
                                                feedback.trigger(KeySoundType.SPACE_ENTER)
                                                if (!isSymbolMode) {
                                                    isCapsLock = !isCapsLock
                                                    isUpper = isCapsLock
                                                }
                                            }
                                        )
                                    },
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(
                                    imageVector = Icons.Default.KeyboardCapslock,
                                    contentDescription = "Shift",
                                    tint = if ((isUpper || isCapsLock) && !isSymbolMode) Color.White else keyContentColor,
                                    modifier = Modifier.size(20.dp)
                                )
                            }

                            activeRows[2].forEach { raw ->
                                val label = if (!isSymbolMode && isUpper) raw.uppercase() else raw
                                val sub = if (!isSymbolMode) accentVariants[raw]?.firstOrNull() else null
                                KeyVisualCap(
                                    label = label,
                                    subLabel = sub,
                                    isPressed = pressedLetterKey == raw,
                                    keyBg = keyBg,
                                    accentColor = accentColor,
                                    contentColor = keyContentColor,
                                    borderBrush = borderBrush,
                                    fontSize = keyFontSp,
                                    modifier = Modifier
                                        .weight(1f)
                                        .height(keyHeight)
                                        .onGloballyPositioned { keyBoundsMap[raw] = it.boundsInRoot() }
                                )
                            }

                            // Backspace Inteligente: Toque = 1 letra | Segurar = Rajada Acelerada | Deslizar p/ Esquerda = Apagar Palavras (Direita desfaz)
                            Box(
                                modifier = Modifier
                                    .weight(1.35f)
                                    .height(keyHeight)
                                    .clip(RoundedCornerShape(10.dp))
                                    .background(actionKeyBg)
                                    .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                                    .pointerInput(Unit) {
                                        val wordSwipeStepPx = with(density) { 42.dp.toPx() }
                                        awaitEachGesture {
                                            val down = awaitFirstDown(requireUnconsumed = false)
                                            down.consume()

                                            var didRepeat = false
                                            var swipingWords = false
                                            var accumDx = 0f
                                            val deletedStack = ArrayDeque<String>()

                                            val repeatJob = scope.launch {
                                                delay(340)
                                                var stepDelay = 85L
                                                while (!swipingWords) {
                                                    didRepeat = true
                                                    handleBackspacePress()
                                                    delay(stepDelay)
                                                    if (stepDelay > 36L) stepDelay -= 6L
                                                }
                                            }

                                            while (true) {
                                                val event = awaitPointerEvent()
                                                val change = event.changes.firstOrNull { it.id == down.id } ?: break
                                                if (!change.pressed) break
                                                val dx = change.positionChange().x
                                                change.consume()

                                                accumDx += dx
                                                if (!swipingWords && accumDx <= -wordSwipeStepPx) {
                                                    swipingWords = true
                                                    repeatJob.cancel()
                                                }
                                                if (swipingWords) {
                                                    while (accumDx <= -wordSwipeStepPx) {
                                                        accumDx += wordSwipeStepPx
                                                        val removed = onDeletePreviousWord()
                                                        if (removed.isNotEmpty()) {
                                                            deletedStack.addLast(removed)
                                                            feedback.trigger(KeySoundType.DELETE)
                                                        }
                                                    }
                                                    while (accumDx >= wordSwipeStepPx && deletedStack.isNotEmpty()) {
                                                        accumDx -= wordSwipeStepPx
                                                        val restore = deletedStack.removeLast()
                                                        onCommitText(restore)
                                                        feedback.triggerLightTick()
                                                    }
                                                }
                                            }

                                            repeatJob.cancel()
                                            if (!didRepeat && !swipingWords) {
                                                handleBackspacePress()
                                            } else {
                                                currentTypingWord = onGetCurrentWordBeforeCursor()
                                            }
                                        }
                                    },
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(
                                    imageVector = Icons.AutoMirrored.Filled.Backspace,
                                    contentDescription = "Apagar",
                                    tint = keyContentColor,
                                    modifier = Modifier.size(20.dp)
                                )
                            }
                        }
                    }

                    // Trilha visual luminosa da Digitação por Gestos (Swipe)
                    if (glideTrail.size >= 2) {
                        Canvas(modifier = Modifier.matchParentSize()) {
                            val path = Path().apply {
                                moveTo(glideTrail.first().x, glideTrail.first().y)
                                for (i in 1 until glideTrail.size) {
                                    lineTo(glideTrail[i].x, glideTrail[i].y)
                                }
                            }
                            drawPath(
                                path = path,
                                color = accentColor.copy(alpha = 0.78f),
                                style = Stroke(width = 12f, cap = StrokeCap.Round, join = StrokeJoin.Round)
                            )
                        }
                    }

                    // Balão Flutuante Slide-to-Select (Seleciona automaticamente ao soltar o dedo!)
                    if (slidePopupOpen && slidePopupVariants.isNotEmpty()) {
                        val displayVariants = if (slidePopupReversed) slidePopupVariants.reversed() else slidePopupVariants
                        val highlightedDisplayIdx = if (slidePopupReversed) {
                            (displayVariants.size - 1) - slidePopupSelectedIndex
                        } else {
                            slidePopupSelectedIndex
                        }
                        val slotPx = with(density) { 40.dp.toPx() }
                        val popupW = displayVariants.size * slotPx + with(density) { 18.dp.toPx() }
                        val popupX = (slidePopupAnchorCenterX - popupW / 2f)
                            .coerceIn(4f, (gridWidthPx - popupW - 4f).coerceAtLeast(4f))
                        val popupY = slidePopupAnchorTopY - with(density) { 58.dp.toPx() }

                        Popup(
                            alignment = Alignment.TopStart,
                            offset = IntOffset(popupX.roundToInt(), popupY.roundToInt()),
                            properties = PopupProperties(focusable = false)
                        ) {
                            Surface(
                                shape = RoundedCornerShape(14.dp),
                                color = Color(0xFF1D2538),
                                border = BorderStroke(1.5.dp, accentColor),
                                shadowElevation = 14.dp
                            ) {
                                Row(
                                    modifier = Modifier.padding(horizontal = 6.dp, vertical = 5.dp),
                                    horizontalArrangement = Arrangement.spacedBy(4.dp),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    displayVariants.forEachIndexed { idx, ch ->
                                        val active = idx == highlightedDisplayIdx
                                        Box(
                                            modifier = Modifier
                                                .size(36.dp)
                                                .clip(RoundedCornerShape(9.dp))
                                                .background(if (active) accentColor else Color(0xFF2B354D)),
                                            contentAlignment = Alignment.Center
                                        ) {
                                            Text(
                                                text = ch,
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

                // Linha 4 (123 | Emoji/Custom | Vírgula | Microfone Voz | Espaço Trackpad | Ponto | Enter)
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    Box(
                        modifier = Modifier
                            .weight(1.15f)
                            .height(keyHeight)
                            .clip(RoundedCornerShape(10.dp))
                            .background(actionKeyBg)
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
                            fontSize = 12.5.sp
                        )
                    }

                    // Tecla configurável ao lado esquerdo (Emoji ou símbolo rápido; segurar abre Emojis)
                    Box(
                        modifier = Modifier
                            .weight(1.0f)
                            .height(keyHeight)
                            .clip(RoundedCornerShape(10.dp))
                            .background(actionKeyBg)
                            .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                            .pointerInput(spaceNeighborKey) {
                                detectTapGestures(
                                    onTap = {
                                        feedback.trigger(KeySoundType.CHAR)
                                        if (spaceNeighborKey == "EMOJI") {
                                            showEmojiPanel = !showEmojiPanel
                                            emojiPanelKitchenMode = false
                                            showClipboardPanel = false
                                            moreSubPanel = ActiveMoreSubPanel.NONE
                                            closeAiPanel()
                                        } else {
                                            handleKeyPress(spaceNeighborKey)
                                        }
                                    },
                                    onLongPress = {
                                        feedback.triggerLightTick()
                                        showEmojiPanel = true
                                        emojiPanelKitchenMode = false
                                        showClipboardPanel = false
                                        moreSubPanel = ActiveMoreSubPanel.NONE
                                        closeAiPanel()
                                    }
                                )
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        if (spaceNeighborKey == "EMOJI") {
                            Icon(
                                imageVector = Icons.Default.EmojiEmotions,
                                contentDescription = "Emojis",
                                tint = keyContentColor,
                                modifier = Modifier.size(20.dp)
                            )
                        } else {
                            Text(
                                text = spaceNeighborKey,
                                color = keyContentColor,
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }

                    // Vírgula com Slide-to-Select simples
                    SimpleSlidePunctuationKey(
                        label = ",",
                        variants = listOf(";", "!"),
                        keyBg = keyBg,
                        accentColor = accentColor,
                        contentColor = keyContentColor,
                        borderBrush = borderBrush,
                        fontSize = keyFontSp,
                        feedback = feedback,
                        modifier = Modifier.weight(0.85f).height(keyHeight),
                        onCommit = { handleKeyPress(it) }
                    )

                    // Microfone de Ditado por Voz (exatamente ao lado da vírgula!)
                    Box(
                        modifier = Modifier
                            .weight(0.95f)
                            .height(keyHeight)
                            .clip(RoundedCornerShape(10.dp))
                            .background(if (isVoiceListening) Color(0xFFEF4444) else actionKeyBg)
                            .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                            .clickable {
                                feedback.trigger(KeySoundType.CHAR)
                                onToggleVoiceDictation()
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = if (isVoiceListening) Icons.Default.MicOff else Icons.Default.Mic,
                            contentDescription = "Ditado por Voz",
                            tint = if (isVoiceListening) Color.White else keyContentColor,
                            modifier = Modifier.size(20.dp)
                        )
                    }

                    // Barra de Espaço com Cursor Trackpad (Deslize horizontal move o cursor letra por letra!)
                    Box(
                        modifier = Modifier
                            .weight(3.15f)
                            .height(keyHeight)
                            .clip(RoundedCornerShape(10.dp))
                            .background(keyBg)
                            .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                            .pointerInput(Unit) {
                                val stepPx = with(density) { 16.dp.toPx() }
                                awaitEachGesture {
                                    val down = awaitFirstDown(requireUnconsumed = false)
                                    down.consume()
                                    var accumX = 0f
                                    var movedCursor = false

                                    while (true) {
                                        val event = awaitPointerEvent()
                                        val change = event.changes.firstOrNull { it.id == down.id } ?: break
                                        if (!change.pressed) break
                                        val dx = change.positionChange().x
                                        change.consume()
                                        accumX += dx
                                        while (accumX >= stepPx) {
                                            accumX -= stepPx
                                            movedCursor = true
                                            onMoveCursor(1)
                                            feedback.triggerLightTick()
                                        }
                                        while (accumX <= -stepPx) {
                                            accumX += stepPx
                                            movedCursor = true
                                            onMoveCursor(-1)
                                            feedback.triggerLightTick()
                                        }
                                    }
                                    if (!movedCursor) {
                                        handleSpacePress()
                                    }
                                }
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "espaço",
                            color = keyContentColor.copy(alpha = 0.72f),
                            fontSize = 12.5.sp
                        )
                    }

                    // Ponto com Slide-to-Select (?, !, :, -)
                    SimpleSlidePunctuationKey(
                        label = ".",
                        variants = listOf("?", "!", ":", "-"),
                        keyBg = keyBg,
                        accentColor = accentColor,
                        contentColor = keyContentColor,
                        borderBrush = borderBrush,
                        fontSize = keyFontSp,
                        feedback = feedback,
                        modifier = Modifier.weight(0.85f).height(keyHeight),
                        onCommit = { handleKeyPress(it) }
                    )

                    // Enter
                    Box(
                        modifier = Modifier
                            .weight(1.25f)
                            .height(keyHeight)
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

private fun iconForTool(tool: ToolbarToolId): ImageVector = when (tool) {
    ToolbarToolId.IA -> Icons.Default.AutoAwesome
    ToolbarToolId.RESPONDER -> Icons.Default.ChatBubbleOutline
    ToolbarToolId.CORRIGIR -> Icons.Default.Spellcheck
    ToolbarToolId.REESCREVER -> Icons.Default.Edit
    ToolbarToolId.TRADUZIR -> Icons.Default.Translate
    ToolbarToolId.LUPA -> Icons.Default.Search
    ToolbarToolId.COPIADOS -> Icons.Default.ContentPaste
    ToolbarToolId.KITCHEN -> Icons.Default.EmojiEmotions
}

@Composable
private fun MoreIconButton(
    icon: ImageVector,
    contentDesc: String,
    accent: Color,
    textColor: Color,
    onClick: () -> Unit
) {
    Box(
        modifier = Modifier
            .size(44.dp)
            .clip(RoundedCornerShape(12.dp))
            .background(accent.copy(alpha = 0.16f))
            .border(1.dp, accent.copy(alpha = 0.45f), RoundedCornerShape(12.dp))
            .clickable { onClick() },
        contentAlignment = Alignment.Center
    ) {
        Icon(icon, contentDescription = contentDesc, tint = textColor, modifier = Modifier.size(22.dp))
    }
}

@Composable
private fun KeyVisualCap(
    label: String,
    subLabel: String?,
    isPressed: Boolean,
    keyBg: Color,
    accentColor: Color,
    contentColor: Color,
    borderBrush: Brush,
    fontSize: androidx.compose.ui.unit.TextUnit,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .clip(RoundedCornerShape(10.dp))
            .background(if (isPressed) accentColor.copy(alpha = 0.45f) else keyBg)
            .border(1.dp, borderBrush, RoundedCornerShape(10.dp)),
        contentAlignment = Alignment.Center
    ) {
        if (subLabel != null) {
            Text(
                text = subLabel,
                color = contentColor.copy(alpha = 0.48f),
                fontSize = 9.sp,
                modifier = Modifier
                    .align(Alignment.TopEnd)
                    .padding(top = 2.dp, end = 4.dp)
            )
        }
        Text(
            text = label,
            color = contentColor,
            fontSize = fontSize,
            fontWeight = FontWeight.Medium,
            textAlign = TextAlign.Center
        )
    }
}

@Composable
private fun SimpleSlidePunctuationKey(
    label: String,
    variants: List<String>,
    keyBg: Color,
    accentColor: Color,
    contentColor: Color,
    borderBrush: Brush,
    fontSize: androidx.compose.ui.unit.TextUnit,
    feedback: KeyFeedbackEngine,
    modifier: Modifier = Modifier,
    onCommit: (String) -> Unit
) {
    val scope = rememberCoroutineScope()
    val density = LocalDensity.current
    var showPopup by remember { mutableStateOf(false) }
    var selectedIdx by remember { mutableIntStateOf(0) }

    Box(
        modifier = modifier
            .clip(RoundedCornerShape(10.dp))
            .background(keyBg)
            .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
            .pointerInput(label, variants) {
                val slotPx = with(density) { 38.dp.toPx() }
                awaitEachGesture {
                    val down = awaitFirstDown(requireUnconsumed = false)
                    down.consume()
                    val lpJob = scope.launch {
                        delay(300)
                        selectedIdx = 0
                        showPopup = true
                        feedback.triggerLightTick()
                    }
                    while (true) {
                        val event = awaitPointerEvent()
                        val change = event.changes.firstOrNull { it.id == down.id } ?: break
                        if (!change.pressed) break
                        change.consume()
                        if (showPopup) {
                            val dx = change.position.x - down.position.x
                            val newIdx = (kotlin.math.abs(dx) / slotPx).roundToInt().coerceIn(0, variants.lastIndex)
                            if (newIdx != selectedIdx) {
                                selectedIdx = newIdx
                                feedback.triggerLightTick()
                            }
                        }
                    }
                    lpJob.cancel()
                    if (showPopup) {
                        onCommit(variants.getOrElse(selectedIdx) { label })
                        showPopup = false
                    } else {
                        onCommit(label)
                    }
                }
            },
        contentAlignment = Alignment.Center
    ) {
        Text(text = label, color = contentColor, fontSize = fontSize, fontWeight = FontWeight.Medium)

        if (showPopup) {
            Popup(
                alignment = Alignment.TopCenter,
                offset = IntOffset(0, -135),
                properties = PopupProperties(focusable = false)
            ) {
                Surface(
                    shape = RoundedCornerShape(12.dp),
                    color = Color(0xFF1D2538),
                    border = BorderStroke(1.5.dp, accentColor),
                    shadowElevation = 10.dp
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 6.dp, vertical = 5.dp),
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        variants.forEachIndexed { idx, v ->
                            Box(
                                modifier = Modifier
                                    .size(34.dp)
                                    .clip(RoundedCornerShape(8.dp))
                                    .background(if (idx == selectedIdx) accentColor else Color(0xFF2B354D)),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(v, color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                            }
                        }
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
            .widthIn(min = 56.dp)
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
        targetValue = if (bouncing) 1.4f else 1f,
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
                    delay(160)
                    bouncing = false
                }
            },
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = emoji,
            fontSize = 22.sp,
            modifier = Modifier.graphicsLayer {
                scaleX = scale
                scaleY = scale
            }
        )
    }
}
EOF

# 16. PrismKeyboardService.kt (SpeechRecognizer Voz + Emoji Kitchen CommitContent + Cursor Trackpad + Backspace Swipe-Word)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/service/PrismKeyboardService.kt
package com.prismkey.keyboard.service

import android.Manifest
import android.content.ClipDescription
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.inputmethodservice.InputMethodService
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.text.InputType
import android.view.KeyEvent
import android.view.View
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.ExtractedTextRequest
import androidx.compose.runtime.mutableLongStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.platform.ComposeView
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import androidx.core.view.inputmethod.EditorInfoCompat
import androidx.core.view.inputmethod.InputConnectionCompat
import androidx.core.view.inputmethod.InputContentInfoCompat
import androidx.lifecycle.*
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistryController
import androidx.savedstate.SavedStateRegistryOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import com.prismkey.keyboard.MainActivity
import com.prismkey.keyboard.audio.KeyFeedbackEngine
import com.prismkey.keyboard.data.PrefsManager
import com.prismkey.keyboard.ui.keyboard.PrismKeyboardView
import java.io.File
import java.util.Locale

class PrismKeyboardService : InputMethodService(), LifecycleOwner, ViewModelStoreOwner, SavedStateRegistryOwner {

    private val lifecycleRegistry = LifecycleRegistry(this)
    private val store = ViewModelStore()
    private val savedStateController = SavedStateRegistryController.create(this)
    private lateinit var prefs: PrefsManager
    private lateinit var feedbackEngine: KeyFeedbackEngine

    private val mainHandler = Handler(Looper.getMainLooper())
    private var speechRecognizer: SpeechRecognizer? = null

    private val themeSyncVersion = mutableLongStateOf(1L)
    private val isVoiceListening = mutableStateOf(false)
    private val voicePartialText = mutableStateOf("")
    private val voiceReviewText = mutableStateOf("")
    private val voiceStatusMessage = mutableStateOf<String?>(null)

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
                isVoiceListening = isVoiceListening.value,
                voicePartialText = voicePartialText.value,
                voiceReviewText = voiceReviewText.value,
                voiceStatusMessage = voiceStatusMessage.value,
                onToggleVoiceDictation = { toggleVoiceDictation() },
                onAcceptVoiceReview = { text ->
                    commitTextUnlimited("$text ")
                    voiceReviewText.value = ""
                    voiceStatusMessage.value = null
                },
                onDismissVoiceReview = {
                    voiceReviewText.value = ""
                    voiceStatusMessage.value = null
                },
                onCommitText = { text -> commitTextUnlimited(text) },
                onCommitSticker = { file, fallbackEmoji -> commitStickerPng(file, fallbackEmoji) },
                onDeleteChar = {
                    val ic = currentInputConnection ?: return@PrismKeyboardView
                    val selected = ic.getSelectedText(0)
                    if (!selected.isNullOrEmpty()) {
                        ic.commitText("", 1)
                    } else {
                        ic.deleteSurroundingText(1, 0)
                    }
                },
                onDeletePreviousWord = { deletePreviousWordAndReturn() },
                onMoveCursor = { delta ->
                    if (delta < 0) sendDownUpKeyEvents(KeyEvent.KEYCODE_DPAD_LEFT)
                    else if (delta > 0) sendDownUpKeyEvents(KeyEvent.KEYCODE_DPAD_RIGHT)
                },
                onEnterPressed = { sendDownUpKeyEvents(KeyEvent.KEYCODE_ENTER) },
                onGetCurrentFieldText = { readCompleteFieldText() },
                onGetCurrentWordBeforeCursor = { readWordBeforeCursor() },
                onReplaceWordBeforeCursor = { replacement, fallbackLen ->
                    val ic = currentInputConnection ?: return@PrismKeyboardView
                    val word = readWordBeforeCursor()
                    val deleteCount = if (word.isNotEmpty()) word.length else fallbackLen
                    if (deleteCount > 0) {
                        ic.deleteSurroundingText(deleteCount, 0)
                    }
                    ic.commitText(replacement, 1)
                },
                onReplaceCurrentFieldText = { newText -> replaceCompleteFieldText(newText) },
                onShouldAutoCapitalize = {
                    val ic = currentInputConnection
                    if (ic == null) false
                    else ic.getCursorCapsMode(InputType.TYPE_TEXT_FLAG_CAP_SENTENCES) != 0
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

    private fun toggleVoiceDictation() {
        mainHandler.post {
            if (isVoiceListening.value) {
                stopVoiceDictation()
                return@post
            }
            val granted = ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.RECORD_AUDIO
            ) == PackageManager.PERMISSION_GRANTED
            if (!granted) {
                voiceStatusMessage.value = "Conceda permissão de Microfone na aba Início do PrismKey."
                val intent = Intent(this, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                startActivity(intent)
                return@post
            }
            if (!SpeechRecognizer.isRecognitionAvailable(this)) {
                voiceStatusMessage.value = "Reconhecimento de voz indisponível neste aparelho."
                return@post
            }

            voiceStatusMessage.value = null
            voicePartialText.value = ""
            voiceReviewText.value = ""

            runCatching { speechRecognizer?.destroy() }
            speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this).apply {
                setRecognitionListener(object : RecognitionListener {
                    override fun onReadyForSpeech(params: Bundle?) {
                        isVoiceListening.value = true
                    }
                    override fun onBeginningOfSpeech() {}
                    override fun onRmsChanged(rmsdB: Float) {}
                    override fun onBufferReceived(buffer: ByteArray?) {}
                    override fun onEndOfSpeech() {
                        isVoiceListening.value = false
                    }
                    override fun onError(error: Int) {
                        isVoiceListening.value = false
                        voicePartialText.value = ""
                        voiceStatusMessage.value = when (error) {
                            SpeechRecognizer.ERROR_NO_MATCH, SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "Não captei fala. Toque no microfone e tente novamente."
                            SpeechRecognizer.ERROR_NETWORK, SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> "Erro de rede no reconhecimento de voz."
                            else -> "Ditado pausado (código $error)."
                        }
                    }
                    override fun onResults(results: Bundle?) {
                        isVoiceListening.value = false
                        val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                        val spoken = matches?.firstOrNull()?.trim().orEmpty()
                        voicePartialText.value = ""
                        if (spoken.isNotBlank()) {
                            if (prefs.reviewVoiceDictation) {
                                voiceReviewText.value = spoken
                            } else {
                                commitTextUnlimited("$spoken ")
                            }
                        }
                    }
                    override fun onPartialResults(partialResults: Bundle?) {
                        val partial = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)?.firstOrNull()
                        if (!partial.isNullOrBlank()) voicePartialText.value = partial
                    }
                    override fun onEvent(eventType: Int, params: Bundle?) {}
                })
            }

            val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
                putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale("pt", "BR").toLanguageTag())
                putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
                putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 1)
            }
            isVoiceListening.value = true
            runCatching { speechRecognizer?.startListening(intent) }.onFailure {
                isVoiceListening.value = false
                voiceStatusMessage.value = "Não foi possível iniciar o microfone."
            }
        }
    }

    private fun stopVoiceDictation() {
        runCatching { speechRecognizer?.stopListening() }
        isVoiceListening.value = false
    }

    private fun commitStickerPng(file: File, fallbackEmoji: String): Boolean {
        val ic = currentInputConnection ?: return false
        val editorInfo = currentInputEditorInfo ?: return false

        val mimeTypes = EditorInfoCompat.getContentMimeTypes(editorInfo)
        val supportsPng = mimeTypes.any {
            ClipDescription.compareMimeTypes(it, "image/png") || ClipDescription.compareMimeTypes(it, "image/*")
        }

        if (supportsPng && file.exists()) {
            val committed = runCatching {
                val uri = FileProvider.getUriForFile(this, "$packageName.fileprovider", file)
                val info = InputContentInfoCompat(
                    uri,
                    ClipDescription("PrismKey Emoji Kitchen", arrayOf("image/png")),
                    null
                )
                InputConnectionCompat.commitContent(
                    ic,
                    editorInfo,
                    info,
                    InputConnectionCompat.INPUT_CONTENT_GRANT_READ_URI_PERMISSION,
                    null
                )
            }.getOrDefault(false)
            if (committed) return true
        }

        commitTextUnlimited(fallbackEmoji)
        return false
    }

    private fun deletePreviousWordAndReturn(): String {
        val ic = currentInputConnection ?: return ""
        val before = ic.getTextBeforeCursor(60, 0)?.toString() ?: return ""
        if (before.isEmpty()) return ""

        var idx = before.length
        while (idx > 0 && before[idx - 1].isWhitespace()) idx--
        while (idx > 0 && !before[idx - 1].isWhitespace()) idx--

        val count = before.length - idx
        if (count <= 0) return ""
        val removed = before.substring(idx)
        ic.deleteSurroundingText(count, 0)
        return removed
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
        return before.takeLastWhile { it.isLetter() || it == '/' || it == '@' }
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
        runCatching { speechRecognizer?.destroy() }
        feedbackEngine.release()
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        store.clear()
        super.onDestroy()
    }
}
EOF

# 17. PrismaLensAccessibilityService.kt (Lupa Flutuante: Detecção de Idioma + Tradução + Voz + Responder + Segurar 5s Oculta)
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
                                text = "Idioma: $detectedLangName",
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

                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            .background(Color.White)
                            .border(1.dp, Color(0xFFE5E7EB), RoundedCornerShape(12.dp))
                            .padding(10.dp),
                        verticalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        Text("Original ($detectedLangName):", color = Color(0xFF6B7280), fontSize = 11.sp)
                        Text(
                            text = if (capturedText.isBlank()) "Toque na bolha em cima de uma conversa." else capturedText,
                            color = Color(0xFF1F2937),
                            fontSize = 14.sp,
                            fontStyle = FontStyle.Italic,
                            maxLines = 4,
                            overflow = TextOverflow.Ellipsis
                        )
                    }

                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            .background(Color(0xFFF3E8FF))
                            .border(1.dp, Color(0xFFD8B4FE), RoundedCornerShape(12.dp))
                            .padding(10.dp),
                        verticalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        Text("Tradução em Português:", color = Color(0xFF7C3AED), fontSize = 11.sp, fontWeight = FontWeight.Medium)
                        if (isProcessing) {
                            LinearProgressIndicator(modifier = Modifier.fillMaxWidth(), color = Color(0xFF8B5CF6))
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

                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(6.dp)) {
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

# 18. MainActivity.kt (Prévia Intermediária Gboard com Bordas + Global Bordas + Preferências Keyvya + IA Local + 13 Idiomas + Créditos Davi e Pedro Paulo)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/MainActivity.kt
package com.prismkey.keyboard

import android.Manifest
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
import kotlin.math.roundToInt

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
    var pendingCropExistingPath by remember { mutableStateOf<String?>(null) }
    var previewThemePath by remember { mutableStateOf<String?>(null) }
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
                        onPickImageForCrop = { uri ->
                            pendingCropExistingPath = null
                            pendingCropUri = uri
                        },
                        onOpenThemePreview = { path -> previewThemePath = path },
                        onThemesMutated = { themesRefreshTick++ }
                    )
                    2 -> AiAndLensTab(prefs = prefs, status = status)
                    3 -> AboutAndPrivacyTab(prefs = prefs)
                }
            }
        }

        // Prévia Intermediária estilo Gboard (Editar, Lixeira, Bordas das teclas, Cancelar e Aplicar)
        val previewPath = previewThemePath
        if (previewPath != null) {
            GboardThemePreviewSheet(
                imagePath = previewPath,
                initialBorders = prefs.showKeyBorders,
                dimAlpha = prefs.overlayDimAlpha,
                onEdit = {
                    previewThemePath = null
                    pendingCropUri = null
                    pendingCropExistingPath = previewPath
                },
                onDelete = {
                    prefs.removeCustomThemePath(previewPath)
                    themesRefreshTick++
                    previewThemePath = null
                    Toast.makeText(context, "Tema removido.", Toast.LENGTH_SHORT).show()
                },
                onCancel = { previewThemePath = null },
                onApply = { bordersEnabled ->
                    prefs.showKeyBorders = bordersEnabled
                    prefs.customImagePath = previewPath
                    prefs.themeMode = PrismThemeMode.CUSTOM_IMAGE
                    themesRefreshTick++
                    previewThemePath = null
                    Toast.makeText(context, "Tema aplicado ao PrismKey!", Toast.LENGTH_SHORT).show()
                }
            )
        }

        // Editor de Enquadramento Tela Cheia estilo Gboard
        if (pendingCropUri != null || pendingCropExistingPath != null) {
            GboardStyleCropOverlay(
                imageUri = pendingCropUri,
                existingFilePath = pendingCropExistingPath,
                prefs = prefs,
                onCancel = {
                    pendingCropUri = null
                    pendingCropExistingPath = null
                },
                onDone = { savedPath ->
                    prefs.addCustomThemePath(savedPath)
                    themesRefreshTick++
                    pendingCropUri = null
                    pendingCropExistingPath = null
                    previewThemePath = savedPath
                }
            )
        }
    }
}

@Composable
private fun GboardThemePreviewSheet(
    imagePath: String,
    initialBorders: Boolean,
    dimAlpha: Float,
    onEdit: () -> Unit,
    onDelete: () -> Unit,
    onCancel: () -> Unit,
    onApply: (Boolean) -> Unit
) {
    var bordersOn by remember { mutableStateOf(initialBorders) }
    val bmp = remember(imagePath) {
        if (File(imagePath).exists()) BitmapFactory.decodeFile(imagePath)?.asImageBitmap() else null
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.Black.copy(alpha = 0.72f))
            .clickable(enabled = false) {},
        contentAlignment = Alignment.BottomCenter
    ) {
        Surface(
            shape = RoundedCornerShape(topStart = 26.dp, topEnd = 26.dp),
            color = Color(0xFF151921),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 18.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.End,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    IconButton(onClick = onEdit) {
                        Icon(Icons.Default.Edit, contentDescription = "Editar", tint = Color(0xFF86EFAC))
                    }
                    IconButton(onClick = onDelete) {
                        Icon(Icons.Default.Delete, contentDescription = "Excluir", tint = Color(0xFF86EFAC))
                    }
                }

                // Mini prévia do teclado sobre a imagem com alternância de bordas em tempo real
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(195.dp)
                        .clip(RoundedCornerShape(16.dp))
                        .background(Color(0xFF0E1117))
                ) {
                    if (bmp != null) {
                        Image(
                            bitmap = bmp,
                            contentDescription = null,
                            contentScale = ContentScale.Crop,
                            modifier = Modifier.fillMaxSize()
                        )
                        Box(modifier = Modifier.fillMaxSize().background(Color.Black.copy(alpha = dimAlpha)))
                    }

                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(8.dp),
                        verticalArrangement = Arrangement.SpaceBetween
                    ) {
                        val previewRows = listOf(
                            listOf("q", "w", "e", "r", "t", "y", "u", "i", "o", "p"),
                            listOf("a", "s", "d", "f", "g", "h", "j", "k", "l"),
                            listOf("⇧", "z", "x", "c", "v", "b", "n", "m", "⌫")
                        )
                        previewRows.forEach { row ->
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(4.dp)
                            ) {
                                row.forEach { ch ->
                                    Box(
                                        modifier = Modifier
                                            .weight(1f)
                                            .height(34.dp)
                                            .clip(RoundedCornerShape(6.dp))
                                            .background(if (bordersOn) Color(0xFF141925).copy(alpha = 0.58f) else Color.Transparent),
                                        contentAlignment = Alignment.Center
                                    ) {
                                        Text(ch, color = Color.White, fontSize = 13.sp, fontWeight = FontWeight.Medium)
                                    }
                                }
                            }
                        }

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(6.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text("?123", color = Color.White, fontSize = 11.sp, modifier = Modifier.padding(horizontal = 4.dp))
                            Box(
                                modifier = Modifier
                                    .weight(1f)
                                    .height(28.dp)
                                    .clip(RoundedCornerShape(6.dp))
                                    .background(Color.White.copy(alpha = if (bordersOn) 0.28f else 0.16f))
                            )
                            Box(
                                modifier = Modifier
                                    .width(44.dp)
                                    .height(28.dp)
                                    .clip(RoundedCornerShape(14.dp))
                                    .background(Color(0xFF4F7DF3)),
                                contentAlignment = Alignment.Center
                            ) {
                                Text("↵", color = Color.White, fontWeight = FontWeight.Bold)
                            }
                        }
                    }
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("Bordas das teclas", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.Medium)
                    Switch(checked = bordersOn, onCheckedChange = { bordersOn = it })
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    OutlinedButton(
                        onClick = onCancel,
                        shape = RoundedCornerShape(24.dp),
                        modifier = Modifier.width(128.dp).height(44.dp)
                    ) {
                        Text("Cancelar", color = Color(0xFF86EFAC))
                    }
                    Button(
                        onClick = { onApply(bordersOn) },
                        shape = RoundedCornerShape(24.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF3E4E34)),
                        modifier = Modifier.width(128.dp).height(44.dp)
                    ) {
                        Text("Aplicar", color = Color(0xFFDCFCE7), fontWeight = FontWeight.Bold)
                    }
                }
            }
        }
    }
}

@Composable
private fun GboardStyleCropOverlay(
    imageUri: Uri?,
    existingFilePath: String?,
    prefs: PrefsManager,
    onCancel: () -> Unit,
    onDone: (String) -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    var loadedBitmap by remember(imageUri, existingFilePath) { mutableStateOf<Bitmap?>(null) }
    var isLoading by remember(imageUri, existingFilePath) { mutableStateOf(true) }
    var isSaving by remember { mutableStateOf(false) }

    var containerSize by remember { mutableStateOf(IntSize.Zero) }
    var userScale by remember { mutableFloatStateOf(1f) }
    var offsetX by remember { mutableFloatStateOf(0f) }
    var offsetY by remember { mutableFloatStateOf(0f) }
    var dimAlpha by remember { mutableFloatStateOf(prefs.overlayDimAlpha) }

    LaunchedEffect(imageUri, existingFilePath) {
        isLoading = true
        loadedBitmap = withContext(Dispatchers.IO) {
            when {
                imageUri != null -> ImageCropper.loadSafeBitmap(context, imageUri)
                !existingFilePath.isNullOrBlank() && File(existingFilePath).exists() -> BitmapFactory.decodeFile(existingFilePath)
                else -> null
            }
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

                    withTransform({
                        translate(left = w / 2f + offsetX, top = h / 2f + offsetY)
                        scale(scaleX = totalScale, scaleY = totalScale, pivot = Offset.Zero)
                        translate(left = -bmp.width / 2f, top = -bmp.height / 2f)
                    }) {
                        drawImage(imageBitmap)
                    }

                    drawRect(
                        color = Color.Black.copy(alpha = dimAlpha),
                        topLeft = Offset(left, top),
                        size = Size(cropW, cropH)
                    )

                    val scrim = Color.Black.copy(alpha = 0.68f)
                    drawRect(color = scrim, topLeft = Offset.Zero, size = Size(w, top))
                    drawRect(color = scrim, topLeft = Offset(0f, top + cropH), size = Size(w, h - (top + cropH)))
                    drawRect(color = scrim, topLeft = Offset(0f, top), size = Size(left, cropH))
                    drawRect(color = scrim, topLeft = Offset(left + cropW, top), size = Size(w - (left + cropW), cropH))

                    drawRect(
                        color = Color.White,
                        topLeft = Offset(left, top),
                        size = Size(cropW, cropH),
                        style = Stroke(width = 4f)
                    )
                }

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
                        modifier = Modifier.width(190.dp).height(48.dp)
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
                moveTo(w * 0.80f, h * 0.14f); lineTo(w * 0.94f, h * 0.50f); lineTo(w * 0.80f, h * 0.50f); close()
            }
            drawPath(path = topFacet, brush = Brush.linearGradient(listOf(Color(0xFFE0F2FE), Color(0xFF60A5FA))))
            val leftFacet = Path().apply {
                moveTo(w * 0.80f, h * 0.14f); lineTo(w * 0.66f, h * 0.50f); lineTo(w * 0.80f, h * 0.50f); close()
            }
            drawPath(path = leftFacet, brush = Brush.linearGradient(listOf(Color(0xFF93C5FD), Color(0xFF3B82F6))))
            val bottomLeftFacet = Path().apply {
                moveTo(w * 0.66f, h * 0.50f); lineTo(w * 0.80f, h * 0.86f); lineTo(w * 0.80f, h * 0.50f); close()
            }
            drawPath(path = bottomLeftFacet, brush = Brush.linearGradient(listOf(Color(0xFF2563EB), Color(0xFF1D4ED8))))
            val bottomRightFacet = Path().apply {
                moveTo(w * 0.94f, h * 0.50f); lineTo(w * 0.80f, h * 0.86f); lineTo(w * 0.80f, h * 0.50f); close()
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
                    text = "VERSÃO 1.4.0",
                    color = Color(0xFF93C5FD),
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                )
            }
            Text(text = "PrismKey", color = Color.White, fontSize = 28.sp, fontWeight = FontWeight.ExtraBold)
            Text(
                text = "IA Offline, Emoji Kitchen, Gestos e Temas Livres.",
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

    val micPermLauncher = rememberLauncherForActivityResult(ActivityResultContracts.RequestPermission()) { granted ->
        onRefreshStatus()
        Toast.makeText(
            context,
            if (granted) "Microfone liberado para ditado por voz!" else "Permissão de microfone negada.",
            Toast.LENGTH_SHORT
        ).show()
    }

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
                modifier = Modifier.fillMaxWidth().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                if (status.isKeyboardEnabled && status.isKeyboardDefault) {
                    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        Icon(Icons.Default.CheckCircle, contentDescription = null, tint = Color(0xFF34D399))
                        Column {
                            Text("PrismKey Ativo e Padrão", color = Color.White, fontWeight = FontWeight.Bold)
                            Text("Tudo pronto! Teste digitação, gestos, voz e Emoji Kitchen abaixo.", color = Color.White.copy(alpha = 0.7f), fontSize = 12.sp)
                        }
                    }
                } else {
                    Text("Ativação do PrismKey no Android", color = Color(0xFFFBBF24), fontWeight = FontWeight.Bold)
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

                HorizontalDivider(color = Color.White.copy(alpha = 0.1f))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text("Ditado por Voz (Microfone)", color = Color.White, fontWeight = FontWeight.SemiBold, fontSize = 14.sp)
                        Text(
                            if (status.hasMicrophonePermission) "Permissão ativa para transcrever voz" else "Permita o microfone para usar o botão de voz",
                            color = if (status.hasMicrophonePermission) Color(0xFF34D399) else Color(0xFFFBBF24),
                            fontSize = 11.5.sp
                        )
                    }
                    if (!status.hasMicrophonePermission) {
                        Button(
                            onClick = { micPermLauncher.launch(Manifest.permission.RECORD_AUDIO) },
                            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 4.dp)
                        ) {
                            Text("Permitir", fontSize = 12.sp)
                        }
                    } else {
                        Icon(Icons.Default.Mic, contentDescription = null, tint = Color(0xFF34D399))
                    }
                }
            }
        }

        OutlinedTextField(
            value = testText,
            onValueChange = { testText = it },
            placeholder = { Text("Área de teste: digite, deslize ou fale pelo microfone...") },
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
    onOpenThemePreview: (String) -> Unit,
    onThemesMutated: () -> Unit
) {
    val context = LocalContext.current
    var selectedMode by remember(refreshTick) { mutableStateOf(prefs.themeMode) }
    var activeImagePath by remember(refreshTick) { mutableStateOf(prefs.customImagePath) }
    var activeSolidBg by remember(refreshTick) { mutableLongStateOf(prefs.solidColorBgHex) }
    val customThemes = remember(refreshTick) { prefs.savedCustomThemes }

    var showKeyBorders by remember(refreshTick) { mutableStateOf(prefs.showKeyBorders) }
    var dimAlpha by remember(refreshTick) { mutableFloatStateOf(prefs.overlayDimAlpha) }

    var autoCorrect by remember { mutableStateOf(prefs.autoCorrectionEnabled) }
    var autoCap by remember { mutableStateOf(prefs.autoCapitalizeEnabled) }
    var reviewVoice by remember { mutableStateOf(prefs.reviewVoiceDictation) }
    var showNumberRow by remember { mutableStateOf(prefs.showNumberRow) }
    var gestureTyping by remember { mutableStateOf(prefs.gestureTypingEnabled) }
    var keyTextScale by remember { mutableFloatStateOf(prefs.keyTextScale) }
    var keyboardHeightScale by remember(refreshTick) { mutableFloatStateOf(prefs.keyboardHeightScale) }
    var spaceNeighbor by remember { mutableStateOf(prefs.spaceNeighborKey) }

    var soundEnabled by remember { mutableStateOf(prefs.soundEnabled) }
    var soundVolume by remember { mutableFloatStateOf(prefs.soundVolume) }
    var vibrationEnabled by remember { mutableStateOf(prefs.vibrationEnabled) }
    var vibrationMs by remember { mutableIntStateOf(prefs.vibrationDurationMs) }

    var snippetTrigger by remember { mutableStateOf("") }
    var snippetText by remember { mutableStateOf("") }
    val snippets = remember(refreshTick) { prefs.personalSnippets }

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
        Text("Temas & Preferências", color = Color.White, fontSize = 25.sp, fontWeight = FontWeight.Bold)

        // Chave Global: Bordas das teclas (funciona em todos os temas!)
        Surface(shape = RoundedCornerShape(16.dp), color = Color(0xFF161B26)) {
            Row(
                modifier = Modifier.fillMaxWidth().padding(14.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text("Bordas das teclas (Todos os temas)", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                    Text("Desative para visual limpo sem contorno nas teclas", color = Color.White.copy(alpha = 0.65f), fontSize = 11.5.sp)
                }
                Switch(
                    checked = showKeyBorders,
                    onCheckedChange = {
                        showKeyBorders = it
                        prefs.showKeyBorders = it
                        onThemesMutated()
                    }
                )
            }
        }

        // 1. Meus Temas estilo Gboard
        Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
            Text("Meus temas (toque para visualizar, editar bordas ou excluir)", color = Color(0xFFB6C4D8), fontSize = 13.sp, fontWeight = FontWeight.SemiBold)

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
                        Icon(Icons.Default.Add, contentDescription = "Adicionar tema", tint = Color(0xFF86EFAC), modifier = Modifier.size(34.dp))
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
                            .clickable { onOpenThemePreview(path) }
                    ) {
                        if (thumb != null) {
                            Image(bitmap = thumb, contentDescription = "Tema salvo", contentScale = ContentScale.Crop, modifier = Modifier.fillMaxSize())
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

        // 2. Padrão
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
                    onClick = { prefs.themeMode = PrismThemeMode.DYNAMIC_WALLPAPER; selectedMode = PrismThemeMode.DYNAMIC_WALLPAPER }
                )
                GboardPresetCard(
                    title = "Automático",
                    bgColor = Color(0xFFF3F4F6),
                    accentDot = Color(0xFF93C5FD),
                    splitDarkHalf = true,
                    selected = selectedMode == PrismThemeMode.SYSTEM_AUTO,
                    modifier = Modifier.weight(1f),
                    onClick = { prefs.themeMode = PrismThemeMode.SYSTEM_AUTO; selectedMode = PrismThemeMode.SYSTEM_AUTO }
                )
                GboardPresetCard(
                    title = "Claro padrão",
                    bgColor = Color(0xFFF4F6FA),
                    accentDot = Color(0xFF2563EB),
                    splitDarkHalf = false,
                    selected = selectedMode == PrismThemeMode.LIQUID_LIGHT,
                    modifier = Modifier.weight(1f),
                    onClick = { prefs.themeMode = PrismThemeMode.LIQUID_LIGHT; selectedMode = PrismThemeMode.LIQUID_LIGHT }
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
                    onClick = { prefs.themeMode = PrismThemeMode.LIQUID_DARK; selectedMode = PrismThemeMode.LIQUID_DARK }
                )
                Spacer(Modifier.weight(1f))
                Spacer(Modifier.weight(1f))
            }
        }

        // 3. Cores
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

        // 4. Preferências de Digitação (Estilo Keyvya + Gboard)
        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text("Preferências de Digitação", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)

                SettingSwitchRow(
                    title = "Correção automática",
                    subtitle = "Corrige palavras ao dar espaço (apagar logo depois desfaz)",
                    checked = autoCorrect,
                    onCheckedChange = { autoCorrect = it; prefs.autoCorrectionEnabled = it }
                )
                SettingSwitchRow(
                    title = "Maiúscula automática",
                    subtitle = "Começa cada frase com letra maiúscula",
                    checked = autoCap,
                    onCheckedChange = { autoCap = it; prefs.autoCapitalizeEnabled = it }
                )
                SettingSwitchRow(
                    title = "Revisar ditado antes de inserir",
                    subtitle = "Mostra o que você falou no microfone para conferir antes de inserir",
                    checked = reviewVoice,
                    onCheckedChange = { reviewVoice = it; prefs.reviewVoiceDictation = it }
                )
                SettingSwitchRow(
                    title = "Linha de números",
                    subtitle = "Mostra os números (1 a 0) acima das letras",
                    checked = showNumberRow,
                    onCheckedChange = { showNumberRow = it; prefs.showNumberRow = it }
                )
                SettingSwitchRow(
                    title = "Digitação por Gestos (Swipe)",
                    subtitle = "Deslize o dedo pelas letras para digitar palavras completas",
                    checked = gestureTyping,
                    onCheckedChange = { gestureTyping = it; prefs.gestureTypingEnabled = it }
                )

                HorizontalDivider(color = Color.White.copy(alpha = 0.1f))

                Text("Tamanho da letra das teclas: ${(keyTextScale * 100).roundToInt()}%", color = Color.White, fontSize = 13.sp)
                Slider(
                    value = keyTextScale,
                    onValueChange = { keyTextScale = it; prefs.keyTextScale = it },
                    valueRange = 0.85f..1.35f
                )

                Text("Tamanho do teclado: ${(keyboardHeightScale * 100).roundToInt()}%", color = Color.White, fontSize = 13.sp)
                Slider(
                    value = keyboardHeightScale,
                    onValueChange = { keyboardHeightScale = it; prefs.keyboardHeightScale = it },
                    valueRange = 1.0f..1.4f
                )

                Text("Tecla ao lado do espaço (segurar abre emojis)", color = Color.White, fontSize = 13.sp)
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf("EMOJI" to "Emoji", "?" to "?", "!" to "!", "@" to "@", "-" to "-").forEach { (id, label) ->
                        val active = spaceNeighbor == id
                        Surface(
                            shape = RoundedCornerShape(12.dp),
                            color = if (active) Color(0xFF7C3AED) else Color(0xFF232B3D),
                            modifier = Modifier
                                .weight(1f)
                                .height(38.dp)
                                .clickable { spaceNeighbor = id; prefs.spaceNeighborKey = id }
                        ) {
                            Box(contentAlignment = Alignment.Center) {
                                Text(label, color = Color.White, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                            }
                        }
                    }
                }
            }
        }

        // 5. Som (SoundPool WAV) & Vibração
        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Icon(Icons.Default.GraphicEq, contentDescription = null, tint = Color(0xFF8B5CF6))
                    Text("Som e Vibração ao Digitar", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                }

                SettingSwitchRow(
                    title = "Som ao digitar (SoundPool)",
                    subtitle = "Clique clássico estilo iPhone / SwiftKey",
                    checked = soundEnabled,
                    onCheckedChange = {
                        soundEnabled = it
                        prefs.soundEnabled = it
                        if (it) feedbackPreview.previewClick()
                    }
                )

                if (soundEnabled) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Volume do clique: ${(soundVolume * 100).toInt()}%", color = Color.White.copy(alpha = 0.8f), fontSize = 12.sp)
                        TextButton(onClick = { feedbackPreview.previewClick() }) {
                            Text("Testar clique", color = Color(0xFF93C5FD), fontSize = 12.sp)
                        }
                    }
                    Slider(
                        value = soundVolume,
                        onValueChange = { soundVolume = it; prefs.soundVolume = it },
                        valueRange = 0.1f..1.0f
                    )
                }

                HorizontalDivider(color = Color.White.copy(alpha = 0.1f))

                SettingSwitchRow(
                    title = "Vibração ao tocar",
                    subtitle = "Pulso háptico rápido a cada tecla",
                    checked = vibrationEnabled,
                    onCheckedChange = { vibrationEnabled = it; prefs.vibrationEnabled = it }
                )

                if (vibrationEnabled) {
                    Text("Duração da vibração: ${vibrationMs} ms", color = Color.White.copy(alpha = 0.8f), fontSize = 12.sp)
                    Slider(
                        value = vibrationMs.toFloat(),
                        onValueChange = { vibrationMs = it.toInt(); prefs.vibrationDurationMs = it.toInt() },
                        valueRange = 8f..50f
                    )
                }
            }
        }

        // 6. Atalhos Rápidos (Snippets Pessoais)
        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Icon(Icons.Default.Bolt, contentDescription = null, tint = Color(0xFFFBBF24))
                    Text("Atalhos Rápidos (Snippets)", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                }
                Text("Digite o atalho (ex: /pix) + Espaço para colar sua frase automaticamente.", color = Color.White.copy(alpha = 0.65f), fontSize = 12.sp)

                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    OutlinedTextField(
                        value = snippetTrigger,
                        onValueChange = { snippetTrigger = it },
                        placeholder = { Text("/atalho") },
                        singleLine = true,
                        modifier = Modifier.weight(0.4f)
                    )
                    OutlinedTextField(
                        value = snippetText,
                        onValueChange = { snippetText = it },
                        placeholder = { Text("Texto completo...") },
                        singleLine = true,
                        modifier = Modifier.weight(0.6f)
                    )
                }
                Button(
                    onClick = {
                        if (snippetTrigger.isNotBlank() && snippetText.isNotBlank()) {
                            prefs.addSnippet(snippetTrigger, snippetText)
                            snippetTrigger = ""
                            snippetText = ""
                            onThemesMutated()
                            Toast.makeText(context, "Atalho salvo!", Toast.LENGTH_SHORT).show()
                        }
                    },
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("Adicionar Atalho")
                }

                snippets.forEach { (k, v) ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(10.dp))
                            .background(Color(0xFF1E2636))
                            .padding(horizontal = 10.dp, vertical = 6.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text(k, color = Color(0xFF93C5FD), fontWeight = FontWeight.Bold, fontSize = 13.sp)
                            Text(v, color = Color.White.copy(alpha = 0.8f), fontSize = 12.sp, maxLines = 1)
                        }
                        IconButton(onClick = { prefs.removeSnippet(k); onThemesMutated() }, modifier = Modifier.size(28.dp)) {
                            Icon(Icons.Default.Delete, contentDescription = "Remover", tint = Color(0xFFF87171), modifier = Modifier.size(18.dp))
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun SettingSwitchRow(
    title: String,
    subtitle: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f).padding(end = 8.dp)) {
            Text(title, color = Color.White, fontWeight = FontWeight.Medium, fontSize = 14.sp)
            Text(subtitle, color = Color.White.copy(alpha = 0.65f), fontSize = 11.5.sp)
        }
        Switch(checked = checked, onCheckedChange = onCheckedChange)
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
            Row(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .fillMaxWidth()
                    .padding(horizontal = 10.dp, vertical = 7.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Spacer(Modifier.width(8.dp))
                Box(modifier = Modifier.width(36.dp).height(5.dp).clip(RoundedCornerShape(4.dp)).background(Color.Gray.copy(alpha = 0.45f)))
                Box(modifier = Modifier.size(8.dp).clip(CircleShape).background(accentDot))
            }
            if (selected) {
                Box(
                    modifier = Modifier.align(Alignment.Center).size(26.dp).clip(CircleShape).background(Color(0xFF86EFAC)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.Default.Check, contentDescription = null, tint = Color(0xFF0A1F12), modifier = Modifier.size(16.dp))
                }
            }
        }
        Text(text = title, color = Color.White.copy(alpha = 0.82f), fontSize = 11.sp, maxLines = 1, textAlign = TextAlign.Center)
    }
}

@Composable
private fun AiAndLensTab(prefs: PrefsManager, status: PrismSystemStatus) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    var localInstalled by remember { mutableStateOf(HybridAiEngine.isLocalModelInstalled(prefs)) }
    var localSizeMb by remember { mutableLongStateOf(HybridAiEngine.getLocalModelSizeMb(prefs)) }
    var preferLocal by remember { mutableStateOf(prefs.preferLocalAi) }
    var modelUrlInput by remember { mutableStateOf(prefs.localModelUrl) }
    var modelTransferBusy by remember { mutableStateOf(false) }
    var modelProgress by remember { mutableIntStateOf(0) }
    var modelStatusMsg by remember { mutableStateOf<String?>(null) }

    var apiKeyInput by remember { mutableStateOf(prefs.apiKey) }
    var lensToggle by remember { mutableStateOf(prefs.lensEnabled) }
    var downloadedLangs by remember { mutableStateOf<Set<String>>(emptySet()) }
    var activeTargetLang by remember { mutableStateOf(prefs.targetLangCode) }
    var downloadingCode by remember { mutableStateOf<String?>(null) }

    val modelFilePicker = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocument()) { uri: Uri? ->
        if (uri != null) {
            scope.launch {
                modelTransferBusy = true
                modelProgress = 0
                modelStatusMsg = "Importando modelo local (.task / .bin)..."
                val res = HybridAiEngine.importLocalModelFromUri(context, prefs, uri) { pct -> modelProgress = pct }
                modelTransferBusy = false
                res.onSuccess {
                    localInstalled = true
                    localSizeMb = HybridAiEngine.getLocalModelSizeMb(prefs)
                    modelStatusMsg = "✓ IA Local Offline instalada ($localSizeMb MB)!"
                }.onFailure { err ->
                    modelStatusMsg = err.message
                }
            }
        }
    }

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
        Text("IA Local Offline & Idiomas", color = Color.White, fontSize = 24.sp, fontWeight = FontWeight.Bold)

        // 1. Card IA Local 100% Offline (MediaPipe / LiteRT Gemma)
        Surface(
            shape = RoundedCornerShape(18.dp),
            color = Color(0xFF161B26),
            border = BorderStroke(1.dp, if (localInstalled) Color(0xFF34D399) else Color(0xFF8B5CF6))
        ) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Icon(Icons.Default.Memory, contentDescription = null, tint = if (localInstalled) Color(0xFF34D399) else Color(0xFF8B5CF6))
                    Column {
                        Text("Cérebro IA Local (100% Offline)", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 15.sp)
                        Text(
                            if (localInstalled) "Instalado na memória ($localSizeMb MB) — roda sem internet!"
                            else "Roda direto no celular via MediaPipe/LiteRT sem chaves ou erro 404.",
                            color = if (localInstalled) Color(0xFF34D399) else Color.White.copy(alpha = 0.7f),
                            fontSize = 12.sp
                        )
                    }
                }

                SettingSwitchRow(
                    title = "Priorizar IA Local Offline",
                    subtitle = "Usa sempre o cérebro no aparelho antes da nuvem",
                    checked = preferLocal,
                    onCheckedChange = { preferLocal = it; prefs.preferLocalAi = it }
                )

                if (modelTransferBusy) {
                    LinearProgressIndicator(
                        progress = { modelProgress / 100f },
                        modifier = Modifier.fillMaxWidth(),
                        color = Color(0xFF8B5CF6)
                    )
                    Text("Progresso: $modelProgress%", color = Color(0xFFA5C4FF), fontSize = 12.sp)
                }

                if (modelStatusMsg != null) {
                    Text(modelStatusMsg!!, color = Color(0xFF93C5FD), fontSize = 12.sp)
                }

                if (!localInstalled) {
                    OutlinedTextField(
                        value = modelUrlInput,
                        onValueChange = { modelUrlInput = it; prefs.localModelUrl = it },
                        label = { Text("URL direta do modelo (.task / .bin)") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth()
                    )
                }

                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    if (!localInstalled) {
                        Button(
                            onClick = {
                                if (modelTransferBusy) return@Button
                                scope.launch {
                                    modelTransferBusy = true
                                    modelProgress = 0
                                    modelStatusMsg = "Baixando modelo local..."
                                    val res = HybridAiEngine.downloadLocalModel(context, prefs, modelUrlInput) { pct -> modelProgress = pct }
                                    modelTransferBusy = false
                                    res.onSuccess {
                                        localInstalled = true
                                        localSizeMb = HybridAiEngine.getLocalModelSizeMb(prefs)
                                        modelStatusMsg = "✓ IA Local baixada ($localSizeMb MB)!"
                                    }.onFailure { err ->
                                        modelStatusMsg = err.message
                                    }
                                }
                            },
                            enabled = !modelTransferBusy,
                            modifier = Modifier.weight(1f)
                        ) {
                            Icon(Icons.Default.Download, contentDescription = null, modifier = Modifier.size(16.dp))
                            Spacer(Modifier.width(6.dp))
                            Text("Baixar IA", fontSize = 12.sp)
                        }
                    }

                    OutlinedButton(
                        onClick = { if (!modelTransferBusy) modelFilePicker.launch(arrayOf("*/*")) },
                        enabled = !modelTransferBusy,
                        modifier = Modifier.weight(1f)
                    ) {
                        Icon(Icons.Default.FolderOpen, contentDescription = null, tint = Color(0xFF93C5FD), modifier = Modifier.size(16.dp))
                        Spacer(Modifier.width(6.dp))
                        Text(if (localInstalled) "Trocar .task" else "Importar .task", color = Color.White, fontSize = 12.sp)
                    }

                    if (localInstalled) {
                        OutlinedButton(
                            onClick = {
                                scope.launch {
                                    HybridAiEngine.deleteLocalModel(prefs)
                                    localInstalled = false
                                    localSizeMb = 0L
                                    modelStatusMsg = "Modelo local removido."
                                }
                            },
                            modifier = Modifier.weight(0.8f)
                        ) {
                            Text("Remover", color = Color(0xFFF87171), fontSize = 12.sp)
                        }
                    }
                }
            }
        }

        // 2. Lupa Flutuante
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
                        Text("Detecta idioma, traduz na hora, lê em voz alta e envia para resposta.", color = Color.White.copy(alpha = 0.7f), fontSize = 12.sp)
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
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        if (!status.canDrawOverlays) {
                            OutlinedButton(
                                onClick = {
                                    context.startActivity(Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:${context.packageName}")))
                                },
                                modifier = Modifier.weight(1f)
                            ) { Text("Sobreposição", color = Color.White, fontSize = 12.sp) }
                        }
                        if (!status.isAccessibilityEnabled) {
                            OutlinedButton(
                                onClick = { context.startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)) },
                                modifier = Modifier.weight(1f)
                            ) { Text("Acessibilidade", color = Color.White, fontSize = 12.sp) }
                        }
                    }
                }
            }
        }

        // 3. Fallback Nuvem Opcional (Gemini API)
        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Text("Modo Nuvem Opcional (Chave Gemini)", color = Color.White, fontWeight = FontWeight.Bold)
                OutlinedTextField(
                    value = apiKeyInput,
                    onValueChange = { apiKeyInput = it },
                    label = { Text("Chave API Gemini (opcional)") },
                    visualTransformation = PasswordVisualTransformation(),
                    singleLine = true,
                    modifier = Modifier.fillMaxWidth()
                )
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Button(
                        onClick = {
                            prefs.apiKey = apiKeyInput
                            Toast.makeText(context, "Chave salva!", Toast.LENGTH_SHORT).show()
                        },
                        modifier = Modifier.weight(1f)
                    ) { Text("Salvar Chave") }
                    OutlinedButton(
                        onClick = {
                            context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("https://aistudio.google.com/app/apikey")))
                        },
                        modifier = Modifier.weight(1f)
                    ) { Text("Obter Chave", color = Color.White) }
                }
            }
        }

        // 4. Todos os 13 Idiomas Offline
        Surface(shape = RoundedCornerShape(18.dp), color = Color(0xFF161B26)) {
            Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Text("Idiomas Offline (13 Idiomas)", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                Text(
                    "Baixe para traduzir sem internet no teclado e na Lupa Flutuante.",
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
                            .border(1.dp, if (isSelected) Color(0xFF8B5CF6) else Color.Transparent, RoundedCornerShape(12.dp))
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
                                if (isInstalled) "Baixado • Pronto offline" else "Disponível para download • ${pack.approxSizeMb}",
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
                                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF86EFAC)),
                                contentPadding = PaddingValues(horizontal = 14.dp, vertical = 4.dp)
                            ) {
                                Text("Baixar", color = Color(0xFF0A1F12), fontSize = 12.sp, fontWeight = FontWeight.Bold)
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
                    "O PrismKey não possui servidores próprios. Suas configurações, fotos recortadas, atalhos pessoais, modelo de IA local e pacotes de idiomas ficam exclusivamente na memória do seu aparelho.",
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
                Text("🛠️ Créditos", color = Color.White, fontWeight = FontWeight.Bold)
                Text(
                    "Este teclado foi feito por Davi e Pedro Paulo.\n\nO PrismKey é um teclado que visa mesclar as funções presentes nos teclados Keyvya do canal Tech World e do Gboard do Google, trazendo novas features.",
                    color = Color.White.copy(alpha = 0.85f),
                    fontSize = 13.5.sp
                )
                Text(
                    "PrismKey v1.4.0 • Licença Open Source: GNU GPL-3.0",
                    color = Color(0xFF7CA4FF),
                    fontSize = 12.sp,
                    fontWeight = FontWeight.SemiBold
                )
            }
        }
    }
}
EOF

# 19. PrismKeyUnitTest.kt (Testes unitários completos da v1.4.0)
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
    fun testAutoCorrectionTypos() {
        assertEquals("você", WordPredictor.autoCorrectWord("vc"))
        assertEquals("Também", WordPredictor.autoCorrectWord("Tambem"))
    }

    @Test
    fun testGlideTypingPrediction() {
        val predicted = WordPredictor.predictFromGlidePath("teclado")
        assertEquals("teclado", predicted)
    }

    @Test
    fun testSnippetExpansion() {
        val snippets = mapOf("/pix" to "chave@prismkey.com")
        assertEquals("chave@prismkey.com", WordPredictor.findSnippet("/pix", snippets))
    }

    @Test
    fun testAll13LanguagesPresent() {
        assertEquals(13, HybridAiEngine.availableLanguages.size)
        assertEquals("Coreano", HybridAiEngine.languageDisplayName("ko"))
        assertEquals("Árabe", HybridAiEngine.languageDisplayName("ar"))
        assertEquals("Vietnamita", HybridAiEngine.languageDisplayName("vi"))
    }

    @Test
    fun testEmptyInputReturnsEmpty() {
        assertTrue(WordPredictor.suggest("").isEmpty())
    }
}
EOF

# 20. Auditoria automática de integridade v1.4.0
echo "🔍 Executando auditoria automática de integridade PrismKey v1.4.0..."
REQUIRED_FILES=(
  "gradle.properties"
  "settings.gradle.kts"
  "build.gradle.kts"
  "app/build.gradle.kts"
  "app/src/main/AndroidManifest.xml"
  "app/src/main/res/xml/file_paths.xml"
  "app/src/main/java/com/prismkey/keyboard/MainActivity.kt"
  "app/src/main/java/com/prismkey/keyboard/data/PrefsManager.kt"
  "app/src/main/java/com/prismkey/keyboard/data/WordPredictor.kt"
  "app/src/main/java/com/prismkey/keyboard/data/EmojiKitchenEngine.kt"
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

for check in "android.permission.VIBRATE" "android.permission.RECORD_AUDIO" "RecognitionService" "FileProvider"; do
  if ! grep -q "$check" app/src/main/AndroidManifest.xml; then
    echo "❌ ERRO: Item obrigatório ausente no AndroidManifest.xml: $check"
    exit 1
  fi
done

for dep in "language-id" "tasks-genai" "translate"; do
  if ! grep -q "$dep" app/build.gradle.kts; then
    echo "❌ ERRO: Dependência obrigatória ausente no build.gradle.kts: $dep"
    exit 1
  fi
done

echo "✅ Auditoria completa concluída! PrismKey v1.4.0 pronto para compilar!"
