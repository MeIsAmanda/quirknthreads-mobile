part of 'catalog_bloc.dart';

enum CatalogStatus {initial, loading, loaded, error}

class CatalogState extends Equatable{
  final CatalogStatus status;
  final List<Product> products;
  final Category? category;

  const CatalogState({
    this.status = CatalogStatus.initial,
    this.products = const <Product>[],
    this.category,
});
  copyWith({
    CatalogStatus? status,
    List<Product>? products,
    Category? category,
}) {
    return CatalogState(
      status: status ?? this.status,
      products: products ?? this.products,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [status, category, products];

}

final class CatalogInitial extends CatalogState {}
