#!/usr/bin/env bash
set -euo pipefail

echo "Criando estrutura do projeto Android PrivaKey (Fase 3)..."

mkdir -p app/src/main/res/xml
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/java/com/privakey/keyboard/model
mkdir -p app/src/main/java/com/privakey/keyboard/data
mkdir -p app/src/main/java/com/privakey/keyboard/ai
mkdir -p app/src/main/java/com/privakey/keyboard/accessibility
mkdir -p app/src/main/java/com/privakey/keyboard/ime
mkdir -p app/src/main/java/com/privakey/keyboard/ui/onboarding
mkdir -p app/src/main/java/com/privakey/keyboard/ui/theme
mkdir -p app/src/main/java/com/privakey/keyboard/ui/keyboard

cat << 'EOF' > settings.gradle.kts
pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
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

rootProject.name = "PrivaKey"
include(":app")
EOF

cat << 'EOF' > build.gradle.kts
plugins {
    id("com.android.application") version "8.6.1" apply false
    id("org.jetbrains.kotlin.android") version "2.0.20" apply false
    id("org.jetbrains.kotlin.plugin.compose") version "2.0.20" apply false
}
EOF

cat << 'EOF' > gradle.properties
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
android.nonTransitiveRClass=true
EOF

cat << 'EOF' > app/build.gradle.kts
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "com.privakey.keyboard"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.privakey.keyboard"
        minSdk = 26
        targetSdk = 34
        versionCode = 3
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
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

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {
    val composeBom = platform("androidx.compose:compose-bom:2024.09.03")
    implementation(composeBom)

    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.activity:activity-compose:1.9.2")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.8.6")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.8.6")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.8.6")
    implementation("androidx.savedstate:savedstate-ktx:1.2.1")
    implementation("com.google.android.material:material:1.12.0")

    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")

    implementation("androidx.datastore:datastore-preferences:1.1.1")
    implementation("io.coil-kt:coil-compose:2.7.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.google.mlkit:translate:17.0.3")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.8.1")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")

    debugImplementation("androidx.compose.ui:ui-tooling")
}
EOF

cat << 'EOF' > app/proguard-rules.pro
# Regras padrão de ofuscação/otimização para PrivaKey
-keep class com.privakey.keyboard.** { *; }
EOF

cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />

    <application
        android:allowBackup="false"
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@drawable/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.PrivaKey">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <service
            android:name=".ime.TecladoIMEService"
            android:exported="true"
            android:label="PrivaKey PT-BR"
            android:permission="android.permission.BIND_INPUT_METHOD">
            <intent-filter>
                <action android:name="android.view.InputMethod" />
            </intent-filter>
            <meta-data
                android:name="android.view.im"
                android:resource="@xml/method" />
        </service>

        <service
            android:name=".accessibility.FloatingMagnifierService"
            android:exported="false"
            android:label="PrivaKey Lupa Tradutora"
            android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE">
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

cat << 'EOF' > app/src/main/res/values/strings.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">PrivaKey</string>
    <string name="magnifier_service_description">Permite que a Lupa Flutuante do PrivaKey leia o texto visível na tela sob demanda para tradução instantânea em Português.</string>
</resources>
EOF

cat << 'EOF' > app/src/main/res/values/themes.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.PrivaKey" parent="Theme.Material3.DayNight.NoActionBar">
        <item name="android:statusBarColor">#020617</item>
        <item name="android:navigationBarColor">#020617</item>
    </style>
</resources>
EOF

cat << 'EOF' > app/src/main/res/drawable/ic_launcher.xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#0F172A"
        android:pathData="M0,0h108v108h-108z" />
    <path
        android:fillColor="#0284C7"
        android:pathData="M24,34h60a8,8 0 0,1 8,8v28a8,8 0 0,1 -8,8h-60a8,8 0 0,1 -8,-8v-28a8,8 0 0,1 8,-8z" />
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M28,44h8v8h-8zM42,44h8v8h-8zM56,44h8v8h-8zM70,44h10v8h-10zM34,60h40v8h-40z" />
</vector>
EOF

cat << 'EOF' > app/src/main/res/drawable/ic_launcher_round.xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#0284C7"
        android:pathData="M54,4a50,50 0 1,0 0,100a50,50 0 1,0 0,-100z" />
    <path
        android:fillColor="#0F172A"
        android:pathData="M26,38h56a6,6 0 0,1 6,6v22a6,6 0 0,1 -6,6h-56a6,6 0 0,1 -6,-6v-22a6,6 0 0,1 6,-6z" />
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M30,46h8v6h-8zM44,46h8v6h-8zM58,46h8v6h-8zM72,46h6v6h-6zM36,58h36v6h-36z" />
</vector>
EOF

cat << 'EOF' > app/src/main/res/xml/method.xml
<?xml version="1.0" encoding="utf-8"?>
<input-method xmlns:android="http://schemas.android.com/apk/res/android"
    android:settingsActivity="com.privakey.keyboard.MainActivity"
    android:supportsSwitchingToNextInputMethod="true">

    <subtype
        android:icon="@drawable/ic_launcher"
        android:imeSubtypeLocale="pt_BR"
        android:imeSubtypeMode="keyboard"
        android:label="Português (Brasil) - QWERTY" />

</input-method>
EOF

cat << 'EOF' > app/src/main/res/xml/accessibility_service_config.xml
<?xml version="1.0" encoding="utf-8"?>
<accessibility-service xmlns:android="http://schemas.android.com/apk/res/android"
    android:accessibilityEventTypes="typeWindowStateChanged|typeWindowContentChanged"
    android:accessibilityFeedbackType="feedbackGeneric"
    android:accessibilityFlags="flagReportViewIds|flagRetrieveInteractiveWindows"
    android:canRetrieveWindowContent="true"
    android:description="@string/magnifier_service_description"
    android:notificationTimeout="120" />
EOF

cat << 'EOF' > app/src/main/java/com/privakey/keyboard/model/KeyboardTheme.kt
package com.privakey.keyboard.model

enum class KeyboardThemeType(val id: String, val displayName: String) {
    LIQUID_GLASS("liquid_glass", "Liquid Glass"),
    LIGHT("light", "Claro"),
    DARK("dark", "Escuro"),
    AUTO_SYSTEM("auto_system", "Automático do Sistema"),
    CUSTOM_PHOTO("custom_photo", "Foto Personalizada")
}

data class KeyboardThemeConfig(
    val themeType: KeyboardThemeType = KeyboardThemeType.LIQUID_GLASS,
    val customImagePath: String? = null,
    val backgroundDimPercent: Float = 45f,
    val showKeyBorders: Boolean = true,
    val geminiApiKey: String = "",
    val geminiModel: String = "gemini-2.5-flash",
    val magnifierEnabled: Boolean = false,
    val onboardingCompleted: Boolean = false,
    val localLearningEnabled: Boolean = true
)

enum class ShiftState { OFF, SHIFT, CAPS_LOCK }

enum class KeyboardLayer { LETTERS, SYMBOLS, EMOJIS }

enum class AiPanelMode { NONE, CORRECT, REWRITE, REPLY, TRANSLATE, MORE }

data class AiPreviewState(
    val isLoading: Boolean = false,
    val resultText: String? = null,
    val errorMessage: String? = null,
    val mode: AiPanelMode = AiPanelMode.NONE
)

object PtBrKeyboardData {
    val numberRow = listOf("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")

    val qwertyRows = listOf(
        listOf("q", "w", "e", "r", "t", "y", "u", "i", "o", "p"),
        listOf("a", "s", "d", "f", "g", "h", "j", "k", "l", "ç"),
        listOf("z", "x", "c", "v", "b", "n", "m")
    )

    val symbolRows = listOf(
        listOf("@", "#", "$", "_", "&", "-", "+", "(", ")", "/"),
        listOf("*", "\"", "'", ":", ";", "!", "?", "%", "="),
        listOf("~", "`", "|", "•", "√", "π", "÷")
    )

