// import 'package:flutter/material.dart';
// import 'package:english_words/english_words.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {

//   final _name = 'Shiva';
//   @override
//   Widget build(BuildContext context) {

//     return MaterialApp(
//       title: 'Welcome to Flutter',
//       //home: NetworkCall()
//       home: Scaffold(
//         // appBar: AppBar(
//         //   centerTitle: true,
//         //   title: Text('Welcome to Flutter'),
//         // ),
//         // body: Column(
//         // children: <Widget>[
//         //   FlatButton(
//         //     onPressed: () {
//         //       /*...*/
//         //     },
//         //     child: Text(
//         //       "Flat Button",
//         //     ),
//         //   ),
//         //   FlatButton(
//         //     color: Colors.blue,
//         //     textColor: Colors.white,
//         //     disabledColor: Colors.grey,
//         //     disabledTextColor: Colors.black,
//         //     padding: EdgeInsets.all(8.0),
//         //     splashColor: Colors.blueAccent,
//         //     onPressed: () {
//         //       /*...*/
//         //     },
//         //     child: Text(
//         //       "Flat Button",
//         //       style: TextStyle(fontSize: 20.0),
//         //     ),
//         //   ),
//         //   RaisedButton(
//         //     onPressed: null,
//         //     padding: EdgeInsets.all(10.0),
//         //     child: Text(
//         //       'Disabled Button',
//         //       style: TextStyle(fontSize: 20)
//         //     ),
//         //   ),
//         //   RaisedButton(
//         //     onPressed: () {},
//         //     child: const Text(
//         //       'Enabled Button',
//         //       style: TextStyle(fontSize: 20)
//         //     ),
//         //   ),
//         //   OutlineButton(
//         //     onPressed: () {

//         //     },
//         //     borderSide: BorderSide(
//         //       color: Colors.blue,
//         //       width: 2
//         //     ),
//         //     child: Text(
//         //       'Outline Button'
//         //     ),
//         //   )
//         // ]
//         // ),
//         body: SizedBox(
//           width: 250,
//           height: 250,
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 width: 250,
//                 height: 250,
//                 color: Colors.white,
//               ),
//               Container(
//                 padding: EdgeInsets.all(5.0),
//                 alignment: Alignment.bottomCenter,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: <Color>[
//                       Colors.black.withAlpha(0),
//                       Colors.black12,
//                       Colors.black45
//                     ],
//                   ),
//                 ),
//                 child: Text(
//                   "Foreground Text",
//                   style: TextStyle(color: Colors.white, fontSize: 20.0),
//                 ),
//               ),
//             ],
//           ),
//         )
//         // floatingActionButton: FloatingActionButton.extended(
//         //   onPressed: null, 
//         //   label: Text('Accepted'),
//         //   icon: Icon(Icons.thumb_up),
//         // ),
//       )
//     );
//   }
// }

// class RandomWordsState extends State<RandomWords> {
//   final List<WordPair> _suggestions = <WordPair>[];
//   final Set<WordPair> _saved = Set<WordPair>();
//   final TextStyle _biggerFont = TextStyle(fontSize: 18.0);

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print('Init State');
//     //final response = call();
//     //print(response.toString());
//   }

//   // Future<http.Response> call() async {
//   //   final response = await http.get('https://jsonplaceholder.typicode.com/albums/1');

//   //   if (response.statusCode == 200) {
//   //     // If the server did return a 200 OK response,
//   //     // then parse the JSON.
//   //     // return Album.fromJson(json.decode(response.body));
//   //     return json.decode(response.body);
//   //   } else {
//   //     // If the server did not return a 200 OK response,
//   //     // then throw an exception.
//   //     throw Exception('Failed to load album');
//   //   }
//   // }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     print('Dispose State');
//   }

//   @override
//   void reassemble() {
//     // TODO: implement reassemble
//     super.reassemble();
//     print('Reassemble lifecycle called because application has reloaded!');
//   }

//   @override
//   void didUpdateWidget(RandomWords oldWidget) {
//     // TODO: implement didUpdateWidget
//     super.didUpdateWidget(oldWidget);
//     print('Did Update Widget : ' + oldWidget.toString());
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter'),
//         actions: <Widget>[
//           IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
//           IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
//         ],
//       ),
//       body: _buildSuggestions(),
//     );
//   }

