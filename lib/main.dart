import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carpicost_app/Materiales/Materiales.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(Miapp());
  });
}

class Miapp extends StatelessWidget {
  const Miapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Myapp",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: cuerpo(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(38, 154, 201, 0.5),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_present), label: "Documentos"),
        ],
      ),
    );
  }
}

Widget cuerpo(BuildContext context) {
  return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/fondo.jpg"), fit: BoxFit.cover)),
      child: Center(
        child: Container(
            width: 350,
            height: 725,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.5).withOpacity(0.30),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logo(),
                nombre(),
                SizedBox(
                  height: 30.0,
                ),
                Bienvenido(),
                SizedBox(
                  height: 125.0,
                ),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Flexible(
                    child: botonEntrar(context),
                  ),
                  Flexible(
                    child: botonEntrar1(),
                  )
                ])
              ],
            )),
      ));
}

Widget logo() {
  return new Center(
      child: Image(
          image: new AssetImage('assets/logo.png'), width: 100, height: 100));
}

Widget nombre() {
  return Text("Carpicost",
      style:
          TextStyle(color: Colors.white, fontSize: 55.0, fontFamily: 'Inter'));
}

Widget Bienvenido() {
  return Text("Bienvenid@",
      style:
          TextStyle(color: Colors.black, fontSize: 35.0, fontFamily: 'Inter'));
}

Widget botonEntrar(BuildContext context) {
  return FlatButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      },
      child: Container(
          width: 225,
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Column(children: [
              SizedBox(
                height: 30.0,
              ),
              Icon(Icons.calculate_outlined),
              SizedBox(
                height: 30.0,
              ),
              Text("Cotizar",
                  style: TextStyle(
                      color: Colors.black, fontSize: 25.0, fontFamily: 'Inter'))
            ]),
          )));
}

Widget botonEntrar1() {
  return FlatButton(
      onPressed: () {},
      child: Container(
          width: 225,
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Column(children: [
              SizedBox(
                height: 30.0,
              ),
              Icon(Icons.square_foot_outlined),
              SizedBox(
                height: 30.0,
              ),
              Text("Cubicar",
                  style: TextStyle(
                      color: Colors.black, fontSize: 25.0, fontFamily: 'Inter'))
            ]),
          )));
}
