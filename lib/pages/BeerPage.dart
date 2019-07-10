import 'package:flutter/material.dart';
import '../models/Beer.dart';
import '../models/Sale.dart';
import 'package:flutter/services.dart';
import 'package:icvm_mobile/context/AppContext.dart';
import 'package:scoped_model/scoped_model.dart';

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

  /*void sendData(BuildContext context) async {
    //var now = DateTime.parse(sales[0].date); si es compatible con la fecha de JS
    int updatedQuantity = beer.quantity + int.parse(quantity);
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"id": "' + beer.id.toString() + '","quantity": "' + updatedQuantity.toString() + '"}';
    var response = await http.put(Uri.parse(_serverIP), headers: headers, body: json);
    if(response.statusCode == 200) {
      //_showNotification(context, 'Agregado correctamente');
      print(response.body);
    } else {
      print(response.body);
      //_showNotification(context, 'No se puede conectar con el servidor');
    }
  }*/

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(beer.name),
      ),
      body: buildBeerPageData(quantity, beer)
    );
  }
}

var buildBeerPageData = (String quantity, Beer beer) => ScopedModelDescendant<AppContext>(
  builder: (context, child, model) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text('Agregar a inventario'),
                    Container(
                      width: 200.0,
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
      )
);