    val emojis = listOf(
        "😀", "😂", "🥰", "😎", "🤔", "🙏", "👍", "🔥",
        "✨", "🎉", "❤️", "👏", "🚀", "💡", "🇧🇷", "✅"
    )

    val accentsMap: Map<String, List<String>> = mapOf(
        "a" to listOf("á", "à", "ã", "â", "ä", "ª"),
        "e" to listOf("é", "ê", "è", "ë"),
        "i" to listOf("í", "ì", "î", "ï"),
        "o" to listOf("ó", "ô", "õ", "ò", "ö", "º"),
        "u" to listOf("ú", "ù", "û", "ü"),
        "c" to listOf("ç", "ć", "č"),
        "n" to listOf("ñ", "ń")
    )

    val rewritePresets = listOf("Profissional", "Carinhoso", "Resumido")
    val replyPresets = listOf("Confirmar", "Agradecer", "Recusar")
    val translateLanguages = listOf("Inglês", "Espanhol", "Francês", "Português")
}
EOF

cat << 'EOF' > app/src/main/java/com/privakey/keyboard/data/ThemePreferencesRepository.kt
package com.privakey.keyboard.data

import android.content.Context
import android.graphics.Bitmap
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.*
import androidx.datastore.preferences.preferencesDataStore
import com.privakey.keyboard.model.KeyboardThemeConfig
import com.privakey.keyboard.model.KeyboardThemeType
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileOutputStream

private val Context.keyboardDataStore: DataStore<Preferences> by preferencesDataStore(
    name = "privakey_theme_prefs"
)

class ThemePreferencesRepository(private val context: Context) {

    private object Keys {
        val THEME_TYPE = stringPreferencesKey("theme_type")
        val CUSTOM_IMAGE_PATH = stringPreferencesKey("custom_image_path")
        val BACKGROUND_DIM = floatPreferencesKey("background_dim_percent")
        val SHOW_KEY_BORDERS = booleanPreferencesKey("show_key_borders")
        val GEMINI_API_KEY = stringPreferencesKey("gemini_api_key")
        val GEMINI_MODEL = stringPreferencesKey("gemini_model")
        val MAGNIFIER_ENABLED = booleanPreferencesKey("magnifier_enabled")
        val ONBOARDING_COMPLETED = booleanPreferencesKey("onboarding_completed")
        val LOCAL_LEARNING = booleanPreferencesKey("local_learning_enabled")
    }

    val themeConfigFlow: Flow<KeyboardThemeConfig> = context.keyboardDataStore.data.map { prefs ->
        val themeId = prefs[Keys.THEME_TYPE] ?: KeyboardThemeType.LIQUID_GLASS.id
        val themeType = KeyboardThemeType.entries.firstOrNull { it.id == themeId }
            ?: KeyboardThemeType.LIQUID_GLASS

        KeyboardThemeConfig(
            themeType = themeType,
            customImagePath = prefs[Keys.CUSTOM_IMAGE_PATH],
            backgroundDimPercent = prefs[Keys.BACKGROUND_DIM] ?: 45f,
            showKeyBorders = prefs[Keys.SHOW_KEY_BORDERS] ?: true,
            geminiApiKey = prefs[Keys.GEMINI_API_KEY] ?: "",
            geminiModel = prefs[Keys.GEMINI_MODEL] ?: "gemini-2.5-flash",
            magnifierEnabled = prefs[Keys.MAGNIFIER_ENABLED] ?: false,
            onboardingCompleted = prefs[Keys.ONBOARDING_COMPLETED] ?: false,
            localLearningEnabled = prefs[Keys.LOCAL_LEARNING] ?: true
        )
    }

    suspend fun updateThemeType(type: KeyboardThemeType) {
        context.keyboardDataStore.edit { it[Keys.THEME_TYPE] = type.id }
    }

    suspend fun cycleQuickTheme() {
        val current = themeConfigFlow.first().themeType
        val order = listOf(
            KeyboardThemeType.LIQUID_GLASS,
            KeyboardThemeType.LIGHT,
            KeyboardThemeType.DARK,
            KeyboardThemeType.CUSTOM_PHOTO
        )
        val next = order[(order.indexOf(current).coerceAtLeast(0) + 1) % order.size]
        updateThemeType(next)
    }

    suspend fun updateBackgroundDim(dimPercent: Float) {
        context.keyboardDataStore.edit { it[Keys.BACKGROUND_DIM] = dimPercent.coerceIn(0f, 100f) }
    }

    suspend fun updateShowKeyBorders(show: Boolean) {
        context.keyboardDataStore.edit { it[Keys.SHOW_KEY_BORDERS] = show }
    }

    suspend fun updateGeminiConfig(apiKey: String, model: String) {
        context.keyboardDataStore.edit {
            it[Keys.GEMINI_API_KEY] = apiKey.trim()
            it[Keys.GEMINI_MODEL] = model
        }
    }

    suspend fun updateMagnifierEnabled(enabled: Boolean) {
        context.keyboardDataStore.edit { it[Keys.MAGNIFIER_ENABLED] = enabled }
    }

    suspend fun setOnboardingCompleted(completed: Boolean) {
        context.keyboardDataStore.edit { it[Keys.ONBOARDING_COMPLETED] = completed }
    }

    suspend fun updateLocalLearningEnabled(enabled: Boolean) {
        context.keyboardDataStore.edit { it[Keys.LOCAL_LEARNING] = enabled }
    }

    suspend fun clearAllLocalData() = withContext(Dispatchers.IO) {
        context.keyboardDataStore.edit { it.clear() }
        context.filesDir.listFiles()?.forEach { file ->
            if (file.name.startsWith("keyboard_bg_")) file.delete()
        }
    }

