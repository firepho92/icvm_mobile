import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icvm_mobile/context/AppContext.dart';
import 'package:scoped_model/scoped_model.dart';
import './BeerPage.dart';
import '../models/Sale.dart';
import '../models/Beer.dart';

class ThirdPage extends StatefulWidget {
  ThirdPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _ThirdPageState createState() => _ThirdPageState();
  
}

class _ThirdPageState extends State<ThirdPage> {
  _ThirdPageState({this.title});
  final String title;
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: buildThirdPage()
    );
  }
}

List<Sale> sales(List<Sale> sales, int beer) => sales.where((sale) => sale.beer == beer).toList();

var beerData = (Beer beer) => beer.name + ': ' + beer.quantity.toString();

var buildThirdPage = () => ScopedModelDescendant<AppContext>(
  builder: (context, child, model) => buildBeerData()
);

var buildBeerData = () => ScopedModelDescendant<AppContext>(
  builder: (context, child, model) => ListView.builder(
    itemCount: model.beers.length,
    itemBuilder: (BuildContext context, int index) {
      return Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => BeerPage(beer: model.beers[index], sales: sales(model.sales, index)))
            );
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: new Text(
              beerData(model.beers[index])
            ),
          ),
        ),
      );
    },
  )
);