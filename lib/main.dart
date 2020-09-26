import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_pagination_helper/pagination_helper/item_list_callback.dart';
import 'package:flutter_pagination_helper/pagination_helper/list_helper.dart';
import 'package:flutter_pagination_helper/pagination_helper/event_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';
import 'package:sample_web/model/cartModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geolocator/geolocator.dart';

import 'model/product.dart';
import 'config/size_config.dart';
import 'colors.dart';
import 'data/moor_database.dart';

final ThemeData _appThemeData = _buildAppTheme();
const int threshold = 13;
const int totalItems = 39;

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: primaryColor,
    accentColor: primaryLight,
    buttonColor: primaryDark,

    // textTheme: _buildTextTheme(base.textTheme),
    // primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    // accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500
    ),
    title: base.title.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  ).apply(
    fontFamily: 'OpenSans'
  );
}

// void main() => runApp(
//   ChangeNotifierProvider(
//     create: (context) => CartModel(),
//       // child: MyApp1(),
//       // child: MyApp(),
//       // child: MyApp2(),
//       // child: Pagination(),
//       // child: LazyScrollView(),
//       // child: FB(),
//       // child: SB(),
//       child: MQ(),
//   )
// );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      // home: HomePage(),
      // home: TextScalePage(),
      initialRoute: '/',
      routes: {
        '/' : (context) => HomePage(),
        '/productlist' : (context) => ProductList(),
        '/favoritelist' : (context) => FavoriteList(),
        '/cart': (context) => Cart(),
        //'/second' : (context) => DetailScreen(),
      },
      theme: _appThemeData,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, semanticLabel: 'menu'), 
          onPressed: () {
            print('menu btn');
          }
        ),
        title: Text('Home Page',),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              print('Search button');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/productlist');
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Home Page'),
      )
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  ProductListState createState() => new ProductListState();
}

class ProductListState extends State<ProductList> {
  // List<Product> favoriteList = new List<Product>();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() { });
  }

  loadProducts() {
    // if(_scrollController.lis
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, semanticLabel: 'menu'), 
          onPressed: () {
            print('menu btn');
          }
        ),
        title: Text('Shopping',),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              semanticLabel: 'search',
            ),
            onPressed: () {
              print('Cart button');
              Navigator.pushNamed(
                context, 
                '/cart'
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              semanticLabel: 'Favorite List',
            ),
            onPressed: () {
              Navigator.pushNamed(
                context, 
                '/favoritelist',
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              print('Search button');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              print('Filter button');
            },
          ),
        ],
      ),
      body: GridView.count(
        controller: _scrollController,
        crossAxisCount: 2,
        padding: EdgeInsets.all(10.0),
        childAspectRatio: 8.0 / 9.0,
        children: _buildGridCards(10, context)
      )
    );
  }

  List<Card> _buildGridCards(int count, BuildContext context) {
    // List<Product> products = ProductsRepository.loadProducts(Category.all);
    var cartModel = Provider.of<CartModel>(context);
    List<Product> products = cartModel.getproducts();
    List<Product> favoriteList = cartModel.getFavoriteproducts();
    //print(products);
    //null check
    if (products == null || products.isEmpty) {
      return const <Card>[];
    }
    
    final List<Card> list = products.map((product) {
      final isFavorite = favoriteList.contains(product);
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    product.assetName,
                    package: product.assetPackage,
                    fit: BoxFit.fitWidth,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ), 
                      onPressed: () {
                        setState(() {
                          if(isFavorite) {
                            cartModel.removeFromFavorites(product);
                            //print('Favorite List : ' + favoriteList.toList().toString());
                          } else {
                            cartModel.addToFavorites(product);
                          }
                        });
                      },
                    ),
                  )
                ],
              )
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.title,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '₹'+product.price.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(width: 8.0),
                        product.oldPrice==null?Text(''):Text(
                          '₹'+product.price.toString(),
                          style: TextStyle(decoration :TextDecoration.lineThrough),
                          textAlign: TextAlign.center,
                        ),
                        //addButton()
                        // IconButton(
                        //   constraints: BoxConstraints(),
                        //   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        //   icon: Icon(
                        //     Icons.add,
                        //     semanticLabel: 'filter',
                        //   ), 
                        //   onPressed: null,
                        //   alignment: Alignment.topRight,
                        // )
                      ],
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     addButton()
                    //   ],
                    // )
                    addButton(product: product)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    return list.isEmpty?CircularProgressIndicator():list;
  }
}