    suspend fun saveCroppedBackgroundBitmap(bitmap: Bitmap): String = withContext(Dispatchers.IO) {
        val file = File(context.filesDir, "keyboard_bg_${System.currentTimeMillis()}.jpg")
        context.filesDir.listFiles()?.forEach { existing ->
            if (existing.name.startsWith("keyboard_bg_") && existing.name.endsWith(".jpg")) {
                existing.delete()
            }
        }
        FileOutputStream(file).use { out -> bitmap.compress(Bitmap.CompressFormat.JPEG, 92, out) }
        context.keyboardDataStore.edit { prefs ->
            prefs[Keys.CUSTOM_IMAGE_PATH] = file.absolutePath
            prefs[Keys.THEME_TYPE] = KeyboardThemeType.CUSTOM_PHOTO.id
        }
        file.absolutePath
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/privakey/keyboard/ai/GeminiAiClient.kt
package com.privakey.keyboard.ai

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.TimeUnit

class GeminiAiClient {

    private val client = OkHttpClient.Builder()
        .connectTimeout(15, TimeUnit.SECONDS)
        .readTimeout(25, TimeUnit.SECONDS)
        .build()

    suspend fun correctText(apiKey: String, model: String, text: String) = generate(
        apiKey, model,
        "Corrija ortografia e gramática em Português (Brasil). Retorne APENAS o texto corrigido.",
        text
    )

    suspend fun rewriteText(apiKey: String, model: String, text: String, style: String) = generate(
        apiKey, model,
        "Reescreva o texto em Português (Brasil) no tom solicitado. Retorne APENAS o texto reescrito.",
        "Tom/Instrução: $style\nTexto: $text"
    )

    suspend fun generateReply(apiKey: String, model: String, copied: String, intent: String) = generate(
        apiKey, model,
        "Gere uma resposta curta e natural em Português (Brasil) pronta para enviar. Retorne APENAS a resposta.",
        "Intenção: $intent\nMensagem recebida: $copied"
    )

    suspend fun translateText(apiKey: String, model: String, text: String, lang: String) = generate(
        apiKey, model,
        "Traduza naturalmente para $lang. Retorne APENAS a tradução.",
        text
    )

    private suspend fun generate(
        apiKey: String,
        model: String,
        systemPrompt: String,
        userPrompt: String
    ): Result<String> = withContext(Dispatchers.IO) {
        if (apiKey.isBlank()) {
            return@withContext Result.failure(
                IllegalStateException("Adicione sua chave do Gemini na aba IA & Lupa do aplicativo.")
            )
        }
        runCatching {
            val url = "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey"
            val payload = JSONObject().apply {
                put("system_instruction", JSONObject().apply {
                    put("parts", JSONArray().put(JSONObject().put("text", systemPrompt)))
                })
                put("contents", JSONArray().put(JSONObject().apply {
                    put("role", "user")
                    put("parts", JSONArray().put(JSONObject().put("text", userPrompt)))
                }))
            }
            val request = Request.Builder()
                .url(url)
                .post(payload.toString().toRequestBody("application/json; charset=utf-8".toMediaType()))
                .build()

            client.newCall(request).execute().use { response ->
                val body = response.body?.string().orEmpty()
                if (!response.isSuccessful) throw IllegalStateException("Erro (${response.code})")
                JSONObject(body)
                    .getJSONArray("candidates")
                    .getJSONObject(0)
                    .getJSONObject("content")
                    .getJSONArray("parts")
                    .getJSONObject(0)
                    .getString("text")
                    .trim()
            }
        }
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/privakey/keyboard/accessibility/FloatingMagnifierService.kt
package com.privakey.keyboard.accessibility

import android.accessibilityservice.AccessibilityService
import android.graphics.PixelFormat
import android.provider.Settings
import android.view.Gravity
import android.view.MotionEvent
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import com.google.mlkit.common.model.DownloadConditions
import com.google.mlkit.nl.translate.TranslateLanguage
import com.google.mlkit.nl.translate.Translation
import com.google.mlkit.nl.translate.TranslatorOptions
import com.privakey.keyboard.ai.GeminiAiClient
import com.privakey.keyboard.data.ThemePreferencesRepository
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.tasks.await
import kotlin.math.abs

class FloatingMagnifierService : AccessibilityService() {

    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    private lateinit var windowManager: WindowManager
    private lateinit var repository: ThemePreferencesRepository
    private val geminiClient = GeminiAiClient()

    private var bubbleView: FrameLayout? = null
    private var translationCardView: LinearLayout? = null
    private var lastTapTimestamp = 0L

    override fun onServiceConnected() {
        super.onServiceConnected()
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        repository = ThemePreferencesRepository(applicationContext)

        serviceScope.launch {
            repository.themeConfigFlow.collect { config ->
                if (config.magnifierEnabled && Settings.canDrawOverlays(this@FloatingMagnifierService)) {
                    showMagnifierBubble()
                } else {
                    removeAllOverlays()
                }
            }
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) = Unit

    override fun onInterrupt() = removeAllOverlays()

    private fun showMagnifierBubble() {
        if (bubbleView != null) return

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.END
            x = 24
            y = 320
        }

        val bubble = FrameLayout(this).apply {
            setPadding(28, 28, 28, 28)
            setBackgroundColor(0xE60284C7.toInt())
            addView(TextView(context).apply {
                text = "🔍"
                textSize = 20f
            })
        }

        var initialX = 0
        var initialY = 0
        var touchX = 0f
        var touchY = 0f

        bubble.setOnTouchListener { _, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x; initialY = params.y
                    touchX = event.rawX; touchY = event.rawY
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    params.x = initialX - (event.rawX - touchX).toInt()
                    params.y = initialY + (event.rawY - touchY).toInt()
                    windowManager.updateViewLayout(bubble, params)
                    true
                }
                MotionEvent.ACTION_UP -> {
                    val moved = abs(event.rawX - touchX) > 12 || abs(event.rawY - touchY) > 12
                    if (!moved) {
                        val now = System.currentTimeMillis()
                        if (now - lastTapTimestamp < 320L) {
                            serviceScope.launch { repository.updateMagnifierEnabled(false) }
                            removeAllOverlays()
                        } else {
                            captureAndTranslateScreenText()
                        }
                        lastTapTimestamp = now
                    }
                    true
                }
                else -> false
            }
        }

        bubbleView = bubble
        windowManager.addView(bubble, params)
    }

    private fun captureAndTranslateScreenText() {
        val root = rootInActiveWindow ?: return
        val extracted = StringBuilder()
        collectVisibleText(root, extracted)
        val screenText = extracted.toString().trim().take(600)
        if (screenText.isEmpty()) {
            showTranslationBalloon("Nenhum texto visível encontrado nesta tela.")
            return
        }
        showTranslationBalloon("Traduzindo...")
        serviceScope.launch {
            val config = repository.themeConfigFlow.first()
            val translated = if (config.geminiApiKey.isNotBlank()) {
                geminiClient.translateText(config.geminiApiKey, config.geminiModel, screenText, "Português (Brasil)")
                    .getOrElse { translateOfflineWithMlKit(screenText) }
            } else {
                translateOfflineWithMlKit(screenText)
            }
            showTranslationBalloon(translated)
        }
    }

    private fun collectVisibleText(node: AccessibilityNodeInfo?, out: StringBuilder) {
        if (node == null || out.length > 600) return
        val text = node.text?.toString()?.trim()
        if (!text.isNullOrEmpty() && node.isVisibleToUser) out.append(text).append("\n")
        for (i in 0 until node.childCount) collectVisibleText(node.getChild(i), out)
    }

    private suspend fun translateOfflineWithMlKit(text: String): String = withContext(Dispatchers.IO) {
        runCatching {
            val options = TranslatorOptions.Builder()
                .setSourceLanguage(TranslateLanguage.ENGLISH)
                .setTargetLanguage(TranslateLanguage.PORTUGUESE)
                .build()
            val translator = Translation.getClient(options)
            translator.downloadModelIfNeeded(DownloadConditions.Builder().build()).await()
            val result = translator.translate(text).await()
            translator.close()
            result
        }.getOrElse { "Não foi possível traduzir offline." }
    }

    private fun showTranslationBalloon(translatedText: String) {
        translationCardView?.let { runCatching { windowManager.removeView(it) } }
        val card = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(36, 28, 36, 28)
            setBackgroundColor(0xF20F172A.toInt())
            addView(TextView(context).apply {
                text = "Lupa Tradutora · Toque para fechar"
                textSize = 12f
                setTextColor(0xFF38BDF8.toInt())
            })
            addView(TextView(context).apply {
                text = translatedText
                textSize = 15f
                setTextColor(0xFFF8FAFC.toInt())
                setPadding(0, 12, 0, 0)
            })
            setOnClickListener {
                runCatching { windowManager.removeView(this) }
                translationCardView = null
            }
        }
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.CENTER_HORIZONTAL
            y = 140
        }
        translationCardView = card
        windowManager.addView(card, params)
    }

    private fun removeAllOverlays() {
        bubbleView?.let { runCatching { windowManager.removeView(it) } }
        translationCardView?.let { runCatching { windowManager.removeView(it) } }
        bubbleView = null
        translationCardView = null
    }

