import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectCountry extends StatefulWidget {
  @override
  _SelectCountry createState() => _SelectCountry();
}

class _SelectCountry extends State<SelectCountry> {
  List<dynamic>? dataRetrieved; // data decoed from the json file
  List<dynamic>? data; // data to display on the screen
  var searchController = TextEditingController();
  var searchValue = '';
  @override
  void initState() {
    _getData();
  }

  Future _getData() async {
    final String response =
        await rootBundle.loadString("img/CountryCodes.json");
    dataRetrieved = await json.decode(response) as List<dynamic>;
    setState(() {
      data = dataRetrieved;
      print("This is Data $data");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text("Select Country"),
            previousPageTitle: "Edit Number",
          ),
          SliverToBoxAdapter(
            child: CupertinoSearchTextField(
              onChanged: (value) {
                setState(() {
                  print(value);
                  searchValue = value;
                });
              },
              controller: searchController,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              data != null
                  ? data!
                      .where((e) => e['name']
                          .toString()
                          .toLowerCase()
                          .contains(searchValue.toLowerCase()))
                      .map(
                        (e) => ListTile(
                          onTap: () {
                            print(e['name']);
                            Navigator.pop(context,
                                {"name": e['name'], "code": e['dial_code']});
                          },
                          title: Text(
                            e['name'],
                            textScaleFactor: 1.5,
                          ),
                          trailing: Text(e['dial_code']),
                        ),
                      )
                      .toList()
                  : [
                      const Center(
                        child: Text("Loading"),
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
