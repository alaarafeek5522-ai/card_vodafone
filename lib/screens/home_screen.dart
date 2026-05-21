import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import 'charge_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductCategory _selected = ProductCategory.fakka;
  String _search = '';

  List<Product> get filtered => allProducts
      .where((p) =>
          p.category == _selected &&
          (_search.isEmpty || p.name.contains(_search)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: Text(
          'Card Vodafone',
          style: GoogleFonts.cairo(
            color: AppTheme.white,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.red, width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'فودافون كاش',
              style: GoogleFonts.cairo(
                color: AppTheme.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category tabs
          _buildTabs(),
          // Search
          _buildSearch(),
          // List
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: ProductCategory.values.map((cat) {
          final active = _selected == cat;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selected = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? AppTheme.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  cat == ProductCategory.fakka ? '💸 فكة' : '⚡ مارد',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    color: active ? AppTheme.white : AppTheme.grey,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2);
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        onChanged: (v) => setState(() => _search = v),
        style: GoogleFonts.cairo(color: AppTheme.white),
        decoration: InputDecoration(
          hintText: 'ابحث عن كرت...',
          hintStyle: GoogleFonts.cairo(color: AppTheme.grey),
          prefixIcon: const Icon(Icons.search, color: AppTheme.grey),
          filled: true,
          fillColor: AppTheme.cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildList() {
    final items = filtered;
    if (items.isEmpty) {
      return Center(
        child: Text(
          'مفيش نتايج',
          style: GoogleFonts.cairo(color: AppTheme.grey, fontSize: 16),
        ),
      );
    }
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final p = items[i];
          return AnimationConfiguration.staggeredList(
            position: i,
            duration: const Duration(milliseconds: 350),
            child: SlideAnimation(
              verticalOffset: 30,
              child: FadeInAnimation(
                child: _ProductCard(product: p),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChargeScreen(product: product)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  product.category == ProductCategory.fakka ? '💸' : '⚡',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                product.name,
                style: GoogleFonts.cairo(
                  color: AppTheme.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: AppTheme.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
