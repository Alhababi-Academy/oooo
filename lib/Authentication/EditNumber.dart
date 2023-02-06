import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wsy/Authentication/select_country.dart';
import 'package:wsy/Authentication/verify_number.dart';

class EditNumberScreen extends StatefulWidget {
  @override
  _EditNumber createState() => _EditNumber();
}

class _EditNumber extends State<EditNumberScreen> {
  var _enterPhoneNumber = TextEditingController();
  Map<String, dynamic> data = {"name": "Philippines", "code": "+63"};
  Map<String, dynamic>? dataResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Number"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row(
          //   children: [
          //     Logo(),
          //     Text(
          //       ("Verification . one step"),
          //       style: TextStyle(
          //           color: Color(0xFF00bfff).withOpacity(0.7), fontSize: 25),
          //     )
          //   ],
          // // ),
          // Text("Enter Your Phone Number"),
          ListTile(
            title: Text(data['name']),
            onTap: () async {
              dataResult = await Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SelectCountry()));
              setState(() {
                if (dataResult != null) data = dataResult!;
              });
            },
          ),
          const Divider(
            height: 1,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  data['code'],
                  style: const TextStyle(
                      fontSize: 25, color: CupertinoColors.secondaryLabel),
                ),
                Expanded(
                  child: CupertinoTextField(
                    placeholder: "Enter your Phone Number",
                    controller: _enterPhoneNumber,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontSize: 25, color: CupertinoColors.secondaryLabel),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "You will receive an activation code in short time",
            style: TextStyle(color: Colors.black.withOpacity(0.3)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CupertinoButton.filled(
              child: Text("Request Code"),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => VerifyNumber(
                              number: data['code'] + _enterPhoneNumber.text,
                            )));
                // Route route = MaterialPageRoute(builder: (c) => SelectCountry());
                // Navigator.push(context, route);
              },
            ),
          ),
        ],
      ),
    );
  }

  Logo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Image(
          image: AssetImage('img/whatsapp.png'),
          width: 12,
        ),
      ),
    );
  }
}
