/// Partially hides an email for display, e.g. `jennifer@amanah.com` →
/// `je***er@amanah.com`. Keeps the domain, shows the first 1–2 local characters,
/// and uses a fixed `***` so the real length isn't leaked. Returns the input
/// unchanged when it isn't a recognisable email.
String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 0 || at == email.length - 1) return email;

  final local = email.substring(0, at);
  final domain = email.substring(at + 1);

  if (local.length <= 4) {
    return '${local.substring(0, 1)}******@$domain';
  }

  final first = local.substring(0, 2);
  final last = local.substring(local.length - 2);

  return '$first******$last@$domain';
}
