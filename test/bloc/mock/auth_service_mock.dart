import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/auth/data/models/login_response_model.dart';
import 'package:ferrisfwt/feature/auth/domain/usecases/uc_get_auth.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:mockito/mockito.dart';

final class AuthServiceMock extends Mock implements UCGetAuth {
  @override
  Future<Either<Failure, LoginResponseModel>> login(
      {required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
