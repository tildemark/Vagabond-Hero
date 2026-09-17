import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future.sync(() async {
    try {
      final result = await WasmDatabase.open(
        databaseName: 'vagabond_hero_web',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );
      return result.resolvedExecutor;
    } catch (e, stack) {
      debugPrint('WasmDatabase.open failed: $e\n$stack');
      rethrow;
    }
  }));
}
