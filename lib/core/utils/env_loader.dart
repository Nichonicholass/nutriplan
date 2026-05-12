import 'dart:io';
import 'package:flutter/services.dart';

class Env {
  static final Map<String, String> env = {};


  static Future<void> load([String path = '.env']) async {
    String? content;

    try {
      final file = File(path);
      if (await file.exists()) {
        content = await file.readAsString();
      }
    } catch (_) {}

    if (content == null) {
      try {
        content = await rootBundle.loadString(path);
      } catch (_) {}
    }

    if (content == null) return;

    final lines = content.split('\n');
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final idx = line.indexOf('=');
      if (idx == -1) continue;
      final key = line.substring(0, idx).trim();
      var value = line.substring(idx + 1).trim();
      if ((value.startsWith('"') && value.endsWith('"')) ||
          (value.startsWith("'") && value.endsWith("'"))) {
        value = value.substring(1, value.length - 1);
      }
      env[key] = value;
    }
  }
}
