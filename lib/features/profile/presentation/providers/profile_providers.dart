import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:amanah/features/profile/data/mock_profile_repository.dart';
import 'package:amanah/features/profile/data/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Swaps to the real repository when the profile API ships — UI untouched.
/// The mock receives the current user so updateProfile can return a merged
/// record instead of a hand-built placeholder.
// ignore: provider_dependencies
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => MockProfileRepository(ref.watch(currentUserProvider)),
);
