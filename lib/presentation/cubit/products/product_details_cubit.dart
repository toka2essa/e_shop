import 'package:eshop_app/domain/auth/usecases/get_product_details_use_case.dart';
import 'package:eshop_app/presentation/cubit/products/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsCubit(this.getProductDetailsUseCase)
      : super(const ProductDetailsInitial());

  Future<void> getProductDetails(String id) async {
    emit(const ProductDetailsLoading());
    final result = await getProductDetailsUseCase(id);
    result.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) => emit(ProductDetailsLoaded(product)),
    );
  }
}
