

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

class DB { //SQLITE classe helpers de banco de dado, tipo singleton
//com essa classe limite para abrir o banco de dados uma vez invés de ficar abrindo varias

//construtor com acesso privado
DB._();

//criar uma instancia de DB
static final DB instance = DB._();


//instancia do SQLite
static Database? _database; 

get database async{ //metodo do tipo get chamado database e ele verifica se o database é diferente de null, se for retorna database, caso contrario ele inicializará o db.
if(_database != null){
  return _database;
}else {
  return await _initDatabase();
}
}
_initDatabase() async { //metodo para iniciar o BD
return await openDatabase( //funcao para abrir o bd
  join(await getDatabasesPath(), 'SQLITECripto.db'), //usa o join do pacote path para criar caminho para o bd, onde o getdaatabasepath retorna o diretorio e o bd chama SQLITEcripto
  version: 1,
  onCreate: _onCreate, //callback quando o bd for criado primeira vez.
);
}
_onCreate(db, versao) async {
  await db.execute(_conta);
  await db.execute(_carteira);
  await db.execute(_historico);
  await db.insert('conta', {'saldo': 0});
}
//COMANDOS DO BANCO DE DADOS
//criar as estruturas da tabela  o ''' é string em bloco em dart
String get _conta => '''   
CREATE TABLE conta (
id INTEGER PRIMARY KEY AUTOINCREMENT,
saldo REAL
);
''';
String get _carteira=> '''   
CREATE TABLE carteira (
sigla TEXT PRIMARY KEY,
moeda TEXT,
quantidade TEXT
);
''';
String get _historico => '''   
CREATE TABLE historico (
id INTEGER PRIMARY KEY AUTOINCREMENT,
data_operacao INT,
tipo_operacao TEXT,
moeda TEXT,
sigla TEXT,
valor REAL,
quantidade TEXT
);
''';

}