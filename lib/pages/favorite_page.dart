import 'package:flutter/material.dart';
import '../models/phones.dart';
import '../widgets/phone_card.dart';
import 'detail_page.dart';
import 'edit_page.dart';

class FavoritePage extends StatelessWidget {
  final List<Phone> favorites;
  final Set<String> favoriteIds;
  final Function(String) onFavoriteToggle;

  const FavoritePage({
    Key? key,
    required this.favorites,
    required this.favoriteIds,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Phones')),
      body: favorites.isEmpty
          ? const Center(child: Text('Belum ada favorite'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final phone = favorites[index];
                return PhoneCard(
                  phone: phone,
                  isFavorite: favoriteIds.contains(phone.id),
                  onFavoriteToggle: () => onFavoriteToggle(phone.id),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailPage.routeName,
                      arguments: phone,
                    );
                  },
                  onEdit: () async {
                    final didUpdate = await Navigator.pushNamed(
                      context,
                      EditPage.routeName,
                      arguments: phone,
                    );
                    if (didUpdate == true) {
                      // Anda bisa menambahkan callback untuk refresh jika perlu
                    }
                  }, onDelete: () {  },
                  // onDelete bisa ditambahkan jika ingin hapus dari favorite
                );
              },
            ),
    );
  }
}