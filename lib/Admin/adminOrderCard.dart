import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../Models/item.dart';
import '../Store/storehome.dart';
import '../Widgets/orderCard.dart';
import 'adminOrderDetails.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final String? addressID;
  final String? orderBy;
  var solo;

  AdminOrderCard({
    Key? key,
    this.itemCount,
    this.data,
    this.orderID,
    this.addressID,
    this.orderBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        route = MaterialPageRoute(
            builder: (c) => AdminOrderDetails(
                  orderID: orderID!,
                  orderBy: orderBy!,
                  addressID: addressID!,
                ));
        // if(counter == 0)
        // {
        //   counter = counter + 1;
        //   route = MaterialPageRoute(builder: (c) => AdminOrderDetails(orderID: orderID, orderBy: orderBy, addressID: addressID,));
        // }
        Navigator.push(context, route);
      },
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
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount! * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data());
            return sourceOrderInfo(model, context, solo);
          },
        ),
      ),
    );
  }
}
