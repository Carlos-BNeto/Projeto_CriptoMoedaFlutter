
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_aula_01/pages/ChicoMoedas_page.dart';
import 'package:flutter_aula_01/pages/home_page.dart';

// ignore: camel_case_types
class Meu_Aplicativo extends StatelessWidget {
  const Meu_Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( //adicionar materialApp
    title: "Criptomoedas do ChicoMoedas",
    debugShowCheckedModeBanner: false, //tirar o debug do lado da tela
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
      appBarTheme: AppBarTheme( backgroundColor: Colors.blueGrey[100])
       ),
    home: HomePage(), 
    );
  }
}