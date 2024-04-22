part of 'category_bloc.dart';

enum CategoryStatus {initial, loading, loaded, error}


class CategoryState extends Equatable{
  final CategoryStatus status;
  final List<Category> categories;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const <Category>[],
});

  CategoryState copyWith({
    CategoryStatus? status,
    List<Category>? categories,
}) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,);
  }

  @override
  List<Object> get props => [status];

}

final class CategoryInitial extends CategoryState {}
