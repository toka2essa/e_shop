import 'package:eshop_app/core/network/rest/api/api.dart';
import 'package:eshop_app/core/network/rest/api/api_consumer.dart';
import 'package:eshop_app/domain/auth/repositories/auth_repository.dart';
import 'package:eshop_app/domain/auth/usecases/login_use_case.dart';
import 'package:eshop_app/domain/auth/usecases/resend_otp_use_case.dart';
import 'package:eshop_app/domain/auth/usecases/sign_up_use_case.dart';
import 'package:eshop_app/domain/auth/usecases/verify_email_use_case.dart';
import 'package:eshop_app/domain/auth/usecases/get_products_use_case.dart';
import 'package:eshop_app/domain/auth/usecases/get_product_details_use_case.dart';
import 'package:eshop_app/infrastructure/auth/data_sources/auth_remote_data_source.dart';
import 'package:eshop_app/infrastructure/auth/repositories/auth_repository_impl.dart';
import 'package:eshop_app/infrastructure/auth/data_sources/product_remote_data_source.dart';
import 'package:eshop_app/infrastructure/auth/repositories/product_repository_impl.dart';
import 'package:eshop_app/presentation/cubit/products/products_cubit.dart';
import 'package:eshop_app/presentation/cubit/products/product_details_cubit.dart';
import 'package:eshop_app/presentation/cubit/login/login_cubit.dart';
import 'package:eshop_app/presentation/cubit/auth/auth_cubit.dart';
import 'package:get_it/get_it.dart';

import 'domain/auth/repositories/product_repository.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<ApiConsumer>(() => Api());

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(sl()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl()),
  );

  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl()),
  );

  sl.registerLazySingleton<VerifyEmailUseCase>(
    () => VerifyEmailUseCase(sl()),
  );

  sl.registerLazySingleton<ResendOtpUseCase>(
    () => ResendOtpUseCase(sl()),
  );

  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl()),
  );

  sl.registerLazySingleton<GetProductDetailsUseCase>(
    () => GetProductDetailsUseCase(sl()),
  );

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(sl(), sl(), sl()),
  );

  sl.registerFactory<ProductsCubit>(() => ProductsCubit(sl()));

  sl.registerFactory<ProductDetailsCubit>(() => ProductDetailsCubit(sl()));

  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
}
