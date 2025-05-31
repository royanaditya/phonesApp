class Phone {
  final String id;
  final String name;
  final String brand;
  final String img_url;
  final String price;
  final String specification;

  Phone({
    required this.id,
    required this.name,
    required this.brand,
    required this.img_url,
    required this.price,
    required this.specification,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      img_url: json['img_url'] ?? '',
      price: json['price'].toString(),
      specification: json['specification'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'img_url': img_url,
    'price': price,
    'brand': brand,
    'specification': specification,
  };
}
