import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to the loaded `.env` file. Call [load] once in `main()`
/// before reading any member.
///
/// The flavor selects which committed env file is loaded:
///   flutter run                          → env/.env.dev
///   flutter run --dart-define=FLAVOR=prod → env/.env.prod
///
/// Both files are bundled assets and hold **non-secret config only**
/// (`USE_MOCK_API`, `API_BASE_URL`). Real secrets never go here — runtime
/// tokens live in secure storage. See [[amanah-flutter-stack]].
abstract final class Env {
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static Future<void> load() => dotenv.load(fileName: 'env/.env.$flavor');

  /// Human label of the loaded env file (`dev`/`prod`). Falls back to [flavor].
  /// TEMPORARY: surfaced in the Profile screen for build verification.
  static String get envName => dotenv.maybeGet('ENV_NAME') ?? flavor;

  /// When true, repositories resolve to their mock implementations
  /// (dummy data, no backend). Drives the M1–M2 mock-first strategy.
  static bool get useMockApi =>
      (dotenv.maybeGet('USE_MOCK_API') ?? 'true').toLowerCase() == 'true';

  static String get apiBaseUrl => dotenv.maybeGet('API_BASE_URL') ?? '';
}
