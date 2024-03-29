import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=60df7606";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitCoinController = TextEditingController();

  double dolar;
  double euro;
  double bitcoin;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    bitCoinController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    bitCoinController.text = (real/bitcoin).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    bitCoinController.text = (dolar * this.dolar / bitcoin).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    bitCoinController.text = (euro * this.euro / bitcoin).toStringAsFixed(2);
  }

  void _bitCoinChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double bitCoin = double.parse(text);
    realController.text = (bitCoin * this.bitcoin).toStringAsFixed(2);
    dolarController.text = (bitCoin * this.bitcoin / dolar).toStringAsFixed(2);
    euroController.text = (bitCoin * this.bitcoin / euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0
                  ),
                ),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao carregar dados...",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0
                    ),
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,),
                      buildTextField("Reais", "R", realController, _realChanged),
                      Divider(),
                      buildTextField("Dólares", "US", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euros", "€", euroController, _euroChanged),
                      Divider(),
                      buildTextField("BitCoins", "B", bitCoinController, _bitCoinChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function function){
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: "$prefix\$ "
    ),
    style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0
    ),
    onChanged: function,
    keyboardType: TextInputType.number,
  );
}

