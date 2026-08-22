import 'package:amanah/core/providers.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:amanah/features/profile/data/mock_profile_repository.dart';
import 'package:amanah/features/profile/data/profile_repository.dart';
import 'package:amanah/features/profile/data/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Real profile repository. `updateProfile` hits `PUT /auth/profile`; the other
/// methods fall back to the mock until their endpoints ship. The mock also
/// receives the current user so its fallbacks return merged records.
// ignore: provider_dependencies
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    ref.watch(dioProvider),
    MockProfileRepository(ref.watch(currentUserProvider)),
  ),
);