//   Widget _buildSuggestions() {
//   return ListView.builder(
//     padding: const EdgeInsets.all(16.0),
//     itemBuilder: (context, i) {
//       if (i.isOdd) return Divider();

//       final index = i ~/ 2;
//       if (index >= _suggestions.length) {
//         _suggestions.addAll(generateWordPairs().take(10));
//       }
//       return _buildRow(_suggestions[index]);
//     });
//   }

//   Widget _buildRow(WordPair pair) {
//     final bool alreadySaved = _saved.contains(pair);
//     return ListTile(
//       title: Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//       trailing: Icon( 
//         alreadySaved ? Icons.favorite : Icons.favorite_border,
//         color: alreadySaved ? Colors.red : null,
//       ),  
//       onTap: () {
//         setState(() {
//           if (alreadySaved) {
//             _saved.remove(pair);
//             showToast('Removed from Favorites');
//           } else { 
//             _saved.add(pair); 
//             showToast('Added to Favorites');
//           } 
//         });
//       },               
//     );
//   }

//   void _pushSaved() {
//     Navigator.of(context).push(
//       MaterialPageRoute<void>(   
//         builder: (BuildContext context) {
          
//           // if saved list is empty
//           if(_saved.isEmpty) return Scaffold(         
//             appBar: AppBar(
//               title: Text('Saved Words'),
//             ),
//             body: Text('No saved words')
//           );

//           final Iterable<ListTile> tiles = _saved.map(
//             (WordPair pair) {
//               print(pair.asPascalCase.isEmpty);
//               return ListTile(
//                 title: Text(
//                   pair.asPascalCase,
//                   style: _biggerFont,
//                 ),
//               );
//             },
//           );
//           final List<Widget> divided = ListTile
//             .divideTiles(
//               context: context,
//               tiles: tiles,
//             ).toList();
//           return Scaffold(         
//             appBar: AppBar(
//               title: Text('Saved Words'),
//             ),
//             body: ListView(children: divided)
//           ); 
//         },
//       ),
//     );
//   }

//   void showToast(msg) {
//     print(msg);
//     // Fluttertoast.showToast(
//     //     msg: msg,
//     //     toastLength: Toast.LENGTH_SHORT,
//     //     gravity: ToastGravity.CENTER,
//     //     //timeInSecForIosWeb: 1,
//     //     backgroundColor: Colors.red,
//     //     textColor: Colors.white,
//     //     fontSize: 16.0
//     // );
//     Fluttertoast.showToast(msg: msg);
//   }
// }

// class RandomWords extends StatefulWidget {
//   @override
//   RandomWordsState createState() => RandomWordsState();
// }

// class NetworkCall extends StatefulWidget {
//   @override
//   NetworkCallState createState() => NetworkCallState();
// }

// class NetworkCallState extends State<NetworkCall> {
  
//   Future<Model> model;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     model = getDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Http Request',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Http Request'),
//         ),
//         body: Center(
//           child: FutureBuilder(
//             future: model,
//             builder: (context, snapshot) {
//               if(snapshot.hasData) {
//                 return Text(snapshot.data.title);
//               } else if(snapshot.hasError){
//                 return Text("${snapshot.error}");
//               }
//               return CircularProgressIndicator();
//             }
//           ),
//         ),
//       ),
//     );
//   }

// }

// class Model {
//   final int userId;
//   final int id;
//   final String title;

//   Model({this.userId, this.id, this.title});

//   factory Model.fromJson(Map<String, dynamic> json) {
//     return Model (
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }

// Future<Model> getDetails() async {
//   final response = await http.get('https://jsonplaceholder.typicode.com/posts');

//   if(response.statusCode==200) {
//     return Model.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Failed to load album');
//   }
// }




// import 'package:flutter/material.dart';

// class MyAppBar extends StatelessWidget {
//   MyAppBar({this.title});

//   // Fields in a Widget subclass are always marked "final".

