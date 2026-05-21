class Product {
  final String name;
  final String id;
  final ProductCategory category;

  const Product({
    required this.name,
    required this.id,
    required this.category,
  });
}

enum ProductCategory { fakka, mared }

const List<Product> allProducts = [
  Product(name: 'فكة 2.5 جنيه',   id: 'Fakka_2.5_Unite',    category: ProductCategory.fakka),
  Product(name: 'فكة 4.25 جنيه',  id: 'Fakka_4.25_Unite',   category: ProductCategory.fakka),
  Product(name: 'فكة 5 جنيه',     id: 'Fakka_5_Unite',      category: ProductCategory.fakka),
  Product(name: 'فكة 6 جنيه',     id: 'Fakka_6_NewUnite',   category: ProductCategory.fakka),
  Product(name: 'فكة 7 جنيه',     id: 'Fakka_7_Unite',      category: ProductCategory.fakka),
  Product(name: 'فكة 9 جنيه',     id: 'Fakka_9_Unite',      category: ProductCategory.fakka),
  Product(name: 'فكة 10 جنيه',    id: 'Fakka_10_Unite',     category: ProductCategory.fakka),
  Product(name: 'فكة 10 جنيه (new)', id: 'Fakka_10_NewUnite', category: ProductCategory.fakka),
  Product(name: 'فكة 10.5 جنيه',  id: 'Fakka_10.5_Unite',   category: ProductCategory.fakka),
  Product(name: 'فكة 11.5 جنيه',  id: 'Fakka_11.5_Unite',   category: ProductCategory.fakka),
  Product(name: 'فكة 12 جنيه',    id: 'Fakka_12_Unite',     category: ProductCategory.fakka),
  Product(name: 'فكة 12.5 جنيه',  id: 'Fakka_12.5_Unite',   category: ProductCategory.fakka),
  Product(name: 'فكة 13 جنيه',    id: 'Fakka_13_Unite',     category: ProductCategory.fakka),
  Product(name: 'فكة 13.5 جنيه',  id: 'Fakka_13.5_Unite',   category: ProductCategory.fakka),
  Product(name: 'فكة 15 جنيه',    id: 'Fakka_15_Unite',     category: ProductCategory.fakka),
  Product(name: 'فكة 15 جنيه (new)', id: 'Fakka_15_NewUnite', category: ProductCategory.fakka),
  Product(name: 'فكة 15.5 جنيه',  id: 'Fakka_15.5_Unite',   category: ProductCategory.fakka),
  Product(name: 'فكة 16.5 جنيه',  id: 'Fakka_16.5_Unite',   category: ProductCategory.fakka),
  Product(name: 'فكة 17.5 جنيه',  id: 'Fakka_17.5_Unite',   category: ProductCategory.fakka),
  Product(name: 'فكة 19.5 جنيه',  id: 'Fakka_19.5_NewUnite',category: ProductCategory.fakka),
  Product(name: 'فكة 20 جنيه',    id: 'Fakka_20_Unite',     category: ProductCategory.fakka),
  Product(name: 'فكة 26 جنيه',    id: 'Fakka_26_Unite',     category: ProductCategory.fakka),
  Product(name: 'مارد 10 دقايق',  id: 'Mared_10_Minuts',    category: ProductCategory.mared),
  Product(name: 'مارد 10 فليكس',  id: 'Mared_10_Flexs',     category: ProductCategory.mared),
  Product(name: 'مارد 10 سوشيال', id: 'Mared_10_Social',    category: ProductCategory.mared),
];
