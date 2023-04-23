import 'package:flutter/material.dart';
import 'package:flutter_parcial_3/api/api.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AppiRestFlutter());
}

class AppiRestFlutter extends StatefulWidget {
  const AppiRestFlutter({super.key});

  @override
  State<AppiRestFlutter> createState() => _AppiRestFlutterState();
}

class _AppiRestFlutterState extends State<AppiRestFlutter> {
  late Future<List<Ipwhois>> _listadogiphy;

  Future<List<Ipwhois>> _getip() async {
    final response = await http.get(Uri.parse(
        "http://ipwho.is/8.8.4.4"));

    List<Ipwhois> ip = [];
    if (response.statusCode == 200) {
      String bodys = utf8.decode(response.bodyBytes);
      //print(bodys);

      final jsonData = jsonDecode(bodys);
      // print(jsonData["data"][0]["username"]);
      for (var item in jsonData["data"]) {
        ip.add(Ipwhois(item["country"], item["flag"]["img"]));
      }
      return ip;
    } else {
      throw Exception("Falla en conectarse");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadogiphy = _getip();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Api Rest",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Api Flutter"),
          ),
          body: FutureBuilder(
            future: _listadogiphy,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data);
                return GridView.count(
                  crossAxisCount: 2,
                  children: _infoIP(snapshot.requireData),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Soy error");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }

  List<Widget> _infoIP(List<Ipwhois> data) {
    List<Widget> ip = [];
    for (var gif in data) {
      ip.add(Card(
          child: Column(
        children: [
          Expanded(
            child: Image.network(
              gif.flat,
              fit: BoxFit.fill,
            ),
          ),
          /*    Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(gif.nombre),
          ),*/
        ],
      )));
    }
    return ip;
  }
}
