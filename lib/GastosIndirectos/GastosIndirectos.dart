import 'dart:math';

import 'package:carpicost_app/Materiales/CrearMaterial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(GastosIndirectos());
  });
}

class GastosIndirectos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Gastos indirectos'),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getManoDeObra();
    getMateriales();
    getPorcentajes();
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
                if (!snapshot.hasData) return CircularProgressIndicator();

                for (var i = 0; i < snapshot.data!.docs.length; i++) {
                  sumatotal += (snapshot.data?.docs[i]['Costo'] *
                      snapshot.data?.docs[i]['Cantidad']);
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
                        child: Text("Gastos Indirectos",
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
                          child: Text(
                              "\$" +
                                  (sumatotal + sumatotalManoObra + sumatotalMat)
                                      .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontFamily: 'Inter')),
                        ),
                        Center(
                          child: Text(sumatotalPorcen.toDouble().toString(),
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
            Text("Materiales",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: 17.0, fontFamily: 'Inter')),
            Text(sumatotalMat.toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.black, fontSize: 17.0, fontFamily: 'Inter')),
          ]),
          Row(children: <Widget>[
            Text("Mano de Obra",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: 17.0, fontFamily: 'Inter')),
            Text(sumatotalManoObra.toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.black, fontSize: 17.0, fontFamily: 'Inter')),
          ]),
          Row(children: <Widget>[
            Text("Transporte",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: 17.0, fontFamily: 'Inter')),
            Text(sumatotal.toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.black, fontSize: 17.0, fontFamily: 'Inter')),
          ]),
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
          botonSiguiente()
        ]));
  }
}

Widget botonSiguiente() {
  return FlatButton(
      color: Color.fromRGBO(38, 154, 201, 0.5),
      padding: EdgeInsets.symmetric(horizontal: 160.0, vertical: 10),
      onPressed: () {},
      child: Text(
        "Siguiente",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ));
}

getManoDeObra() {
  FirebaseFirestore.instance
      .collection('ManoDeObra')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      sumatotalManoObra += (doc["Cantidad"] * doc["Costo"]);
    });
  });
}

var sumatotal = 0.0;
var sumatotalPorcen = 0.0;
var sumatotalMat = 0.0;
var sumatotalManoObra = 0.0;
getPorcentajes() {
  FirebaseFirestore.instance
      .collection('Porcentajes')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      sumatotalPorcen += doc["Administracion"] +
          doc["Depreciacion"] +
          doc["Diseño"] +
          doc["Mantenimiento"] +
          doc["Otro"] +
          doc["Renta"] +
          doc["Seguro"] +
          doc["Servicios"];
    });
  });
}

getMateriales() {
  FirebaseFirestore.instance
      .collection('Materiales')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      sumatotalMat += (doc["Cantidad"] * doc["Precio"]);
    });
  });
}