    override fun onDestroy() {
        super.onDestroy()
        removeAllOverlays()
        serviceScope.cancel()
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/privakey/keyboard/ime/TecladoIMEService.kt
package com.privakey.keyboard.ime

import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.inputmethodservice.InputMethodService
import android.view.KeyEvent
import android.view.View
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.ExtractedTextRequest
import androidx.compose.runtime.*
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.lifecycle.*
import androidx.savedstate.*
import com.privakey.keyboard.MainActivity
import com.privakey.keyboard.ai.GeminiAiClient
import com.privakey.keyboard.data.ThemePreferencesRepository
import com.privakey.keyboard.model.*
import com.privakey.keyboard.ui.keyboard.KeyboardScreen
import kotlinx.coroutines.launch

class TecladoIMEService : InputMethodService(),
    LifecycleOwner,
    ViewModelStoreOwner,
    SavedStateRegistryOwner {

    private val lifecycleRegistry = LifecycleRegistry(this)
    private val store = ViewModelStore()
    private val savedStateRegistryController = SavedStateRegistryController.create(this)

    private lateinit var themeRepository: ThemePreferencesRepository
    private val geminiClient = GeminiAiClient()
    private val currentImeAction = mutableIntStateOf(EditorInfo.IME_ACTION_NONE)

    override val lifecycle: Lifecycle get() = lifecycleRegistry
    override val viewModelStore: ViewModelStore get() = store
    override val savedStateRegistry: SavedStateRegistry
        get() = savedStateRegistryController.savedStateRegistry

    override fun onCreate() {
        super.onCreate()
        savedStateRegistryController.performRestore(null)
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_CREATE)
        themeRepository = ThemePreferencesRepository(applicationContext)
    }

    override fun onCreateInputView(): View {
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_START)
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_RESUME)

        window?.window?.decorView?.let { decorView ->
            decorView.setViewTreeLifecycleOwner(this)
            decorView.setViewTreeViewModelStoreOwner(this)
            decorView.setViewTreeSavedStateRegistryOwner(this)
        }

        return ComposeView(this).apply {
            setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                val scope = rememberCoroutineScope()
                val themeConfig by themeRepository.themeConfigFlow.collectAsState(initial = KeyboardThemeConfig())
                var aiPreview by remember { mutableStateOf(AiPreviewState()) }

                KeyboardScreen(
                    themeConfig = themeConfig,
                    imeAction = currentImeAction.intValue,
                    aiPreview = aiPreview,
                    onCommitText = { currentInputConnection?.commitText(it, 1) },
                    onDeleteBackward = { deleteBackward() },
                    onEnterAction = { handleDynamicEnter() },
                    onRunAiAction = { mode, option ->
                        scope.launch {
                            val sourceText = if (mode == AiPanelMode.REPLY) readClipboardText() else readCurrentFieldText()
                            if (sourceText.isBlank()) {
                                aiPreview = AiPreviewState(mode = mode, errorMessage = "Nenhum texto encontrado.")
                                return@launch
                            }
                            aiPreview = AiPreviewState(isLoading = true, mode = mode)
                            val result = when (mode) {
                                AiPanelMode.CORRECT -> geminiClient.correctText(themeConfig.geminiApiKey, themeConfig.geminiModel, sourceText)
                                AiPanelMode.REWRITE -> geminiClient.rewriteText(themeConfig.geminiApiKey, themeConfig.geminiModel, sourceText, option)
                                AiPanelMode.REPLY -> geminiClient.generateReply(themeConfig.geminiApiKey, themeConfig.geminiModel, sourceText, option)
                                AiPanelMode.TRANSLATE -> geminiClient.translateText(themeConfig.geminiApiKey, themeConfig.geminiModel, sourceText, option)
                                else -> Result.success("")
                            }
                            aiPreview = result.fold(
                                onSuccess = { AiPreviewState(mode = mode, resultText = it) },
                                onFailure = { AiPreviewState(mode = mode, errorMessage = it.localizedMessage) }
                            )
                        }
                    },
                    onToggleMagnifier = {
                        scope.launch { themeRepository.updateMagnifierEnabled(!themeConfig.magnifierEnabled) }
                    },
                    onCycleTheme = {
                        scope.launch { themeRepository.cycleQuickTheme() }
                    },
                    onReplaceWithAiText = {
                        replaceCurrentFieldText(it)
                        aiPreview = AiPreviewState()
                    },
                    onDismissAiPreview = { aiPreview = AiPreviewState() },
                    onOpenSettings = {
                        startActivity(Intent(applicationContext, MainActivity::class.java).apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        })
                    }
                )
            }
        }
    }

    override fun onStartInputView(info: EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        currentImeAction.intValue = (info?.imeOptions ?: 0) and EditorInfo.IME_MASK_ACTION
    }

    private fun readCurrentFieldText(): String {
        val ic = currentInputConnection ?: return ""
        return ic.getExtractedText(ExtractedTextRequest(), 0)?.text?.toString().orEmpty()
    }

    private fun replaceCurrentFieldText(replacement: String) {
        val ic = currentInputConnection ?: return
        val current = readCurrentFieldText()
        if (current.isNotEmpty()) ic.setSelection(0, current.length)
        ic.commitText(replacement, 1)
    }

    private fun readClipboardText(): String {
        val cm = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        return cm.primaryClip?.getItemAt(0)?.coerceToText(this)?.toString().orEmpty()
    }

    private fun deleteBackward() {
        val ic = currentInputConnection ?: return
        val selected = ic.getSelectedText(0)
        if (selected.isNullOrEmpty()) ic.deleteSurroundingText(1, 0) else ic.commitText("", 1)
    }

    private fun handleDynamicEnter() {
        val ic = currentInputConnection ?: return
        val action = currentImeAction.intValue
        val handled = when (action) {
            EditorInfo.IME_ACTION_SEND, EditorInfo.IME_ACTION_SEARCH,
            EditorInfo.IME_ACTION_DONE, EditorInfo.IME_ACTION_NEXT -> ic.performEditorAction(action)
            else -> false
        }
        if (!handled) {
            ic.sendKeyEvent(KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_ENTER))
            ic.sendKeyEvent(KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_ENTER))
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        store.clear()
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/privakey/keyboard/ui/onboarding/OnboardingScreen.kt
package com.privakey.keyboard.ui.onboarding

import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun OnboardingScreen(onFinish: () -> Unit) {
    val context = LocalContext.current
    var step by remember { mutableIntStateOf(0) }
    var enabledInSystem by remember { mutableStateOf(false) }
    var selectedAsDefault by remember { mutableStateOf(false) }

    val slides = listOf(
        Triple("Teclado Inteligente com IA", "Corrija, reescreva, responda e traduza mensagens direto do teclado sem trocar de aplicativo.", Icons.Rounded.AutoFixHigh),
        Triple("Liquid Glass & Sua Foto", "Personalize com efeito vidro fosco ou qualquer foto da sua galeria com controle de escurecimento.", Icons.Rounded.Palette),
        Triple("Lupa Tradutora na Tela", "Traduza conversas em outros idiomas instantaneamente sobre qualquer app com um toque.", Icons.Rounded.Search)
    )

    Column(
        modifier = Modifier.fillMaxSize().padding(24.dp),
        verticalArrangement = Arrangement.SpaceBetween
    ) {
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
            TextButton(onClick = onFinish) { Text("Pular") }
        }

        if (step < 3) {
            val (title, subtitle, icon) = slides[step]
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Icon(icon, contentDescription = null, tint = Color(0xFF38BDF8), modifier = Modifier.size(64.dp))
                Text(title, fontSize = 24.sp, fontWeight = FontWeight.Bold)
                Text(subtitle, fontSize = 15.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }

            Button(
                onClick = { step++ },
                modifier = Modifier.fillMaxWidth().height(52.dp),
                shape = RoundedCornerShape(14.dp)
            ) {
                Text(if (step < 2) "Continuar" else "Configurar Teclado")
            }
        } else {
            Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                Text("Ative em 2 passos", fontSize = 24.sp, fontWeight = FontWeight.Bold)
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp), modifier = Modifier.fillMaxWidth()) {
                    Card(
                        onClick = {
                            context.startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS))
                            enabledInSystem = true
                        },
                        modifier = Modifier.weight(1f),
                        shape = RoundedCornerShape(16.dp)
                    ) {
                        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                            Icon(
                                if (enabledInSystem) Icons.Rounded.CheckCircle else Icons.Rounded.Settings,
                                contentDescription = null,
                                tint = if (enabledInSystem) Color(0xFF22C55E) else Color(0xFF38BDF8)
                            )
                            Text("1. Ativar no Sistema", fontWeight = FontWeight.SemiBold, fontSize = 14.sp)
                        }
                    }

                    Card(
                        onClick = {
                            val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                            imm.showInputMethodPicker()
                            selectedAsDefault = true
                        },
                        modifier = Modifier.weight(1f),
                        shape = RoundedCornerShape(16.dp)
                    ) {
                        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                            Icon(
                                if (selectedAsDefault) Icons.Rounded.CheckCircle else Icons.Rounded.Keyboard,
                                contentDescription = null,
                                tint = if (selectedAsDefault) Color(0xFF22C55E) else Color(0xFF38BDF8)
                            )
                            Text("2. Definir Padrão", fontWeight = FontWeight.SemiBold, fontSize = 14.sp)
                        }
                    }
                }
            }

            Button(
                onClick = onFinish,
                modifier = Modifier.fillMaxWidth().height(52.dp),
                shape = RoundedCornerShape(14.dp)
            ) {
                Text("Começar a Usar")
            }
        }
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/privakey/keyboard/ui/theme/ThemeEditorComponents.kt
package com.privakey.keyboard.ui.theme

