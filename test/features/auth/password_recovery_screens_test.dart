import 'package:amanah/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:amanah/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:amanah/features/auth/presentation/screens/set_new_password_screen.dart';
import 'package:amanah/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) =>
    ProviderScope(child: MaterialApp(home: child));

void main() {
  testWidgets('Sign In renders its key elements', (tester) async {
    await tester.pumpWidget(_wrap(const SignInScreen()));
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('Forgot Password renders', (tester) async {
    await tester.pumpWidget(_wrap(const ForgotPasswordScreen()));
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Verify email'), findsOneWidget);
    expect(find.text('Back to login'), findsOneWidget);
  });

  testWidgets('OTP screen renders with the target email', (tester) async {
    await tester.pumpWidget(
      _wrap(const OtpVerificationScreen(email: 'auditor@isnahalal.com')),
    );
    expect(find.text('Verify email address'), findsOneWidget);
    expect(find.textContaining('auditor@isnahalal.com'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Resend'), findsOneWidget);
  });

  testWidgets('Set New Password renders two fields + CTA', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SetNewPasswordScreen(
          email: 'auditor@isnahalal.com',
          code: '000000',
        ),
      ),
    );
    expect(find.text('New password'), findsOneWidget);
    expect(find.text('Retype new password'), findsOneWidget);
    // Title and button share the label.
    expect(find.text('Set new password'), findsNWidgets(2));
  });
}
