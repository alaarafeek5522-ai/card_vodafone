import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/charge_provider.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class ChargeScreen extends StatefulWidget {
  final Product product;
  const ChargeScreen({super.key, required this.product});

  @override
  State<ChargeScreen> createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  final _receiverCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _pinVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _receiverCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ChargeProvider>();
    provider.selectProduct(widget.product);
    await provider.charge(
      receiver: _receiverCtrl.text.trim(),
      pin: _pinCtrl.text.trim(),
    );
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<ChargeProvider>().state == ChargeState.loading;

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: Text(
          widget.product.name,
          style: GoogleFonts.cairo(
            color: AppTheme.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product badge
              _buildProductBadge(),
              const SizedBox(height: 28),
              // Receiver field
              _buildLabel('📱 رقم المستقبل'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _receiverCtrl,
                hint: '01xxxxxxxxx',
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'ادخل الرقم';
                  if (!v.startsWith('01') || v.length != 11) {
                    return 'رقم غير صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // PIN field
              _buildLabel('🔒 الرقم السري للمحفظة'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _pinCtrl,
                hint: '••••••',
                obscure: !_pinVisible,
                suffix: IconButton(
                  icon: Icon(
                    _pinVisible ? Icons.visibility_off : Icons.visibility,
                    color: AppTheme.grey,
                  ),
                  onPressed: () => setState(() => _pinVisible = !_pinVisible),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'ادخل الرقم السري';
                  return null;
                },
              ),
              const SizedBox(height: 36),
              // Submit button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.red,
                    foregroundColor: AppTheme.white,
                    disabledBackgroundColor: AppTheme.redDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'شحن الآن',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.red.withOpacity(0.2), AppTheme.cardBg],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.red.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Text(
            widget.product.category == ProductCategory.fakka ? '💸' : '⚡',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الكرت المختار',
                style: GoogleFonts.cairo(color: AppTheme.grey, fontSize: 12),
              ),
              Text(
                widget.product.name,
                style: GoogleFonts.cairo(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2);
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        color: AppTheme.greyLight,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.cairo(color: AppTheme.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(color: AppTheme.grey),
        suffixIcon: suffix,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
