import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/global.dart';
import 'package:flutter_application_3/reusable/reusableW%C4%B1dgets.dart';
import 'package:intl/intl.dart';

class StepperPage extends StatefulWidget {
  const StepperPage({super.key});

  @override
  State<StepperPage> createState() => _StepperPageState();
}

const List<int> stokTipiList = <int>[1, 2, 3];
const List<String> birimiList = <String>['Adet', 'Kg', 'G'];
const List<double> kdvTipiList = <double>[0.08, 0.10, 0.12, 0.14];

class _StepperPageState extends State<StepperPage> {
  int currentStep = 0;

  // GIRIS START
  final username = TextEditingController();
  final password = TextEditingController();
  // GIRIS END

  // ozet START
  final stokKodu = TextEditingController();
  final stokAdi = TextEditingController();
  int stokTipi = stokTipiList.first;
  String birimi = birimiList.first;
  final barkodu = TextEditingController();
  double kdvTipi = kdvTipiList.first;
  final aciklama = TextEditingController();
  DateTime olusturmazamani = DateTime.now();
  final dateController = TextEditingController();
  // ozet END

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: olusturmazamani,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != olusturmazamani)
      setState(() {
        olusturmazamani = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(olusturmazamani);
      });
  }

  continueStep() {
    if (currentStep == 2) {
      sendPostRequest(stokKodu.text, stokAdi.text, stokTipi, birimi,
          barkodu.text, kdvTipi, aciklama.text, olusturmazamani);
    }
    if (currentStep < 2) {
      setState(() {
        currentStep = currentStep + 1;
      });
    }
  }

  cancleStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  String getStep2Summary() {
    int kdvTipiPercent = (kdvTipi * 100).toInt();
    String summary =
        "Stok Kodu=${stokKodu.text}\nStok Adi=${stokAdi.text}\nstokTipi: ${stokTipi}\nbirimi:${birimi}\nbarkodu: ${barkodu.text}\naciklama: ${aciklama.text}\nkdvTipi=${kdvTipiPercent}%\ndateController=${DateFormat('yyyy-MM-dd').format(olusturmazamani)}";
    print(summary);
    return summary;
  }

  Widget controlsBuilder(content, details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: details.onStepCancel,
          child: const Text("Back"),
        ),
        ElevatedButton(
          onPressed: details.onStepContinue,
          child: Text("Next"),
        ),
      ],
    );
  }

  Future<void> sendPostRequest(
    String? stokKodu,
    String stokAdi,
    int stokTipi,
    String birimi,
    String barkodu,
    double kdvTipi,
    String aciklama,
    DateTime olusturmazamani,
  ) async {
    print(stokKodu);
    print(stokKodu == "");
    if (stokKodu == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Failed"),
            content: Text("Stock kodu required!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentStep = 0;
                  });
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      print('stokKodu is required.');
      return;
    }
    final dio = Dio();
    var headers = {'Content-Type': 'application/json'};

    final url = 'http://${globalServerAddress}:8080/api/stocks';
    print("post request");
    String formattedDateTime = olusturmazamani.toIso8601String();

    var postData = {
      'stokKodu': stokKodu,
      'stokAdi': stokAdi,
      'stockTipi': stokTipi,
      'birimi': birimi,
      'barkodu': barkodu,
      'kdvTipi': kdvTipi,
      'aciklama': aciklama,
      'olusturmazamani': formattedDateTime,
    };
    print(postData);
    var jsonData = json.encode(postData);
    try {
      final response = await dio
          .post(
            url,
            data: jsonData,
            options: Options(headers: headers),
          )
          .timeout(Duration(seconds: 10));

      print(response);
      if (response.statusCode == 200) {
        print('Post request successful!');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Post request successful!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      currentStep = 0;
                    });
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (e is DioException) {
        print(e.response?.statusCode);
        if (e.response?.statusCode == 500) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Failed"),
                content: Text(e.response.toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
          return;
        }
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Failed"),
            content: Text("Bir hata olustur"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Stepper(
            elevation: 0,
            physics: const ScrollPhysics(),
            type: StepperType.horizontal,
            currentStep: currentStep,
            onStepContinue: continueStep,
            onStepCancel: cancleStep,
            onStepTapped: onStepTapped,
            controlsBuilder: controlsBuilder,
            steps: [
              Step(
                  title: const Text('Giris'),
                  content: Column(
                    children: [
                      TextFormField(
                        controller: username,
                        decoration:
                            const InputDecoration(labelText: "username"),
                      ),
                      TextFormField(
                        controller: password,
                        decoration:
                            const InputDecoration(labelText: "password"),
                      ),
                    ],
                  ),
                  isActive: currentStep >= 0,
                  state: currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled),
              Step(
                  title: const Text('Ozet'),
                  content: Column(
                    children: [
                      TextField(
                        controller: stokKodu,
                        label: "Stok Kodu",
                        height: 40,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: stokAdi,
                        label: "Stok Adi",
                        height: 40,
                      ),
                      const SizedBox(height: 20),
                      DropdownMenuExample(
                        label: 'Stok Tipi',
                        value: stokTipi,
                        list: stokTipiList,
                        percent: false,
                        onChanged: (newValue) {
                          setState(() {
                            stokTipi = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownMenuExample(
                        label: 'Birimi',
                        value: birimi,
                        list: birimiList,
                        percent: false,
                        onChanged: (newValue) {
                          setState(() {
                            birimi = newValue!;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: barkodu,
                        label: "Barkodu",
                        height: 40,
                      ),
                      const SizedBox(height: 20),
                      DropdownMenuExample(
                        label: 'Kdv Tipi',
                        value: kdvTipi,
                        list: kdvTipiList,
                        percent: true,
                        onChanged: (newValue) {
                          setState(() {
                            kdvTipi = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: aciklama,
                        label: "Aciklama",
                        height: 40,
                      ),
                      // TextField(
                      //   controller: aciklama,
                      //   label: "Aciklama",
                      //   height: 40,
                      //   onTap: () => _selectDate(context),
                      //   showDatePicker: true,
                      // ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                            labelText: "Olusturma Zamani"),
                        onTap: () => _selectDate(context),
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  isActive: currentStep >= 1,
                  state: currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled),
              Step(
                  title: Text('Bitis'),
                  content: Column(
                    children: [
                      Text(getStep2Summary()),
                    ],
                  ),
                  isActive: currentStep >= 2,
                  state: currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled)
            ]),
      ),
    );
  }
}

class TextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double height;
  final VoidCallback? onTap;
  final bool? showDatePicker;

  TextField({
    required this.label,
    required this.controller,
    required this.height,
    this.onTap,
    this.showDatePicker,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label on the left
        Container(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 16),
        // GestureDetector wrapping the TextFormField or DatePicker
        Expanded(
          child: GestureDetector(
            onTap: showDatePicker == true ? onTap : null,
            child: Container(
              height: height,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
