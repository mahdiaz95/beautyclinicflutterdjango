import 'package:PARLACLINIC/core/providers/current_user_notifier.dart';
import 'package:PARLACLINIC/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/user_model.dart';
import '../repositories/auth_local_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  late AuthRemoteRepository _authremoterepository;

  @override
  AsyncValue<UserModel>? build() {
    _authremoterepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res =
        await _authremoterepository.login(email: email, password: password);
    switch (res) {
      case Left(value: final l):
        {
          state = AsyncValue.error(l.message, StackTrace.current);
        }
      case Right(value: final r):
        _authLocalRepository.setToken(r);
        final user = await _authremoterepository.getCurrentUser();
        switch (user) {
          case Left(value: final l):
            {
              _authLocalRepository.clearToken();
              state = AsyncValue.error(l.message, StackTrace.current);
            }
          case Right(value: final r):
            {
              final user = r;
              _currentUserNotifier.addUser(user);
              state = AsyncValue.data(user);
            }
        }
    }
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();

    if (token != null) {
      final res = await _authremoterepository.getCurrentUser();
      switch (res) {
        case Left(value: final l):
          {
            state = AsyncValue.error(l.message, StackTrace.current);
            return null;
          }
        case Right(value: final r):
          {
            state = AsyncValue.data(r);
            _currentUserNotifier.addUser(r);
            return r;
          }
      }
    }

    return null;
  }

  Future<void> logoutUser() async {
    state = const AsyncValue.loading();
    _authLocalRepository.clearToken();
    _currentUserNotifier.removeUser();
    state = null;
  }
}
