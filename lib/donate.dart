import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class Donate extends StatefulWidget {
  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  static const String iapIdtest = 'android.test.purchased';
  static const String iapId =
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqm0kTtEUXAzlWagkqrc2n0NaFdmIQQ3IHG2OIJ/dWmSyYIXOSwWW6srbsqOXiIbvqFB17vOkkzuKX9jc1QNVQ9p88ORVhJHQ7FIDO4pgIPLp17KZ2VMPAWGlIAaIQTrKyyQH/Z0XmA7CGIjXQvIc5LHNB76q9iJvGLwBE8kf+z7Hm1dEfbag2A9bEXgk/lWJW0bEbj1N21IoJBMS6Mg3WK/gz3yBo2xLE0XExG13R+xIvo+SxHWcPswiP256NUTDEbJTBu81vrneBzylzmon+vwdOAIWKlUkP0USJaIYhbigrjHMtyWgv4BfhyuAWUH9bKH5FUQC3nVtD1HLZlk8rQIDAQAB';
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
    List<IAPItem> items = await FlutterInappPurchase.getProducts([iapId]);
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
                height: 300.0,
                width: double.infinity,
                child: Card(
                    child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${item.title}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'This is a consumable item.',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'This item you can buy multiple times.',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    MaterialButton(
                      height: 50.0,
                      color: Colors.pink,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () => buyProduct(item),
                      child: Text(
                        'Donate ${item.price} ${item.currency}',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
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
