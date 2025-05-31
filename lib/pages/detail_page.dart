// detail_page.dart
import 'package:flutter/material.dart';
import '../models/phones.dart';

class DetailPage extends StatelessWidget {
  static const String routeName = '/detail';

  final Phone phone;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const DetailPage({
    Key? key,
    required this.phone,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(phone.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: onFavoriteToggle,
            tooltip: isFavorite ? 'Unfavorite' : 'Favorite',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            phone.img_url.isNotEmpty &&
                    (phone.img_url.startsWith('http://') || phone.img_url.startsWith('https://')) &&
                    (phone.img_url.endsWith('.jpg') || phone.img_url.endsWith('.jpeg') || phone.img_url.endsWith('.png') || phone.img_url.endsWith('.webp'))
                ? Image.network(
                    phone.img_url,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
                  )
                : Icon(Icons.broken_image, size: 100),
            SizedBox(height: 16),
            Text('Brand: ${phone.brand}', style: TextStyle(fontSize: 18)),
            Text('Price: ${phone.price}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Specification:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(phone.specification),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
