import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance/quotations?key=837b6301"; //837b6301

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
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
  final libraController = TextEditingController();
  final pesoController = TextEditingController();

  double dolar;
  double euro;
  double libra;
  double peso;

  void clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    libraController.text = "";
    pesoController.text = "";
  }

  void realchanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    pesoController.text = (real/peso).toStringAsFixed(2);
    libraController.text = (real/libra).toStringAsFixed(2);
  }

  void dolarchanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    pesoController.text = (dolar * this.dolar / peso).toStringAsFixed(2);
    libraController.text = (dolar * this.dolar / libra).toStringAsFixed(2);
  }

  void eurochanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    euroController.text = (euro * this.euro / euro).toStringAsFixed(2);
    pesoController.text = (euro * this.euro / peso).toStringAsFixed(2);
    libraController.text = (euro * this.euro / libra).toStringAsFixed(2);

  }

  void pesochanged(String text){
    double peso = double.parse(text);
    realController.text = (peso * this.peso).toStringAsFixed(2);
    dolarController.text = (peso * this.peso / dolar).toStringAsFixed(2);
    euroController.text = (peso * this.peso / euro).toStringAsFixed(2);
    libraController.text = (peso * this.peso / libra).toStringAsFixed(2);
  }

  void librachanged(String text){
    double libra = double.parse(text);
    realController.text = (libra * this.libra).toStringAsFixed(2);
    euroController.text = (libra * this.libra / euro).toStringAsFixed(2);
    pesoController.text = (libra * this.libra / peso).toStringAsFixed(2);
    dolarController.text = (libra * this.libra / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: clearAll,)
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                "Carregando dados. Aguarde um momento.",
                style: TextStyle(color: Colors.amber, fontSize: 25.0),
                textAlign: TextAlign.center,
              ));
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "Erro ao carregar dados.",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];
                peso = snapshot.data["results"]["currencies"]["ARS"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.amber),
                      buildTextField("Reais", "R\$", realController, realchanged),
                      Divider(),
                      buildTextField("Dolares", "USD", dolarController, dolarchanged),
                      Divider(),
                      buildTextField("Euro", "€", euroController, eurochanged),
                      Divider(),
                      buildTextField("Peso Argentino", "ARS", pesoController, pesochanged),
                      Divider(),
                      buildTextField("Libra Esterlina", "£", libraController, librachanged)
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

Widget buildTextField(String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
