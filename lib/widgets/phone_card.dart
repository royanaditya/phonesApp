import 'package:flutter/material.dart';
import '../models/phones.dart';

class PhoneCard extends StatelessWidget {
  final Phone phone;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PhoneCard({
    Key? key,
    required this.phone,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: phone.img_url.isNotEmpty
            ? Image.network(phone.img_url, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.phone_android, size: 40),
        title: Text(phone.name),
        subtitle: Text('${phone.brand}\n${phone.price}'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: onFavoriteToggle,
              tooltip: isFavorite ? 'Unfavorite' : 'Favorite',
            ),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
                tooltip: 'Edit',
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
                tooltip: 'Delete',
              ),
          ],
        ),
      ),
    );
  }
}