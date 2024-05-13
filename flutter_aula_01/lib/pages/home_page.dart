import 'package:flutter/material.dart';
import 'package:flutter_aula_01/pages/ChicoMoedas_page.dart';
import 'package:flutter_aula_01/pages/Configuracoes_page.dart';
import 'package:flutter_aula_01/pages/carteira_page.dart';
import 'package:flutter_aula_01/pages/favoritos_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc; //controlar os slides
    void initState() {  //iniciar o page controller, 
    super.initState();
    pc = PageController(initialPage: paginaAtual); //começa na pagina atual, na primeiro pagina
  }
  setPaginaAtual(pagina){ //aqui vai mudar o currentIndex lá embaixo, para que fique selecionado o icone na pagina em que está
    setState(() {
      paginaAtual = pagina;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          ChicoMoedas(),
          FavoritasPages(),
          CarteiraPage(),
          ConfiguracoesPage(),
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar( //coloca uma barra de navegação no final da tela
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed, //deixar borda fixa
        items: [ //o que terá dentro da bottom navigation
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todas'), //adicionando as paginas com icone de navegação embaixo
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favoritas'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Carteira'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Conta'),
       
        ],
        onTap: (pagina) { // ação ao clicar nos icones embaixo
        pc.animateToPage(pagina, duration: Duration(milliseconds: 400), curve: Curves.ease); //adicionando uma animação ao clicar 
        }
      ),
    );
  }
}