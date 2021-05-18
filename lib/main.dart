import 'package:flutter/material.dart';
import 'dart:math' as matematik;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<DersModel> dersListesi;
  var formKey = GlobalKey<FormState>();
  double notOrtalama = 0.0;
  int listeSayaci = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dersListesi = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //keyboard açıldığında sayfa elemanlarını küçültmeye çalışmaz direk üzerne açılır
      appBar: AppBar(
        title: Text("Not Ortalama"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            //eğer veriler doğrulşanmışsa
            formKey.currentState
                .save(); //onları kaydet (bunlar formun onsaved alanında gerçekleşir)
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return uygulamaGovdesi();
          } else
            return uygulamaGovdesiLandscape();
        },
      ),
    );
  }

  Widget uygulamaGovdesiLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  // color: Colors.red.shade200,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          focusNode: FocusNode(),
                          //bunu vererek otomotik focus olayını ortadan kaldırdım (done butonuna tıklandığğında otomotik focuslanmıyordu ama...)
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: cerceveRengi(), width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: cerceveRengi(), width: 2)),
                            labelText: "Ders Adı",
                            hintText: "Ders Adını Giriniz",
                            border: OutlineInputBorder(),
                          ),
                          validator: (girilenDeger) {
                            if (girilenDeger.length > 0) {
                              return null;
                            } else
                              return "Ders Adı boş oluur?";
                          },
                          onSaved: (kaydedilecekDeger) {
                            dersAdi = kaydedilecekDeger;
                            setState(() {
                              dersListesi.add(DersModel(dersAdi, dersHarfDegeri,
                                  dersKredi, rasgeleRenkOlustur()));
                              notOrtalama = 0;
                              _notOrtalamHesapla();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 4),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  items: _dersKrediItems(),
                                  value: dersKredi,
                                  onChanged: (secilenKredi) {
                                    setState(() {
                                      dersKredi = secilenKredi;
                                    });
                                  },
                                ),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: cerceveRengi(),
                                    width: 2,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<double>(
                                    items: _dersHarfNotlariItems(),
                                    value: dersHarfDegeri,
                                    onChanged: (secilenHarf) {
                                      setState(() {
                                        dersHarfDegeri = secilenHarf;
                                      });
                                    },
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: cerceveRengi(),
                                      width: 2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))))
                          ],
                        ),
                        /*Divider(
                      color: Colors.blue[800],
                      height: 23,
                      indent: 5,
                    )*/
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    //color: Colors.blue,
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        top: BorderSide(color: Colors.blue, width: 2),
                        bottom: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: dersListesi.length <= 0
                                  ? "Lütfen ders ekleyiniz"
                                  : "Ortalama: ",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                            TextSpan(
                              text: dersListesi.length <= 0
                                  ? ""
                                  : "${notOrtalama.toStringAsFixed(2)}",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.purple),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              // color: cerceveRengi(),
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: dersListesi.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget uygulamaGovdesi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //Static Elemanların olacağı alan textfiled vb
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          // color: Colors.red.shade200,
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(

                  focusNode: FocusNode(),
                  //bunu vererek otomotik focus olayını ortadan kaldırdım (done butonuna tıklandığğında otomotik focuslanmıyordu ama...)
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 20),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: cerceveRengi(), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: cerceveRengi(), width: 2)),
                    labelText: "Ders Adı",
                    hintText: "Ders Adını Giriniz",
                    border: OutlineInputBorder(),
                  ),
                  validator: (girilenDeger) {
                    Pattern pattern=r'^[a-zA-Z0-9_ ]*$'; //sadece harf içerecek ve kelimeler arası boşluk olabilir
                    RegExp regexp=RegExp(pattern);
                    if (girilenDeger.length > 0) {
                      if(!regexp.hasMatch(girilenDeger)){
                          return "Ders Adı sadece harf içerebilir";
                      }else {
                        debugPrint(girilenDeger+"  bunugndfgdfkklfdklgdf");
                      }
                      return null;
                    } else
                      return "Ders Adı boş oluur?";
                  },
                  onSaved: (kaydedilecekDeger) {
                    dersAdi = kaydedilecekDeger;
                    setState(() {
                      dersListesi.add(DersModel(dersAdi, dersHarfDegeri,
                          dersKredi, rasgeleRenkOlustur()));
                      notOrtalama = 0;
                      _notOrtalamHesapla();
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          items: _dersKrediItems(),
                          value: dersKredi,
                          onChanged: (secilenKredi) {
                            setState(() {
                              dersKredi = secilenKredi;
                            });
                          },
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: cerceveRengi(),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: _dersHarfNotlariItems(),
                            value: dersHarfDegeri,
                            onChanged: (secilenHarf) {
                              setState(() {
                                dersHarfDegeri = secilenHarf;
                              });
                            },
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: cerceveRengi(),
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))
                  ],
                ),
                /*Divider(
                  color: Colors.blue[800],
                  height: 23,
                  indent: 5,
                )*/
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: 70,
          //color: Colors.blue,
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(color: Colors.blue, width: 2),
              bottom: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: dersListesi.length <= 0
                        ? "Lütfen ders ekleyiniz"
                        : "Ortalama: ",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  TextSpan(
                    text: dersListesi.length <= 0
                        ? ""
                        : "${notOrtalama.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 30, color: Colors.purple),
                  ),
                ],
              ),
            ),
          ),
        ),
        //Listenin içinde olacağı alan
        Expanded(
          child: Container(
            // color: cerceveRengi(),
            child: ListView.builder(
              itemBuilder: _listeElemanlariniOlustur,
              itemCount: dersListesi.length,
            ),
          ),
        )
      ],
    );
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    listeSayaci++;
    return Dismissible(
      key: Key(listeSayaci.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          dersListesi.removeAt(index);
          _notOrtalamHesapla();
        });
      },
      child: Container(
        key: Key(listeSayaci.toString()),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: dersListesi[index]._renk, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          leading: Icon(
            Icons.done,
            size: 24,
            color: dersListesi[index]._renk,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right_outlined,
            color: dersListesi[index]._renk,
          ),
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Ders Adı: ",
                  style: TextStyle(color: Colors.black, fontSize: 22)),
              TextSpan(
                  text: dersListesi[index].dersAdi,
                  style: TextStyle(color: Colors.purple, fontSize: 20)),
            ]),
          ),
          subtitle: Text(dersListesi[index].kredi.toString() +
              " " +
              dersListesi[index].harfDegeri.toString()),
        ),
      ),
    );
  }

  Color rasgeleRenkOlustur() {
    return Color.fromARGB(
        105 + matematik.Random().nextInt(105),
        matematik.Random().nextInt(105),
        matematik.Random().nextInt(255),
        matematik.Random().nextInt(255));
  }

  Color cerceveRengi() {
    return Colors.purple;
  }

  void _notOrtalamHesapla() {
    double toplamKredi = 0;
    double toplamNot = 0;

    for (var oAnkiDers in dersListesi) {
      int kredi = oAnkiDers._kredi;
      double harfDegeri = oAnkiDers._harfDegeri;
      toplamNot += (harfDegeri * kredi);
      toplamKredi += kredi;
    }
    notOrtalama = toplamNot / toplamKredi;
  }
}

