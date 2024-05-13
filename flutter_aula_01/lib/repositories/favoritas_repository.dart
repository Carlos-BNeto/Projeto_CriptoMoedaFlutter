import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_aula_01/adapters/moeda_hive_adapter.dart';
import 'package:flutter_aula_01/models/moedas.dart';
import 'package:hive/hive.dart';
//provider serve para atualizar em tempo real mudanças no codigo e o notify serve para noficiar o flutter que teve alterações e deve atualizar
class FavoritasRepository extends ChangeNotifier{  //extende o changenotifier, que será responsavel por notificar o flutter em redesenhar essa tela.
List<Moeda> _lista = [];
late LazyBox box; //carregar o hive para salvar os favoritas, será laze ou seja nao async
FavoritasRepository() { //metodo construtor
  _startRepository();
}

_startRepository() async { //responsavel por inicalizar o box 
  await _openBox(); //abrir o box
  await _readFavoritas(); //ler as favoritas que vao estar salvo
}
_openBox() async {
Hive.registerAdapter(MoedaHiveAdapter()); //o adapter do hive serve para salvar dados mais complexos como o moeda, por isso é preciso criar um adapter  
box = await Hive.openLazyBox<Moeda>("moeda_favoritas"); //abrir o box acessando com o openlazybox acessando a Moeda com nome moedas_favoritas usando o adapter que nós criamos
}

_readFavoritas (){
  box.keys.forEach((moeda) async {  //acessar o box com todas as chaves moedas q inserimos no box e fazemos um foreach em q cada elemento é uma moeda
    Moeda m = await box.get(moeda); //passar a moeda e ler do nosso hive

    _lista.add(m); //adicionar a moeda na listafavorita
    notifyListeners();
      }
      );
}
UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista); 

//abaixo o metodo para adicionar a lista de favorito
/*saveAll(List<Moeda> moedas){ //metodo para receber um list Moeda chamada moedas
  moedas.forEach((moeda) { //verificar para cada moeda foreach
    if(! _lista.contains(moeda)) _lista.add(moeda); //se a lista não conter a moeda adicionar lista.add(moeda) como favorito
  });
  notifyListeners(); //notificar o flutter para redesenhar a tela, ou seja atualizar.
} */
saveAll(List<Moeda> moedas){  //MESMA COISA COM O DE CIMA APENAS FAZENDO PELO HIVE
  moedas.forEach((moeda) { 
  if(! _lista.any((atual) => atual.sigla == moeda.sigla )); //comparando indentificador unico
  _lista.add(moeda);
  box.put(moeda.sigla, moeda); //suporte tipo moeda por ser um adapter
  });
  notifyListeners(); //notificar o flutter para redesenhar a tela, ou seja atualizar.
}
/* remove(Moeda moeda){ //esse metodo serve para remover moedas no favorito
  _lista.remove(moeda);
  notifyListeners();
} */
remove(Moeda moeda){ //esse metodo serve para remover moedas no favorito
  _lista.remove(moeda);
  box.delete(moeda.sigla); //MESMA COISA COM O COMENTADO APENAS FAZENDO PELO HIVE
  notifyListeners();
}

} 