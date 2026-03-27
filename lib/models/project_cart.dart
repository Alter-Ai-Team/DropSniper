import 'product_group.dart';

class ProjectCart {
  ProjectCart({
    required this.id,
    required this.name,
    required this.budgetThreshold,
    List<ProductGroup>? groups,
  }) : groups = groups ?? <ProductGroup>[];

  final String id;
  final String name;
  final double budgetThreshold;
  final List<ProductGroup> groups;

  double get totalCartPrice => groups.fold(0, (sum, item) => sum + item.cheapestPrice);

  bool get isUnderBudget => totalCartPrice <= budgetThreshold;

  ProjectCart copyWith({
    String? id,
    String? name,
    double? budgetThreshold,
    List<ProductGroup>? groups,
  }) {
    return ProjectCart(
      id: id ?? this.id,
      name: name ?? this.name,
      budgetThreshold: budgetThreshold ?? this.budgetThreshold,
      groups: groups ?? this.groups,
    );
  }
}
