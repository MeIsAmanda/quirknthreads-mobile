import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/category.dart';
import '../../repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc({
    required CategoryRepository categoryRepository,
}) : _categoryRepository = categoryRepository,
        super(const CategoryState()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  void _onLoadCategories(
      LoadCategoriesEvent event,
      Emitter<CategoryState> emit,
      ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    try {
      final categories = await _categoryRepository.fetchCategories();
      emit(state.copyWith(
        status: CategoryStatus.loaded,
        categories: categories,
      ));
    } catch(err){
      emit(state.copyWith(status: CategoryStatus.error));
    }


  }

}
