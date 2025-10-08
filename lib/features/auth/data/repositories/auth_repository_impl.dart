import 'package:blog_app/constants/error/exceptions.dart';
import 'package:blog_app/constants/error/failures.dart';
import 'package:blog_app/constants/konstants/konstants.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/models/user_models.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../constants/common/entities/user.dart';
import '../../../../constants/network/connection_checker.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        if(session == null) {
          return left(Failure('User not logged in!'));
        }
        return right(UserModel(email: session.user.email ?? '', name: '', id: session.user.id));
      }
      final user = await remoteDataSource.getCurrentUSerData();
      if(user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
    final user = await remoteDataSource.getCurrentUSerData();
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      if(!await (connectionChecker.isConnected)) {
        return left(Failure(Konstants.noConnectionErrorMessage));
      }
      final userId = await fn();
      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
