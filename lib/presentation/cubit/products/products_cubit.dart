import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eshop_app/domain/auth/usecases/get_products_use_case.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsCubit(this.getProductsUseCase) : super(const ProductsInitial());

  Future<void> getProducts() async {
    emit(const ProductsLoading());
    final result = await getProductsUseCase();
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }
}
