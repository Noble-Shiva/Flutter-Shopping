import 'dart:collection';

import 'package:flutter/foundation.dart' as foundation;

import 'product.dart';
import 'products_repository.dart';

class CartModel extends foundation.ChangeNotifier {
  List<Product> _products = [];
  List<Product> _favorites = [];

  final _productsInCart = <int, int>{};

  List<Product> getproducts() {
    return _products = ProductsRepository.loadProducts(Category.all);
    // notifyListeners();
  }

  List<Product> getFavoriteproducts() {
    return _favorites;
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProdut(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void removeAll() {
    _products.clear();
    notifyListeners();
  }

  void addToFavorites(Product product) {
    _favorites.add(product);
    notifyListeners();
  }

  void removeFromFavorites(Product product) {
    _favorites.remove(product);
    notifyListeners();
  }

  // The IDs and quantities of products currently in the cart.
  Map<int, int> get productsInCart {
    return Map.from(_productsInCart);
  }

  void addItemToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }

    notifyListeners();
  }

  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }

    notifyListeners();
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _products.firstWhere((p) => p.id == id);
  }
  
  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys.map((id) {
      // Extended price for product line
      return getProductById(id).price * _productsInCart[id];
    }).fold(0, (accumulator, extendedPrice) {
      return accumulator + extendedPrice;
    });
  }
}