import 'package:flutter/material.dart';
import '../models/Beer.dart';
import '../models/Sale.dart';
import 'package:flutter/services.dart';
import 'package:icvm_mobile/context/AppContext.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';


class BeerPage extends StatefulWidget {
  BeerPage({Key key, this.beer, this.sales}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Beer beer;
  final List<Sale> sales;
  @override
  _BeerPageState createState() => _BeerPageState(beer: beer, sales: sales);
  
}

class _BeerPageState extends State<BeerPage> {
  _BeerPageState({this.beer, this.sales}) : super();
  final Beer beer;
  final List<Sale> sales;
  String quantity = '0';
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
          title: Text(beer.name),
          centerTitle: true,
          elevation: 0.0,
          backgroundColorStart: Colors.indigo,
          backgroundColorEnd: Colors.indigo,
          ),
      body: buildBeerPageData(quantity, beer)
    );
  }
}

var buildBeerPageData = (String quantity, Beer beer) => ScopedModelDescendant<AppContext>(
  builder: (context, child, model) => SizedBox(
      height: 600,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          statisticsCards(),
          Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text('Agregar a inventario'),
                    Container(
                      width: 230.0,
                      child: TextField(
                        onChanged: (text) {quantity = text;},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Cantidad'
                        ),
                      ),
                    ),
                    RaisedButton(
                      child: Text('Agregar'),
                      onPressed: () {
                        model.addItemsToStock(beer, quantity, context);
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        quantity = '0';
                      },
                      )
                  ],
                )
              )
            ),
          )
        ],
      ),
    )
        
);

var statisticsCards = () => ScopedModelDescendant<AppContext>(
  builder: (context, child, model) => SizedBox(
    height: 200,
    child: PageView(
      controller: PageController(viewportFraction: 0.8),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          height: 150,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Ventas de hoy: 10')
                  ],
                )
              ),
            )
          )
        ),
        Container(
          height: 150,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Ventas de la semana: 10')
                  ],
                )
              ),
            )
          )
        ),
        Container(
          height: 150,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Ventas del mes: 10')
                  ],
                )
              ),
            )
          )
        ),
    ])
  )
);

