import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/vodafone_service.dart';

enum ChargeState { idle, loading, success, error }

class ChargeProvider extends ChangeNotifier {
  Product? selectedProduct;
  ChargeState state = ChargeState.idle;
  String message = '';

  void selectProduct(Product p) {
    selectedProduct = p;
    notifyListeners();
  }

  Future<void> charge({required String receiver, required String pin}) async {
    if (selectedProduct == null) return;
    state = ChargeState.loading;
    message = '';
    notifyListeners();

    final result = await VodafoneService().charge(
      receiver: receiver,
      pin: pin,
      productId: selectedProduct!.id,
    );

    state = result.success ? ChargeState.success : ChargeState.error;
    message = result.message;
    notifyListeners();
  }

  void reset() {
    state = ChargeState.idle;
    message = '';
    selectedProduct = null;
    notifyListeners();
  }
}
