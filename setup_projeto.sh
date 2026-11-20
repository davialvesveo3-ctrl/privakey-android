#!/bin/bash
set -e

echo "💎 Configurando PrismKey v1.1.0..."

# Limpar estrutura anterior se existir
rm -rf app gradle build.gradle.kts settings.gradle.kts gradle.properties gradlew gradlew.bat

mkdir -p app/src/main/java/com/prismkey/keyboard/service
mkdir -p app/src/main/java/com/prismkey/keyboard/ui/theme
mkdir -p app/src/main/java/com/prismkey/keyboard/ui/screens
mkdir -p app/src/main/java/com/prismkey/keyboard/ui/keyboard
mkdir -p app/src/main/java/com/prismkey/keyboard/ai
mkdir -p app/src/main/java/com/prismkey/keyboard/data
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/xml
mkdir -p gradle/wrapper

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

# 3. build.gradle.kts (raiz)
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
        versionCode = 2
        versionName = "1.1.0"
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
    implementation("io.coil-kt:coil-compose:2.7.0")
    implementation("com.google.mlkit:translate:17.0.3")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.8.1")
}
EOF

# 5. AndroidManifest.xml
cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />

    <application
        android:allowBackup="true"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@android:style/Theme.Material.NoActionBar">

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

# 6. XML Resources
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

# 7. PrefsManager.kt (Configurações, Tema, Zoom/Offset da foto e Chave API)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/data/PrefsManager.kt
package com.prismkey.keyboard.data

import android.content.Context
import android.content.SharedPreferences

enum class PrismThemeMode(val title: String) {
    LIQUID_DARK("Prisma Cristal Escuro"),
    LIQUID_LIGHT("Prisma Cristal Claro"),
    DYNAMIC_WALLPAPER("Cores do Papel de Parede"),
    CUSTOM_IMAGE("Foto Personalizada")
}

class PrefsManager(context: Context) {
    private val prefs: SharedPreferences =
        context.getSharedPreferences("prismkey_prefs_v11", Context.MODE_PRIVATE)

    var apiKey: String
        get() = prefs.getString("gemini_api_key", "") ?: ""
        set(value) = prefs.edit().putString("gemini_api_key", value.trim()).apply()

    var themeMode: PrismThemeMode
        get() {
            val name = prefs.getString("theme_mode", PrismThemeMode.LIQUID_DARK.name)
            return runCatching { PrismThemeMode.valueOf(name!!) }.getOrDefault(PrismThemeMode.LIQUID_DARK)
        }
        set(value) = prefs.edit().putString("theme_mode", value.name).apply()

    var customImagePath: String?
        get() = prefs.getString("custom_image_path", null)
        set(value) = prefs.edit().putString("custom_image_path", value).apply()

    var imageScale: Float
        get() = prefs.getFloat("custom_image_scale", 1f)
        set(value) = prefs.edit().putFloat("custom_image_scale", value).apply()

    var imageOffsetX: Float
        get() = prefs.getFloat("custom_image_offset_x", 0f)
        set(value) = prefs.edit().putFloat("custom_image_offset_x", value).apply()

    var imageOffsetY: Float
        get() = prefs.getFloat("custom_image_offset_y", 0f)
        set(value) = prefs.edit().putFloat("custom_image_offset_y", value).apply()

    var overlayDimAlpha: Float
        get() = prefs.getFloat("overlay_dim_alpha", 0.45f)
        set(value) = prefs.edit().putFloat("overlay_dim_alpha", value).apply()

    var lensEnabled: Boolean
        get() = prefs.getBoolean("lens_enabled", false)
        set(value) = prefs.edit().putBoolean("lens_enabled", value).apply()

    var targetLangCode: String
        get() = prefs.getString("target_lang_code", "en") ?: "en"
        set(value) = prefs.edit().putString("target_lang_code", value).apply()

    fun clearAllLocalData() {
        prefs.edit().clear().apply()
    }
}
EOF

# 8. HybridAiEngine.kt (Motor Híbrido: Gemini 2.5 Flash na nuvem + ML Kit Offline)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/ai/HybridAiEngine.kt
package com.prismkey.keyboard.ai

