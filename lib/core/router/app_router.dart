import 'package:amanah/features/audits/presentation/screens/audits_screen.dart';
import 'package:amanah/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:amanah/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:amanah/features/auth/presentation/screens/password_updated_screen.dart';
import 'package:amanah/features/auth/presentation/screens/set_new_password_screen.dart';
import 'package:amanah/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:amanah/features/auth/presentation/screens/signing_out_screen.dart';
import 'package:amanah/features/home/presentation/screens/home_screen.dart';
import 'package:amanah/features/profile/presentation/screens/profile_screen.dart';
import 'package:amanah/features/shell/presentation/branch_container.dart';
import 'package:amanah/features/shell/presentation/shell_screen.dart';
import 'package:amanah/features/splash/presentation/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();

/// App router. `StatefulShellRoute.indexedStack` preserves each tab's state.
///
/// Auth-state redirect (token → sign-in/home) is added with the real auth
/// controller in the Sign In step; for now the splash routes to `/sign-in`.
GoRouter buildRouter() {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(
          onSignedIn: () => context.go('/home'),
          onSignedOut: () => context.go('/sign-in'),
        ),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signing-out',
        builder: (context, state) => SigningOutScreen(
          onDone: () => context.go('/sign-in'),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) => OtpVerificationScreen(
          email: state.extra as String? ?? 'jenniferanniston@gmail.com',
        ),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final args = state.extra as Map<String, String>? ?? const {};
          return SetNewPasswordScreen(
            email: args['email'] ?? 'jenniferanniston@gmail.com',
            code: args['code'] ?? '000000',
          );
        },
      ),
      GoRoute(
        path: '/password-updated',
        builder: (context, state) => const PasswordUpdatedScreen(),
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) =>
            ShellScreen(navigationShell: navigationShell),
        // Cross-fade between tabs instead of the default instant swap.
        navigatorContainerBuilder: (context, navigationShell, children) =>
            BranchContainer(
          currentIndex: navigationShell.currentIndex,
          children: children,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/audits',
                builder: (context, state) => const AuditsScreen(),
              ),
            ],
          ),
          _branch('/expenses', 'Expenses'),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

StatefulShellBranch _branch(String path, String title) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        builder: (context, state) => PlaceholderTab(title),
      ),
    ],
  );
}
