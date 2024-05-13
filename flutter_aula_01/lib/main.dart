
import 'package:flutter/material.dart';
import 'package:flutter_aula_01/configs/app_settings.dart';
import 'package:flutter_aula_01/configs/hive_configs.dart';
import 'package:flutter_aula_01/repositories/conta_repository.dart';
import 'package:flutter_aula_01/repositories/favoritas_repository.dart';
import 'package:flutter_aula_01/repositories/home_controller.dart';
import 'package:provider/provider.dart';
import 'meuapp.dart';
void main() async {
  //inicialização do hive --> 
  WidgetsFlutterBinding.ensureInitialized(); //garantir que as widgets seja iniciadas antes das intruções, antes do runapp
  await HiveConfig.start();
  
   runApp(
    MultiProvider( //recebe uma lista de providers
      providers: [
        ChangeNotifierProvider(create: (context) => ContaRepository()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()), ////context vai criar uma instancia do favoritasrepository)
        ChangeNotifierProvider(create: (context) => HomeController()),
      ],
       // definindo os provedores de estado necessários para a aplicação e definindo Meu_Aplicativo(
       //) como o widget raiz do aplicativo.
      child: Meu_Aplicativo()),
    );
}
 