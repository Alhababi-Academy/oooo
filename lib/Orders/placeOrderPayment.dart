import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wsy/Config/config.dart';
import 'package:wsy/main.dart';

import '../Counters/cartitemcounter.dart';
import '../Store/PhysicalTherapy.dart';

class PaymentPage extends StatefulWidget {
  final String? addressId;
  final double? totalAmount;

  PaymentPage({
    Key? key,
    this.addressId,
    this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double? _height;
  double? _width;

  String? _setTime, _setDate;

  String? _hour, _minute, _time;

  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  int quantityOfItems = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.teal],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("img/cash.png"),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text(
                  "Pick Date And Time To checkout",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        print(selectedDate);
        _dateController.text = DateFormat.yMd().format(selectedDate);
        print(_dateController.text = DateFormat.yMd().format(selectedDate));
        var _setDate = _dateController.text;
        _selectTime(context, _setDate);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context, _setDate) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ':' + _minute!;
        _timeController.text = _time!;
        print(_timeController.text = _time!);
        var _setTime = _timeController.text;
        addOrderDetails(_setTime, _setDate);
      });
    }
  }

  addOrderDetails(_setTime, _setDate) {
    writeOrderDetailsForUser({
      wsy.addressID: widget.addressId,
      wsy.totalAmount: widget.totalAmount,
      "rating": "",
      "orderStatus": "Pending",
      "Date": _setDate,
      "Time": _setTime,
      "orderBy": wsy.sharedPreferences!.getString(wsy.userUID),
      wsy.productID: wsy.sharedPreferences!.getStringList(wsy.userCartList),
      wsy.paymentDetails: "Cash on Delivery",
      wsy.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      wsy.isSuccess: true,
    });

    writeOrderDetailsForAdmin({
      wsy.addressID: widget.addressId,
      wsy.totalAmount: widget.totalAmount,
      "orderBy": wsy.sharedPreferences!.getString(wsy.userUID),
      wsy.productID: wsy.sharedPreferences!.getStringList(wsy.userCartList),
      wsy.paymentDetails: "Cash on Delivery",
      "orderStatus": "Pending",
      "Date": _setDate,
      "Time": _setTime,
      wsy.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      wsy.isSuccess: true,
      "rating": "",
    }).whenComplete(() => {emptyCartNow()});
  }

  emptyCartNow() {
    wsy.sharedPreferences!.setStringList(wsy.userCartList, ["garbageValue"]);
    List<String>? tempList =
        wsy.sharedPreferences!.getStringList(wsy.userCartList);

    FirebaseFirestore.instance
        .collection("users")
        .doc(wsy.sharedPreferences!.getString(wsy.userUID))
        .update({
      wsy.userCartList: tempList,
    }).then((value) {
      wsy.sharedPreferences!.setStringList(wsy.userCartList, tempList!);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });

    Fluttertoast.showToast(
        msg: "Congratulations, your Order has been placed successfully.");

    Route route = MaterialPageRoute(builder: (c) => MyApp());
    Navigator.pushReplacement(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await wsy.firestore!
        .collection(wsy.collectionUser)
        .doc(wsy.sharedPreferences!.getString(wsy.userUID))
        .collection(wsy.collectionOrders)
        // .doc(wsy.sharedPreferences.getString(wsy.userUID) +
        //     data['orderTime'])
        .doc(wsy.sharedPreferences!.getString(wsy.userUID))
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await wsy.firestore!
        .collection(wsy.collectionOrders)
        .doc(wsy.sharedPreferences!.getString(wsy.userUID))
        .set(data);
  }
}