class addButton extends StatelessWidget {
  final Product product;

  const addButton({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cartModel = Provider.of<CartModel>(context);
    var products = cartModel.productsInCart;

    return Align(
        alignment: Alignment.topRight,
        //heightFactor: 50.0,
        child: OutlineButton(
          onPressed: () => cartModel.addItemToCart(product.id),
          splashColor: Theme.of(context).primaryColor,
          child: products.containsKey(product.id)
              ? Icon(Icons.check, semanticLabel: 'ADDED')
              : Text('ADD'),
      ),
    );
  }
    
}

class FavoriteList extends StatefulWidget {
  @override
  FavoriteListState createState() => new FavoriteListState();
}

class FavoriteListState extends State<FavoriteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: _buildGridCards(context),
      )
    );
  }

  List<Card> _buildGridCards(BuildContext context) {
    var cartModel = Provider.of<CartModel>(context);
    final List<Product> products = cartModel.getFavoriteproducts();
    //null check
    if (products == null || products.isEmpty) {
      return const <Card>[];
    }
    
    final List<Card> list = products.map((product) {
      final isFavorite = products.contains(product);

      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    product.assetName,
                    package: product.assetPackage,
                    fit: BoxFit.fitWidth,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ), 
                      onPressed: () {
                        setState(() {
                          if(isFavorite) {
                            cartModel.removeFromFavorites(product);
                            //print('Favorite List : ' + favoriteList.toList().toString());
                          } else {
                            cartModel.addToFavorites(product);
                          }
                        });
                      },
                    ),
                  )
                ],
              )
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.title,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '₹'+product.price.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(width: 8.0),
                        product.oldPrice==null?Text(''):Text(
                          '₹'+product.price.toString(),
                          style: TextStyle(decoration :TextDecoration.lineThrough),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    return list.isEmpty?CircularProgressIndicator():list;
  }
  
  
}

class Cart extends StatefulWidget {
  @override
  CartState createState() => new CartState();
}

class CartState extends State<Cart> {
  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView(
        children: _buildItemsLayout(context),
      )
      // body: _buildItemsLayout(context),
    );
  }

  List<ListTile> _buildItemsLayout(BuildContext context) {
    var cartModel = Provider.of<CartModel>(context);
    var items = cartModel.productsInCart.keys.toList();

    List<Product> products = new List<Product>();
    products = items.map((e) { return cartModel.getProductById(e);}).toList();

    List<ListTile> list = products.map((product) {
      return ListTile(
        leading: Image.asset(
          product.assetName,
          package: product.assetPackage,
          fit: BoxFit.contain,
          width: 60,
          height: 60,
        ),
        title: Text(product.name,textAlign: TextAlign.left),
        subtitle: Text('₹'+product.price.toString(),textAlign: TextAlign.left),
        // trailing: FlatButton(onPressed: () {}, child: Text('remove')),
        enabled: true,
        // trailing: Stack(
        //   alignment: Alignment.center,
        //   fit: StackFit.loose,
        //   children: <Widget>[
        //     Text(
        //       '₹'+product.price.toString(),
        //       style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        //     ),
        //     FlatButton(
        //       onPressed: () {
        //         setState(() {
        //           cartModel.removeItemFromCart(product.id);
        //         });
        //       },
        //       child: Text('remove')
        //     ),
        //   ],
        // )
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '₹'+product.price.toString(),
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            SizedBox(width: 15),
            GestureDetector(
              child: Icon(
                Icons.remove_circle_outline, 
                color: Colors.red,
              ),
              onTap: () {
                setState(() {
                  cartModel.removeItemFromCart(product.id);
                });
              },
            )
            
            // FlatButton(
            //   onPressed: () {
            //     setState(() {
            //       cartModel.removeItemFromCart(product.id);
            //     });
            //   },
            //   child: Icon(Icons.remove_circle_outline, color: Colors.red),
            //   shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            // ),
          ],
        ),
      );
    }).toList();

    if(list.length!=0) {
      list.add(
        ListTile(
          leading: Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          trailing: Text(
                '₹'+cartModel.subtotalCost.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
        )
      );
    }

    return list;

    // List<Widget> list = products.map((product) {
    //   return row(product);
    // }).toList();

    // return list;
  }

  row(Product product) {
    return Container(
      // top: false,
      // bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
          right: 8,
        ),
        child: Row(
          children: <Widget>[
            AspectRatio(
              // borderRadius: BorderRadius.circular(4),
              aspectRatio: 1/1,
              child: Image.asset(
                product.assetName,
                package: product.assetPackage,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          product.name,
                          //style: Styles.productRowItemName,
                        ),
                        Text(
                          'quantity * product.price',
                          // style: Styles.productRowItemName,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      //'${quantity > 1 ? '$quantity x ' : ''}'
                      '$product.price',
                      //style: Styles.productRowItemPrice,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class Pagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView with Pagination',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lazyloading ListView'),
        ),
        body: PaginatedListWidget(
          itemListCallback: OnScrollListener(),
        ),
      ),
    );
  }

}

