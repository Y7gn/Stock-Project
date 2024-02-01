import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/global.dart';
import 'package:flutter_application_3/reusable/reusableW%C4%B1dgets.dart';
import 'package:intl/intl.dart';

class StockListPage extends StatefulWidget {
  const StockListPage({Key? key}) : super(key: key);

  @override
  State<StockListPage> createState() => _StockListPageState();
}

const List<int> stokTipiList = <int>[1, 2, 3];
const List<String> birimiList = <String>['Adet', 'Kg', 'G'];
const List<double> kdvTipiList = <double>[0.08, 0.10, 0.12, 0.14];

class _StockListPageState extends State<StockListPage>
    with SingleTickerProviderStateMixin {
  final Dio _dio = Dio();
  late Future<List<Map<String, dynamic>>> _stockDataFuture;
  late TabController controller;

  final stokKodu = TextEditingController();
  final stokAdi = TextEditingController();
  int? stokTipi;
  final barkodu = TextEditingController();
  double? kdvTipi;

  late List<Map<String, dynamic>> _filteredStockData;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    _stockDataFuture = fetchStockData();
    _filteredStockData = [];
  }

  Future<List<Map<String, dynamic>>> fetchStockData() async {
    try {
      final response =
          await _dio.get('http://${globalServerAddress}:8080/api/stocks');
      print(response);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.cast<Map<String, dynamic>>().toList()
          ..sort((a, b) => a['stokKodu'].compareTo(b['stokKodu']));
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      throw Exception('Failed to load stock data: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String formatCustomDate(DateTime dateTime) {
    String month = getMonthNameInTurkish(dateTime.month);
    String day = dateTime.day.toString();
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';

    return '$day $month $year $hour:$minute $amPm';
  }

  String getMonthNameInTurkish(int month) {
    switch (month) {
      case 1:
        return 'Ocak';
      case 2:
        return 'Şubat';
      case 3:
        return 'Mart';
      case 4:
        return 'Nisan';
      case 5:
        return 'Mayıs';
      case 6:
        return 'Haziran';
      case 7:
        return 'Temmuz';
      case 8:
        return 'Ağustos';
      case 9:
        return 'Eylül';
      case 10:
        return 'Ekim';
      case 11:
        return 'Kasım';
      case 12:
        return 'Aralık';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              controller: controller,
              tabs: const [Tab(text: "Liste"), Tab(text: "Filtre")],
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3.0,
            ),
            title: const Text(
              "Stok Kart Listesi",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
            leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _fetchFilteredStockData(
                      stokKodu: stokKodu.text,
                      stokAdi: stokAdi.text,
                      stokTipi: stokTipi,
                      barkodu: barkodu.text,
                      kdvTipi: kdvTipi,
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Listele',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
          body: TabBarView(controller: controller, children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _stockDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Kayıtlar mevcut değil.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> stockItem =
                          snapshot.data![index];
                      return buildStockCard(stockItem);
                    },
                  );
                }
              },
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    buildRow(
                        "Stok Kodu",
                        TextFormField(
                          controller: stokKodu,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        )),
                    SizedBox(height: 20),
                    buildRow(
                        "Stok Adı",
                        TextFormField(
                          controller: stokAdi,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        )),
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
                    buildRow(
                        "Barkodu",
                        TextFormField(
                          controller: barkodu,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        )),
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
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildRow(String label, Widget field) {
    return Row(
      children: [
        SizedBox(
          width: 120.0,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: field),
        const SizedBox(width: 16.0),
      ],
    );
  }

  Widget buildStockCard(Map<String, dynamic> stockItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 5.0,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                buildDataRow('Stock Kodu', stockItem['stokKodu']),
                buildDataRow('Stock Type', stockItem['stokTipi']),
                buildDataRow('Barkodu', stockItem['barkodu']),
                buildDataRow('Açıklama', stockItem['aciklama']),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                buildDataRow('Stock Adi', stockItem['stokAdi']),
                buildDataRow('Birimi', stockItem['birimi']),
                buildDataRow(
                    'KDV Tipi', '${(stockItem['kdvTipi'] * 100).toInt()}%'),
                buildDataRow(
                  'Oluşturma\n Zamanı',
                  stockItem['olusturmaZamani'] != null
                      ? formatCustomDate(
                          DateTime.parse(stockItem['olusturmaZamani']))
                      : '',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDataRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text('$title ',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          Expanded(
            child: Text('$value', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchFilteredStockData({
    String? stokKodu,
    String? stokAdi,
    int? stokTipi,
    String? barkodu,
    double? kdvTipi,
  }) async {
    try {
      print("filtering");
      final Map<String, dynamic> queryParameters = {
        if (stokKodu != null && stokKodu.isNotEmpty) 'stokKodu': stokKodu,
        if (stokAdi != null && stokAdi.isNotEmpty) 'stokAdi': stokAdi,
        if (barkodu != null && barkodu.isNotEmpty) 'barkodu': barkodu,
      };

      if (stokTipi != null) {
        queryParameters['stokTipi'] = stokTipi;
      }

      if (kdvTipi != null) {
        queryParameters['kdvTipi'] = kdvTipi;
      }

      final response = await _dio.get(
        'http://${globalServerAddress}:8080/api/stocks',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          _filteredStockData = data.cast<Map<String, dynamic>>().toList();
        });
        _stockDataFuture = Future.value(_filteredStockData);

        controller.animateTo(0);
      } else {
        throw Exception('Failed to load filtered stock data');
      }
    } catch (e) {
      throw Exception('Failed to load filtered stock data: $e');
    }
  }
}
