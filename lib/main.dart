import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:absensi_rfid_firebase/models/AbsenMahasiswa.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final databaseReference =
      FirebaseDatabase.instance.reference().child("mahasiswa");
  List<AbsenMahasiswa> list = List();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => readData());
  }

  @override
  Widget build(BuildContext context) {
    Widget UI(String nama, String kelas, String absen, String key) {
      return new GestureDetector(
        onLongPress: () {},
        onTap: () {},
        child: Card(
          color: Colors.white,
          // margin: EdgeInsets.all(5),
          elevation: 5,
          child: Container(
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(10),
                    child: Icon(
                      Icons.person,
                      color: Colors.blue[300],
                      size: 30,
                    )),
                Container(
                  height: 70,
                  margin: EdgeInsets.only(right: 5),
                  child: const VerticalDivider(
                    color: Colors.blueGrey,
                  ),
                ),
                Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        nama,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        kelas,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        key,
                        style: TextStyle(
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                          child: Text(
                        absen,
                        style: TextStyle(
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 10),
              child: Image(image: AssetImage("assets/images/logo.png")),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child:
                  Text("Absensi Berbasis RFID", style: TextStyle(fontSize: 25)),
            ),
            Expanded(
              child: new Container(
                child: list.length == 0
                    ? Text("Data Kosong")
                    : new ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (_, index) {
                          return UI(list[index].nama, list[index].kelas,
                              list[index].absen, list[index].key);
                        },
                      ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void readData() {
    databaseReference.once().then((DataSnapshot snap) {
      var data = snap.value;
      list.clear();
      data.forEach((key, value) {
        AbsenMahasiswa absenMahasiswa = new AbsenMahasiswa(
            kelas: value['kelas'],
            nama: value['nama'],
            absen: value['absen'],
            key: key);
        list.add(absenMahasiswa);
      });
      setState(() {});
    });
  }
}