class DersModel {
  String _dersAdi;
  double _harfDegeri;
  int _kredi;
  Color _renk;

  Color get renk => _renk;

  set renk(Color value) {
    _renk = value;
  }

  String get dersAdi => _dersAdi;

  set dersAdi(String value) {
    _dersAdi = value;
  }

  DersModel(this._dersAdi, this._harfDegeri, this._kredi, this._renk);

  double get harfDegeri => _harfDegeri;

  set harfDegeri(double value) {
    _harfDegeri = value;
  }

  int get kredi => _kredi;

  set kredi(int value) {
    _kredi = value;
  }
}

_dersHarfNotlariItems() {
  List<DropdownMenuItem<double>> harfDegerleri = [];
  harfDegerleri.add(DropdownMenuItem(
      value: 4,
      child: Text(
        "AA",
        style: TextStyle(
          fontSize: 30,
        ),
      )));
  harfDegerleri.add(DropdownMenuItem(
      value: 3.5,
      child: Text(
        "BA",
        style: TextStyle(
          fontSize: 30,
        ),
      )));
  harfDegerleri.add(DropdownMenuItem(
      value: 3.0,
      child: Text(
        "BB",
        style: TextStyle(
          fontSize: 30,
        ),
      )));
  harfDegerleri.add(DropdownMenuItem(
      value: 2.5,
      child: Text(
        "CB",
        style: TextStyle(
          fontSize: 30,
        ),
      )));
  harfDegerleri.add(DropdownMenuItem(
      value: 2,
      child: Text(
        "CC",
        style: TextStyle(
          fontSize: 30,
        ),
      )));
  harfDegerleri.add(DropdownMenuItem(
      value: 1.5,
      child: Text(
        "DC",
        style: TextStyle(
          fontSize: 30,
        ),
      )));
  harfDegerleri.add(DropdownMenuItem(
      value: 1,
      child: Text(
        "DD",
        style: TextStyle(
          fontSize: 30,
        ),
      )));
  harfDegerleri.add(DropdownMenuItem(
      value: 0,
      child: Text(
        "FF",
        style: TextStyle(
          fontSize: 30,
        ),
      )));
  return harfDegerleri;
}

List<DropdownMenuItem<int>> _dersKrediItems() {
  List<DropdownMenuItem<int>> krediler = [];
  for (int i = 1; i <= 10; i++) {
    krediler.add(DropdownMenuItem(
        value: i,
        child: Text(
          "$i kredi",
          style: TextStyle(fontSize: 30),
        )));
  }
  return krediler;
}
