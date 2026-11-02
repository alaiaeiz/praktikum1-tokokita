
import 'package:get/get.dart';

import '../services/wishlist_service.dart';

class WishlistController extends GetxController {
  final WishlistService _wishlistService = WishlistService();

  final RxSet<String> favoriteIds = <String>{}.obs;
  final RxBool isLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    try {
      final ids = await _wishlistService.getFavoriteIds();

      favoriteIds
        ..clear()
        ..addAll(ids);
    } catch (error) {
      Get.snackbar(
        'Wishlist',
        'Gagal memuat wishlist: $error',
      );
    } finally {
      isLoaded.value = true;
    }
  }

  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }

  Future<void> toggleFavorite(String productId) async {
    final updatedIds = favoriteIds.toSet();

    final bool willBeFavorite = !updatedIds.contains(productId);

    if (willBeFavorite) {
      updatedIds.add(productId);
    } else {
      updatedIds.remove(productId);
    }

    try {
      await _wishlistService.saveFavoriteIds(
        updatedIds.toList(),
      );

      favoriteIds
        ..clear()
        ..addAll(updatedIds);

      Get.snackbar(
        'Wishlist',
        willBeFavorite
            ? 'Produk berhasil ditambahkan ke wishlist.'
            : 'Produk berhasil dihapus dari wishlist.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (error) {
      Get.snackbar(
        'Wishlist',
        'Gagal memperbarui wishlist: $error',
      );
    }
  }

  Future<void> removeFavorite(String productId) async {
    if (!favoriteIds.contains(productId)) return;

    final updatedIds = favoriteIds.toSet()
      ..remove(productId);

    try {
      await _wishlistService.saveFavoriteIds(
        updatedIds.toList(),
      );

      favoriteIds
        ..clear()
        ..addAll(updatedIds);
    } catch (error) {
      Get.snackbar(
        'Wishlist',
        'Gagal menghapus produk: $error',
      );
    }
  }
}
