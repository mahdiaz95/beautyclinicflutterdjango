import 'package:PARLACLINIC/core/failure/failure.dart';
import 'package:PARLACLINIC/services/api_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:PARLACLINIC/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthRemoteRepository(apiService);
}

class AuthRemoteRepository {
  final ApiService _apiService;

  AuthRemoteRepository(this._apiService);

  Future<Either<AppFailure, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _apiService.login(email, password);
      return Right(result);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUser() async {
    try {
      final user = await _apiService.getCurrentUserData();
      return Right(user);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
