import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isVodafone = false;
  bool _checkingNetwork = false;
  final _formKey = GlobalKey<FormState>();

  static const _contactsChannel = MethodChannel('com.card.developerAlaa/contacts');

  @override
  void dispose() {
    _receiverCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickContact() async {
    try {
      final result = await _contactsChannel.invokeMethod<String>('pickContact');
      if (result != null && result.isNotEmpty) {
        // تنظيف الرقم
        String clean = result.replaceAll(RegExp(r'[^\d]'), '');
        if (clean.startsWith('20') && clean.length == 12) {
          clean = '0${clean.substring(2)}';
        }
        if (clean.startsWith('+20')) {
          clean = '0${clean.substring(3)}';
        }
        _receiverCtrl.text = clean;
        if (clean.startsWith('01') && clean.length == 11) {
          await _checkVodafone(clean);
        }
      }
    } catch (e) {
      // لو MethodChannel مش جاهز نفتح contacts بطريقة تانية
      _showContactsManual();
    }
  }

  void _showContactsManual() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'ادخل الرقم يدوياً',
          style: GoogleFonts.cairo(color: Colors.white),
        ),
        backgroundColor: AppTheme.cardBg,
      ),
    );
  }

  Future<void> _checkVodafone(String number) async {
    if (!number.startsWith('01') || number.length != 11) return;
    setState(() => _checkingNetwork = true);

    // Vodafone Egypt prefixes
    final vodafonePrefixes = ['010', '011'];
    final prefix = number.substring(0, 3);
    final isVf = vodafonePrefixes.contains(prefix);

    setState(() {
      _isVodafone = isVf;
      _checkingNetwork = false;
    });
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
              _buildProductBadge(),
              const SizedBox(height: 28),
              _buildLabel('📱 رقم المستقبل'),
              const SizedBox(height: 8),
              // حقل الرقم مع زر جهات الاتصال
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _receiverCtrl,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.cairo(color: AppTheme.white, fontSize: 16),
                      onChanged: (v) {
                        if (v.length == 11) _checkVodafone(v);
                        if (v.length < 11) setState(() => _isVodafone = false);
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'ادخل الرقم';
                        if (!v.startsWith('01') || v.length != 11) return 'رقم غير صحيح';
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: '01xxxxxxxxx',
                        hintStyle: GoogleFonts.cairo(color: AppTheme.grey),
                        suffixIcon: _checkingNetwork
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 16, height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2, color: AppTheme.grey,
                                  ),
                                ),
                              )
                            : _receiverCtrl.text.length == 11
                                ? Icon(
                                    _isVodafone ? Icons.check_circle : Icons.warning_rounded,
                                    color: _isVodafone ? Colors.green : Colors.orange,
                                    size: 20,
                                  )
                                : null,
                        filled: true,
                        fillColor: AppTheme.cardBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _receiverCtrl.text.length == 11
                                ? (_isVodafone ? Colors.green : Colors.orange)
                                : AppTheme.cardBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // زر جهات الاتصال
                  GestureDetector(
                    onTap: _pickContact,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.red.withOpacity(0.4)),
                      ),
                      child: const Icon(
                        Icons.contacts_rounded,
                        color: AppTheme.red,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              // مؤشر فودافون
              if (_receiverCtrl.text.length == 11) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      _isVodafone ? Icons.check_circle : Icons.warning_rounded,
                      color: _isVodafone ? Colors.green : Colors.orange,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isVodafone ? 'رقم فودافون ✅' : 'مش فودافون ⚠️',
                      style: GoogleFonts.cairo(
                        color: _isVodafone ? Colors.green : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              _buildLabel('🔒 الرقم السري للمحفظة'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _pinCtrl,
                obscureText: !_pinVisible,
                style: GoogleFonts.cairo(color: AppTheme.white, fontSize: 16),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'ادخل الرقم السري';
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '••••••',
                  hintStyle: GoogleFonts.cairo(color: AppTheme.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _pinVisible ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.grey,
                    ),
                    onPressed: () => setState(() => _pinVisible = !_pinVisible),
                  ),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 36),
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
                          width: 24, height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'شحن الآن',
                          style: GoogleFonts.cairo(
                            fontSize: 18, fontWeight: FontWeight.w700,
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'V',
                style: GoogleFonts.cairo(
                  color: AppTheme.red,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
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
              Text(
                '${widget.product.units} — ${widget.product.duration}',
                style: GoogleFonts.cairo(color: AppTheme.grey, fontSize: 12),
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
}
