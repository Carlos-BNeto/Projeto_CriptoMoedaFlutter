import 'package:flutter_aula_01/models/moedas.dart';
import 'package:hive/hive.dart';

class MoedaHiveAdapter extends TypeAdapter<Moeda> {
  @override
  final typeId = 0;  //id unico do adaptador
  @override
  //ISSO É NECESSARIO SÓ POR CAUSA DO MEODA SER UM METODO COMPLEXO
  Moeda read(BinaryReader reader) { //retornar uma moeda e um metodo read, é metodo do proprio typeadapter
  return Moeda(  //quando ler do adapter retornar uma moeda
  icone: reader.readString(),
  nome: reader.readString(),
  sigla: reader.readString(),
  preco: reader.readDouble(),
  ); //METODO DE LEITURA
  }
  @override
  void write(BinaryWriter writer, Moeda obj) { //MMETODO DE ESCRITA, SALVAR
    writer.writeString(obj.icone);
    writer.writeString(obj.nome);
    writer.writeString(obj.sigla);
    writer.writeDouble(obj.preco);
  }
}