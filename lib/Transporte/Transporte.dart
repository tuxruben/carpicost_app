import 'dart:math';

import 'package:carpicost_app/GastosIndirectos/GastosIndirectos.dart';
import 'package:carpicost_app/Materiales/CrearMaterial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(Transporte());
  });
}

class Transporte extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Transporte'),
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
  List transportes = [];

  @override
  void initState() {
    getTransportes();

    super.initState();
  }

  void getTransportes() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("Transporte");
    QuerySnapshot users = await collectionReference.get();

    if (users.docs.length != 0) {
      for (var doc in users.docs) {
        transportes.add(doc.data());
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
            height: 35.0,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Transporte')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                num sumatotal = 0.0;
                if (!snapshot.hasData) return CircularProgressIndicator();

                for (var i = 0; i < snapshot.data!.docs.length; i++) {
                  sumatotal += (snapshot.data?.docs[i]['Costo'] *
                      snapshot.data?.docs[i]['Cantidad']);
                  print("Total" + sumatotal.toString());
                }
                return Row(children: <Widget>[
                  Container(
                      width: 225,
                      height: 125,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(230, 230, 230, .5),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          )),
                      child: Center(
                        child: Text("Transporte",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,
                                fontFamily: 'Inter')),
                      )),
                  Container(
                      width: 175,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(38, 154, 201, 0.5),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(children: [
                        SizedBox(
                          height: 25.0,
                        ),
                        Center(
                          child: Text("\$" + sumatotal.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontFamily: 'Inter')),
                        ),
                        Center(
                          child: Text(" Suma",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontFamily: 'Inter')),
                        )
                      ])),
                ]);
              }),
          SizedBox(
            height: 30.0,
          ),
          Row(children: <Widget>[
            Text("Ingresar Transporte",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: 20.0, fontFamily: 'Inter'))
          ]),
          Divider(color: Colors.black),
          Row(children: <Widget>[
            Text("Tipo                                 ",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: 17.0, fontFamily: 'Inter')),
            Text("Cant.                          ",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: 17.0, fontFamily: 'Inter')),
            Text("Costo",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: 17.0, fontFamily: 'Inter'))
          ]),
          Flexible(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Transporte')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var suma = snapshot.data?.docs[index]['Costo'] *
                              snapshot.data?.docs[index]['Cantidad'];
                          var costo = TextEditingController(
                              text: snapshot.data?.docs[index]['Costo']
                                  .toString());
                          var cantidad = TextEditingController(
                              text: snapshot.data?.docs[index]['Cantidad']
                                  .toString());
                          CollectionReference trans = FirebaseFirestore.instance
                              .collection('Transporte');

                          return Column(children: [
                            Divider(color: Colors.black),
                            Row(children: <Widget>[
                              Column(mainAxisSize: MainAxisSize.min, children: <
                                  Widget>[
                                Flexible(
                                    child: Text(
                                        "" + snapshot.data?.docs[index]['Tipo'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontFamily: 'Inter'))),
                                Flexible(
                                    child: Container(
                                        width: 130,
                                        child: TextFormField(
                                          controller: costo,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                /// Establecer el arco de las cuatro esquinas del borde
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),

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
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                        ))),
                              ]),
                              Flexible(
                                  child: Container(
                                      width: 130,
                                      child: TextFormField(
                                        controller: cantidad,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              /// Establecer el arco de las cuatro esquinas del borde
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),

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
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                      ))),
                              Flexible(
                                  child: Container(
                                      width: 130,
                                      child: TextFormField(
                                        initialValue: suma.toString(),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              /// Establecer el arco de las cuatro esquinas del borde
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),

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
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                      ))),
                            ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Future<void> updateTransporte() {
                                        return trans
                                            .doc(snapshot.data?.docs[index].id)
                                            .update({
                                              'Costo': num.parse(costo.text),
                                              'Cantidad':
                                                  num.parse(cantidad.text),
                                            })
                                            .then((value) =>
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Transporte actualizado",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1))
                                            .catchError((error) =>
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Fallo al actualizar Transporte: $error",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1));
                                      }

                                      updateTransporte();
                                    },
                                    child: Icon(Icons.edit),
                                  )
                                ]),
                            Divider(color: Colors.black),
                          ]);
                        });
                  })),
          botonSiguiente(context)
        ]));
  }
}

Widget botonSiguiente(BuildContext context) {
  return FlatButton(
      color: Color.fromRGBO(38, 154, 201, 0.5),
      padding: EdgeInsets.symmetric(horizontal: 160.0, vertical: 10),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => GastosIndirectos()));
      },
      child: Text(
        "Siguiente",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ));
}
