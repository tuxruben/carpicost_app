import 'package:carpicost_app/ManoDeObra/ManoDeObra.dart';
import 'package:carpicost_app/Materiales/CrearMaterial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
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

  @override
  void initState() {
    getMateriales();

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
            height: 35.0,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Materiales')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                num sumatotal = 0.0;
                if (!snapshot.hasData) return CircularProgressIndicator();

                for (var i = 0; i < snapshot.data!.docs.length; i++) {
                  sumatotal += (snapshot.data?.docs[i]['Precio'] *
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
                        child: Text("Materiales",
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
            Text("Ingresar Materiales",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black, fontSize: 20.0, fontFamily: 'Inter'))
          ]),
          Flexible(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Materiales')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var suma = snapshot.data?.docs[index]['Precio'] *
                              snapshot.data?.docs[index]['Cantidad'];
                          var precio = TextEditingController(
                              text: snapshot.data?.docs[index]['Precio']
                                  .toString());
                          var cantidad = TextEditingController(
                              text: snapshot.data?.docs[index]['Cantidad']
                                  .toString());
                          CollectionReference mate = FirebaseFirestore.instance
                              .collection('Materiales');

                          return Column(children: [
                            Divider(color: Colors.black),
                            Row(children: <Widget>[
                              Icon(Icons.arrow_drop_down),
                              Text("" + snapshot.data?.docs[index]['Nombre'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontFamily: 'Inter'))
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),

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
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),

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
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              )),
                            ]),
                            Row(children: <Widget>[
                              Text("      Suma : ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontFamily: 'Inter')),
                              Flexible(
                                  child: TextFormField(
                                initialValue: suma.toString(),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      /// Establecer el arco de las cuatro esquinas del borde
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),

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
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                              )),
                              FlatButton(
                                onPressed: () {
                                  Future<void> deleteUser() {
                                    return mate
                                        .doc(snapshot.data?.docs[index].id
                                            .toString())
                                        .delete()
                                        .then((value) => Fluttertoast.showToast(
                                            msg: "Material Eliminado",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1))
                                        .catchError((error) =>
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Fallo al eliminar Material: $error",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1));
                                  }

                                  deleteUser();
                                },
                                child: Icon(Icons.delete),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Future<void> updateMaterial() {
                                    return mate
                                        .doc(snapshot.data?.docs[index].id)
                                        .update({
                                          'Precio': num.parse(precio.text),
                                          'Cantidad': num.parse(cantidad.text),
                                        })
                                        .then((value) => Fluttertoast.showToast(
                                            msg: "Material actualizado",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1))
                                        .catchError((error) =>
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Fallo al actualizar Material: $error",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1));
                                  }

                                  updateMaterial();
                                },
                                child: Icon(Icons.edit),
                              )
                            ]),
                            Divider(color: Colors.black),
                          ]);
                        });
                  })),
          CircleAvatar(
            backgroundColor: Color.fromRGBO(221, 160, 62, 0.5),
            radius: 30,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CrearMateriales()));
              },
            ),
          ),
          botonSiguiente(context)
        ]));
  }
}

Widget botonSiguiente(BuildContext context) {
  return FlatButton(
      color: Color.fromRGBO(38, 154, 201, 0.5),
      padding: EdgeInsets.symmetric(horizontal: 160.0, vertical: 10),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ManoDeObra()));
      },
      child: Text(
        "Siguiente",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ));
}
