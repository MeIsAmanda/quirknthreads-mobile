part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable{
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoriesEvent extends CategoryEvent {
  const LoadCategoriesEvent();
}
