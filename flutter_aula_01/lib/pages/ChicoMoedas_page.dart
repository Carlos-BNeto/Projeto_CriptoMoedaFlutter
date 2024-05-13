import 'package:flutter/material.dart';
import 'package:flutter_aula_01/configs/app_settings.dart';
import 'package:flutter_aula_01/models/moedas.dart';
import 'package:flutter_aula_01/pages/moedas_detalhes_page.dart';
import 'package:flutter_aula_01/repositories/favoritas_repository.dart';
import 'package:flutter_aula_01/repositories/home_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class ChicoMoedas extends StatefulWidget {
  const ChicoMoedas({super.key});

  @override
  State<ChicoMoedas> createState() => _ChicoMoedasState();
}

class _ChicoMoedasState extends State<ChicoMoedas> {
//final tabela = MoedaRepository.tabela; //acessando o moedarepository e vinculando a tabela
   late NumberFormat real; //nesta parte eu adiciono o formato em ptbr e em reais para a moeda.
  late Map<String, String> loc; //map de 2 string que será nossa localização
  List<Moeda> selecionadas = [];
  late FavoritasRepository favoritas;

readNumberFormat(){ //metodo que faz a inicalização do localização tanto do real que seria numberformat
  loc = context.watch<AppSettings>().locale; //observar mudanças no objeto AppSettings, que provavelmente é um ChangeNotifier. 
  //Em seguida, acessa o atributo locale desse objeto, mapa contendo informações sobre a formatação de números
  real = NumberFormat.currency(locale: loc['locale'], name: loc['nome']); //fazendo a formatação do numero de acordo com a preferencia do usuairo.
}
changeLanguageButton(){
  final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR'; //VERIFICA SE O LOCALE É PTBR ENTÃO MOSTRARÁ EM INGLES OU EM PORTUGUES
  final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$'; //AQUI ELE MOSTRA PTBR OU O DOLAR DEPENDE DA OPÇÃO QUE TIVER SETADO.
  return PopupMenuButton(
    icon: Icon(Icons.language),
    itemBuilder: (context) =>[
    PopupMenuItem(child: ListTile(
      leading: Icon(Icons.swap_vert),
    title: Text('Usar $locale'),
    onTap: (){
      context.read<AppSettings>().setLocale(locale, name);
      Navigator.pop(context);
    },
    ),
    ),
    ]
  );
}
  AppBarDinamic () {
    if(selecionadas.isEmpty){
      return AppBar(
      title: Text("Chico Coins"),
      actions: [ //adicionando o botao na tela 
        changeLanguageButton(),
      ],
      centerTitle: true,
      );
    } else {
      return AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), //adicionando na esquerda icone de voltar
        onPressed: () {
          setState(() {
            selecionadas = [];
          });
        },
        ),
        title: Text("${selecionadas.length} selecionadas"), //contar quantos items da lista está selecionadoo
        centerTitle: true,
        backgroundColor: Colors.indigo[40],
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),

      );
    }
  }
  mostrarDetalhes (Moeda moeda) { //ao clicar na moeda abri detalhes dela em uma pagina
  Navigator.push(context, MaterialPageRoute( //o navigation serve para abrir a pagina, o materialpageroute é o que faz o processo, configura quase tudo já sozinho
    builder: (_) => MoedasDetalhesPage(moeda: moeda) //local para onde vai ao ir, usando build é o destino
    )
    );
  }
  limparSelecionadas(){
    setState(() {
      selecionadas = []; //limpa o selecionadas para limpar a tela dos favoritos declarando selecionadas como vazio
    });
  }
  @override
  void initState() {
    Future.microtask((){
      context.read<HomeController>().getMoeda();
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    favoritas = Provider.of<FavoritasRepository>(context); //instanciar(recuperar o favoritas) na tela
    readNumberFormat(); //carregar o locale
    return Consumer<HomeController>(
      builder:(context, homeController, _) {
        return Scaffold(
          appBar: AppBarDinamic(),
            body: homeController.isLoanding
            ? const Center(
              child: CircularProgressIndicator(),
            )
            : ListView.separated(
            itemBuilder: (BuildContext context, int moeda) { //mostrar os dados na tabela
              return ListTile( //há varias propriedades dentro do listtile.
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), //borda da linha do fundo colorida
        
                leading: (selecionadas.contains(homeController.allCoins[moeda])) //leading é o item que vai a esquerda aqui coloco um check ao selecionar
                 ? CircleAvatar(
                 child: Icon(Icons.check),
                 )
                 : SizedBox(
                  child: Image.asset(homeController.allCoins[moeda].icone),
                  width: 45,
                 ),
        
                 //icone vai na esquerda
                 title: Row(
                  children: [
                Text(homeController.allCoins[moeda].nome, style: TextStyle( //o textstyle serve para configuração da escrita, //nome da moeda
                fontSize: 17, //tamanho da fonte
                fontWeight: FontWeight.w500 //expessura da fonte
                ),
                ),
                if(favoritas.lista.any((fav)=> fav.sigla == homeController.allCoins[moeda].sigla)) //aqui se clicar em uma moeda e favoritar, aparecerá uma estrela na frente
                Icon(Icons.star_border, color: Colors.amber, size: 8),
                ],
              ),
                trailing: Text(real.format(homeController.allCoins[moeda].preco), //preço trailing vai na direita
              ),
              selected: selecionadas.contains(homeController.allCoins[moeda]), //deixar marcado ou desmarcado é verificado com a condição if embaixo
              selectedTileColor: Colors.blueGrey[50], //a cor do fundo da linha selecionada
              onLongPress: () { //quando precionar o texto, servirá como um botão, mudar algo um link etc
              setState(() { //state para funcionar o stateful, aqui embaixo verifica se está marcado ou desmarcado. 
              if(selecionadas.contains(homeController.allCoins[moeda])) {
                selecionadas.remove(homeController.allCoins[moeda]);
              }
              else{
                selecionadas.add(homeController.allCoins[moeda]);
              }
              });
              },
              onTap:() => mostrarDetalhes(homeController.allCoins[moeda]), //essa função servirá para clicar em uma moeda e abrir outra pagina
              );
              
            } , 
            padding: EdgeInsets.all(16),
            separatorBuilder: (_, ___) => Divider(), //separador dos dados
            itemCount: homeController.allCoins.length //chamada para ler a quantidade de tabela que terá, como se fosse um for
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: selecionadas.isNotEmpty //irá fazer o botão aparecer apenas se selecionar alguma criptomoeda 
             ? FloatingActionButton.extended(
              onPressed: () { //quando clicar no favoritas adiciona e limpa o favoritas
                favoritas.saveAll(selecionadas);
                limparSelecionadas();
              },
            icon: Icon(Icons.star), 
            label: Text("FAVORITAR", 
            style: TextStyle( 
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
            )
            )
        )
        : null
        );
      }
    );
  }
}