import android.graphics.Bitmap
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.gestures.detectTransformGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlin.math.roundToInt

@Composable
fun KeyboardPhotoCropperDialog(
    sourceBitmap: Bitmap,
    onDismiss: () -> Unit,
    onConfirmCrop: (Bitmap) -> Unit
) {
    var scale by remember { mutableFloatStateOf(1f) }
    var offset by remember { mutableStateOf(Offset.Zero) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Enquadrar Foto do Teclado", fontWeight = FontWeight.SemiBold) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    text = "Arraste ou faça pinça para ajustar a área que aparecerá atrás das teclas.",
                    fontSize = 13.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .aspectRatio(16f / 9.5f)
                        .clip(RoundedCornerShape(12.dp))
                        .background(Color.Black)
                        .border(2.dp, Color(0xFF0284C7), RoundedCornerShape(12.dp))
                        .pointerInput(Unit) {
                            detectTransformGestures { _, pan, zoom, _ ->
                                scale = (scale * zoom).coerceIn(1f, 3f)
                                offset += pan
                            }
                        },
                    contentAlignment = Alignment.Center
                ) {
                    Image(
                        bitmap = sourceBitmap.asImageBitmap(),
                        contentDescription = "Prévia do recorte",
                        contentScale = ContentScale.Crop,
                        modifier = Modifier
                            .fillMaxSize()
                            .graphicsLayer(
                                scaleX = scale,
                                scaleY = scale,
                                translationX = offset.x,
                                translationY = offset.y
                            )
                    )
                }
            }
        },
        confirmButton = {
            Button(onClick = { onConfirmCrop(cropBitmapToKeyboardRatio(sourceBitmap, scale, offset)) }) {
                Text("Salvar Fundo")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text("Cancelar") }
        }
    )
}

private fun cropBitmapToKeyboardRatio(source: Bitmap, scale: Float, offset: Offset): Bitmap {
    val targetRatio = 16f / 9.5f
    val srcW = source.width.toFloat()
    val srcH = source.height.toFloat()
    val baseCropW = if (srcW / srcH > targetRatio) srcH * targetRatio else srcW
    val baseCropH = if (srcW / srcH > targetRatio) srcH else srcW / targetRatio
    val cropW = (baseCropW / scale).roundToInt().coerceIn(1, source.width)
    val cropH = (baseCropH / scale).roundToInt().coerceIn(1, source.height)
    val left = ((source.width / 2f) - (offset.x * 0.5f) - cropW / 2f).roundToInt().coerceIn(0, source.width - cropW)
    val top = ((source.height / 2f) - (offset.y * 0.5f) - cropH / 2f).roundToInt().coerceIn(0, source.height - cropH)
    return Bitmap.createBitmap(source, left, top, cropW, cropH)
}
EOF

cat << 'EOF' > app/src/main/java/com/privakey/keyboard/ui/keyboard/KeyboardScreen.kt
package com.privakey.keyboard.ui.keyboard

import android.graphics.BitmapFactory
import android.view.inputmethod.EditorInfo
import androidx.compose.foundation.*
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.rounded.Backspace
import androidx.compose.material.icons.automirrored.rounded.KeyboardReturn
import androidx.compose.material.icons.automirrored.rounded.Reply
import androidx.compose.material.icons.automirrored.rounded.Send
import androidx.compose.material.icons.rounded.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Popup
import com.privakey.keyboard.model.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