import com.google.mlkit.common.model.DownloadConditions
import com.google.mlkit.common.model.RemoteModelManager
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

data class OfflineLangPack(
    val name: String,
    val code: String
)

object HybridAiEngine {

    val availableLanguages = listOf(
        OfflineLangPack("Inglês", TranslateLanguage.ENGLISH),
        OfflineLangPack("Espanhol", TranslateLanguage.SPANISH),
        OfflineLangPack("Francês", TranslateLanguage.FRENCH),
        OfflineLangPack("Alemão", TranslateLanguage.GERMAN),
        OfflineLangPack("Italiano", TranslateLanguage.ITALIAN),
        OfflineLangPack("Japonês", TranslateLanguage.JAPANESE)
    )

    suspend fun getDownloadedLanguageCodes(): Set<String> = withContext(Dispatchers.IO) {
        try {
            val models = RemoteModelManager.getInstance()
                .getDownloadedModels(TranslateRemoteModel::class.java)
                .await()
            models.map { it.language }.toSet()
        } catch (e: Exception) {
            emptySet()
        }
    }

    suspend fun downloadLanguagePack(langCode: String): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            val model = TranslateRemoteModel.Builder(langCode).build()
            val conditions = DownloadConditions.Builder().build()
            RemoteModelManager.getInstance().download(model, conditions).await()
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
        if (text.isBlank()) return@withContext Result.failure(Exception("Digite algo antes de traduzir."))
        try {
            val options = TranslatorOptions.Builder()
                .setSourceLanguage(sourceLang)
                .setTargetLanguage(targetLang)
                .build()
            val translator = Translation.getClient(options)
            val conditions = DownloadConditions.Builder().build()
            translator.downloadModelIfNeeded(conditions).await()
            val translated = translator.translate(text).await()
            translator.close()
            Result.success(translated)
        } catch (e: Exception) {
            Result.failure(Exception("Baixe o idioma na aba IA & Lupa para traduzir offline."))
        }
    }

    suspend fun runCloudGeminiAction(
        apiKey: String,
        actionType: String,
        inputText: String
    ): Result<String> = withContext(Dispatchers.IO) {
        if (apiKey.isBlank()) {
            return@withContext Result.failure(Exception("Configure sua Chave API Gemini no app PrismKey."))
        }
        if (inputText.isBlank()) {
            return@withContext Result.failure(Exception("Escreva ou cole um texto no campo primeiro."))
        }

        val prompt = when (actionType) {
            "CORRIGIR" -> "Corrija a ortografia, acentuação e pontuação do texto abaixo mantendo o mesmo tom e idioma. Retorne APENAS o texto corrigido, sem explicações:\n\n$inputText"
            "REESCREVER" -> "Reescreva o texto abaixo de forma mais clara, fluida e bem estruturada no mesmo idioma. Retorne APENAS o texto reescrito:\n\n$inputText"
            "RESPONDER" -> "Gere uma resposta natural, educada e contextual em português para a mensagem abaixo. Retorne APENAS a sugestão de resposta:\n\n$inputText"
            else -> inputText
        }

        try {
            val endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey"
            val url = URL(endpoint)
            val conn = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "POST"
                setRequestProperty("Content-Type", "application/json; charset=UTF-8")
                connectTimeout = 15000
                readTimeout = 20000
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

            val responseCode = conn.responseCode
            val stream = if (responseCode in 200..299) conn.inputStream else conn.errorStream
            val responseText = stream.bufferedReader().use { it.readText() }

            if (responseCode !in 200..299) {
                return@withContext Result.failure(Exception("Erro API ($responseCode): verifique sua chave ou internet."))
            }

            val json = JSONObject(responseText)
            val resultText = json
                .getJSONArray("candidates")
                .getJSONObject(0)
                .getJSONObject("content")
                .getJSONArray("parts")
                .getJSONObject(0)
                .getString("text")
                .trim()

            Result.success(resultText)
        } catch (e: Exception) {
            Result.failure(Exception("Sem conexão com a nuvem. Verifique sua internet."))
        }
    }
}
EOF