class OnScrollListener<T extends Widget> extends ItemListCallback {
  int availableItems = 0;
  @override
  Future<EventModel<Widget>> getItemList() {
    return Future.delayed(Duration(seconds: 3), () {
      List<T> itemList = new List();
      if (availableItems < totalItems) {
        for(int i = availableItems; i < availableItems + threshold; i++) {
          Widget w;
          // w = ListItemWidget(ItemModel(WordPair.random().asPascalCase.toString(), ''));
          w =  TitleWidget(WordPair.random().asPascalCase.toString());
          itemList.add(w);
        }
        availableItems += threshold;
        return EventModel(progress: false, data: itemList, error: null);
      } else {
        for (int i = availableItems; i < availableItems + 3; i++) {
          Widget widget = TitleWidget(WordPair.random().asPascalCase.toString());
          itemList.add(widget);
        }
        availableItems += 3;
        return EventModel(
            progress: false, data: itemList, error: null, stopLoading: true);
      }
    });
  }
  
}

class TitleWidget extends StatelessWidget {
  final String i;

  TitleWidget(this.i);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[50],
          // boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Text(
            "$i",
            style: TextStyle(fontSize: 18),
          ),
      ),
    );
  }
}

class cardsOnScrollListener<T extends Widget> extends ItemListCallback {
  int availableItems = 0;
  Product product; bool isFavorite;

  cardsOnScrollListener(this.isFavorite, this.product);
  @override
  Future<EventModel<Widget>> getItemList() {
    return Future.delayed(Duration(seconds: 3), () {
      List<T> itemList = new List();
      if (availableItems < totalItems) {
        for(int i = availableItems; i < availableItems + threshold; i++) {
          Widget w;
          // w = ListItemWidget(ItemModel(WordPair.random().asPascalCase.toString(), ''));
          w =  TitleWidget(WordPair.random().asPascalCase.toString());
          itemList.add(w);
        }
        availableItems += threshold;
        return EventModel(progress: false, data: itemList, error: null);
      } else {
        for (int i = availableItems; i < availableItems + 3; i++) {
          Widget widget = TitleWidget(WordPair.random().asPascalCase.toString());
          itemList.add(widget);
        }
        availableItems += 3;
        return EventModel(
            progress: false, data: itemList, error: null, stopLoading: true);
      }
    });
  }
  
}

class LazyScrollView extends StatefulWidget {
  @override
  LazyScrollViewState createState() => LazyScrollViewState();
}

