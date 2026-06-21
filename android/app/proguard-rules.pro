# Reglas R8/ProGuard para CogniFit (build de release ofuscado).
#
# R8 renombra y elimina código por defecto. Aquí SOLO se conserva ("keep") lo
# que rompería en runtime si se ofusca: clases referenciadas por reflexión o
# por código nativo. Es el caso clásico de "la ofuscación afecta bibliotecas
# de terceros".

# --- Flutter / plugins vía MethodChannel ---
# El MainActivity y el canal nativo se referencian por nombre desde el engine.
-keep class com.example.cognifit.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# --- Firebase / FCM (usa reflexión para deserializar mensajes) ---
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- flutter_secure_storage / Keystore ---
-keep class androidx.security.crypto.** { *; }

# --- Google Play Core (descarga diferida de Flutter) ---
# Flutter referencia estas clases para "deferred components", pero la app no
# las usa y no están en el classpath. Sin esta regla R8 falla con
# "Missing class com.google.android.play.core...".
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Quita los logs de depuración del binario ofuscado.
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
}
