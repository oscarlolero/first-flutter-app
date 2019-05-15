import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/user.dart';

mixin ProductsModel on ConnectedProductsModel {


  bool _showFavorites = false;

  List<Product> get allProducts {
    //para myproductsmodel.products
    return List.from(_products); //regresa un pointer a una nueva lista
    // en memoria, para eso, si editamos esta lista, no editariamos la original, es lo que queremos
    //si hacemos return _products; se regresa la direccion de la lista de productos original D:
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void updateProduct(String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        username: selectedProduct.username,
        userid: selectedProduct.userid
    );
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners(); //hace un rebuild a lo que esta dentro del wrap de ScopedModelDescendant
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    notifyListeners(); //hace un rebuild a lo que esta dentro del wrap de ScopedModelDescendant
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    if (index != null) {//https://www.udemy.com/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/10840630#questions/6825196
      notifyListeners();//This ensures, that existing pages are only immediately updated (=> re-rendered) when a product is selected, not when it's unselected.
    }
  }

  void toggleFavoriteProduct() {
    final bool isCurrentlyFavorite =
        _products[selectedProductIndex].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updateProduct = Product(
      //unnmutable way, best way
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      username: selectedProduct.username,
      userid: selectedProduct.userid,
      isFavorite: newFavoriteStatus,);
    _products[selectedProductIndex] = updateProduct;
    notifyListeners(); //hace un rebuild a lo que esta dentro del wrap de ScopedModelDescendant
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  int _selProductIndex;
  User _authenticatedUser;

  void addProduct(String title, String description, String image, double price) {
    final Product newProduct = Product(
      title: title,
      description: description,
      price: price,
      image: image,
      username: _authenticatedUser.username,
      userid: _authenticatedUser.id
    );

    _products.add(newProduct);
    notifyListeners(); //hace un rebuild a lo que esta dentro del wrap de ScopedModelDescendant
  }
}


mixin UserModel on ConnectedProductsModel {

  void login(String username, String password) {
    _authenticatedUser = User(
      id: 'asdasd',
      username: username,
      password: password,
    );
  }
}