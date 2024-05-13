
import 'package:flutter_aula_01/models/moedas.dart';
import 'package:flutter_aula_01/repositories/moeda_repository.dart';
import 'package:flutter_aula_01/repositories/status.dart';
//provider serve para atualizar em tempo real mudanças no codigo e o notify serve para noficiar o flutter que teve alterações e deve atualizar
class HomeController extends BaseStatus{  //extende o changenotifier, que será responsavel por notificar o flutter em redesenhar essa tela.
late List<Moeda> _allCoins;
List<Moeda> get allCoins => _allCoins;

late List<Moeda> _favoriteCoins;
List<Moeda> get favoriteCoins => _favoriteCoins;

HomeController () {
  reset();
}

void reset () {
  _allCoins = [];
  _favoriteCoins = [];
}

 void initalize () {

 }

 Future <void> getMoeda () async {
  setStatus(Status.loading);
  await Future.delayed(Duration(seconds: 3));
  _allCoins.clear();
  _allCoins.addAll(MoedaRepository.tabela);
  setStatus(Status.sucess);
 } 
} 