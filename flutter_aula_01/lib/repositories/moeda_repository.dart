import 'package:flutter_aula_01/models/moedas.dart';

class MoedaRepository {
  static List<Moeda> tabela = [
    Moeda(icone: 'images/bitcoin.png', nome: "Bitcoin", sigla: "BTC", preco: 334564),
    Moeda(icone: 'images/ada.png', nome: "Cardano", sigla: "ADA", preco: 245),
    Moeda(icone: 'images/dogeCoin.png', nome: 'DogeCoin', sigla: 'DOGE', preco: 080),
    Moeda(icone: 'images/etherum.png', nome: 'Ethereum', sigla: 'ETH', preco: 16330),
    Moeda(icone: 'images/solana.png', nome: 'Solana', sigla: 'SOL', preco: 76534),
    Moeda(icone: 'images/xrp.png', nome: 'RIPLE', sigla: 'XRP', preco:  245)
  ];
}