@Composable
fun KeyboardScreen(
    themeConfig: KeyboardThemeConfig,
    imeAction: Int,
    aiPreview: AiPreviewState,
    onCommitText: (String) -> Unit,
    onDeleteBackward: () -> Unit,
    onEnterAction: () -> Unit,
    onRunAiAction: (AiPanelMode, String) -> Unit,
    onToggleMagnifier: () -> Unit,
    onCycleTheme: () -> Unit,
    onReplaceWithAiText: (String) -> Unit,
    onDismissAiPreview: () -> Unit,
    onOpenSettings: () -> Unit,
    modifier: Modifier = Modifier
) {
    val isSystemDark = isSystemInDarkTheme()
    var shiftState by remember { mutableStateOf(ShiftState.OFF) }
    var layer by remember { mutableStateOf(KeyboardLayer.LETTERS) }
    var lastShiftTapTime by remember { mutableLongStateOf(0L) }
    var activeAccentKey by remember { mutableStateOf<String?>(null) }
    var activeMenu by remember { mutableStateOf(AiPanelMode.NONE) }

    val customBitmap = remember(themeConfig.customImagePath) {
        themeConfig.customImagePath?.let { runCatching { BitmapFactory.decodeFile(it)?.asImageBitmap() }.getOrNull() }
    }
    val palette = remember(themeConfig, isSystemDark) { resolvePalette(themeConfig, isSystemDark) }

    Box(modifier = modifier.fillMaxWidth().wrapContentHeight().background(palette.containerBg)) {
        if (themeConfig.themeType == KeyboardThemeType.CUSTOM_PHOTO && customBitmap != null) {
            Image(bitmap = customBitmap, contentDescription = null, contentScale = ContentScale.Crop, modifier = Modifier.matchParentSize())
            Box(modifier = Modifier.matchParentSize().background(Color.Black.copy(alpha = (themeConfig.backgroundDimPercent / 100f) * 0.92f)))
        } else if (themeConfig.themeType == KeyboardThemeType.LIQUID_GLASS) {
            Box(
                modifier = Modifier.matchParentSize()
                    .background(Brush.verticalGradient(listOf(Color(0xD9121826), Color(0xEB0B0F19))))
                    .border(0.75.dp, Color.White.copy(alpha = 0.14f))
            )
        }

        Column(
            modifier = Modifier.fillMaxWidth().padding(horizontal = 4.dp, vertical = 6.dp),
            verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()).height(36.dp),
                horizontalArrangement = Arrangement.spacedBy(4.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                ToolbarChip(Icons.Rounded.AutoAwesome, "IA", activeMenu == AiPanelMode.REWRITE, palette) {
                    activeMenu = if (activeMenu == AiPanelMode.REWRITE) AiPanelMode.NONE else AiPanelMode.REWRITE
                }
                ToolbarChip(Icons.AutoMirrored.Rounded.Reply, "Responder", activeMenu == AiPanelMode.REPLY, palette) {
                    activeMenu = if (activeMenu == AiPanelMode.REPLY) AiPanelMode.NONE else AiPanelMode.REPLY
                }
                ToolbarChip(Icons.Rounded.Spellcheck, "Corrigir", false, palette) {
                    activeMenu = AiPanelMode.NONE
                    onRunAiAction(AiPanelMode.CORRECT, "")
                }
                ToolbarChip(Icons.Rounded.AutoFixHigh, "Reescrever", activeMenu == AiPanelMode.REWRITE, palette) {
                    activeMenu = if (activeMenu == AiPanelMode.REWRITE) AiPanelMode.NONE else AiPanelMode.REWRITE
                }
                ToolbarChip(Icons.Rounded.Translate, "Traduzir", activeMenu == AiPanelMode.TRANSLATE, palette) {
                    activeMenu = if (activeMenu == AiPanelMode.TRANSLATE) AiPanelMode.NONE else AiPanelMode.TRANSLATE
                }
                ToolbarChip(Icons.Rounded.Search, "Lupa", themeConfig.magnifierEnabled, palette, onToggleMagnifier)
                ToolbarChip(Icons.Rounded.MoreHoriz, "Mais", activeMenu == AiPanelMode.MORE, palette) {
                    activeMenu = if (activeMenu == AiPanelMode.MORE) AiPanelMode.NONE else AiPanelMode.MORE
                }
            }

            if (activeMenu == AiPanelMode.MORE) {
                Row(
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 4.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Button(onClick = onCycleTheme, modifier = Modifier.weight(1f)) {
                        Icon(Icons.Rounded.Palette, contentDescription = null, modifier = Modifier.size(16.dp))
                        Spacer(Modifier.width(6.dp))
                        Text("Trocar Tema (${themeConfig.themeType.displayName})", fontSize = 12.sp)
                    }
                    OutlinedButton(onClick = onOpenSettings) {
                        Text("Ajustes", fontSize = 12.sp)
                    }
                }
            } else if (activeMenu != AiPanelMode.NONE) {
                val options = when (activeMenu) {
                    AiPanelMode.REWRITE -> PtBrKeyboardData.rewritePresets
                    AiPanelMode.REPLY -> PtBrKeyboardData.replyPresets
                    AiPanelMode.TRANSLATE -> PtBrKeyboardData.translateLanguages
                    else -> emptyList()
                }
                Row(modifier = Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()), horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                    options.forEach { opt ->
                        SuggestionChip(onClick = { onRunAiAction(activeMenu, opt); activeMenu = AiPanelMode.NONE }, label = { Text(opt, fontSize = 12.sp) })
                    }
                }
            }

            if (aiPreview.isLoading || aiPreview.resultText != null || aiPreview.errorMessage != null) {
                Surface(color = palette.popupBg, shape = RoundedCornerShape(10.dp), modifier = Modifier.fillMaxWidth()) {
                    Row(modifier = Modifier.padding(8.dp), verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        Text(aiPreview.resultText ?: aiPreview.errorMessage ?: "Processando...", color = palette.keyText, fontSize = 12.sp, modifier = Modifier.weight(1f))
                        if (aiPreview.resultText != null) {
                            Button(onClick = { onReplaceWithAiText(aiPreview.resultText) }) { Text("Substituir", fontSize = 11.sp) }
                        }
                        IconButton(onClick = onDismissAiPreview, modifier = Modifier.size(24.dp)) {
                            Icon(Icons.Rounded.Close, contentDescription = "Fechar", tint = palette.keyText)
                        }
                    }
                }
            }

            if (layer == KeyboardLayer.EMOJIS) {
                Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                    PtBrKeyboardData.emojis.chunked(8).forEach { row ->
                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                            row.forEach { emoji ->
                                KeyButton(emoji, palette, themeConfig.showKeyBorders, fontSize = 20f, modifier = Modifier.weight(1f).height(44.dp)) { onCommitText(emoji) }
                            }
                        }
                    }
                }
            } else {
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    PtBrKeyboardData.numberRow.forEach { num ->
                        KeyButton(num, palette, themeConfig.showKeyBorders, modifier = Modifier.weight(1f).height(34.dp)) { onCommitText(num) }
                    }
                }
                val rows = if (layer == KeyboardLayer.LETTERS) PtBrKeyboardData.qwertyRows else PtBrKeyboardData.symbolRows
                rows.take(2).forEach { row ->
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                        row.forEach { rawKey ->
                            val display = if (layer == KeyboardLayer.LETTERS && shiftState != ShiftState.OFF) rawKey.uppercase() else rawKey
                            KeyButtonWithAccents(rawKey, display, shiftState, palette, themeConfig.showKeyBorders, activeAccentKey == rawKey, { activeAccentKey = rawKey }, { activeAccentKey = null }, { ch ->
                                onCommitText(ch)
                                if (shiftState == ShiftState.SHIFT) shiftState = ShiftState.OFF
                            }, Modifier.weight(1f).height(44.dp))
                        }
                    }
                }
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    ActionKeyButton(if (shiftState == ShiftState.CAPS_LOCK) Icons.Rounded.KeyboardCapslock else Icons.Rounded.ArrowUpward, "Shift", palette, themeConfig.showKeyBorders, isActive = shiftState != ShiftState.OFF, modifier = Modifier.weight(1.45f).height(44.dp)) {
                        val now = System.currentTimeMillis()
                        shiftState = if (now - lastShiftTapTime < 350L) {
                            if (shiftState == ShiftState.CAPS_LOCK) ShiftState.OFF else ShiftState.CAPS_LOCK
                        } else {
                            if (shiftState == ShiftState.OFF) ShiftState.SHIFT else ShiftState.OFF
                        }
                        lastShiftTapTime = now
                    }
                    rows[2].forEach { rawKey ->
                        val display = if (layer == KeyboardLayer.LETTERS && shiftState != ShiftState.OFF) rawKey.uppercase() else rawKey
                        KeyButtonWithAccents(rawKey, display, shiftState, palette, themeConfig.showKeyBorders, activeAccentKey == rawKey, { activeAccentKey = rawKey }, { activeAccentKey = null }, { ch ->
                            onCommitText(ch)
                            if (shiftState == ShiftState.SHIFT) shiftState = ShiftState.OFF
                        }, Modifier.weight(1f).height(44.dp))
                    }
                    RepeatableBackspaceKey(palette, themeConfig.showKeyBorders, onDeleteBackward, Modifier.weight(1.45f).height(44.dp))
                }
            }

            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                KeyButton(if (layer == KeyboardLayer.LETTERS) "?123" else "ABC", palette, themeConfig.showKeyBorders, isSpecial = true, modifier = Modifier.weight(1.4f).height(44.dp)) {
                    layer = if (layer == KeyboardLayer.LETTERS) KeyboardLayer.SYMBOLS else KeyboardLayer.LETTERS
                }
                KeyButton("😀", palette, themeConfig.showKeyBorders, isSpecial = true, modifier = Modifier.weight(1f).height(44.dp)) {
                    layer = if (layer == KeyboardLayer.EMOJIS) KeyboardLayer.LETTERS else KeyboardLayer.EMOJIS
                }
                KeyButton("Português (BR)", palette, themeConfig.showKeyBorders, fontSize = 13f, modifier = Modifier.weight(4.4f).height(44.dp)) { onCommitText(" ") }
                KeyButton(".", palette, themeConfig.showKeyBorders, isSpecial = true, modifier = Modifier.weight(0.9f).height(44.dp)) { onCommitText(".") }
                ActionKeyButton(resolveEnterIcon(imeAction), "Enter", palette, themeConfig.showKeyBorders, isAccent = true, modifier = Modifier.weight(1.6f).height(44.dp), onClick = onEnterAction)
            }
        }
    }
}

