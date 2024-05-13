import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aula_01/configs/app_settings.dart';
import 'package:flutter_aula_01/repositories/conta_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  @override
  Widget build(BuildContext context) {
    final conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    NumberFormat real = NumberFormat.currency(locale: loc['locale'], name: loc['name']); //formato moeda
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Padding(padding: EdgeInsets.all(12), child: Column(
        children: [
          ListTile(
            title: Text('Saldo'),
            subtitle: Text(
              real.format(conta.saldo),
              style: TextStyle(
                fontSize: 23, color: Colors.indigo,
              ),
            ),
            trailing: IconButton(onPressed: updateSaldo, icon: Icon(Icons.edit)),
          ),
          Divider(),
        ],
      ),),
    );
  }
  updateSaldo() async {
    final form = GlobalKey<FormState>();
    final valor = TextEditingController();
    final conta = context.read<ContaRepository>();
    valor.text = conta.saldo.toString();
    AlertDialog dialog = AlertDialog(
      title: Text('Atualizar o saldo'),
      content: Form(
        key: form,
        child: TextFormField(
          controller: valor,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')), //expressão regular para permitir apenas ponto flutuante
          ],
          validator: (value){
            if(value!.isEmpty)
              return 'informe o valor do saldo';
              return null;
          },
        )
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('CANCELAR')),
        TextButton(onPressed: (){
          if(form.currentState!.validate()) {
            conta.setSaldo(double.parse(valor.text));
            Navigator.pop(context);
          }
        }, child: Text('SALVAR'),),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}