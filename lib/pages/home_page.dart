import 'package:flutter/material.dart';
import '../models/phones.dart';
import '../services/api_services.dart';
import 'detail_page.dart';
import 'create_page.dart';
import 'edit_page.dart';
import '../widgets/phone_card.dart'; // pastikan ada file ini
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Phone>> _futurePhones;
  final Set<String> _favoriteIds = {}; // simpan id phone yang difavoritkan

  @override
  void initState() {
    super.initState();
    _fetchPhones();
  }

  void _fetchPhones() {
    setState(() {
      _futurePhones = ApiService.fetchPhones();
    });
  }

  Future<void> _deletePhone(String id) async {
    try {
      await ApiService.deletePhone(int.parse(id));
      _fetchPhones();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () async {
              final phones = await _futurePhones;
              final favoritePhones = phones.where((p) => _favoriteIds.contains(p.id)).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritePage(
                    favorites: favoritePhones,
                    favoriteIds: _favoriteIds,
                    onFavoriteToggle: (id) {
                      setState(() {
                        if (_favoriteIds.contains(id)) {
                          _favoriteIds.remove(id);
                        } else {
                          _favoriteIds.add(id);
                        }
                      });
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Phone',
            onPressed: () async {
              final didCreate = await Navigator.pushNamed(
                context,
                CreatePage.routeName,
              );
              if (didCreate == true) {
                _fetchPhones();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Phone>>(
        future: _futurePhones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data phone'));
          } else {
            final phones = snapshot.data!;
            return ListView.builder(
              itemCount: phones.length,
              itemBuilder: (context, index) {
                final phone = phones[index];
                return PhoneCard(
                  phone: phone,
                  isFavorite: _favoriteIds.contains(phone.id),
                  onFavoriteToggle: () {
                    setState(() {
                      if (_favoriteIds.contains(phone.id)) {
                        _favoriteIds.remove(phone.id);
                      } else {
                        _favoriteIds.add(phone.id);
                      }
                    });
                  },
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          phone: phone,
                          isFavorite: _favoriteIds.contains(phone.id),
                          onFavoriteToggle: () {
                            setState(() {
                              if (_favoriteIds.contains(phone.id)) {
                                _favoriteIds.remove(phone.id);
                              } else {
                                _favoriteIds.add(phone.id);
                              }
                            });
                            Navigator.pop(context); // agar icon di list juga update
                          },
                        ),
                      ),
                    );
                  },
                  onEdit: () async {
                    final didUpdate = await Navigator.pushNamed(
                      context,
                      EditPage.routeName,
                      arguments: phone, // kirim objek Phone
                    );
                    if (didUpdate == true) {
                      _fetchPhones();
                    }
                  },
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text('Hapus phone ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await _deletePhone(phone.id); // pastikan phone.id adalah id yang benar
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
