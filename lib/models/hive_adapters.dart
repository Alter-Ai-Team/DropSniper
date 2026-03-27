import 'package:hive_flutter/hive_flutter.dart';

import 'product_group.dart';
import 'product_link.dart';
import 'project_cart.dart';

class HiveBoxes {
  static const carts = 'project_carts';
  static const settings = 'settings';
}

class HiveBootstrap {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive
      ..registerAdapter(PricePointAdapter())
      ..registerAdapter(ProductLinkAdapter())
      ..registerAdapter(ProductGroupAdapter())
      ..registerAdapter(ProjectCartAdapter());

    await Hive.openBox<ProjectCart>(HiveBoxes.carts);
    await Hive.openBox(HiveBoxes.settings);
  }
}

class PricePointAdapter extends TypeAdapter<PricePoint> {
  @override
  final int typeId = 1;

  @override
  PricePoint read(BinaryReader reader) {
    return PricePoint(
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      price: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, PricePoint obj) {
    writer
      ..writeInt(obj.timestamp.millisecondsSinceEpoch)
      ..writeDouble(obj.price);
  }
}

class ProductLinkAdapter extends TypeAdapter<ProductLink> {
  @override
  final int typeId = 2;

  @override
  ProductLink read(BinaryReader reader) {
    return ProductLink(
      id: reader.readString(),
      url: reader.readString(),
      vendorName: reader.readString(),
      currentPrice: reader.readDouble(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      priceHistory: (reader.readList().cast<PricePoint>()),
    );
  }

  @override
  void write(BinaryWriter writer, ProductLink obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.url)
      ..writeString(obj.vendorName)
      ..writeDouble(obj.currentPrice)
      ..writeInt(obj.updatedAt.millisecondsSinceEpoch)
      ..writeList(obj.priceHistory);
  }
}

class ProductGroupAdapter extends TypeAdapter<ProductGroup> {
  @override
  final int typeId = 3;

  @override
  ProductGroup read(BinaryReader reader) {
    return ProductGroup(
      id: reader.readString(),
      title: reader.readString(),
      links: reader.readList().cast<ProductLink>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductGroup obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeList(obj.links);
  }
}

class ProjectCartAdapter extends TypeAdapter<ProjectCart> {
  @override
  final int typeId = 4;

  @override
  ProjectCart read(BinaryReader reader) {
    return ProjectCart(
      id: reader.readString(),
      name: reader.readString(),
      budgetThreshold: reader.readDouble(),
      groups: reader.readList().cast<ProductGroup>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProjectCart obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeDouble(obj.budgetThreshold)
      ..writeList(obj.groups);
  }
}
