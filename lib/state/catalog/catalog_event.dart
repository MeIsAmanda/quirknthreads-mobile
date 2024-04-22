part of 'catalog_bloc.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

class LoadCatalogEvent extends CatalogEvent{
  const LoadCatalogEvent({
    required this.categoryId,
    this.category,
});
  final String categoryId;
  final Category? category;

  @override
  List<Object?> get props => [categoryId, category];
}