class LazyScrollViewState extends State<LazyScrollView> {
  int currentLength = 0;
  final int increment = 6;
  bool isLoading = false;
  var cartModel;
  List<Product> products = new List<Product>();
  List<Product> favoriteList = new List<Product>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    cartModel = Provider.of<CartModel>(context);
    // products = cartModel.getproducts();
    favoriteList = cartModel.getFavoriteproducts();
    if(currentLength==0)loadMore(cartModel.getproducts());
    return MaterialApp(
      title: 'ListView with Pagination',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lazyloading ListView'),
        ),
        body: LazyLoadScrollView(
          isLoading: isLoading,
          onEndOfPage: () => loadMore(cartModel.getproducts()),
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(10.0),
            childAspectRatio: 8.0 / 9.0,
            children: _buildGridCards(10, context)
          ), 
        )
      ),
    );
  }

  Future loadMore(List<Product> p) async {
    print(p[0]);
    setState(() {
      isLoading = true;
    });
    await new Future.delayed(const Duration(seconds: 2));
    for (var i = currentLength; i <= currentLength + increment; i++) {
      //setState(() {
        products.add(p[i]);
      //});
    }
    print(products);
    setState(() {
      isLoading = false;
      currentLength = products.length;
    });
  }

  List<Card> _buildGridCards(int count, BuildContext context) {
    // List<Product> products = ProductsRepository.loadProducts(Category.all);
    // var cartModel = Provider.of<CartModel>(context);
    // List<Product> products = cartModel.getproducts();
    // List<Product> favoriteList = cartModel.getFavoriteproducts();
    //print(products);
    //null check
    if (products == null || products.isEmpty) {
      return const <Card>[];
    }
    
    final List<Card> list = products.map((product) {
      final isFavorite = favoriteList.contains(product);
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    product.assetName,
                    package: product.assetPackage,
                    fit: BoxFit.fitWidth,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ), 
                      onPressed: () {
                        setState(() {
                          if(isFavorite) {
                            cartModel.removeFromFavorites(product);
                            //print('Favorite List : ' + favoriteList.toList().toString());
                          } else {
                            cartModel.addToFavorites(product);
                          }
                        });
                      },
                    ),
                  )
                ],
              )
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.title,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '₹'+product.price.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(width: 8.0),
                        product.oldPrice==null?Text(''):Text(
                          '₹'+product.price.toString(),
                          style: TextStyle(decoration :TextDecoration.lineThrough),
                          textAlign: TextAlign.center,
                        ),
                        //addButton()
                        // IconButton(
                        //   constraints: BoxConstraints(),
                        //   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        //   icon: Icon(
                        //     Icons.add,
                        //     semanticLabel: 'filter',
                        //   ), 
                        //   onPressed: null,
                        //   alignment: Alignment.topRight,
                        // )
                      ],
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     addButton()
                    //   ],
                    // )
                    addButton(product: product)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    return list.isEmpty?CircularProgressIndicator():list;
  }

}

class MyApp1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Lazy Load Demo',
      home: new MyHomePage(title: 'Lazy Load Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> data = [];
  int currentLength = 0;

  final int increment = 10;
  bool isLoading = false;

  @override
  void initState() {
    _loadMore();
    super.initState();
  }

  Future _loadMore() async {
    setState(() {
      isLoading = true;
    });

    // Add in an artificial delay
    await new Future.delayed(const Duration(seconds: 2));
    for (var i = currentLength; i <= currentLength + increment; i++) {
      data.add(i);
    }
    setState(() {
      isLoading = false;
      currentLength = data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LazyLoadScrollView(
        isLoading: isLoading,
        onEndOfPage: () => _loadMore(),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, position) {
            return DemoItem(position);
          },
        ),
      ),
    );
  }
}

class DemoItem extends StatelessWidget {
  final int position;

  const DemoItem(
    this.position, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.grey,
                  height: 40.0,
                  width: 40.0,
                ),
                SizedBox(width: 8.0),
                Text("Item $position"),
              ],
            ),
            Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sed vulputate orci. Proin id scelerisque velit. Fusce at ligula ligula. Donec fringilla sapien odio, et faucibus tortor finibus sed. Aenean rutrum ipsum in sagittis auctor. Pellentesque mattis luctus consequat. Sed eget sapien ut nibh rhoncus cursus. Donec eget nisl aliquam, ornare sapien sit amet, lacinia quam."),
          ],
        ),
      ),
    );
  }
}

class FB extends StatefulWidget {
  @override
  FBState createState() => FBState();
}

class FBState extends State<FB> {


  Future<List<User>> _getUsers() async {
    final response = await get('https://api.github.com/users');
    List<User> _users = [];
    var parsedData = json.decode(response.body).cast<Map<String, dynamic>>();
    var data = parsedData.map<User>((json) => User.fromJson(json)).toList();
    // print(data);
    _users= data;
    return _users;
  }

  @override
  void initState() {
    super.initState();
    // _getUsers();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Builder',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Future Builder'),
        ),
        body: Container(
            child: FutureBuilder(
            future: _getUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print('Connection state : '+ snapshot.connectionState.toString());
              if(!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: Text('Loading...')
                  ),
                );
              } 
              else {
                print(snapshot.data.length.toString());
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context,int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data[index].avatarUrl),
                      ),
                      title: Text(snapshot.data[index].login),
                      subtitle: Text(snapshot.data[index].url),
                      // trailing: Text(users.data[index].url),
                    );
                  },
                );
              }
            }
          ),
        ) 
      ),
    );
  }
}

