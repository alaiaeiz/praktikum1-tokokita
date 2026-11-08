import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  static const String _favoriteIdsKey = 'favorite_product_ids';

  Future<List<String>> getFavoriteIds() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getStringList(_favoriteIdsKey) ?? <String>[];
  }

  Future<void> saveFavoriteIds(List<String> ids) async {
    final preferences = await SharedPreferences.getInstance();

    final success = await preferences.setStringList(_favoriteIdsKey, ids);

    if (!success) {
      throw Exception('Gagal menyimpan wishlist.');
    }
  }
}
