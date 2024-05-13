import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter_aula_01/models/moedas.dart";
import "package:flutter_aula_01/repositories/conta_repository.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

// ignore: must_be_immutable
class MoedasDetalhesPage extends StatefulWidget {
  Moeda moeda;
   MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  State<MoedasDetalhesPage> createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>(); //chave aleatorio uma global key de form
  final _valor = TextEditingController();
  double quantidade = 0;
  late ContaRepository conta;
  comprar() async{ //função para salvar no BD a compra
    if(_form.currentState!.validate()) {
      //salvar a compra no BD FUTURAMENTE
      await conta.comprar(widget.moeda, double.parse(_valor.text));
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Compra realizada com sucesso!')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    conta = Provider.of<ContaRepository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome), // o state acessa  os dados  encapsulando
    ),
    body: Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, //comandos para centralizar no centro
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Image.asset(widget.moeda.icone),
                  width: 50,
                ),
                Container(width: 10),
                Expanded(
                  child: Text( //formatação no texto
                    real.format(widget.moeda.preco),
                    overflow: TextOverflow.ellipsis,
                     style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1,
                      color: Colors.indigo[700],
                    ),
                  ),
                )
              ],
            ),
          ),

          (quantidade > 0) // mostrará a informação da quantidade da moeda que tem apenas se digitar algum valor, se não, esconde a quantidade de moeda
          ?
          SizedBox(
            width: MediaQuery.of(context).size.width, //fica no tamanho correto da coluna, já define sozinho //o context nada mais é do que pegar as configurações do contexto atual, ou seja aplicar certa função no contexto atual. isso claro usando o MediaQuery
            child: Container( //container para abaixo
              child: Text('$quantidade ${widget.moeda.sigla}', style: TextStyle( //aqui fica a quantidade que eu tenho da moeda em cima do campo de texto.
                fontSize: 18,
                color: Colors.cyan[300],
              ),
              ),
              margin: EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
            ),
          )
          : Container( // se não colocar valor, então deixa apenas com a margem embaixo
            margin: EdgeInsets.only(bottom: 24)
          ),
          Form(
            key: _form, //a key serverá para recuperar o formulario e também validações
            child: TextFormField( //adicionando um campo de texto no formulario
              controller: _valor,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration( //adicionando uma decoração, ex borda
                border: OutlineInputBorder(), //adiciona um quadrado no texto
                labelText: 'Valor',
                prefixIcon: Icon(Icons.monetization_on_outlined), //icone dentro do text de moeda
                suffix: Text('reais', //escrita reais no final do campo de texto para denotar o reais transparente.
                style: TextStyle(fontSize: 12),
                ),
              ), 
              keyboardType: TextInputType.number, //teclado numerico. propriedade do textformfield
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly //faz com que aceite só numero
              ],
              validator: (value) { //o validator recebe uma função value, que é chamada toda vez que escreve no teclado ou enviar no formulario
              if(value!.isEmpty){ //para ser obrigatorio colocar um valor ao validar
                return 'Informe o valor da compra';
              } else if(double.parse(value)< 5.2){ //valor minimo aceito na caixa de texto, ele converte o valor dentro do label que é uma string em valor
                return 'compra mínima é R\$ 5,20 (um dolar)';
              } else if(double.parse(value) > conta.saldo){ //verifica se tem saldo suficiente
                return 'Você não tem saldo suficiente!';
              }
              return null;
              },
              onChanged: (value) { //nessa função está sendo feito o conversão do valor inserido na aba texto para o valor na criptomoeda, mostrando quantas dá para comprar
                setState(() {
                  quantidade = (value.isEmpty) // aqui vê se está vazio, se sim a quantidade de moeda é zero
                  ? 0 //mesma coisa que um if e else
                  : double.parse(value) / widget.moeda.preco; // se não for vazio, aqui converte para double e divide pelo preço da moeda
                });
              }
            /*onChanged: (value) {
              setState(() {
                if( value.isEmpty){
                  quantidade = 0;
                } else {
                 double.parse(value) / widget.moeda.preco;
                }
              });
            },  */
            ),
          ),
          Container( // aqui eu estou criando o botão de compra 
            alignment:Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 24),
            child: ElevatedButton(
              onPressed: comprar,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check),
                  Padding(padding: EdgeInsets.all(16),
                  child: Text('Comprar',
                  style: TextStyle(fontSize: 18),),)
                ],
              ),
            )
            )
          ],
      )
    ),
    );
  }
} 