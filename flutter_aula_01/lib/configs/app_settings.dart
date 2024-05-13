import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  //late SharedPreferences _prefs; //criando uma instancia
  late Box box; //isso é do hive como ele trabalho, trabalha com box
  Map<String, String> locale = { //CRIANDO UM MAP DE 2 VALORES locale e name
    'locale' : 'pt_BR', 'name': 'R\$',
  };

  AppSettings() { //construtor nao assincrono
    _startSettings();
  }
  _startSettings() async {
    await _startPreferences();
    await _readLocale();
  }
  Future<void> _startPreferences() async{ //vai retornar uma promessa
  //_prefs = await SharedPreferences.getInstance(); //iniciar sistema de arquivo com sharedpreferences
  box = await Hive.openBox('preferencias'); //abrir o box usando o hive
  }
/*_readLocale(){ //ler as informações que já estão salvas no sharedpreferences retornará um map com valores de local e name
final local = _prefs.getString('local') ?? 'pt_BR'; //tenta obter o valor armazenado na chave 'local' nas preferências compartilhadas.
// Se não houver nenhum valor associado a essa chave, ela atribui 'pt_BR' à variável local.
final name = _prefs.getString('name') ?? 'R\$'; //mesma coisa aqui só que com name
*/
_readLocale(){ //MESMA COISA QUE FAZ COM O QUE ESTÁ COMENTADO EMCIMA, APENAS A DIFERENÇA QUE AQUI É COM HIVE
  final local = box.get('local') ?? 'pt_BR'; 
  final name = box.get('name') ?? 'R\$';
locale = { //set do map
'locale': local,
'name': name,
};
notifyListeners();

}
/*setLocale(String local, String name) async { //metodo public para qualquer classe possa alterar o  locale //atualiza os valores armazenados nas preferências compartilhadas (SharedPreferences) 
//com os novos valores local e name e, em seguida, chama a função _readLocale para ler os valores atualizados. 
  await _prefs.setString('local', local);
  await _prefs.setString('name', name);
  await _readLocale();
} */

setLocale(String local, String name) async { //mesma coisa que o de cima só muda que é com o hive
  await box.put('local', local);
  await box.put('name', name);
  await _readLocale();
}

}