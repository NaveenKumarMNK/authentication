import 'dart:convert';
import 'dart:ffi';

import 'package:authentication/HomeDisplay.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:authentication/modelGet.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: MyAp()));

class MyAp extends StatefulWidget {
  @override
  _MyApState createState() => _MyApState();
}

class _MyApState extends State<MyAp> {
  GlobalKey qrKey = GlobalKey();
  var qrText = "";
  QRViewController controller;
  var data;
  var uri;
  Data det;
  Future getDetails;

  Future getData() async {
    uri = Uri.http('www.eradicatefakes.com', '/apiuser/data/$qrText/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      Data details = Data.fromJson(jsonData);
      return details;
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Colors.red,
                borderLength: 10,
                borderWidth: 10,
                cutOutSize: 100),
            onQRViewCreated: _onQRViewCreate,
          ),
        ),
        Container(
          height: 0.0,
          child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  det = snapshot.data;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeDisplay(det: det)));
                }
                return Container(width: 0.0, height: 0.0);
              }),
        )
      ],
    ));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }
}
