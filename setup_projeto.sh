#!/bin/bash
set -e

echo "💎 Configurando PrismKey v1.1.0 Completo (Auditado e Corrigido)..."

rm -rf app gradle build.gradle.kts settings.gradle.kts gradle.properties gradlew gradlew.bat

mkdir -p app/src/main/java/com/prismkey/keyboard/service
mkdir -p app/src/main/java/com/prismkey/keyboard/ui/keyboard
mkdir -p app/src/main/java/com/prismkey/keyboard/ai
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
    implementation("com.google.mlkit:translate:17.0.3")
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

# 6. AndroidManifest.xml (100% PrismKey)
cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />

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

# 8. PrefsManager.kt
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

# 9. WordPredictor.kt (Sugestões em tempo real com suporte completo a acentos)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/data/WordPredictor.kt
package com.prismkey.keyboard.data

object WordPredictor {
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
        "valeu", "vamos", "verdade", "versão", "vez", "vezes", "vídeo", "visual", "você", "vocês",
        "voltar", "vou", "zoom"
    )

    fun suggest(currentWord: String): List<String> {
        val clean = currentWord.trim()
        if (clean.isEmpty()) return emptyList()
        val lower = clean.lowercase()
        val lowerNoAccent = stripAccents(lower)
        val isCapitalized = clean.first().isUpperCase()

        val exactMatches = ptDictionary.filter { it.startsWith(lower) && it != lower }
        val accentMatches = ptDictionary.filter {
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

# 10. HybridAiEngine.kt
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

data class OfflineLangPack(val name: String, val code: String)

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
            val model = TranslateRemoteModel.Builder(langCode).build()
            RemoteModelManager.getInstance().download(model, DownloadConditions.Builder().build()).await()
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
            translator.downloadModelIfNeeded(DownloadConditions.Builder().build()).await()
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

        var conn: HttpURLConnection? = null
        try {
            val endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey"
            conn = (URL(endpoint).openConnection() as HttpURLConnection).apply {
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

            val resultText = JSONObject(responseText)
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
        } finally {
            conn?.disconnect()
        }
    }
}
EOF

# 11. SystemStatusHelper.kt
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

# 12. PrismKeyboardView.kt
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
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
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
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Popup
import androidx.compose.ui.window.PopupProperties
import com.google.mlkit.nl.translate.TranslateLanguage
import com.prismkey.keyboard.ai.HybridAiEngine
import com.prismkey.keyboard.data.PrefsManager
import com.prismkey.keyboard.data.PrismThemeMode
import com.prismkey.keyboard.data.WordPredictor
import com.prismkey.keyboard.service.PrismaLensAccessibilityService
import kotlinx.coroutines.delay
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

@Composable
fun PrismKeyboardView(
    prefs: PrefsManager,
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

    var aiLoading by remember { mutableStateOf(false) }
    var statusBanner by remember { mutableStateOf<String?>(null) }
    var themeTick by remember { mutableIntStateOf(0) }

    var currentTypingWord by remember { mutableStateOf("") }
    var forceShowTools by remember { mutableStateOf(false) }

    val suggestions = remember(currentTypingWord) {
        WordPredictor.suggest(currentTypingWord)
    }
    val showSuggestionBar = currentTypingWord.isNotBlank() && suggestions.isNotEmpty() && !forceShowTools

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

    fun onCharTyped(typed: String) {
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

    fun readFullClipboardUnlimited(): String {
        val cm = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = cm.primaryClip ?: return ""
        if (clip.itemCount == 0) return ""
        return clip.getItemAt(0).coerceToText(context)?.toString() ?: ""
    }

    fun triggerAi(action: String) {
        val currentText = onGetCurrentFieldText()
        if (currentText.isBlank()) {
            statusBanner = "Escreva algo no campo antes de usar $action."
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
                currentTypingWord = ""
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
                        .background(Color(0xFF283147).copy(alpha = 0.94f))
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
                        contentDescription = "Fechar",
                        tint = Color.White.copy(alpha = 0.7f),
                        modifier = Modifier
                            .size(16.dp)
                            .clickable { statusBanner = null }
                    )
                }
            }

            AnimatedContent(
                targetState = showSuggestionBar,
                transitionSpec = { fadeIn() togetherWith fadeOut() },
                label = "TopBarSwitch"
            ) { isSuggesting ->
                if (isSuggesting) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(40.dp)
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
                            Icon(Icons.Default.AutoAwesome, contentDescription = "IA", tint = Color(0xFF7CA4FF), modifier = Modifier.size(16.dp))
                            Text("IA", color = keyContentColor, fontSize = 9.sp, fontWeight = FontWeight.Bold)
                        }

                        VerticalDivider(modifier = Modifier.height(22.dp).padding(horizontal = 4.dp), color = keyContentColor.copy(alpha = 0.2f))

                        suggestions.forEachIndexed { index, word ->
                            Box(
                                modifier = Modifier
                                    .weight(1f)
                                    .fillMaxHeight()
                                    .clickable {
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
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(44.dp),
                        horizontalArrangement = Arrangement.spacedBy(4.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        TopToolButton(
                            icon = Icons.Default.Spellcheck,
                            label = if (aiLoading) "..." else "Corrigir",
                            keyBg = keyBg,
                            contentColor = keyContentColor,
                            modifier = Modifier.weight(1f),
                            onClick = { if (!aiLoading) triggerAi("CORRIGIR") }
                        )
                        TopToolButton(
                            icon = Icons.Default.EditNote,
                            label = "Reescrever",
                            keyBg = keyBg,
                            contentColor = keyContentColor,
                            modifier = Modifier.weight(1f),
                            onClick = { if (!aiLoading) triggerAi("REESCREVER") }
                        )
                        TopToolButton(
                            icon = Icons.Default.Translate,
                            label = "Traduzir",
                            keyBg = keyBg,
                            contentColor = keyContentColor,
                            modifier = Modifier.weight(1f),
                            onClick = { if (!aiLoading) triggerAi("TRADUZIR") }
                        )
                        TopToolButton(
                            icon = Icons.Default.Search,
                            label = "Lupa",
                            keyBg = keyBg,
                            contentColor = keyContentColor,
                            modifier = Modifier.weight(1f),
                            onClick = {
                                val next = !prefs.lensEnabled
                                prefs.lensEnabled = next
                                if (next) PrismaLensAccessibilityService.instance?.showFloatingLens()
                                else PrismaLensAccessibilityService.instance?.hideFloatingLens()
                                statusBanner = if (next) "Lupa ativada" else "Lupa ocultada"
                            }
                        )
                        TopToolButton(
                            icon = Icons.Default.ContentPaste,
                            label = "Copiados",
                            keyBg = keyBg,
                            contentColor = keyContentColor,
                            modifier = Modifier.weight(1f),
                            onClick = {
                                showClipboardPanel = !showClipboardPanel
                                showEmojiPanel = false
                                showMoreMenu = false
                            }
                        )
                        TopToolButton(
                            icon = Icons.Default.MoreHoriz,
                            label = "Mais",
                            keyBg = keyBg,
                            contentColor = keyContentColor,
                            modifier = Modifier.weight(1f),
                            onClick = {
                                showMoreMenu = !showMoreMenu
                                showClipboardPanel = false
                                showEmojiPanel = false
                            }
                        )
                    }
                }
            }

            if (showMoreMenu) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .background(Color(0xFF1A2234))
                        .padding(6.dp),
                    horizontalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    OutlinedButton(
                        onClick = {
                            showMoreMenu = false
                            triggerAi("RESPONDER")
                        },
                        modifier = Modifier.weight(1f),
                        contentPadding = PaddingValues(4.dp)
                    ) {
                        Text("Responder IA", fontSize = 11.sp, color = Color.White)
                    }
                    OutlinedButton(
                        onClick = {
                            val values = PrismThemeMode.entries
                            val next = values[(currentTheme.ordinal + 1) % values.size]
                            prefs.themeMode = next
                            themeTick++
                            statusBanner = "Tema: ${next.title}"
                        },
                        modifier = Modifier.weight(1f),
                        contentPadding = PaddingValues(4.dp)
                    ) {
                        Text("Mudar Tema", fontSize = 11.sp, color = Color.White)
                    }
                    OutlinedButton(
                        onClick = {
                            showMoreMenu = false
                            onOpenAppSettings()
                        },
                        modifier = Modifier.weight(1f),
                        contentPadding = PaddingValues(4.dp)
                    ) {
                        Text("Ajustes App", fontSize = 11.sp, color = Color.White)
                    }
                }
            }

            if (showClipboardPanel) {
                val fullClip = remember(showClipboardPanel) { readFullClipboardUnlimited() }
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(195.dp)
                        .clip(RoundedCornerShape(14.dp))
                        .background(keyBg)
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
                            color = keyContentColor,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp
                        )
                        Text(
                            text = "Voltar ao teclado",
                            color = Color(0xFF7CA4FF),
                            fontSize = 12.sp,
                            fontWeight = FontWeight.SemiBold,
                            modifier = Modifier.clickable { showClipboardPanel = false }
                        )
                    }

                    Text(
                        text = if (fullClip.isBlank()) "Nenhum texto copiado no momento." else fullClip.take(260),
                        color = keyContentColor.copy(alpha = 0.8f),
                        fontSize = 12.sp,
                        maxLines = 5,
                        overflow = TextOverflow.Ellipsis
                    )

                    Button(
                        onClick = {
                            if (fullClip.isNotEmpty()) {
                                onCommitText(fullClip)
                                showClipboardPanel = false
                                currentTypingWord = ""
                                statusBanner = "✓ Colado (${fullClip.length} caracteres sem limite!)"
                            }
                        },
                        enabled = fullClip.isNotEmpty(),
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
                        .background(keyBg)
                        .padding(6.dp)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 6.dp, vertical = 2.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Emojis Animados", color = keyContentColor, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                        Text(
                            "ABC",
                            color = Color(0xFF7CA4FF),
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
                            onKeyClick = { onCharTyped(it) }
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
                            onKeyClick = { onCharTyped(it) }
                        )
                    }
                }

                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(4.dp)) {
                    ActionKeyCap(
                        icon = Icons.Default.KeyboardCapslock,
                        isActive = isUpper && !isSymbolMode,
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        modifier = Modifier.weight(1.35f).height(47.dp),
                        onClick = { if (!isSymbolMode) isUpper = !isUpper }
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
                            onKeyClick = { onCharTyped(it) }
                        )
                    }

                    ActionKeyCap(
                        icon = Icons.AutoMirrored.Filled.Backspace,
                        isActive = false,
                        keyBg = keyBg,
                        contentColor = keyContentColor,
                        modifier = Modifier.weight(1.35f).height(47.dp),
                        onClick = {
                            onDeleteChar()
                            currentTypingWord = onGetCurrentWordBeforeCursor()
                            forceShowTools = false
                        }
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
                            .clickable { isSymbolMode = !isSymbolMode },
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
                                showEmojiPanel = !showEmojiPanel
                                showClipboardPanel = false
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
                        onKeyClick = {
                            onCommitText(it)
                            currentTypingWord = ""
                        }
                    )

                    Box(
                        modifier = Modifier
                            .weight(3.8f)
                            .height(47.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(keyBg)
                            .border(1.dp, borderBrush, RoundedCornerShape(10.dp))
                            .clickable {
                                onCommitText(" ")
                                currentTypingWord = ""
                            },
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
                        onKeyClick = {
                            onCommitText(it)
                            currentTypingWord = ""
                        }
                    )

                    Box(
                        modifier = Modifier
                            .weight(1.3f)
                            .height(47.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(Color(0xFF4F7DF3))
                            .clickable {
                                onEnterPressed()
                                currentTypingWord = ""
                            },
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
private fun TopToolButton(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    label: String,
    keyBg: Color,
    contentColor: Color,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Column(
        modifier = modifier
            .fillMaxHeight()
            .clip(RoundedCornerShape(10.dp))
            .background(keyBg)
            .clickable { onClick() }
            .padding(vertical = 3.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(imageVector = icon, contentDescription = label, tint = contentColor, modifier = Modifier.size(16.dp))
        Text(
            text = label,
            color = contentColor,
            fontSize = 9.5.sp,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis
        )
    }
}

@Composable
private fun ActionKeyCap(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    isActive: Boolean,
    keyBg: Color,
    contentColor: Color,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Box(
        modifier = modifier
            .clip(RoundedCornerShape(10.dp))
            .background(if (isActive) Color(0xFF4F7DF3) else keyBg)
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
                        if (variants.isNotEmpty()) {
                            showPopup = true
                        } else {
                            onKeyClick(label)
                        }
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
                    border = BorderStroke(1.dp, Color(0xFF5D87F6)),
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

# 13. PrismKeyboardService.kt (Com colagem ilimitada em lotes para textos gigantes)
cat << 'EOF' > app/src/main/java/com/prismkey/keyboard/service/PrismKeyboardService.kt
package com.prismkey.keyboard.service

import android.content.Intent
import android.inputmethodservice.InputMethodService
import android.view.KeyEvent
import android.view.View
import android.view.inputmethod.ExtractedTextRequest
import androidx.compose.ui.platform.ComposeView
import androidx.lifecycle.*
import androidx.savedstate.SavedStateRegistry
import androidx.savedstate.SavedStateRegistryController
import androidx.savedstate.SavedStateRegistryOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import com.prismkey.keyboard.MainActivity
import com.prismkey.keyboard.data.PrefsManager
import com.prismkey.keyboard.ui.keyboard.PrismKeyboardView

class PrismKeyboardService : InputMethodService(), LifecycleOwner, ViewModelStoreOwner, SavedStateRegistryOwner {

    private val lifecycleRegistry = LifecycleRegistry(this)
    private val store = ViewModelStore()
    private val savedStateController = SavedStateRegistryController.create(this)
    private lateinit var prefs: PrefsManager

    override val lifecycle: Lifecycle get() = lifecycleRegistry
    override val viewModelStore: ViewModelStore get() = store
    override val savedStateRegistry: SavedStateRegistry get() = savedStateController.savedStateRegistry

    override fun onCreate() {
        super.onCreate()
        savedStateController.performRestore(null)
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_CREATE)
        prefs = PrefsManager(this)
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
        lifecycleRegistry.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        store.clear()
        super.onDestroy()
    }
}
EOF

# 14. PrismaLensAccessibilityService.kt (Corrigido: overlayParams sem sombreamento por View.layoutParams)
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
import androidx.compose.ui.platform.LocalContext
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
    private var overlayParams: WindowManager.LayoutParams? = null
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
        params.x = 80
        params.y = 420
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
                onCaptureScreenText = { captureVisibleScreenText() },
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
    val context = LocalContext.current
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

# 15. MainActivity.kt (Banner Prisma 3D Realista + Abas completas 100% PrismKey)
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
import androidx.compose.foundation.Canvas
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
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
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
            drawPath(
                path = topFacet,
                brush = Brush.linearGradient(listOf(Color(0xFFE0F2FE), Color(0xFF60A5FA)))
            )

            val leftFacet = Path().apply {
                moveTo(w * 0.80f, h * 0.14f)
                lineTo(w * 0.66f, h * 0.50f)
                lineTo(w * 0.80f, h * 0.50f)
                close()
            }
            drawPath(
                path = leftFacet,
                brush = Brush.linearGradient(listOf(Color(0xFF93C5FD), Color(0xFF3B82F6)))
            )

            val bottomLeftFacet = Path().apply {
                moveTo(w * 0.66f, h * 0.50f)
                lineTo(w * 0.80f, h * 0.86f)
                lineTo(w * 0.80f, h * 0.50f)
                close()
            }
            drawPath(
                path = bottomLeftFacet,
                brush = Brush.linearGradient(listOf(Color(0xFF2563EB), Color(0xFF1D4ED8)))
            )

            val bottomRightFacet = Path().apply {
                moveTo(w * 0.94f, h * 0.50f)
                lineTo(w * 0.80f, h * 0.86f)
                lineTo(w * 0.80f, h * 0.50f)
                close()
            }
            drawPath(
                path = bottomRightFacet,
                brush = Brush.linearGradient(listOf(Color(0xFF818CF8), Color(0xFF4338CA)))
            )
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
                    text = "VERSÃO 1.1.0",
                    color = Color(0xFF93C5FD),
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                )
            }
            Text(
                text = "PrismKey",
                color = Color.White,
                fontSize = 28.sp,
                fontWeight = FontWeight.ExtraBold
            )
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
                            Text("Tudo pronto! Nenhuma configuração pendente.", color = Color.White.copy(alpha = 0.7f), fontSize = 12.sp)
                        }
                    }
                } else {
                    Text("Configuração Necessária do PrismKey", color = Color(0xFFFBBF24), fontWeight = FontWeight.Bold)
                    Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        if (!status.isKeyboardEnabled) {
                            Button(
                                onClick = {
                                    context.startActivity(Intent(Settings.ACTION_INPUT_METHOD_SETTINGS))
                                },
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
private fun AppearanceTab(prefs: PrefsManager) {
    val context = LocalContext.current
    var selectedMode by remember { mutableStateOf(prefs.themeMode) }
    var imagePath by remember { mutableStateOf(prefs.customImagePath) }
    var scale by remember { mutableFloatStateOf(prefs.imageScale) }
    var offsetX by remember { mutableFloatStateOf(prefs.imageOffsetX) }
    var offsetY by remember { mutableFloatStateOf(prefs.imageOffsetY) }
    var dimAlpha by remember { mutableFloatStateOf(prefs.overlayDimAlpha) }

    val imagePicker = rememberLauncherForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
        if (uri != null) {
            val destFile = File(context.filesDir, "custom_keyboard_bg.jpg")
            context.contentResolver.openInputStream(uri)?.use { input ->
                FileOutputStream(destFile).use { output -> input.copyTo(output) }
            }
            prefs.customImagePath = destFile.absolutePath
            prefs.themeMode = PrismThemeMode.CUSTOM_IMAGE
            prefs.imageScale = 1f
            prefs.imageOffsetX = 0f
            prefs.imageOffsetY = 0f

            imagePath = destFile.absolutePath
            selectedMode = PrismThemeMode.CUSTOM_IMAGE
            scale = 1f
            offsetX = 0f
            offsetY = 0f
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(vertical = 16.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp)
    ) {
        Text("Aparência & Tema", color = Color.White, fontSize = 24.sp, fontWeight = FontWeight.Bold)

        PrismThemeMode.entries.forEach { mode ->
            Surface(
                shape = RoundedCornerShape(14.dp),
                color = if (selectedMode == mode) Color(0xFF23304D) else Color(0xFF161B26),
                border = BorderStroke(1.dp, if (selectedMode == mode) Color(0xFF5D87F6) else Color.Transparent),
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable {
                        selectedMode = mode
                        prefs.themeMode = mode
                    }
            ) {
                Row(
                    modifier = Modifier.padding(14.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(mode.title, color = Color.White, fontWeight = FontWeight.Medium)
                    if (selectedMode == mode) {
                        Icon(Icons.Default.Check, contentDescription = null, tint = Color(0xFF5D87F6))
                    }
                }
            }
        }

        Button(
            onClick = { imagePicker.launch("image/*") },
            modifier = Modifier.fillMaxWidth()
        ) {
            Icon(Icons.Default.Image, contentDescription = null)
            Spacer(Modifier.width(8.dp))
            Text("Escolher Foto da Galeria")
        }

        val bitmap = remember(imagePath) {
            if (!imagePath.isNullOrBlank() && File(imagePath!!).exists()) {
                BitmapFactory.decodeFile(imagePath)?.asImageBitmap()
            } else null
        }

        if (bitmap != null) {
            Text(
                "Ajuste Livre (use dois dedos para zoom e arraste):",
                color = Color.White.copy(alpha = 0.8f),
                fontSize = 13.sp
            )

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(210.dp)
                    .clip(RoundedCornerShape(16.dp))
                    .background(Color.Black)
                    .border(2.dp, Color(0xFF5D87F6), RoundedCornerShape(16.dp))
                    .pointerInput(Unit) {
                        detectTransformGestures { _, pan, zoom, _ ->
                            scale = (scale * zoom).coerceIn(0.6f, 4f)
                            offsetX += pan.x
                            offsetY += pan.y
                            prefs.imageScale = scale
                            prefs.imageOffsetX = offsetX
                            prefs.imageOffsetY = offsetY
                        }
                    }
            ) {
                Image(
                    bitmap = bitmap,
                    contentDescription = "Prévia do fundo",
                    contentScale = ContentScale.Fit,
                    modifier = Modifier
                        .fillMaxSize()
                        .graphicsLayer {
                            scaleX = scale
                            scaleY = scale
                            translationX = offsetX
                            translationY = offsetY
                        }
                )
                Box(
                    modifier = Modifier
                        .matchParentSize()
                        .background(Color.Black.copy(alpha = dimAlpha))
                )
            }

            OutlinedButton(
                onClick = {
                    scale = 1f; offsetX = 0f; offsetY = 0f
                    prefs.imageScale = 1f; prefs.imageOffsetX = 0f; prefs.imageOffsetY = 0f
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Centralizar Foto", color = Color.White)
            }

            Text("Escurecimento para leitura das teclas: ${(dimAlpha * 100).toInt()}%", color = Color.White, fontSize = 12.sp)
            Slider(
                value = dimAlpha,
                onValueChange = {
                    dimAlpha = it
                    prefs.overlayDimAlpha = it
                },
                valueRange = 0.1f..0.8f
            )
        }
    }
}

@Composable
private fun AiAndLensTab(prefs: PrefsManager, status: PrismSystemStatus) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()

    var apiKeyInput by remember { mutableStateOf(prefs.apiKey) }
    var lensToggle by remember { mutableStateOf(prefs.lensEnabled) }
    var downloadedLangs by remember { mutableStateOf<Set<String>>(emptySet()) }
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
                        Text("Traduz textos na tela offline e sugere respostas.", color = Color.White.copy(alpha = 0.7f), fontSize = 12.sp)
                    }
                    Switch(
                        checked = lensToggle,
                        onCheckedChange = { checked ->
                            lensToggle = checked
                            prefs.lensEnabled = checked
                            if (checked) {
                                PrismaLensAccessibilityService.instance?.showFloatingLens()
                            } else {
                                PrismaLensAccessibilityService.instance?.hideFloatingLens()
                            }
                        }
                    )
                }

                if (status.canDrawOverlays && status.isAccessibilityEnabled) {
                    Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                        Icon(Icons.Default.CheckCircle, contentDescription = null, tint = Color(0xFF34D399), modifier = Modifier.size(16.dp))
                        Text("Permissões de Sobreposição e Acessibilidade OK", color = Color(0xFF34D399), fontSize = 12.sp)
                    }
                } else {
                    Text("⚠️ Permissões pendentes (ou desativadas pelo sistema):", color = Color(0xFFFBBF24), fontSize = 12.sp)
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
                                onClick = {
                                    context.startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
                                },
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
                Text("IA na Nuvem (Gemini 2.5 Flash)", color = Color.White, fontWeight = FontWeight.Bold)
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
                    Text("Salvar Chave (gemini-2.5-flash)")
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
                Text("Pacotes de Idiomas Offline (~30 MB)", color = Color.White, fontWeight = FontWeight.Bold)
                Text(
                    "Baixe na memória para traduzir instantaneamente sem internet no PrismKey.",
                    color = Color.White.copy(alpha = 0.7f),
                    fontSize = 12.sp
                )

                HybridAiEngine.availableLanguages.forEach { pack ->
                    val isInstalled = downloadedLangs.contains(pack.code)
                    val isBusy = downloadingCode == pack.code

                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(10.dp))
                            .background(Color(0xFF1F2636))
                            .padding(horizontal = 12.dp, vertical = 8.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Column {
                            Text(pack.name, color = Color.White, fontWeight = FontWeight.Medium)
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
                                        prefs.targetLangCode = pack.code
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
                    "O PrismKey não possui servidores próprios. Suas configurações, fotos de tema e modelos offline ficam armazenados exclusivamente na memória do seu dispositivo.",
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
                    "PrismKey v1.1.0 — Desenvolvido por Davi com colaboração de Pedro Paulo.\n\nInspiração conceitual em recursos modernos de teclados inteligentes apresentados pelo canal Tech World BR (Keyvya), adaptados de forma independente em Kotlin e Jetpack Compose.",
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

# 16. PrismKeyUnitTest.kt (Teste unitário para validação das sugestões)
cat << 'EOF' > app/src/test/java/com/prismkey/keyboard/PrismKeyUnitTest.kt
package com.prismkey.keyboard

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
    fun testEmptyInputReturnsEmpty() {
        assertTrue(WordPredictor.suggest("").isEmpty())
    }
}
EOF

# 17. Auditoria automática de integridade dos arquivos gerados
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

echo "✅ Auditoria concluída e estrutura do PrismKey v1.1.0 gerada com sucesso!"