@Composable
private fun ToolbarChip(icon: ImageVector, label: String, selected: Boolean, palette: KeyboardPalette, onClick: () -> Unit) {
    Row(
        modifier = Modifier.clip(RoundedCornerShape(8.dp))
            .background(if (selected) palette.accentBg.copy(alpha = 0.25f) else Color.Transparent)
            .clickable(onClick = onClick)
            .padding(horizontal = 8.dp, vertical = 5.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Icon(icon, contentDescription = label, tint = palette.toolbarIconTint, modifier = Modifier.size(15.dp))
        Text(label, color = palette.toolbarIconTint, fontSize = 11.sp, fontWeight = FontWeight.Medium)
    }
}

@Composable
private fun KeyButtonWithAccents(rawKey: String, label: String, shiftState: ShiftState, palette: KeyboardPalette, showBorder: Boolean, isPopupOpen: Boolean, onOpenPopup: () -> Unit, onDismissPopup: () -> Unit, onCommit: (String) -> Unit, modifier: Modifier = Modifier) {
    val accents = PtBrKeyboardData.accentsMap[rawKey.lowercase()].orEmpty()
    Box(modifier = modifier) {
        Surface(
            color = if (showBorder) palette.keyBg else Color.Transparent,
            shape = RoundedCornerShape(8.dp),
            border = if (showBorder && palette.keyBorder != Color.Transparent) BorderStroke(0.75.dp, palette.keyBorder) else null,
            modifier = Modifier.fillMaxSize().pointerInput(rawKey, shiftState) {
                detectTapGestures(onTap = { onCommit(label) }, onLongPress = { if (accents.isNotEmpty()) onOpenPopup() else onCommit(label) })
            }
        ) { Box(contentAlignment = Alignment.Center) { Text(label, color = palette.keyText, fontSize = 17.sp, fontWeight = FontWeight.Medium) } }
        if (isPopupOpen && accents.isNotEmpty()) {
            Popup(alignment = Alignment.TopCenter, onDismissRequest = onDismissPopup) {
                Row(modifier = Modifier.offset(y = (-50).dp).clip(RoundedCornerShape(12.dp)).background(palette.popupBg).border(1.dp, palette.keyBorder, RoundedCornerShape(12.dp)).padding(4.dp), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    accents.forEach { acc ->
                        val f = if (shiftState == ShiftState.OFF) acc else acc.uppercase()
                        Box(modifier = Modifier.size(34.dp).clip(RoundedCornerShape(8.dp)).clickable { onCommit(f); onDismissPopup() }, contentAlignment = Alignment.Center) {
                            Text(f, color = palette.keyText, fontSize = 17.sp, fontWeight = FontWeight.SemiBold)
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun KeyButton(label: String, palette: KeyboardPalette, showBorder: Boolean, isSpecial: Boolean = false, fontSize: Float = 16f, modifier: Modifier = Modifier, onClick: () -> Unit) {
    Surface(
        color = when { !showBorder -> Color.Transparent; isSpecial -> palette.specialKeyBg; else -> palette.keyBg },
        shape = RoundedCornerShape(8.dp),
        border = if (showBorder && palette.keyBorder != Color.Transparent) BorderStroke(0.75.dp, palette.keyBorder) else null,
        modifier = modifier.clickable(onClick = onClick)
    ) { Box(contentAlignment = Alignment.Center) { Text(label, color = palette.keyText, fontSize = fontSize.sp, fontWeight = FontWeight.Medium) } }
}

@Composable
private fun ActionKeyButton(icon: ImageVector, contentDescription: String, palette: KeyboardPalette, showBorder: Boolean, isActive: Boolean = false, isAccent: Boolean = false, modifier: Modifier = Modifier, onClick: () -> Unit) {
    Surface(
        color = when { isAccent -> palette.accentBg; isActive -> palette.accentBg.copy(alpha = 0.85f); !showBorder -> Color.Transparent; else -> palette.specialKeyBg },
        shape = RoundedCornerShape(8.dp),
        modifier = modifier.clickable(onClick = onClick)
    ) { Box(contentAlignment = Alignment.Center) { Icon(icon, contentDescription = contentDescription, tint = if (isAccent || isActive) Color.White else palette.keyText, modifier = Modifier.size(19.dp)) } }
}

@Composable
private fun RepeatableBackspaceKey(palette: KeyboardPalette, showBorder: Boolean, onDelete: () -> Unit, modifier: Modifier = Modifier) {
    val scope = rememberCoroutineScope()
    Surface(
        color = if (showBorder) palette.specialKeyBg else Color.Transparent,
        shape = RoundedCornerShape(8.dp),
        modifier = modifier.pointerInput(Unit) {
            detectTapGestures(onPress = {
                val job = scope.launch { onDelete(); delay(380L); while (true) { onDelete(); delay(55L) } }
                tryAwaitRelease(); job.cancel()
            })
        }
    ) { Box(contentAlignment = Alignment.Center) { Icon(Icons.AutoMirrored.Rounded.Backspace, contentDescription = "Apagar", tint = palette.keyText, modifier = Modifier.size(19.dp)) } }
}

private fun resolveEnterIcon(imeAction: Int): ImageVector = when (imeAction) {
    EditorInfo.IME_ACTION_SEND -> Icons.AutoMirrored.Rounded.Send
    EditorInfo.IME_ACTION_SEARCH -> Icons.Rounded.Search
    EditorInfo.IME_ACTION_DONE -> Icons.Rounded.Check
    EditorInfo.IME_ACTION_NEXT -> Icons.Rounded.ArrowForward
    else -> Icons.AutoMirrored.Rounded.KeyboardReturn
}

private data class KeyboardPalette(val containerBg: Color, val keyBg: Color, val specialKeyBg: Color, val keyBorder: Color, val keyText: Color, val toolbarIconTint: Color, val accentBg: Color, val popupBg: Color)

private fun resolvePalette(config: KeyboardThemeConfig, isSystemDark: Boolean): KeyboardPalette {
    val effective = if (config.themeType == KeyboardThemeType.AUTO_SYSTEM) {
        if (isSystemDark) KeyboardThemeType.DARK else KeyboardThemeType.LIGHT
    } else config.themeType
    return when (effective) {
        KeyboardThemeType.LIQUID_GLASS -> KeyboardPalette(Color.Transparent, Color.White.copy(alpha = 0.11f), Color.White.copy(alpha = 0.06f), Color.White.copy(alpha = 0.18f), Color.White, Color(0xFFE2E8F0), Color(0xFF0284C7), Color(0xF01E293B))
        KeyboardThemeType.LIGHT -> KeyboardPalette(Color(0xFFECEFF4), Color.White, Color(0xFFD8DEE9), Color(0x1F0F172A), Color(0xFF0F172A), Color(0xFF334155), Color(0xFF0284C7), Color.White)
        KeyboardThemeType.DARK -> KeyboardPalette(Color(0xFF111318), Color(0xFF232731), Color(0xFF1A1D24), Color.Transparent, Color(0xFFF8FAFC), Color(0xFFCBD5E1), Color(0xFF0284C7), Color(0xFF2D3340))
        else -> KeyboardPalette(Color(0xFF0B0F19), Color.Black.copy(alpha = 0.34f), Color.Black.copy(alpha = 0.48f), Color.White.copy(alpha = 0.22f), Color.White, Color.White, Color(0xFF0284C7), Color(0xEB0F172A))
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/privakey/keyboard/MainActivity.kt
package com.privakey.keyboard

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.ImageDecoder
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.privakey.keyboard.data.ThemePreferencesRepository
import com.privakey.keyboard.model.*
import com.privakey.keyboard.ui.onboarding.OnboardingScreen
import com.privakey.keyboard.ui.theme.KeyboardPhotoCropperDialog
import kotlinx.coroutines.launch
import kotlin.math.roundToInt

private enum class HomeTab(val label: String, val icon: ImageVector) {
    HOME("Início", Icons.Rounded.Home),
    APPEARANCE("Aparência", Icons.Rounded.Palette),
    AI_LENS("IA & Lupa", Icons.Rounded.AutoAwesome),
    PRIVACY("Privacidade", Icons.Rounded.Shield)
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val repository = ThemePreferencesRepository(applicationContext)

        setContent {
            MaterialTheme(colorScheme = darkColorScheme()) {
                Surface(modifier = Modifier.fillMaxSize(), color = Color(0xFF020617)) {
                    val scope = rememberCoroutineScope()
                    val config by repository.themeConfigFlow.collectAsState(initial = KeyboardThemeConfig())

                    if (!config.onboardingCompleted) {
                        OnboardingScreen(
                            onFinish = { scope.launch { repository.setOnboardingCompleted(true) } }
                        )
                    } else {
                        PrivaKeyMainShell(repository = repository, config = config)
                    }
                }
            }
        }
    }
}

@Composable
private fun PrivaKeyMainShell(
    repository: ThemePreferencesRepository,
    config: KeyboardThemeConfig
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    var currentTab by remember { mutableStateOf(HomeTab.HOME) }
    var testText by remember { mutableStateOf("") }
    var apiKeyInput by remember(config.geminiApiKey) { mutableStateOf(config.geminiApiKey) }
    var selectedModel by remember(config.geminiModel) { mutableStateOf(config.geminiModel) }
    var pendingBitmap by remember { mutableStateOf<Bitmap?>(null) }

    val galleryPicker = rememberLauncherForActivityResult(ActivityResultContracts.PickVisualMedia()) { uri ->
        if (uri != null) {
            pendingBitmap = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                ImageDecoder.decodeBitmap(ImageDecoder.createSource(context.contentResolver, uri)) { d, _, _ -> d.isMutableRequired = true }
            } else {
                @Suppress("DEPRECATION")
                MediaStore.Images.Media.getBitmap(context.contentResolver, uri)
            }
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 20.dp, vertical = 20.dp)
                .padding(bottom = 96.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Text(currentTab.label, fontSize = 26.sp, fontWeight = FontWeight.Bold, color = Color.White)

            when (currentTab) {
                HomeTab.HOME -> {
                    Card(shape = RoundedCornerShape(16.dp)) {
                        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                            Text("Status do Teclado", fontWeight = FontWeight.SemiBold)
                            Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                                Button(onClick = { context.startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS)) }, modifier = Modifier.weight(1f)) {
                                    Text("Ativar", fontSize = 13.sp)
                                }
                                OutlinedButton(onClick = {
                                    val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                                    imm.showInputMethodPicker()
                                }, modifier = Modifier.weight(1f)) {
                                    Text("Definir Padrão", fontSize = 13.sp)
                                }
                            }
                        }
                    }

                    OutlinedTextField(
                        value = testText,
                        onValueChange = { testText = it },
                        label = { Text("Toque aqui para testar seu teclado") },
                        modifier = Modifier.fillMaxWidth()
                    )
                }

                HomeTab.APPEARANCE -> {
                    Card(shape = RoundedCornerShape(16.dp)) {
                        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                            Text("Temas", fontWeight = FontWeight.SemiBold)
                            KeyboardThemeType.entries.forEach { type ->
                                Row(
                                    modifier = Modifier.fillMaxWidth().clickable { scope.launch { repository.updateThemeType(type) } }.padding(vertical = 4.dp),
                                    verticalAlignment = Alignment.CenterVertically,
                                    horizontalArrangement = Arrangement.SpaceBetween
                                ) {
                                    Text(type.displayName)
                                    RadioButton(selected = config.themeType == type, onClick = { scope.launch { repository.updateThemeType(type) } })
                                }
                            }
                            Button(
                                onClick = { galleryPicker.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)) },
                                modifier = Modifier.fillMaxWidth()
                            ) { Text("Escolher Foto da Galeria") }

                            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                                Text("Escurecimento do Fundo", fontSize = 14.sp)
                                Text("${config.backgroundDimPercent.roundToInt()}%", fontSize = 14.sp)
                            }
                            Slider(value = config.backgroundDimPercent, onValueChange = { scope.launch { repository.updateBackgroundDim(it) } }, valueRange = 0f..100f)

                            Row(modifier = Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.SpaceBetween) {
                                Text("Bordas das Teclas", fontSize = 14.sp)
                                Switch(checked = config.showKeyBorders, onCheckedChange = { scope.launch { repository.updateShowKeyBorders(it) } })
                            }
                        }
                    }
                }

                HomeTab.AI_LENS -> {
                    Card(shape = RoundedCornerShape(16.dp)) {
                        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
                            Row(modifier = Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.SpaceBetween) {
                                Column(modifier = Modifier.weight(1f)) {
                                    Text("Lupa Flutuante Tradutora", fontWeight = FontWeight.SemiBold)
                                    Text("Toque duplo na bolha fecha rapidamente.", fontSize = 12.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                                }
                                Switch(checked = config.magnifierEnabled, onCheckedChange = { scope.launch { repository.updateMagnifierEnabled(it) } })
                            }
                            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                OutlinedButton(
                                    onClick = { context.startActivity(Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:${context.packageName}"))) },
                                    modifier = Modifier.weight(1f)
                                ) { Text("Sobreposição", fontSize = 12.sp) }
                                OutlinedButton(
                                    onClick = { context.startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)) },
                                    modifier = Modifier.weight(1f)
                                ) { Text("Acessibilidade", fontSize = 12.sp) }
                            }
                        }
                    }

                    Card(shape = RoundedCornerShape(16.dp)) {
                        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                            Text("Inteligência Artificial", fontWeight = FontWeight.SemiBold)
                            OutlinedTextField(
                                value = apiKeyInput,
                                onValueChange = { apiKeyInput = it },
                                label = { Text("Chave API Gemini") },
                                visualTransformation = PasswordVisualTransformation(),
                                singleLine = true,
                                modifier = Modifier.fillMaxWidth()
                            )
                            Button(
                                onClick = { scope.launch { repository.updateGeminiConfig(apiKeyInput, selectedModel) } },
                                modifier = Modifier.fillMaxWidth()
                            ) { Text("Salvar Chave ($selectedModel)") }
                        }
                    }
                }

                HomeTab.PRIVACY -> {
                    Card(shape = RoundedCornerShape(16.dp)) {
                        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
                            Text("100% Local-First", fontWeight = FontWeight.SemiBold)
                            Text("Sem nuvem e sem registro de senhas. Suas preferências ficam apenas neste aparelho.", fontSize = 13.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                            Row(modifier = Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.SpaceBetween) {
                                Text("Aprendizado local de palavras", fontSize = 14.sp)
                                Switch(checked = config.localLearningEnabled, onCheckedChange = { scope.launch { repository.updateLocalLearningEnabled(it) } })
                            }
                            Button(
                                onClick = { scope.launch { repository.clearAllLocalData() } },
                                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFDC2626)),
                                modifier = Modifier.fillMaxWidth()
                            ) { Text("Apagar todos os dados locais") }
                        }
                    }
                }
            }
        }

        Row(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .padding(horizontal = 20.dp, vertical = 16.dp)
                .clip(RoundedCornerShape(32.dp))
                .background(Color(0xCC0F172A))
                .border(1.dp, Color.White.copy(alpha = 0.16f), RoundedCornerShape(32.dp))
                .padding(horizontal = 10.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.spacedBy(6.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            HomeTab.entries.forEach { tab ->
                val selected = tab == currentTab
                Column(
                    modifier = Modifier
                        .clip(RoundedCornerShape(24.dp))
                        .background(if (selected) Color(0xFF0284C7).copy(alpha = 0.28f) else Color.Transparent)
                        .clickable { currentTab = tab }
                        .padding(horizontal = 14.dp, vertical = 6.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(tab.icon, contentDescription = tab.label, tint = if (selected) Color(0xFF38BDF8) else Color(0xFF94A3B8), modifier = Modifier.size(20.dp))
                    Text(tab.label, fontSize = 10.sp, color = if (selected) Color.White else Color(0xFF94A3B8), fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Normal)
                }
            }
        }
    }

    pendingBitmap?.let { bmp ->
        KeyboardPhotoCropperDialog(
            sourceBitmap = bmp,
            onDismiss = { pendingBitmap = null },
            onConfirmCrop = { cropped ->
                pendingBitmap = null
                scope.launch { repository.saveCroppedBackgroundBitmap(cropped) }
            }
        )
    }
}
EOF

echo "Projeto Android PrivaKey criado com sucesso! Pronto para compilar no Gradle / GitHub Actions."
