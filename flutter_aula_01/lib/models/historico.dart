
import 'package:flutter_aula_01/models/moedas.dart';

class Historico {
  DateTime dataOperacao;
  String tipoOperacao;
  Moeda moeda;
  double valor;
  double quantidade;

  Historico({
    required this.dataOperacao,
    required this.tipoOperacao,
    required this.moeda,
    required this.valor,
    required this.quantidade,
  });
}