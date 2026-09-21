import 'package:flutter/material.dart';
import '../models/product.dart';

// --- Widget Custom Pendukung ---
class PriceLabel extends StatelessWidget {
  final double price;
  const PriceLabel({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      formatRupiah(price),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.green,
        fontSize: 14,
      ),
    );
  }
}

class StockBadge extends StatelessWidget {
  final String status;
  const StockBadge({super.key, required this.status});

  Color _getBadgeColor() {
    if (status == 'Tersedia') return Colors.green;
    if (status == 'Stok Terbatas') return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getBadgeColor().withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getBadgeColor(),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

// --- ProductCard Utama ---
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    print('initState() dipanggil untuk: ${widget.product.name}');
  }

  @override
  void dispose() {
    print('dispose() dipanggil untuk: ${widget.product.name}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build() dipanggil me-render: ${widget.product.name}');
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.shopping_bag, size: 40, color: Colors.blue),
                StockBadge(status: widget.product.getStatusStok()),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            PriceLabel(price: widget.product.price),
          ],
        ),
      ),
    );
  }
}