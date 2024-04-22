import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../repositories/category_repository.dart';
import '../../repositories/product_repository.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CategoryRepository _categoryRepository;
  final ProductRepository _productRepository;


  CatalogBloc({
    required CategoryRepository categoryRepository,
    required ProductRepository productRepository,
}) : _categoryRepository = categoryRepository,
        _productRepository = productRepository,
        super(CatalogState()) {
    on<LoadCatalogEvent>(_onLoadCatalog);
  }

  _onLoadCatalog(
      LoadCatalogEvent event,
      Emitter<CatalogState> emit,
      ) async {
    emit(state.copyWith(status: CatalogStatus.loading));
    try {
      print("yo");
      print(event.categoryId);
      final category =
          await _categoryRepository.fetchCategory(event.categoryId);

      if (category == null) {
        emit(state.copyWith(status: CatalogStatus.error));
        return;
      } else {
        emit(state.copyWith(status: CatalogStatus.loaded,
          category: category,
        ));
      }
      await emit.forEach(
        _productRepository.streamProducts(event.categoryId),
        onData: (products) {
          return state.copyWith(
            status: CatalogStatus.loaded,
            products: products,
          );
        },
      );
    } catch (err) {
      emit(state.copyWith(status: CatalogStatus.error));
    }

  }



}