# 9. SystemStatusHelper.kt (Verificação em tempo real de Teclado, Padrão, Sobreposição e Acessibilidade)
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
# 10. PrismKeyboardView.kt (Teclado Jetpack Compose com Popup nativo sem sobreposição e IA funcional)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/ui/keyboard/PrismKeyboardView.kt
package com.prismkey.keyboard.ui.keyboard

import android.graphics.BitmapFactory
import android.os.Build
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
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
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Popup
import androidx.compose.ui.window.PopupProperties
import com.google.mlkit.nl.translate.TranslateLanguage
import com.prismkey.keyboard.ai.HybridAiEngine
import com.prismkey.keyboard.data.PrefsManager
import com.prismkey.keyboard.data.PrismThemeMode
import kotlinx.coroutines.launch
import java.io.File

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

@Composable
fun PrismKeyboardView(
    prefs: PrefsManager,
    onCommitText: (String) -> Unit,
    onDeleteChar: () -> Unit,
    onEnterPressed: () -> Unit,
    onGetCurrentFieldText: () -> String,
    onReplaceCurrentFieldText: (String) -> Unit,
    onOpenAppSettings: () -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    val systemDark = isSystemInDarkTheme()

    var isUpper by remember { mutableStateOf(false) }
    var isSymbolMode by remember { mutableStateOf(false) }
    var aiLoading by remember { mutableStateOf(false) }
    var statusBanner by remember { mutableStateOf<String?>(null) }
    var themeTick by remember { mutableIntStateOf(0) }

    val currentTheme = remember(themeTick) { prefs.themeMode }

    val dynamicBg = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        if (systemDark) dynamicDarkColorScheme(context).surfaceContainerHighest
        else dynamicLightColorScheme(context).surfaceContainerLow
    } else {
        Color(0xFF141824)
    }

    val containerBg = when (currentTheme) {
        PrismThemeMode.LIQUID_DARK -> Color(0xFF0E1117)
        PrismThemeMode.LIQUID_LIGHT -> Color(0xFFE9EEF5)
        PrismThemeMode.DYNAMIC_WALLPAPER -> dynamicBg
        PrismThemeMode.CUSTOM_IMAGE -> Color(0xFF0E1117)
    }

    val keyBg = when (currentTheme) {
        PrismThemeMode.LIQUID_LIGHT -> Color.White.copy(alpha = 0.88f)
        PrismThemeMode.CUSTOM_IMAGE -> Color(0xFF1B202C).copy(alpha = 0.72f)
        else -> Color(0xFF1E2433).copy(alpha = 0.85f)
    }

    val keyContentColor = if (currentTheme == PrismThemeMode.LIQUID_LIGHT) Color(0xFF12161F) else Color.White
    val borderBrush = Brush.verticalGradient(
        listOf(Color.White.copy(alpha = 0.25f), Color.White.copy(alpha = 0.05f))
    )

    val customBitmap = remember(themeTick) {
        val path = prefs.customImagePath
        if (currentTheme == PrismThemeMode.CUSTOM_IMAGE && !path.isNullOrBlank() && File(path).exists()) {
            BitmapFactory.decodeFile(path)?.asImageBitmap()
        } else null
    }

    val numberRow = listOf("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
    val alphaRows = listOf(
        listOf("q", "w", "e", "r", "t", "y", "u", "i", "o", "p"),
        listOf("a", "s", "d", "f", "g", "h", "j", "k", "l", "ç"),
        listOf("z", "x", "c", "v", "b", "n", "m")
    )
    val symbolRows = listOf(
        listOf("@", "#", "$", "_", "&", "-", "+", "(", ")", "/"),
        listOf("*", "\"", "'", ":", ";", "!", "?", "~", "`", "|"),
        listOf("\\", "{", "}", "[", "]", "<", ">")
    )

    fun triggerAi(action: String) {
        val currentText = onGetCurrentFieldText()
        if (currentText.isBlank()) {
            statusBanner = "Escreva algo no campo de texto antes de usar $action."
            return
        }
        aiLoading = true
        statusBanner = "Processando $action..."
        scope.launch {
            val res = if (action == "TRADUZIR") {
                HybridAiEngine.translateOffline(
                    text = currentText,
                    sourceLang = TranslateLanguage.PORTUGUESE,
                    targetLang = prefs.targetLangCode
                )
            } else {
                HybridAiEngine.runCloudGeminiAction(prefs.apiKey, action, currentText)
            }
            aiLoading = false
            res.onSuccess { output ->
                onReplaceCurrentFieldText(output)
                statusBanner = "✓ $action concluído!"
            }.onFailure { err ->
                statusBanner = err.message ?: "Falha na IA."
            }
        }
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
                modifier = Modifier
                    .matchParentSize()
                    .graphicsLayer {
                        scaleX = prefs.imageScale
                        scaleY = prefs.imageScale
                        translationX = prefs.imageOffsetX
                        translationY = prefs.imageOffsetY
                    }
            )
            Box(
                modifier = Modifier
                    .matchParentSize()
                    .background(Color.Black.copy(alpha = prefs.overlayDimAlpha))
            )
        }

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 4.dp, vertical = 6.dp),
            verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            if (statusBanner != null) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(10.dp))
                        .background(Color(0xFF283147).copy(alpha = 0.92f))
                        .padding(horizontal = 10.dp, vertical = 5.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(
                        text = statusBanner!!,
                        color = Color(0xFFDCE6FF),
                        fontSize = 12.sp,
                        modifier = Modifier.weight(1f)
                    )
                    Icon(
                        imageVector = Icons.Default.Close,
                        contentDescription = "Fechar aviso",
                        tint = Color.White.copy(alpha = 0.7f),
                        modifier = Modifier
                            .size(16.dp)
                            .clickable { statusBanner = null }
                    )
                }
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .horizontalScroll(rememberScrollState()),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                ToolbarChip(
                    icon = Icons.Default.AutoAwesome,
                    label = if (aiLoading) "Aguarde..." else "Corrigir",
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    onClick = { if (!aiLoading) triggerAi("CORRIGIR") }
                )
                ToolbarChip(
                    icon = Icons.Default.Reply,
                    label = "Responder",
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    onClick = { if (!aiLoading) triggerAi("RESPONDER") }
                )
                ToolbarChip(
                    icon = Icons.Default.EditNote,
                    label = "Reescrever",
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    onClick = { if (!aiLoading) triggerAi("REESCREVER") }
                )
                ToolbarChip(
                    icon = Icons.Default.Translate,
                    label = "Traduzir",
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    onClick = { if (!aiLoading) triggerAi("TRADUZIR") }
                )
                ToolbarChip(
                    icon = Icons.Default.Palette,
                    label = "Tema",
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    onClick = {
                        val values = PrismThemeMode.entries
                        val next = values[(currentTheme.ordinal + 1) % values.size]
                        prefs.themeMode = next
                        themeTick++
                        statusBanner = "Tema: ${next.title}"
                    }
                )
                ToolbarChip(
                    icon = Icons.Default.Settings,
                    label = "Ajustes",
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    onClick = onOpenAppSettings
                )
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                numberRow.forEach { num ->
                    PrismKeyCap(
                        label = num,
                        subLabel = null,
                        variants = emptyList(),
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        borderBrush = borderBrush,
                        modifier = Modifier.weight(1f).height(38.dp),
                        onKeyClick = { onCommitText(it) }
                    )
                }
            }

            val activeRows = if (isSymbolMode) symbolRows else alphaRows

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                activeRows[0].forEach { raw ->
                    val label = if (!isSymbolMode && isUpper) raw.uppercase() else raw
                    val variants = if (!isSymbolMode) {
                        (accentVariants[raw] ?: emptyList()).map { if (isUpper) it.uppercase() else it }
                    } else emptyList()
                    PrismKeyCap(
                        label = label,
                        subLabel = variants.lastOrNull(),
                        variants = variants,
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        borderBrush = borderBrush,
                        modifier = Modifier.weight(1f).height(46.dp),
                        onKeyClick = {
                            onCommitText(it)
                            if (isUpper) isUpper = false
                        }
                    )
                }
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                activeRows[1].forEach { raw ->
                    val label = if (!isSymbolMode && isUpper) raw.uppercase() else raw
                    val variants = if (!isSymbolMode) {
                        (accentVariants[raw] ?: emptyList()).map { if (isUpper) it.uppercase() else it }
                    } else emptyList()
                    PrismKeyCap(
                        label = label,
                        subLabel = variants.lastOrNull(),
                        variants = variants,
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        borderBrush = borderBrush,
                        modifier = Modifier.weight(1f).height(46.dp),
                        onKeyClick = {
                            onCommitText(it)
                            if (isUpper) isUpper = false
                        }
                    )
                }
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                ActionKeyCap(
                    icon = Icons.Default.KeyboardCapslock,
                    isActive = isUpper && !isSymbolMode,
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    modifier = Modifier.weight(1.35f).height(46.dp),
                    onClick = {
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
                        subLabel = variants.lastOrNull(),
                        variants = variants,
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        borderBrush = borderBrush,
                        modifier = Modifier.weight(1f).height(46.dp),
                        onKeyClick = {
                            onCommitText(it)
                            if (isUpper) isUpper = false
                        }
                    )
                }

                ActionKeyCap(
                    icon = Icons.AutoMirrored.Filled.Backspace,
                    isActive = false,
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    modifier = Modifier.weight(1.35f).height(46.dp),
                    onClick = onDeleteChar
                )
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                Box(
                    modifier = Modifier
                        .weight(1.4f)
                        .height(46.dp)
                        .clip(RoundedCornerShape(10.dp))
                        .background(keyBg)
                        .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                        .clickable { isSymbolMode = !isSymbolMode },
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = if (isSymbolMode) "ABC" else "?123",
                        color = keyContentColor,
                        fontWeight = FontWeight.SemiBold,
                        fontSize = 13.sp
                    )
                }

                PrismKeyCap(
                    label = ",",
                    subLabel = null,
                    variants = listOf(";", "!"),
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    borderBrush = borderBrush,
                    modifier = Modifier.weight(1f).height(46.dp),
                    onKeyClick = { onCommitText(it) }
                )

                Box(
                    modifier = Modifier
                        .weight(4.2f)
                        .height(46.dp)
                        .clip(RoundedCornerShape(10.dp))
                        .background(keyBg)
                        .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                        .clickable { onCommitText(" ") },
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "PrismKey • PT-BR",
                        color = keyContentColor.copy(alpha = 0.65f),
                        fontSize = 12.sp
                    )
                }

                PrismKeyCap(
                    label = ".",
                    subLabel = null,
                    variants = listOf("?", "!", ":", "-"),
                    keyBg = keyBg,
                    contentColor = keyContentColor,
                    borderBrush = borderBrush,
                    modifier = Modifier.weight(1f).height(46.dp),
                    onKeyClick = { onCommitText(it) }
                )

                Box(
                    modifier = Modifier
                        .weight(1.4f)
                        .height(46.dp)
                        .clip(RoundedCornerShape(10.dp))
                        .background(Color(0xFF4F7DF3))
                        .clickable { onEnterPressed() },
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

@Composable
private fun ToolbarChip(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    label: String,
    keyBg: Color,
    contentColor: Color,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .clip(RoundedCornerShape(20.dp))
            .background(keyBg)
            .clickable { onClick() }
            .padding(horizontal = 10.dp, vertical = 6.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Icon(imageVector = icon, contentDescription = null, tint = contentColor, modifier = Modifier.size(14.dp))
        Text(text = label, color = contentColor, fontSize = 12.sp, fontWeight = FontWeight.Medium)
    }
}

@Composable
private fun ActionKeyCap(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    isActive: Boolean# 12. PrismaLensAccessibilityService.kt (Nova Lupa Liquid Glass com Tradução Offline e Resposta IA)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/service/PrismaLensAccessibilityService.kt
package com.prismkey.keyboard.service

import android.accessibilityservice.AccessibilityService
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.graphics.PixelFormat
import android.provider.Settings
import android.view.Gravity
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import android.widget.Toast
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
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
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.*
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistryController
import androidx.savedstate.SavedStateRegistryOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import com.google.mlkit.nl.translate.TranslateLanguage
import com.prismkey.keyboard.ai.HybridAiEngine
import com.prismkey.keyboard.data.PrefsManager
import kotlinx.coroutines.launch
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
    private var layoutParams: WindowManager.LayoutParams? = null
    private lateinit var prefs: PrefsManager

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
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_START)
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_RESUME)
        if (prefs.lensEnabled) {
            showFloatingLens()
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}

    fun showFloatingLens() {
        if (!Settings.canDrawOverlays(this) || floatingView != null) return

        layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = 80
            y = 420
        }

        floatingView = ComposeView(this).apply {
            setViewTreeLifecycleOwner(this@PrismaLensAccessibilityService)
            setViewTreeViewModelStoreOwner(this@PrismaLensAccessibilityService)
            setViewTreeSavedStateRegistryOwner(this@PrismaLensAccessibilityService)

            setContent {
                PrismaLensBubbleUI(
                    onDrag = { dx, dy ->
                        layoutParams?.let { lp ->
                            lp.x += dx.roundToInt()
                            lp.y += dy.roundToInt()
                            windowManager?.updateViewLayout(floatingView, lp)
                        }
                    },
                    onCaptureScreenText = { captureVisibleScreenText() },
                    onCloseBubble = {
                        prefs.lensEnabled = false
                        hideFloatingLens()
                    }
                )
            }
        }

        windowManager?.addView(floatingView, layoutParams)
    }

    fun hideFloatingLens() {
        floatingView?.let {
            runCatching { windowManager?.removeView(it) }
            floatingView = null
        }
    }

    private fun captureVisibleScreenText(): String {
        val root = rootInActiveWindow ?: return ""
        val collected = mutableListOf<String>()
        fun traverse(node: AccessibilityNodeInfo?) {
            if (node == null) return
            val txt = node.text?.toString()?.trim()
            if (!txt.isNullOrBlank() && txt.length > 2) {
                collected.add(txt)
            }
            for (i in 0 until node.childCount) {
                traverse(node.getChild(i))
            }
        }
        traverse(root)
        return collected.takeLast(8).joinToString("\n")
    }

    override fun onDestroy() {
        instance = null
        hideFloatingLens()
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        store.clear()
        super.onDestroy()
    }
}

