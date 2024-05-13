import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_aula_01/models/moedas.dart';
import 'package:flutter_aula_01/pages/moedas_detalhes_page.dart';
import 'package:flutter_aula_01/repositories/favoritas_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MoedaCard extends StatefulWidget {
  Moeda moeda;
   MoedaCard({Key? key, required this.moeda}) : super(key : key);
  @override
  State<MoedaCard> createState() => _MoedaCardState();
}

class _MoedaCardState extends State<MoedaCard> {
  NumberFormat real = NumberFormat.currency(locale: 'pt-BR',  name: 'R\$');

  static Map<String, Color> precoColor = <String, Color>{
    'up': Colors.teal,
    'down': Colors.indigo,
  };
  abrirDetalhes(){ //metodo para abrir a pagina de detalhes dentro do favorito
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (_) => MoedasDetalhesPage(moeda: widget.moeda),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(  //usando um card clicavel usando o inkwell que serve para virar um card clicavel
      margin: EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => abrirDetalhes(),
        child: Padding(
          padding: EdgeInsets.only(top:20, bottom: 20, left: 20),
          child: Row( //aqio tera a imagem
            children: [Image.asset(widget.moeda.icone,
            height: 40,
            ),
            Expanded(child: Container(
              margin: EdgeInsets.only(left: 12),
              child: Column( //terá 2 coluna... o texto da moeda e o texto  da sigla 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.moeda.nome, //texto da moeda
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                  Text( //texto da sigla
                    widget.moeda.sigla,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            ),
            Expanded(
              child: Container( 
                padding: EdgeInsets.symmetric(vertical:10, horizontal:20),
                decoration: BoxDecoration(
                  color: precoColor['down']!.withOpacity(0.05), // puxa de um map  
                  border: Border.all(
                    color: precoColor['down']!.withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  real.format(widget.moeda.preco),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: precoColor['down'],
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            PopupMenuButton( //pop up para remover a moeda das favoritas
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(child: ListTile(
                  title: Text('Remover das Favoritas'),
                  onTap: (){ //quando clicar remover com o provider e com o notifiy atualizar o favorito
                    Navigator.pop(context);
                    Provider.of<FavoritasRepository>(context, listen: false).remove(widget.moeda);                  },
                ))
              ],
            )
            ],
          ),
        ),
      ),

    );
  }
}