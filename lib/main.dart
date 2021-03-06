import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:string_validator/string_validator.dart';

import 'dart:async';
import 'dart:convert';

const request = #adicione aq seu link com a chave da api, lembresse entre aspas duplas;
void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
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


  void _limparCampos(){
    realController.text="";
    dolarController.text="";
    euroController.text="";
  }
  void _realMudar(String text) {
    if(text.isEmpty){
      _limparCampos();
      return;
    }


    double real= double.parse(text);
    dolarController.text=(real/dolar).toStringAsFixed(2);
    euroController.text=(real/euro).toStringAsFixed(2);
  }

  void _dolarMudar(String text) {
    if(text.isEmpty){
      _limparCampos();
      return;
    }
    double dolar=double.parse(text);
    realController.text=( dolar * this.dolar).toStringAsFixed(2);
    euroController.text=(dolar * this.dolar/euro).toStringAsFixed(2);

  }

  void _euroMudar(String text) {
    if(text.isEmpty){
      _limparCampos();
      return;
    }
    double euro= double.parse(text);
    realController.text=(euro * this.euro).toStringAsFixed(2);
    dolarController.text=(euro * this.euro/dolar).toStringAsFixed(2);
  }

  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(" \$ Conversor \$",
              style: TextStyle(fontSize: 30.0)
          ),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none: //nao concetado
                case ConnectionState.waiting: // esperando
                  return Center(
                      child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao carregar dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber),
                          buildTextFild("Reais", "R\$", realController, _realMudar),
                          Divider(),
                          buildTextFild("Dolar", "US\$", dolarController,_dolarMudar),
                          Divider(),
                          buildTextFild("Euros", "€", euroController,_euroMudar),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextFild(
    String label, String prefixo, TextEditingController cont, Function func) {
  return TextField(
    controller: cont,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefixo),
    style: TextStyle(color: Colors.amber, fontSize: 25.0
    ),
    onChanged: func,
    //keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
