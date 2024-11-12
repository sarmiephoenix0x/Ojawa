# Keep the error-prone annotations to prevent R8 from stripping them
-keep class com.google.errorprone.annotations.* { *; }
-keep class com.google.crypto.tink.* { *; }

# Suppress warnings for missing classes from errorprone annotations
-dontwarn com.google.errorprone.annotations.CanIgnoreReturnValue
-dontwarn com.google.errorprone.annotations.CheckReturnValue
-dontwarn com.google.errorprone.annotations.Immutable
-dontwarn com.google.errorprone.annotations.InlineMe
-dontwarn com.google.errorprone.annotations.RestrictedApi
