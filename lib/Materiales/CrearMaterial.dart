import 'package:carpicost_app/Materiales/Materiales.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(CrearMateriales());
  });
}

class CrearMateriales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Materiales'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List materiales = [];

  var precio;
  var cantidad;
  var nombre;
  CollectionReference mate =
      FirebaseFirestore.instance.collection('Materiales');
  @override
  void initState() {
    getMateriales();
    precio = TextEditingController();
    cantidad = TextEditingController();
    nombre = TextEditingController();
    super.initState();
  }

  void getMateriales() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("Materiales");
    QuerySnapshot users = await collectionReference.get();

    if (users.docs.length != 0) {
      for (var doc in users.docs) {
        materiales.add(doc.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(38, 154, 201, 0.5),
          title: Center(child: Text(widget.title)),
        ),
        body: Column(children: [
          SizedBox(
            height: 30.0,
          ),
          SizedBox(
            height: 30.0,
          ),
          Row(children: <Widget>[
            Text("Crear Material",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: 20.0, fontFamily: 'Inter'))
          ]),
          Flexible(
              child: Column(children: [
            Divider(color: Colors.black),
            Row(children: <Widget>[
              Icon(Icons.arrow_drop_down),
              Text("",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black, fontSize: 15.0, fontFamily: 'Inter'))
            ]),
            Row(children: <Widget>[
              Text("      Nombre : ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontFamily: 'Inter')),
              Flexible(
                  child: TextFormField(
                controller: nombre,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      /// Establecer el arco de las cuatro esquinas del borde
                      borderRadius: BorderRadius.all(Radius.circular(10)),

                      /// Se usa para configurar el estilo de borde
                      borderSide: BorderSide(
                        /// Establecer el color del borde
                        color: Colors.red,

                        /// Establecer el grosor del borde
                        width: 2.0,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                keyboardType: TextInputType.text,
              )),
            ]),
            Row(children: <Widget>[
              Text("      Precio : ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontFamily: 'Inter')),
              Flexible(
                  child: TextFormField(
                controller: precio,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      /// Establecer el arco de las cuatro esquinas del borde
                      borderRadius: BorderRadius.all(Radius.circular(10)),

                      /// Se usa para configurar el estilo de borde
                      borderSide: BorderSide(
                        /// Establecer el color del borde
                        color: Colors.red,

                        /// Establecer el grosor del borde
                        width: 2.0,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              )),
            ]),
            Row(children: <Widget>[
              Text("      Cantidad : ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontFamily: 'Inter')),
              Flexible(
                  child: TextFormField(
                controller: cantidad,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      /// Establecer el arco de las cuatro esquinas del borde
                      borderRadius: BorderRadius.all(Radius.circular(10)),

                      /// Se usa para configurar el estilo de borde
                      borderSide: BorderSide(
                        /// Establecer el color del borde
                        color: Colors.red,

                        /// Establecer el grosor del borde
                        width: 2.0,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              )),
            ]),
            Divider(color: Colors.black),
          ])),
          CircleAvatar(
            backgroundColor: Color.fromRGBO(221, 160, 62, 0.5),
            radius: 30,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.save),
              color: Colors.white,
              onPressed: () {
                Future<void> crearMaterial() {
                  return mate
                      .doc()
                      .set({
                        'Nombre': nombre.text,
                        'Precio': num.parse(precio.text),
                        'Cantidad': num.parse(cantidad.text),
                      })
                      .then((value) => Fluttertoast.showToast(
                          msg: "Material creado",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1))
                      .catchError((error) => Fluttertoast.showToast(
                          msg: "Fallo al crear Material: $error",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1));
                }

                crearMaterial();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ),
        ]));
  }
}
