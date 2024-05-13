import 'package:flutter/material.dart';
import 'package:flutter_aula_01/database/db.dart';
import 'package:flutter_aula_01/models/historico.dart';
import 'package:flutter_aula_01/models/moedas.dart';
import 'package:flutter_aula_01/models/posicao.dart';
import 'package:flutter_aula_01/repositories/moeda_repository.dart';
import 'package:sqflite/sqflite.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  List<Posicao> _carteira = []; //operações da carteira
  double _saldo = 0;
  List<Historico> _historico = [];
 
  get saldo => _saldo;
  List<Posicao> get carteira => _carteira;
  List<Historico> get historico => _historico;
  
  ContaRepository(){
    _initRepository();
  }

  _initRepository() async {
    await _getSaldo();
    await _getCarteira(); 
    await _getHistorico();
  } //trabalhar com dados asincronos q nao pode ser feito dentro do construtor
  
  _getSaldo() async { //instancia o banco de dados, consulta a tabela 'conta' para obter o saldo e atualiza a variável _saldo com o valor obtido
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    _saldo = conta.first['saldo'];
    notifyListeners();
  }
  setSaldo(double valor) async {
    db = await DB.instance.database; //instancia o DB
    db.update('conta', {
      'saldo': valor,
  
    });
    _saldo = valor;
    notifyListeners();
  }
  comprar(Moeda moeda, double valor) async {
    db = await DB.instance.database;//instanciar a db
    await db.transaction((txn) async{  //permite que varias operações ocorram de ofrma simultanea e se uma dela der um erro a transação é anualada, igual em bancos
    //verificar se a moeda já foi comprada antes -->
    final PosicaoMoeda = await txn.query('carteira', where: 'sigla = ?', whereArgs: [moeda.sigla]);
    //se nao tiver a moeda na carteira então vou inserir -->
    if(PosicaoMoeda.isEmpty){
      await txn.insert('carteira', {
        'sigla': moeda.sigla,
        'moeda': moeda.nome,
        'quantidade': (valor / moeda.preco).toString()
      });
    }
    //se não já tem a moeda em carteira.. não precisa inserir novamente
    else {
      final atual = double.parse(PosicaoMoeda.first['quantidade'].toString());
      await txn.update('carteira', {
        'quantidade' : (atual + (valor/ moeda.preco)).toString(), //map
      }, where: 'sigla = ?', whereArgs: [moeda.sigla], );
    }
    //inserindo o historico da compra
    await txn.insert('historico', {
      'sigla': moeda.sigla,
      'moeda': moeda.nome,
      'quantidade': (valor/ moeda.preco).toString(),
      'valor': valor,
      'tipo_operacao': 'compra', //tipo de operação como compra
      'data_operacao': DateTime.now().millisecondsSinceEpoch //pega a data agora e converte em milisegundos
    });

    //atualizar o saldo
    await txn.update('conta', {'saldo' : saldo -valor });
    });
    //atualizar o repositorio
    await _initRepository();
    notifyListeners();
  }

  //metodo para recuperar as posiçõoes de compra que criamos
  _getCarteira() async {
    _carteira = []; //primeiro zeramos a carteira
    List posicoes = await db.query('carteira'); //lista de posição onde pega os dados que temos em carteira
    posicoes.forEach((posicao) { //para cada posição recuperamos uma moeda, e que cada posição recuperada do bd  
      Moeda moeda = MoedaRepository.tabela.firstWhere((m) =>m.sigla == posicao['sigla'] ); //obtem a moeda corresponde a partir da lista de moeda moedarepository.tabela com a mesma sigla
      _carteira.add(Posicao(moeda: moeda, quantidade: double.parse(posicao['quantidade']))); //adicionada uma nova posição a lista _carteira onde a quantidade é convertida para um numero de ponto flutuante
    });
    notifyListeners();
  }
    _getHistorico() async {
    _historico = [];
    List posicoes = await db.query('historico'); 
    posicoes.forEach((operacao) { 
      Moeda moeda = MoedaRepository.tabela.firstWhere((m) =>m.sigla == operacao['sigla'] ); 
      _historico.add(
        Historico(dataOperacao: DateTime.fromMicrosecondsSinceEpoch(operacao['data_operacao']),
         tipoOperacao: operacao['tipo_operacao'],
          moeda: moeda,
           valor: operacao['valor'],
            quantidade: double.parse(operacao['quantidade']))
      );
    });
    notifyListeners();
  }
}