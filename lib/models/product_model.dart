class Product {
  final String name;
  final String id;
  final String netCharge;
  final String units;
  final String duration;
  final ProductCategory category;

  const Product({
    required this.name,
    required this.id,
    required this.netCharge,
    required this.units,
    required this.duration,
    required this.category,
  });
}

enum ProductCategory { fakka, social }

const List<Product> allProducts = [
  Product(name: 'Fakka 2.5',    id: 'Fakka_2.5_Unite',      netCharge: '1.75',  units: '45 وحدة',             duration: 'يوم واحد',  category: ProductCategory.fakka),
  Product(name: 'Fakka 3',      id: 'Fakka_3_Unite',         netCharge: '2.10',  units: '125 وحدة',            duration: 'يوم واحد',  category: ProductCategory.fakka),
  Product(name: 'Fakka 4.25',   id: 'Fakka_4.25_Unite',      netCharge: '2.97',  units: '190 وحدة',            duration: 'يوم واحد',  category: ProductCategory.fakka),
  Product(name: 'Fakka 5',      id: 'Fakka_5_Unite',         netCharge: '3.50',  units: '225 وحدة',            duration: 'يوم واحد',  category: ProductCategory.fakka),
  Product(name: 'Fakka 6',      id: 'Fakka_6_Unite',         netCharge: '4.20',  units: '270 وحدة',            duration: 'يوم واحد',  category: ProductCategory.fakka),
  Product(name: 'Fakka 7',      id: 'Fakka_7_Unite',         netCharge: '4.90',  units: '300 وحدة',            duration: '3 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 8',      id: 'Fakka_8_Unite',         netCharge: '5.60',  units: '350 وحدة',            duration: '3 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 9',      id: 'Fakka_9_Unite',         netCharge: '6.30',  units: '400 وحدة',            duration: '4 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 10',     id: 'Fakka_10_Unite',        netCharge: '7.00',  units: '450 وحدة',            duration: '7 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 10.5',   id: 'Fakka_10.5_Unite',      netCharge: '7.35',  units: '400 وحدة + 50MB',     duration: '7 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 11.5',   id: 'Fakka_11.5_Unite',      netCharge: '8.05',  units: '550 وحدة',            duration: '7 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 12',     id: 'Fakka_12_Unite',        netCharge: '8.40',  units: '425 وحدة',            duration: '7 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 12.5',   id: 'Fakka_12.5_Unite',      netCharge: '8.75',  units: '500 وحدة',            duration: '7 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 13',     id: 'Fakka_13_Unite',        netCharge: '9.10',  units: '500 وحدة',            duration: '7 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 13.5',   id: 'Fakka_13.5_Unite',      netCharge: '9.45',  units: '625 وحدة',            duration: '7 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 15',     id: 'Fakka_15_Unite',        netCharge: '10.50', units: '550 وحدة',            duration: '7 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 15.5',   id: 'Fakka_15.5_Unite',      netCharge: '10.85', units: '625 وحدة',            duration: '7 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 16.5',   id: 'Fakka_16.5_Unite',      netCharge: '11.55', units: '425 وحدة',            duration: '6 أيام',    category: ProductCategory.fakka),
  Product(name: 'Fakka 17.5',   id: 'Fakka_17.5_Unite',      netCharge: '12.25', units: '650 وحدة',            duration: '10 أيام',   category: ProductCategory.fakka),
  Product(name: 'Fakka 19.5',   id: 'Fakka_19.5_NewUnite',   netCharge: '13.65', units: '550 وحدة',            duration: '10 أيام',   category: ProductCategory.fakka),
  Product(name: 'Fakka 20',     id: 'Fakka_20_Unite',        netCharge: '14.00', units: '700 وحدة',            duration: '10 أيام',   category: ProductCategory.fakka),
  Product(name: 'Fakka 26',     id: 'Fakka_26_Unite',        netCharge: '18.20', units: '750 وحدة',            duration: '10 أيام',   category: ProductCategory.fakka),
  Product(name: 'Fakka 2.5 Social',  id: 'Fakka_2.5_Social',  netCharge: '1.75',  units: '45 وحدة سوشيال',    duration: 'يوم واحد',  category: ProductCategory.social),
  Product(name: 'Fakka 4.25 Social', id: 'Fakka_4.25_Social', netCharge: '2.97',  units: '190 وحدة سوشيال',   duration: 'يوم واحد',  category: ProductCategory.social),
  Product(name: 'Fakka 7 Social',    id: 'Fakka_7_Social',    netCharge: '4.90',  units: '300 وحدة سوشيال',   duration: '3 أيام',    category: ProductCategory.social),
  Product(name: 'Fakka 9 Social',    id: 'Fakka_9_Social',    netCharge: '6.30',  units: '400 وحدة سوشيال',   duration: '4 أيام',    category: ProductCategory.social),
];