@Composable
private fun PrismaLensBubbleUI(
    onDrag: (Float, Float) -> Unit,
    onCaptureScreenText: () -> String,
    onCloseBubble: () -> Unit
) {
    val context = androidx.compose.ui.platform.LocalContext.current
    val prefs = remember { PrefsManager(context) }
    val scope = rememberCoroutineScope()

    var expanded by remember { mutableStateOf(false) }
    var capturedText by remember { mutableStateOf("") }
    var resultText by remember { mutableStateOf("") }
    var isProcessing by remember { mutableStateOf(false) }

    Column(
        horizontalAlignment = Alignment.Start,
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Surface(
            shape = CircleShape,
            color = Color(0xFF151C2E).copy(alpha = 0.90f),
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
                    if (expanded) {
                        capturedText = onCaptureScreenText()
                        resultText = ""
                    }
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
                shape = RoundedCornerShape(18.dp),
                color = Color(0xFF121726).copy(alpha = 0.96f),
                border = BorderStroke(1.dp, Color(0xFF3E5282)),
                shadowElevation = 14.dp,
                modifier = Modifier.width(290.dp)
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
                        Text(
                            text = "💎 Prisma Lens",
                            color = Color.White,
                            fontWeight = FontWeight.Bold,
                            fontSize = 14.sp
                        )
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            Text(
                                text = "Ocultar",
                                color = Color(0xFFF87171),
                                fontSize = 12.sp,
                                modifier = Modifier.clickable { onCloseBubble() }
                            )
                            Icon(
                                imageVector = Icons.Default.Close,
                                contentDescription = "Fechar",
                                tint = Color.White.copy(alpha = 0.7f),
                                modifier = Modifier
                                    .size(18.dp)
                                    .clickable { expanded = false }
                            )
                        }
                    }

                    Text(
                        text = if (capturedText.isBlank()) "Nenhum texto capturado na tela."
                        else capturedText.take(180),
                        color = Color.White.copy(alpha = 0.75f),
                        fontSize = 12.sp,
                        maxLines = 4
                    )

                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        Button(
                            onClick = {
                                isProcessing = true
                                scope.launch {
                                    val res = HybridAiEngine.translateOffline(
                                        text = capturedText,
                                        sourceLang = TranslateLanguage.ENGLISH,
                                        targetLang = TranslateLanguage.PORTUGUESE
                                    )
                                    isProcessing = false
                                    resultText = res.getOrElse { it.message ?: "Erro ao traduzir" }
                                }
                            },
                            modifier = Modifier.weight(1f),
                            contentPadding = PaddingValues(horizontal = 8.dp, vertical = 6.dp)
                        ) {
                            Text("Traduzir PT", fontSize = 12.sp)
                        }

                        OutlinedButton(
                            onClick = {
                                isProcessing = true
                                scope.launch {
                                    val res = HybridAiEngine.runCloudGeminiAction(
                                        apiKey = prefs.apiKey,
                                        actionType = "RESPONDER",
                                        inputText = capturedText
                                    )
                                    isProcessing = false
                                    resultText = res.getOrElse { it.message ?: "Erro na IA" }
                                }
                            },
                            modifier = Modifier.weight(1f),
                            contentPadding = PaddingValues(horizontal = 8.dp, vertical = 6.dp)
                        ) {
                            Text("Responder IA", fontSize = 12.sp, color = Color.White)
                        }
                    }

                    if (isProcessing) {
                        LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
                    }

                    if (resultText.isNotBlank()) {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(10.dp))
                                .background(Color(0xFF1D263B))
                                .padding(10.dp)
                        ) {
                            Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                                Text(text = resultText, color = Color(0xFFE2E8F0), fontSize = 12.sp)
                                Text(
                                    text = "📋 Copiar resultado",
                                    color = Color(0xFF7CA4FF),
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.SemiBold,
                                    modifier = Modifier.clickable {
                                        val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                                        cm.setPrimaryClip(ClipData.newPlainText("PrismKey", resultText))
                                        Toast.makeText(context, "Copiado!", Toast.LENGTH_SHORT).show()
                                    }
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

# 13. MainActivity.kt (Abas: Início com Status Dinâmico, Aparência com Zoom/Pan estilo Gboard, IA & Lupa Híbrida, Privacidade & Créditos)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/MainActivity.kt
package com.prismkey.keyboard

import android.content.Context
import android.content.Intent
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
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTransformGestures
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import com.prismkey.keyboard.ai.HybridAiEngine
import com.prismkey.keyboard.data.PrefsManager
import com.prismkey.keyboard.data.PrismSystemStatus
import com.prismkey.keyboard.data.PrismThemeMode
import com.prismkey.keyboard.data.SystemStatusHelper
import com.prismkey.keyboard.service.PrismaLensAccessibilityService
import kotlinx.coroutines.launch
import java.io.File
import java.io.FileOutputStream

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

    DisposableEffect(lifecycleOwner) {
        val observer = LifecycleEventObserver { _, event ->
            if (event == Lifecycle.Event.ON_RESUME) {
                status = SystemStatusHelper.checkStatus(context)
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose { lifecycleOwner.lifecycle.removeObserver(observer) }
    }

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
                    label = { Text("Aparência") }
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
                1 -> AppearanceTab(prefs = prefs)
                2 -> AiAndLensTab(prefs = prefs, status = status)
                3 -> AboutAndPrivacyTab(prefs = prefs)
            }
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
        Text("💎 PrismKey v1.1", color = Color.White, fontSize = 26.sp, fontWeight = FontWeight.Bold)

        Surface(
            shape = RoundedCornerShape(18.dp),
            color = Color(0xFF161B26),
