import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    this.quantity = 1,
  });
}

class CartService extends ChangeNotifier {
  // Singleton pour garder le même panier partout dans l'app
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Calcul automatique du montant total
  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Ajouter un article ou incrémenter sa quantité s'il existe déjà
  void addItem(CartItem newItem) {
    final index = _items.indexWhere((item) => item.id == newItem.id);
    if (index >= 0) {
      _items[index].quantity += newItem.quantity;
    } else {
      _items.add(newItem);
    }
    notifyListeners(); // Prvient l'interface qu'il y a du changement
  }

  // Mettre à jour la quantité (utilisé dans CartScreen)
  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  // Supprimer un article spécifique
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Vider complètement le panier (après un paiement réussi)
  void clear() {
    _items.clear();
    notifyListeners();
  }
}