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

// ── Audits tab ───────────────────────────────────────────────────────────

/// The three segments of the Audits screen. `assigned` is the union of every
/// section (running + upcoming + completed); the other two map 1:1 to a
/// `/my-audits` section.
enum AuditTab {
  assigned,
  inProgress,
  completed;

  String get label => switch (this) {
        AuditTab.assigned => 'Assigned',
        AuditTab.inProgress => 'In progress',
        AuditTab.completed => 'Completed',
      };
}

/// Keyword typed into the Audits search box. Shared across tabs (one search
/// field sits above the segmented control), server-side search per tab.
final auditsSearchProvider =
    NotifierProvider<AuditsSearch, String>(AuditsSearch.new);

class AuditsSearch extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) {
    if (value == state) return;
    state = value;
  }
}

/// Audits for one [AuditTab], filtered by [auditsSearchProvider]. `assigned`
/// fans out to all three sections in parallel and concatenates them so each
/// card keeps its own status chip (In progress / Upcoming / Completed).
// ignore: specify_nonobvious_property_types
final auditsTabProvider =
    FutureProvider.autoDispose.family<List<Audit>, AuditTab>((ref, tab) {
  final keyword = ref.watch(auditsSearchProvider);
  final repo = ref.watch(auditRepositoryProvider);

  switch (tab) {
    case AuditTab.inProgress:
      return repo.myAudits(section: AuditSection.running, keyword: keyword);
    case AuditTab.completed:
      return repo.myAudits(section: AuditSection.completed, keyword: keyword);
    case AuditTab.assigned:
      return Future.wait([
        repo.myAudits(section: AuditSection.running, keyword: keyword),
        repo.myAudits(section: AuditSection.upcoming, keyword: keyword),
        repo.myAudits(section: AuditSection.completed, keyword: keyword),
      ]).then((lists) => [for (final list in lists) ...list]);
  }
});
