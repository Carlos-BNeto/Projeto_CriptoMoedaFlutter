import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveConfig { //inicia o hive no diretorio de documentos do aplicativvo
  static start() async{
    Directory dir = await getApplicationDocumentsDirectory(); //acessar o diretorio onde os documentos do app estão armazenados
    await Hive.initFlutter(dir.path); //inicia o hive no diretorio especificado
  }
}