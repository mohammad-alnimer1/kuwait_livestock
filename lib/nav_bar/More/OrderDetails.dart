import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';

class OrderDetails extends StatefulWidget {
  final partner_id;
  final amount_total;
  OrderDetails({this.partner_id,this.amount_total});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    print('hi hi hi hi hi  ');

    super.initState();
  }

  // void texe(){
  //   for (int i = 0; i < widget.partner_id.length; i++){
  //     var  order_line= widget.partner_id[i] ;
  //     print('hi hi hi hi hi  ${order_line}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppController.textDirection,
        child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '${AppController.strings.orderDetails}',
          style: TextStyle(color: Colors.black87),
        ),),
      body: ListView(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.partner_id.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Divider(color: Colors.black87,),

                    Container(
                      color: Colors.grey.shade200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Text(
                            '${AppController.strings.name}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            '${widget.partner_id[index]['product_id'][1]}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [

                        Text(
                          '${AppController.strings.price_unit}',
                          style: TextStyle(fontSize: 20),
                        ),    Text(
                          '${widget.partner_id[index]['price_unit']}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${AppController.strings.totalQty_unit }',
                          style: TextStyle(fontSize: 20),
                        ),    Text(
                          '${widget.partner_id[index]['product_uom_qty']}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          '${AppController.strings.totalprice_unit}',
                          style: TextStyle(fontSize: 20),
                        ),    Text(
                          '${widget.partner_id[index]['price_subtotal']}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),

                  ],
                ),
              );
            },
          ),
          Container(
            height: 50,
            color: Colors.grey.shade200,
            child: Row(children: [         Text(
              '${AppController.strings.TotalPrice}',
              style: TextStyle(fontSize: 20),
            ),    Text(
              '${widget.amount_total}',
              style: TextStyle(fontSize: 20),
            ),],),
          )
        ],
      ),
    ));
  }
}
