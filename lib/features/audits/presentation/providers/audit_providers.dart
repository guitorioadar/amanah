import 'package:amanah/core/providers.dart';
import 'package:amanah/features/audits/data/audit_repository.dart';
import 'package:amanah/features/audits/data/models/audit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Audit backend is live, so the app talks to the real repository.
/// [MockAuditRepository] stays for tests.
final Provider<AuditRepository> auditRepositoryProvider =
    Provider<AuditRepository>((ref) {
  return AuditRepositoryImpl(ref.watch(dioProvider));
});

/// Running audits for the Home carousel (no search).
// ignore: specify_nonobvious_property_types
final runningAuditsProvider = FutureProvider.autoDispose<List<Audit>>((ref) {
  return ref
      .watch(auditRepositoryProvider)
      .myAudits(section: AuditSection.running);
});

/// Current keyword for the Upcoming-audits search box.
final upcomingSearchProvider =
    NotifierProvider<UpcomingSearch, String>(UpcomingSearch.new);

class UpcomingSearch extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) {
    if (value == state) return;
    state = value;
  }
}

/// Upcoming audits for the Home list, filtered by [upcomingSearchProvider]
/// (server-side keyword search).
// ignore: specify_nonobvious_property_types
final upcomingAuditsProvider = FutureProvider.autoDispose<List<Audit>>((ref) {
  final keyword = ref.watch(upcomingSearchProvider);
  return ref
      .watch(auditRepositoryProvider)
      .myAudits(section: AuditSection.upcoming, keyword: keyword);
});
