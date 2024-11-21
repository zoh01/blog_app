import 'package:fpdart/fpdart.dart';

import '../../../../constants/common/entities/user.dart';
import '../../../../constants/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
});
  Future<Either<Failure, User>> currentUser();
}