class User {
    String login;
    int id;
    String nodeId;
    String avatarUrl;
    String gravatarId;
    String url;
    String htmlUrl;
    String followersUrl;
    String followingUrl;
    String gistsUrl;
    String starredUrl;
    String subscriptionsUrl;
    String organizationsUrl;
    String reposUrl;
    String eventsUrl;
    String receivedEventsUrl;
    Type type;
    bool siteAdmin;

    User({
        this.login,
        this.id,
        this.nodeId,
        this.avatarUrl,
        this.gravatarId,
        this.url,
        this.htmlUrl,
        this.followersUrl,
        this.followingUrl,
        this.gistsUrl,
        this.starredUrl,
        this.subscriptionsUrl,
        this.organizationsUrl,
        this.reposUrl,
        this.eventsUrl,
        this.receivedEventsUrl,
        this.type,
        this.siteAdmin,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        login: json["login"],
        id: json["id"],
        nodeId: json["node_id"],
        avatarUrl: json["avatar_url"],
        gravatarId: json["gravatar_id"],
        url: json["url"],
        htmlUrl: json["html_url"],
        followersUrl: json["followers_url"],
        followingUrl: json["following_url"],
        gistsUrl: json["gists_url"],
        starredUrl: json["starred_url"],
        subscriptionsUrl: json["subscriptions_url"],
        organizationsUrl: json["organizations_url"],
        reposUrl: json["repos_url"],
        eventsUrl: json["events_url"],
        receivedEventsUrl: json["received_events_url"],
        siteAdmin: json["site_admin"],
    );

    Map<String, dynamic> toJson() => {
        "login": login,
        "id": id,
        "node_id": nodeId,
        "avatar_url": avatarUrl,
        "gravatar_id": gravatarId,
        "url": url,
        "html_url": htmlUrl,
        "followers_url": followersUrl,
        "following_url": followingUrl,
        "gists_url": gistsUrl,
        "starred_url": starredUrl,
        "subscriptions_url": subscriptionsUrl,
        "organizations_url": organizationsUrl,
        "repos_url": reposUrl,
        "events_url": eventsUrl,
        "received_events_url": receivedEventsUrl,
        "site_admin": siteAdmin,
    };
}

class SB extends StatefulWidget {
  @override
  SBState createState() => SBState();
}

class SBState extends State<SB> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "713f2973f0f19d599d6541400f6c1fef50a42bfa";

  TextEditingController _controller = new TextEditingController();
  
  StreamController _streamController;
  Stream _stream;

  Timer _timer;
  
  _search() async {
    if(_controller.text==null || _controller.text.length==0) {
      _streamController.add(null);
      return;
    }

    _streamController.add('waiting');
    Response response = await get(_url + _controller.text.trim(), headers: {'Authorization': 'Token 713f2973f0f19d599d6541400f6c1fef50a42bfa'});
    print(json.decode(response.body));
    _streamController.add(json.decode(response.body));

  }

  @override
  void initState() {
    _streamController = new StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Builder',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stream Builder'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 12.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0)
                    ),
                    child: TextFormField(
                      onChanged: (String text) {
                        // if(_timer?.isActive ?? false) _timer.cancel();
                        // _timer = Timer(const Duration(milliseconds: 1000), () {
                        //   _search();
                        // });
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Search a word',
                        contentPadding: EdgeInsets.only(left: 24.0),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ), 
                  onPressed: () {
                    _search();
                  }
                )
              ],
            )
          ),
        ),
        body: Container(
            margin: EdgeInsets.all(8.0),
            child: StreamBuilder(
            stream: _stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.data==null) {
                return Center(
                  child: Text('Please type a word in the field')
                );
              }

              if(snapshot.data=='waiting') {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data['definitions'].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListBody(
                    children: <Widget>[
                      Container(
                        color: Colors.grey[300],
                        child: ListTile(
                          leading: snapshot.data['definitions'][index]['image_url']==null?
                          null:
                          CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data['definitions'][index]['image_url']),
                          ),
                          title: Text(_controller.text.trim()+" ("+snapshot.data['definitions'][index]['type']+")"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(snapshot.data['definitions'][index]['definition'])
                      )
                    ],
                  );
                }
              );
            }
          ),
        ),
      ),
    );
  }
}

