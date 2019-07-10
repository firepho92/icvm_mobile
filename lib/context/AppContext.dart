import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Beer.dart';
import '../models/Sale.dart';

class AppContext extends Model {
  bool _isLoading = true;
  final String _serverIP = 'https://icvm-server.herokuapp.com/';//https://icvm-server.herokuapp.com/
  List<Beer> _beers = List();
  List<Sale> _sales = List();

  List<Beer> get beers => _beers;
  List<Sale> get sales => _sales;
  bool get isLoading => _isLoading;

  AppContext() {
    init();
  }

  init() async {
    final bool beers = await _fecthBeers();
    final bool sales = await _fetchSales();
    if(beers && sales){
      notifyListeners();
    } else {
      //_showNotification(context, 'No se puede conectar con el servidor');
    }
  }

  _fecthBeers() async {
    _isLoading = true;
    final response = await http.get(Uri.parse(_serverIP + 'beers'));
    if(response.statusCode == 200) {
      _beers = (json.decode(response.body) as List)
        .map((data) => new Beer.fromJson(data))
        .toList();
        _isLoading = false;
    } else {
      throw Exception('Failed to fecth data from server');
    }
    if(response.statusCode == 200)
      return true;
    else
      return false;
  }

  _fetchSales() async {
    final response = await http.get(Uri.parse(_serverIP + 'sales'));
    if(response.statusCode == 200) {
      _sales = (json.decode(response.body) as List)
        .map((data) => new Sale.fromJson(data))
        .toList();
        _isLoading = false;
    } else {
      throw Exception('Failed to fecth data from server');
    }
    if(response.statusCode == 200)
      return true;
    else
      return false;
  }

  addBeerCount(index) async {
    _beers[index].amount += 1;
    _beers[index].quantity -= 1;
    notifyListeners();
  }

  _setAmountsToZero() {
    _beers.forEach((beer) => {
      beer.amount = 0
    });
  }

  addItemsToStock(Beer beer, String quantity, BuildContext context) async {
    print(quantity);
    print(beer.quantity);
    beer.quantity += int.parse(quantity);
    print(beer.quantity);
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"id": "' + beer.id.toString() + '","quantity": "' + beer.quantity.toString() + '"}';
    var response = await http.put(Uri.parse(_serverIP + 'beers'), headers: headers, body: json);
    if(response.statusCode == 200) {
      _showNotification(context, 'Agregado correctamente');
      print(response.body);
    } else {
      print(response.body);
      _showNotification(context, 'No se puede conectar con el servidor');
    }
  }

  _showNotification(context, msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Ocultar',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  putData(BuildContext context) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    String sales = '';
    String json = '';
    for(int i = 0; i < _beers.length; i++) {
      if(i == _beers.length -1) {
        sales += '{"beer": "' + _beers[i].id.toString() + '", "quantity": "' + _beers[i].quantity.toString() + ' "}';
        break;
      }
      sales += '{"beer": "' + _beers[i].id.toString() + '", "quantity": "' + _beers[i].quantity.toString() + '"}, ';
    }
    json = '{"sales":[' + sales + ']}';
    final response = await http.post(Uri.parse(_serverIP + 'sales'), headers: headers, body: json);
    print(response.body);
    if(response.statusCode == 200) {
      _showNotification(context, 'Agregado(s) correctamente');
    } else {
      _showNotification(context, 'Error, no se pudo conectar con el servidor');
    }
    _setAmountsToZero();
    notifyListeners();
  }
}
