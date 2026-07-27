import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/entities/product.dart';
import 'package:eshop_app/domain/repositories/app_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProductDetailsUseCase {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<ServerFailure, Product>> call(String id) {
    return repository.getProductById(id);
  }
}

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Either<ServerFailure, List<Product>>> call() {
    return _repository.getProducts();
  }
}

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<ServerFailure, String>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return repository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
  }
}

class VerifyEmailUseCase {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Either<ServerFailure, String>> call({
    required String email,
    required String otp,
  }) {
    return repository.verifyEmail(email: email, otp: otp);
  }
}

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<Either<ServerFailure, String>> call(String email) {
    return repository.resendOtp(email: email);
  }
}

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<ServerFailure, String>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