//   final Widget title;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 56.0, // in logical pixels
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       decoration: BoxDecoration(color: Colors.blue[500]),
//       // Row is a horizontal, linear layout.
//       child: Row(
//         // <Widget> is the type of items in the list.
//         children: <Widget>[
//           IconButton(
//             icon: Icon(Icons.menu),
//             tooltip: 'Navigation menu',
//             onPressed: null, // null disables the button
//           ),
//           // Expanded expands its child to fill the available space.
//           Expanded(
//             child: title,
//           ),
//           IconButton(
//             icon: Icon(Icons.search),
//             tooltip: 'Search',
//             onPressed: null,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MyScaffold extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Material is a conceptual piece of paper on which the UI appears.
//     return Material(
//       // Column is a vertical, linear layout.
//       child: Column(
//         children: <Widget>[
//           MyAppBar(
//             title: Text(
//               'Example title',
//               style: Theme.of(context).primaryTextTheme.title,
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Text('Hello, world!'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     title: 'My app', // used by the OS task switcher
//     home: MyScaffold(),
//   ));
// }


// ============================   *************    =============================== //
// import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     title: 'Flutter Tutorial',
//     home: TutorialHome(),
//   ));
// }

// class TutorialHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Scaffold is a layout for the major Material Components.
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           tooltip: 'Navigation menu',
//           onPressed: null,
//         ),
//         title: Text('Example title'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.search),
//             tooltip: 'Search',
//             onPressed: null,
//           ),
//         ],
//       ),
//       // body is the majority of the screen.
//       body: Counter(),
//       floatingActionButton: FloatingActionButton(
//         tooltip: 'Add', // used by assistive technologies
//         child: Icon(Icons.add),
//         onPressed: null,
//       ),
//     );
//   }
// }

// class MyButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print('MyButton was tapped!');
//       },
//       child: Container(
//         height: 36.0,
//         padding: const EdgeInsets.all(8.0),
//         margin: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 30.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.0),
//           color: Colors.lightGreen[500],
//         ),
//         child: Center(
//           child: Text('Engage'),
//         ),
//       ),
//     );
//   }
// }

// class CounterDisplay extends StatelessWidget {
//   CounterDisplay({this.count});

//   final int count;

//   @override
//   Widget build(BuildContext context) {
//     return Text('Count: $count');
//   }
// }

// class CounterIncrementor extends StatelessWidget {
//   CounterIncrementor({this.onPressed});

//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return RaisedButton(
//       onPressed: onPressed,
//       child: Text('Increment'),
//     );
//   }
// }

// class Counter extends StatefulWidget {
//   @override
//   _CounterState createState() => _CounterState();
// }

// class _CounterState extends State<Counter> {
//   int _counter = 0;

//   void _increment() {
//     setState(() {
//       ++_counter;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: <Widget>[
//       CounterIncrementor(onPressed: _increment),
//       CounterDisplay(count: _counter),
//     ]);
//   }
// }

// ================================ *********** =============================//
// import 'package:flutter/material.dart';

// class Product {
//   const Product({this.name});
//   final String name;
// }

// typedef void CartChangedCallback(Product product, bool inCart);

// class ShoppingListItem extends StatelessWidget {
//   ShoppingListItem({this.product, this.inCart, this.onCartChanged})
//       : super(key: ObjectKey(product));

//   final Product product;
//   final bool inCart;
//   final CartChangedCallback onCartChanged;

//   Color _getColor(BuildContext context) {
//     // The theme depends on the BuildContext because different parts of the tree
//     // can have different themes.  The BuildContext indicates where the build is
//     // taking place and therefore which theme to use.

//     return inCart ? Colors.black54 : Theme.of(context).primaryColor;
//   }

//   TextStyle _getTextStyle(BuildContext context) {
//     if (!inCart) return null;

//     return TextStyle(
//       color: Colors.black54,
//       decoration: TextDecoration.lineThrough,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         onCartChanged(product, inCart);
//       },
//       leading: CircleAvatar(
//         backgroundColor: _getColor(context),
//         child: Text(product.name[0]),
//       ),
//       title: Text(product.name, style: _getTextStyle(context)),
//     );
//   }
// }

// class ShoppingList extends StatefulWidget {
//   ShoppingList({Key key, this.products}) : super(key: key);

//   final List<Product> products;

//   // The framework calls createState the first time a widget appears at a given
//   // location in the tree. If the parent rebuilds and uses the same type of
//   // widget (with the same key), the framework re-uses the State object
//   // instead of creating a new State object.

//   @override
//   _ShoppingListState createState() => _ShoppingListState();
// }

// class _ShoppingListState extends State<ShoppingList> {
//   Set<Product> _shoppingCart = Set<Product>();

//   void _handleCartChanged(Product product, bool inCart) {
//     setState(() {
//       // When a user changes what's in the cart, you need to change
//       // _shoppingCart inside a setState call to trigger a rebuild.
//       // The framework then calls build, below,
//       // which updates the visual appearance of the app.

//       if (!inCart)
//         _shoppingCart.add(product);
//       else
//         _shoppingCart.remove(product);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shopping List'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.symmetric(vertical: 8.0),
//         children: widget.products.map((Product product) {
//           return ShoppingListItem(
//             product: product,
//             inCart: _shoppingCart.contains(product),
//             onCartChanged: _handleCartChanged,
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     title: 'Shopping App',
//     home: ShoppingList(
//       products: <Product>[
//         Product(name: 'Eggs'),
//         Product(name: 'Flour'),
//         Product(name: 'Chocolate chips'),
//       ],
//     ),
//   ));
// }

// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sample',
//       home: Scaffold(
//         body: Center(
//           child: Row(
//             //spacing: 8.0, // gap between adjacent chips
//             //runSpacing: 4.0, // gap between lines
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Chip(
//                 avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('AH')),
//                 label: Text('Hamilton'),
//               ),
//               Chip(
//                 avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('ML')),
//                 label: Text('Lafayette'),
//               ),
//               Chip(
//                 avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('HM')),
//                 label: Text('Mulligan'),
//               ),
//               Chip(
//                 avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('JL')),
//                 label: Text('Laurens'),
//               ),
//               Chip(
//                 avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('JL')),
//                 label: Text('Laurens'),
//               ),
//               Chip(
//                 avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('JL')),
//                 label: Text('Laurens'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// }

// import 'dart:js';

// import 'package:flutter/material.dart';

// class MainScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Main Screen'),
//       ),
//       body: GestureDetector(
//         onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (_) {
//             return DetailScreen();
//           }));
//         },
//         child: Hero(
//           tag: 'imageHero',
//           child: Image.network(
//             'https://picsum.photos/250?image=9',
//           ),
//         )
//       ),
//     );
//   }
// }

// class DetailScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           Navigator.pop(context);
//         },
//         child: Hero(
//           tag: 'imageHero',
//           child: Image.network(
//             'https://picsum.photos/250?image=9',
//           ),
//         )
//       ),
//     );
//   }
// }

// class FirstRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('First Route'),
//       ),
//       body: Center(
//         child: RaisedButton(
//           child: Text('Open route'),
//           onPressed: () {
//             // Navigate to second route when tapped.
//             // Navigator.push(
//             //   context, 
//             //   MaterialPageRoute(
//             //     builder: (BuildContext context) {
//             //       return SecondRoute();
//             //     }
//             //   )
//             // );
//             // Navigator.pushNamed(
//             //   context, 
//             //   '/second',
//             //   arguments: 'arguments'
//             // );
//             _navigateAndDisplaySelection(context);
//           },
//         ),
//       ),
//     );
//   }

//   _navigateAndDisplaySelection(BuildContext context) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext contexxt) {
//           SecondRoute();
//         }
//       )
//     );
//   }
// }

// class SecondRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     //final Object args = ModalRoute.of(context).settings.arguments;
//     //print(args);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Second Route"),
//       ),
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             // Navigate back to first route when tapped.
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

// void main () => runApp(
//   MaterialApp(
//     title: 'Navigation App',
//     home: FirstRoute(),
//     //initialRoute: '/',
//     // routes: {
//     //   '/' : (context) => FirstRoute(),
//     //   '/second' : (context) => SecondRoute(),
//     //   ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
//     // },
//   )
// );

// class ScreenArguments {
//   final String title;
//   final String message;

//   ScreenArguments(this.title, this.message);
// }

// class ExtractArgumentsScreen extends StatelessWidget {
//   static const routeName = '/extractArguments';

//   @override
//   Widget build(BuildContext context) {
//     // Extract the arguments from the current ModalRoute settings and cast
//     // them as ScreenArguments.
//     final ScreenArguments args = ModalRoute.of(context).settings.arguments;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(args.title),
//       ),
//       body: Center(
//         child: Text(args.message),
//       ),
//     );
//   }
// }


// class ProductListState extends State<ProductList> {
//   // List<Product> favoriteList = new List<Product>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.menu, semanticLabel: 'menu'), 
//           onPressed: () {
//             print('menu btn');
//           }
//         ),
//         title: Text('Shopping',),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.shopping_cart,
//               semanticLabel: 'search',
//             ),
//             onPressed: () {
//               print('Cart button');
//               Navigator.pushNamed(
//                 context, 
//                 '/cart'
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.favorite,
//               semanticLabel: 'Favorite List',
//             ),
//             onPressed: () {
//               Navigator.pushNamed(
//                 context, 
//                 '/favoritelist',
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.search,
//               semanticLabel: 'search',
//             ),
//             onPressed: () {
//               print('Search button');
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.tune,
//               semanticLabel: 'filter',
//             ),
//             onPressed: () {
//               print('Filter button');
//             },
//           ),
//         ],
//       ),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: EdgeInsets.all(10.0),
//         childAspectRatio: 8.0 / 9.0,
//         children: _buildGridCards(10, context)
//       )
//     );
//   }

//   List<Card> _buildGridCards(int count, BuildContext context) {
//     // List<Product> products = ProductsRepository.loadProducts(Category.all);
//     var cartModel = Provider.of<CartModel>(context);
//     List<Product> products = cartModel.getproducts();
//     List<Product> favoriteList = cartModel.getFavoriteproducts();
//     //print(products);
//     //null check
//     if (products == null || products.isEmpty) {
//       return const <Card>[];
//     }
    
//     final List<Card> list = products.map((product) {
//       final isFavorite = favoriteList.contains(product);

//       return Card(
//         clipBehavior: Clip.antiAlias,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             AspectRatio(
//               aspectRatio: 18 / 11,
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: <Widget>[
//                   Image.asset(
//                     product.assetName,
//                     package: product.assetPackage,
//                     fit: BoxFit.fitWidth,
//                   ),
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: IconButton(
//                       icon: Icon(
//                         isFavorite ? Icons.favorite : Icons.favorite_border,
//                         color: isFavorite ? Colors.red : Colors.black,
//                       ), 
//                       onPressed: () {
//                         setState(() {
//                           if(isFavorite) {
//                             cartModel.removeFromFavorites(product);
//                             //print('Favorite List : ' + favoriteList.toList().toString());
//                           } else {
//                             cartModel.addToFavorites(product);
//                           }
//                         });
//                       },
//                     ),
//                   )
//                 ],
//               )
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
//                 child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       product.name,
//                       style: Theme.of(context).textTheme.title,
//                       maxLines: 1,
//                     ),
//                     SizedBox(height: 8.0),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           '₹'+product.price.toString(),
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         SizedBox(width: 8.0),
//                         product.oldPrice==null?Text(''):Text(
//                           '₹'+product.price.toString(),
//                           style: TextStyle(decoration :TextDecoration.lineThrough),
//                           textAlign: TextAlign.center,
//                         ),
//                         //addButton()
//                         // IconButton(
//                         //   constraints: BoxConstraints(),
//                         //   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                         //   icon: Icon(
//                         //     Icons.add,
//                         //     semanticLabel: 'filter',
//                         //   ), 
//                         //   onPressed: null,
//                         //   alignment: Alignment.topRight,
//                         // )
//                       ],
//                     ),
//                     // Column(
//                     //   crossAxisAlignment: CrossAxisAlignment.start,
//                     //   children: <Widget>[
//                     //     addButton()
//                     //   ],
//                     // )
//                     addButton(product: product)
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();

//     return list.isEmpty?CircularProgressIndicator():list;
//   }
// }