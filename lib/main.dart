import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.blue[900], primaryColor: Colors.white),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TextEditingController> controllers = List();
  List<double> notas = List();
  final List<String> itens = ["0", "1","2","3","4","5", "6"];
  List<Widget> listForm = List();

  int _qnt=0;
  String _value = "0";

  String msg = "";
  double notaFinal, media;

  void _calculate() {
    media = 0;
    for(int i=0;i<_qnt;i++){
      media+=double.parse(controllers[i].text);
    }
    media /= _qnt;
    setState(() {
      if (_qnt == 0)
        msg = "";
      else if (media >= 7)
        msg = "Sua média foi ${media.toStringAsFixed(2)}, você passou abestado";
      else if (media < 3)
        msg = "Sua média foi ${media.toStringAsFixed(2)}, sinto muito, não pode fazer final";
      else {
        notaFinal = (12.5 - (1.5 * media));
        if (notaFinal < 3) {
          notaFinal = 3.0;
        }
        msg = "Sua média foi ${media.toStringAsFixed(2)}, você precisa de ${notaFinal.toStringAsFixed(2)} para passar";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          "Final Uefs",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 120,
                  child: Image.asset("assets/brasao.gif",fit: BoxFit.contain,),
                ),
                Padding(padding: EdgeInsets.all(7.0),),
                Text(
                  "Escolha a quantidade de provas e preencha",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 20.0,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: _value,
                  onChanged: (String newValue) {
                    setState(() {
                      _value = newValue;
                      _qnt = int.parse(_value);
                      updateList();
                    });
                  },
                  items: itens.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Padding(padding: EdgeInsets.all(7.0),),
                Container(
                  child: Column(
                    children: listForm,
                  ),
                ),
                Padding(padding: EdgeInsets.all(7.0),),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _calculate();
                    }
                  },
                  padding: EdgeInsets.all(10.0),
                  color: Colors.blue[900],
                  child: Text(
                    "Calcular",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    msg,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )),
    );
  }
  updateList(){
    listForm = List();
    controllers = List();
    for(int i = 0; i <_qnt; i++){
      controllers.add(TextEditingController());
      listForm.add(_buildTextField(controllers[i], i+1));
      listForm.add(Padding(padding: EdgeInsets.all(7.0),));
    }
  }
  Widget _buildTextField(TextEditingController c, int qnt) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(
          labelText: "Nota $qnt  ",
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          prefixText: "Av $qnt  ",
          border: OutlineInputBorder()),
      style: TextStyle(color: Colors.black, fontSize: 20),
      keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
      validator: (value) {
        if (value.isEmpty)
          return ("informe uma nota");
        else if (double.parse(c.text) > 10 || double.parse(c.text) < 0)
          return ("informe uma nota entre 0 e 10");
      },
    );
  }
}



