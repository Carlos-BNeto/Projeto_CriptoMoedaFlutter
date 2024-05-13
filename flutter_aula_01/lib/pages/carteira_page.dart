import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aula_01/configs/app_settings.dart';
import 'package:flutter_aula_01/models/posicao.dart';
import 'package:flutter_aula_01/repositories/conta_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class CarteiraPage extends StatefulWidget {
  CarteiraPage({Key? key}) : super(key : key);

  @override
  _CarteiraPageState createState() => _CarteiraPageState(); 
}
class _CarteiraPageState extends State<CarteiraPage> {
    int index = 0; //controle do grafico de pizza
  double totalCarteira = 0;
  double saldo = 0;
  late NumberFormat real;
  late ContaRepository conta;
  String graficoLabel = '';
  double graficoValor = 0;
  List<Posicao> carteira = [];
  @override
  Widget build(BuildContext context) {
    conta = context.watch<ContaRepository>(); //inicializando com provider a conta
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    saldo = conta.saldo;
    setTotalCarteira();
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 45, bottom: 8 ),
            child: Text(
              'Valor da Carteira',
              style: TextStyle(
              fontSize: 18,
            ),
            ),
            ),
            Text(
              real.format(totalCarteira),
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.5,
              ),
            ),
            loadingGrafico(),
            loadHistorico(),
          ],
        ),
      ),
    );
  }
  
  setTotalCarteira(){
    final cartieraList = conta.carteira; //obtem a lista de moedas na carteira do usuario 
    setState(() { //atualiza o estado da widget
      totalCarteira = conta.saldo; //define o valor inicial da variavel como o saldo da conta
      for(var posicao in cartieraList){ //para cada quantidade de moeda  que eu tenha comprado: intera cada posicao da carteira
        totalCarteira += posicao.moeda.preco  * posicao.quantidade; //para cada posicao da carteira adiciona o totalcarteira o valor da moeda
      }
    });
  }

setGraficoDados(int index){
  if (index < 0) return;
  if(index == carteira.length){
    graficoLabel = 'Saldo';
    graficoValor = conta.saldo;
  } else {
    graficoLabel = carteira[index].moeda.nome;
    graficoValor = carteira[index].moeda.preco * carteira[index].quantidade;
  }
}

  loadCarteira() {
    setGraficoDados(index);
    carteira = conta.carteira;
    final tamanholista = carteira.length+1;

    return List.generate(tamanholista, (i) {
      final isTouched = i == index;
          final isSaldo = i == tamanholista -1;
          final fontSize = isTouched ? 18.0 : 14.0;
          final radius = isTouched ? 60.0 : 50.0;
          final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];
          double porcentagem = 0;
          if(!isSaldo){
            porcentagem = carteira[i].moeda.preco * carteira[i].quantidade / totalCarteira;
          } else {
            porcentagem = (conta.saldo > 0) ? conta.saldo /totalCarteira : 0;
          }
          porcentagem += 100;
          return PieChartSectionData(
            color:  color,
            value: porcentagem,
            title: '${porcentagem.toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          );
    });
  }
  loadingGrafico() { //loading para dar tempo do grafico carregar no sql
  return (conta.saldo <= 0) //se o conta.saldo for menor ou igual a zero mostra o container
    ? Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    )
    : Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sectionsSpace: 5, //espaço no grafico da pizza
              centerSpaceRadius: 110,
              sections: loadCarteira(),
              pieTouchData: PieTouchData(
                touchCallback:(touch) => setState(() {
                  index = touch.touchedSection!.touchedSectionIndex;
                  setGraficoDados(index); //se tocar na fatia de algo ou do saldo ele
                }),   //fazer ações quando o grafico tocar em cada parte do grafico de pizza
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(graficoLabel, style: TextStyle(
              fontSize: 20, color: Colors.blueGrey,
            ),),
            Text(
              real.format(graficoValor),
              style: TextStyle(
                fontSize: 28,
              ),
            )
          ],
        )
      ],
    ) ;//caso ao contrario
  }
  loadHistorico() { //aparece historico de compra ao clicar no grafico
    final historico = conta.historico;
    final date = DateFormat('dd/MM/yyyy - hh:mm');
    List<Widget> widgets = [];
    for(var operacao in historico){
      widgets.add(ListTile(
        title: Text(operacao.moeda.nome),
        subtitle: Text(date.format(operacao.dataOperacao)),
        trailing: Text(real.format((operacao.moeda.preco * operacao.quantidade))),
      ));
      widgets.add(Divider());
    }
    return Column(
      children: widgets,
    );
  }
}