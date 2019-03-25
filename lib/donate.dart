import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class Donate extends StatefulWidget {
  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  // static const List<String> iapIdtest = ['android.test.purchased'];
  static const List<String> iapId = ['burger', 'beer', 'donate'];
  List<IAPItem> _items = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() async {
    super.dispose();
    await FlutterInappPurchase.endConnection;
  }

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.initConnection;
    print('result = $result');

    // If the widget was removed from the tree while the async
    // message was in flight, we want to discard the reply rather than
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // refresh items for android
    String msg = await FlutterInappPurchase.consumeAllItems;
    print('consumeAllitems = $msg');

    await getProducts();
  }

  Future<Null> getProducts() async {
    List<IAPItem> items = await FlutterInappPurchase.getProducts(iapId);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
    });
  }

  Future<Null> buyProduct(IAPItem item) async {
    try {
      PurchasedItem purchasedItem =
          await FlutterInappPurchase.buyProduct(item.productId);
      print(purchasedItem);
      String msg = await FlutterInappPurchase.consumeAllItems;
      print('consumeAllitems = $msg');
    } catch (error) {
      print('Error IAP = $error');
    }
  }

  List<Widget> renderButton() {
    List<Widget> widgets = this
        ._items
        .map(
          (item) => Container(
                height: 150.0,
                width: double.infinity,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${item.title}',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${item.description}',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      MaterialButton(
                        height: 50.0,
                        color: Colors.pink,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () => buyProduct(item),
                        child: Text(
                          '${item.price} ${item.currency}',
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        )
        .toList();

    return widgets;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Donate'),
        ),
        body: Column(children: this.renderButton()),
      );
}