class MQ extends StatefulWidget {
  @override
  MQState createState() => MQState();
}

class MQState extends State<MQ> {
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return MaterialApp(
      title: 'Media Query',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Media Query'),
        ),
        body: _MQBody(context)
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Media Query'),
    //   ),
    //   body: Center(
    //     child: Container(
    //       width: SizeConfig.blockSizeHorizontal*20,
    //       height: SizeConfig.blockSizeVertical*30,
    //       color: Colors.black,
    //     ),
    //   ),
    // );
  }

  _MQBody(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.blue,
    );
  }
}

class TextScalePage extends StatefulWidget {
  @override
  _TextScalePageState createState() => _TextScalePageState();
}

class _TextScalePageState extends State<TextScalePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: Text(
          'Scaling text!',
          style: TextStyle(
            fontSize: SizeConfig.safeBlockHorizontal * 10,
          ),
        ),
      ),
    );
  }
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scale UI to fit multiple display sizes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: TextScalePage(),
      // home: MyCustomForm(),
      // home: SP(),
      // home: DB(),
      // home: MF()
      home: MyMap(),
    );
  }
}

void main() => runApp(MyApp2());

// void main() => runApp(MFApp());


// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    _focusNode = new FocusNode();

    _controller.addListener((onChangeListener));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  onChangeListener() {
    print('Text Changed : ' + _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forms'),
      ),
      body:  Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'User Name',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              validator: (value) {
                if(value.isEmpty) {
                  return 'Please Enter Text';
                }
                return null;
              },
              // onChanged: (text) {
              //   print('Text changed : ' + text);
              // },
              controller: _controller,
              focusNode: _focusNode,
            ),
            FlatButton(
              onPressed: () {
                // if(_formKey.currentState.validate()) {
                //   Scaffold.
                //     of(context)
                //     .showSnackBar(SnackBar(content: Text('Processing')));
                // }
                // return showDialog(
                //   context: context,
                //   child: AlertDialog(
                //     content: Text(''+_controller.text),
                //     title: Text('Message'),
                //   ),
                //   barrierDismissible: true,
                // );
                _focusNode.requestFocus();
              }, 
              child: Text('Submit')
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'This is a TextField'
              ),
            )
          ],
        ),
      )
    );
  }
  
}

class SP extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SPState();
  }
}

class SPState extends State<SP> {
  int _counter = 0;

  _loadCounter() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = _prefs.getInt('counter') ?? 0;
    });
  }

  _incrementCounter() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = _counter+1;
      _prefs.setInt('counter', _counter);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Pref's")
      ),
      body: Center(
          child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed $_counter times')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter();
        }
      ),
    );
  }

}

class DB extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DBState();
  }
}

class DBState extends State<DB> {
  
  Future<Database> database;
  List<Dog> _dogs = new List<Dog>();

  @override
  void initState() {
    super.initState();
    _initDB();
    dogs();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DB'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await _addDog();
            }
          )
        ],
      ),
      // body: FutureBuilder(
      //   future: dogs(),
      //   builder: (context, snapshot) {
      //     return ListView.builder(
      //       itemCount: snapshot.data.length??0,
      //       itemBuilder: (context, index) {
      //         if(snapshot.connectionState==ConnectionState.waiting) {
      //           return CircularProgressIndicator();
      //         } 
      //         return ListTile(
      //           title: Text(snapshot.data[index].name),
      //           trailing: IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: () => _deleteDOg(snapshot.data[index].id)),
      //         );
      //       }
      //     );
      //     // if(snapshot.connectionState==ConnectionState.waiting) {
      //     //   return CircularProgressIndicator();
      //     // } 
      //     // return Text('Success');
      //   },
      // ),
      // body: Container(),
      body: Container(
        child: ListView.builder(
          itemCount: _dogs.length??0,
          itemBuilder: (context, index) {
            if(_dogs.isEmpty) {
              return Center(
                child: Text('Empty List'),
              );
            }
            return ListTile(
              title: Text(_dogs[index].name),
              trailing: IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: () => _deleteDOg(_dogs[index].id)),
            );
          } 
        ),
      )
    );
  }

  _initDB() async {
    database = openDatabase(
      //create db
      join(await getDatabasesPath(), 'dog_database.db'),
      //create table
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)'
        );
      },
      version: 1
    );
  }

  _addDog() async {
    final Database db = await database;
    await db.insert('dogs', {
      'name': WordPair.random().asPascalCase,
      'age': 42,
    },conflictAlgorithm: ConflictAlgorithm.replace);
    print('added!');
    dogs();
  }

  _deleteDOg(id) async {
    final Database db = await database;
    await db.delete(
      'dogs',
      where: "id = ?",
      whereArgs: [id],
    );
    dogs();
  }

  _updateDog() async{
    final Database db = await database;
    await db.update(
      'dogs',
      {
        'id': 0,
        'name': WordPair.random(),
        'age': 39,
      },
      where: "id = ?",
      whereArgs: [0],
    );
  }

  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    if(maps.isEmpty) {
      _dogs = [];
      setState(() {
        _dogs = [];
      });
    } else {
      List<Dog> dogs = List.generate(maps.length, (i) {
        return Dog(
          id: maps[i]['id'],
          name: maps[i]['name'],
          age: maps[i]['age'],
        );
      });

      setState(() {
        _dogs = dogs;
      });
    }
    
  }
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  Map<String, dynamic>toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'age': this.age
    };
  }
}

class MFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppDatabase(),
      child: MaterialApp(
        title: 'Material App',
        home: MF(),
      ),
    );
  }
}

class MF extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MFState();
  }
}

class MFState extends State<MF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('Moor Example')
      ),
      body:Column(
        children: <Widget>[
          Expanded(child: _buildTaskList(context)),
          NewTaskInput(),
        ],
      ),
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    return StreamBuilder(
      stream: db.watchAllTasks(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final tasks = snapshot.data ?? List();
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final taskItem = tasks[index];
              return _buildTaskItem(taskItem, db);
            }
          );
        }
      }
    );
  }

  Widget _buildTaskItem(Task task, AppDatabase db) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            db.deleteTask(task);
          },
        )
      ],
      child: CheckboxListTile(
        value: task.completed, 
        onChanged: (value) {
          db.updatetask(task.copyWith(completed: value));
        },
        title: Text(task.name),
        subtitle: Text(task.dueDate?.toString() ?? 'No Date'),
      ),
    );
  }

}

class NewTaskInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewTaskInputState();
  }
}

class NewTaskInputState extends State<NewTaskInput> {
  DateTime newTaskDateTime;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController();
  } 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTextField(context),
          _buildDateButton(context)
        ],
      ),
    );
  }

  Widget _buildTextField(context) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Task Name'
        ),
        onSaved: (value) {
          final db = Provider.of<AppDatabase>(context);
          final task = Task(
            name: value.toString(),
            dueDate: newTaskDateTime
          );
          db.insertTask(task);
          resetValues();
        },
        onFieldSubmitted: (value) {
          final db = Provider.of<AppDatabase>(context);
          final task = Task(
            name: value.toString(),
            dueDate: newTaskDateTime
          );
          db.insertTask(task);
          resetValues();
        },
      )
    );
  }

  resetValues() {
    setState(() {
      controller.clear();
      newTaskDateTime = null;
    });
  }

  Widget _buildDateButton(context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.calendar_today), 
          onPressed: () async {
            newTaskDateTime = await showDatePicker(
              context: context, 
              initialDate: DateTime.now(), 
              firstDate: DateTime(2019), 
              lastDate: DateTime(2030)
            );
          }
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            final db = Provider.of<AppDatabase>(context,listen: false);
            final task = Task(
              name: controller.text.toString(),
              dueDate: newTaskDateTime
            );
            db.insertTask(task);
            resetValues();
          }
        )
      ],
    );
  }

}

class MyMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MapState();
  }
}

class MapState extends State<MyMap> {
  GoogleMapController mapController;
  Position coordinates;
  LatLng _center = const LatLng(45.521563, -122.677433);
  Set<Marker> _markers = new Set();
  @override
  void initState() {
    super.initState();
  }
  
  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
    _getCurrentLocation();
  }
  
  void _getCurrentLocation() async {
    coordinates = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('Coordinates : ' + coordinates.latitude.toString());
    setState(() {
      _center = LatLng(coordinates.latitude, coordinates.longitude);
      print(_center.toString());
      Marker marker = new Marker(markerId: MarkerId('value'), position: _center);
      _markers.add(marker);
    });
  }

  // Future<Position> position = Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 1.0
        )
      ),
    );
  }
  
}

