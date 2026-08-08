import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/storage/secure_storage.dart';
import 'package:amanah/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late _MockSecureStorage storage;
  late MockAuthRepository repo;

  setUp(() {
    storage = _MockSecureStorage();
    when(
      () => storage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {});
    repo = MockAuthRepository(storage);
  });

  test('valid demo credentials return the user and persist tokens', () async {
    final user = await repo.signIn(
      email: 'auditor@isnahalal.com',
      password: 'password',
    );

    expect(user.email, 'auditor@isnahalal.com');
    verify(
      () => storage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).called(1);
  });

  test('email match is case-insensitive', () async {
    final user = await repo.signIn(
      email: 'AUDITOR@ISNAHALAL.COM',
      password: 'password',
    );
    expect(user.email, 'auditor@isnahalal.com');
  });

  test('wrong password throws unauthorized and saves nothing', () async {
    await expectLater(
      () => repo.signIn(email: 'auditor@isnahalal.com', password: 'nope'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.type,
          'type',
          ApiErrorType.unauthorized,
        ),
      ),
    );
    verifyNever(
      () => storage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    );
  });

  group('password recovery', () {
    test('requestPasswordReset succeeds for any email', () async {
      await expectLater(repo.requestPasswordReset('x@y.com'), completes);
    });

    test('resetPassword with demo code returns the user and persists tokens',
        () async {
      final user = await repo.resetPassword(
        email: 'x@y.com',
        code: '000000',
        newPassword: 'newpassword',
      );
      expect(user.email, 'auditor@isnahalal.com');
      verify(
        () => storage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).called(1);
    });

    test('resetPassword rejects a wrong code and saves nothing', () async {
      await expectLater(
        () => repo.resetPassword(
          email: 'x@y.com',
          code: '111111',
          newPassword: 'newpassword',
        ),
        throwsA(
          isA<ApiException>().having(
            (e) => e.type,
            'type',
            ApiErrorType.validation,
          ),
        ),
      );
      verifyNever(
        () => storage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      );
    });
  });
}
