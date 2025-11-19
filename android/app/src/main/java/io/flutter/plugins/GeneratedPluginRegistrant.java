package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Registers Flutter plugins.
 *
 * <p>This project currently does not rely on any third-party Flutter plugins, so the generated
 * registrant intentionally leaves the registration list empty. This avoids build failures on
 * Android that were caused by stale references to plugins which are no longer part of the
 * project dependencies.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private GeneratedPluginRegistrant() {}

  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    // No-op: there are no Flutter plugins to register.
  }

  /** Legacy v1 embedding support. */
  public static void registerWith(@NonNull PluginRegistry registry) {
    // Intentionally empty for the same reason as above.
  }
}
