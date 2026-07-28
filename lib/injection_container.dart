import 'package:eshop_app/core/network/rest/api/api.dart';
import 'package:eshop_app/core/network/rest/api/api_consumer.dart';
import 'package:eshop_app/core/network/rest/auth_token_storage.dart';
import 'package:eshop_app/domain/repositories/app_repository.dart';
import 'package:eshop_app/domain/usecases/usecase_app.dart';
import 'package:eshop_app/infrastructure/data_sources/app_dataSource.dart';
import 'package:eshop_app/infrastructure/repositories/repository_impl.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<ApiConsumer>(() => Api());
  sl.registerLazySingleton<AuthTokenStorage>(() => AuthTokenStorage());

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(sl(), sl()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(sl()));

  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

  sl.registerLazySingleton<VerifyEmailUseCase>(() => VerifyEmailUseCase(sl()));

  sl.registerLazySingleton<ResendOtpUseCase>(() => ResendOtpUseCase(sl()));

  sl.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(sl()));

  sl.registerLazySingleton<GetProductDetailsUseCase>(
    () => GetProductDetailsUseCase(sl()),
  );

  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl(), sl()),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl(), sl()),
  );

  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));

  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl()),
  );

  sl.registerLazySingleton<GetCartUseCase>(() => GetCartUseCase(sl()));

  sl.registerLazySingleton<AddToCartUseCase>(() => AddToCartUseCase(sl()));

  sl.registerLazySingleton<RemoveCartItemUseCase>(
    () => RemoveCartItemUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateCartItemUseCase>(
    () => UpdateCartItemUseCase(sl()),
  );

  sl.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(getCategoriesUseCase: sl()),
  );

  sl.registerFactory<AppCubit>(
    () => AppCubit(
      signUpUseCase: sl(),
      loginUseCase: sl(),
      verifyEmailUseCase: sl(),
      resendOtpUseCase: sl(),
      getProductsUseCase: sl(),
      getProductDetailsUseCase: sl(),
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      removeCartItemUseCase: sl(),
      updateCartItemUseCase: sl(),
    ),
  );
}
