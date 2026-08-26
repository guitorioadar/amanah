import 'package:amanah/features/audits/presentation/screens/audit_details_screen.dart';
import 'package:amanah/features/audits/presentation/screens/audits_screen.dart';
import 'package:amanah/features/audits/presentation/screens/observation_list_screen.dart';
import 'package:amanah/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:amanah/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:amanah/features/auth/presentation/screens/password_updated_screen.dart';
import 'package:amanah/features/auth/presentation/screens/set_new_password_screen.dart';
import 'package:amanah/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:amanah/features/auth/presentation/screens/signing_out_screen.dart';
import 'package:amanah/features/expenses/presentation/screens/expense_detail_screen.dart';
import 'package:amanah/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:amanah/features/home/presentation/screens/home_screen.dart';
import 'package:amanah/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:amanah/features/profile/presentation/screens/legal_screen.dart';
import 'package:amanah/features/profile/presentation/screens/notification_settings_screen.dart';
import 'package:amanah/features/profile/presentation/screens/personal_info_screen.dart';
import 'package:amanah/features/profile/presentation/screens/profile_screen.dart';
import 'package:amanah/features/profile/presentation/screens/security_screen.dart';
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
      // Notifications feed (full-screen over the shell; opened from the bell).
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      // Profile subscreens (full-screen over the shell).
      GoRoute(
        path: '/profile/personal-info',
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: '/profile/security',
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: '/profile/notifications',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/profile/privacy',
        builder: (context, state) => const LegalScreen.privacy(),
      ),
      GoRoute(
        path: '/profile/terms',
        builder: (context, state) => const LegalScreen.terms(),
      ),
      // Expense date-group detail (full-screen over the shell).
      GoRoute(
        path: '/expense/:date',
        builder: (context, state) => ExpenseDetailScreen(
          dateKey: state.pathParameters['date']!,
        ),
      ),
      // Full-screen over the shell (own back button, no bottom nav).
      GoRoute(
        path: '/audit/:id',
        builder: (context, state) => AuditDetailsScreen(
          auditId: int.parse(state.pathParameters['id']!),
        ),
        routes: [
          GoRoute(
            path: 'category/:cid',
            builder: (context, state) => ObservationListScreen(
              auditId: int.parse(state.pathParameters['id']!),
              categoryId: int.parse(state.pathParameters['cid']!),
            ),
          ),
        ],
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/expenses',
                builder: (context, state) => const ExpensesScreen(),
              ),
            ],
          ),
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
