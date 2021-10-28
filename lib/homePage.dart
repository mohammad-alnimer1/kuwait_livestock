import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
//import 'package:kuwait_livestock/chat.dart';
import 'dart:convert';
import 'package:http/http.dart ' as http;
import 'page1.dart';
import 'AppHelper/AppController.dart';
import 'AppHelper/networking.dart';


//import 'Category_Model.dart';

//import 'Product_Model.dart';

void main() => runApp(MaterialApp(
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool itemloading = false;
  List<CategoryModel> items = [];
  var _isInit = true;
  var _isLoading = false;
  List<CategoryModel> CategoryList = [];
  Map<int, List<CategoryModel>> maplist = new Map<int, List<CategoryModel>>();

  Future<void> getCateg() async {
    CategoryList = [];

    try {
      final NetworkHelper networkHelper = NetworkHelper("http://kuwaitlivestock.com:5000/categ_ids");
      //NetworkHelper("http://kuwaitlivestock.com:5000/categ_ids");
      final Categorydata = await networkHelper.getdata() as List;
      if (Categorydata.isEmpty) {
        print("no item-----------------------------------------------");
        return;
      }
      Categorydata.forEach((data) {
        //var model = CategoryModel();
        /* model.id = data['id'];
        model.name = data['name'];
        model.images = Base64Codec().decode((data['image']));*/


        fetchCategory(id: data['id']).then((value) => {
          if (value != null)
            {
              CategoryList.add(new CategoryModel(id: data['id'], name: data['name'])),
              print("category"),
              print(value[0].name),
              maplist.putIfAbsent(data['id'], () => value)
            }
          else
            {
              print(
                  "error whene fetching list of product for this category")
            }
        });
      });
    } catch (err) {
      throw err;
    }
  }

  Future<List<CategoryModel>> fetchCategory({@required int id}) async {
    List<CategoryModel> item = [];
    NetworkHelper networkHelper;
    // networkHelper = NetworkHelper("http://kuwaitlivestock.com:5000/categ_ids?categ_id=${id}");
    //http: //127.0.0.1:3336/api/products/products/id/?id
    //NetworkHelper networkHelper;
    print("http://kuwaitlivestock.com:5000/categ_ids?categ_id=${id}");
    networkHelper = NetworkHelper(
        "http://kuwaitlivestock.com:5000/categ_ids?categ_id=${id}");
    final extractedData = await networkHelper.getdata() as List;
    if (extractedData == null) {
      return null;
    }
    // print(extractedData);
    extractedData.forEach((catData) {
      item.add(CategoryModel(
          id: catData['id'],
          name: catData['name'],
          images: Base64Codec().decode(
            (catData['image_1920']),
          )));

      // print(catData['name']);
    });

    setState(() {});
    return item;
  }

  @override
  void initState() {
    super.initState();
    // getCateg();
    setState(() {
      _isLoading = true;
    });
    getCateg().then((value) => {
      setState(() {
        _isLoading = false;
      })
    });
  }

  List<CategoryModel> getiem(int index) {
    return maplist[CategoryList[index].id];
  }

  @override
  void didChangeDependencies() {
    /* setState(() {
      _isLoading = true;
    });
    getCateg().then((value) => {
          setState(() {
            _isLoading = false;
          })
        });*/
    /*fetchCategory(id: widget.categoryID).then((_) {

    })*/
  }

  bool _hasMore;

  Future<String> refreshList() async {
    items.clear();
    maplist.clear();
    setState(() {
      _isLoading = true;
    });
    getCateg().then((value) => {
      setState(() {
        _isLoading = false;
      })
    });

    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<dynamic> globalKey = GlobalKey();

    return  Directionality(
        textDirection: AppController.textDirection,
        child:  Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => ChatScreen(),
          //     ));
        },
        child: const Icon(Icons.chat),
        backgroundColor: Colors.green,
      ),

      backgroundColor: Colors.white,
      drawer: Drawer(),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    labelText: '${AppController.strings.SearchAboutProduct}',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey.shade100, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey.shade100, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Carousel(
                      animationDuration: Duration(seconds: 1),
                      //pageController: PageController(),
                      boxFit: BoxFit.cover,
                      animationCurve: Curves.fastOutSlowIn,
                      dotSize: 10.0,
                      autoplay: true,
                      dotIncreasedColor: Color(0xFFf33BE9F),
                      dotBgColor: Colors.transparent,
                      dotPosition: DotPosition.bottomCenter,
                      dotVerticalPadding: 10.0,
                      showIndicator: true,
                      indicatorBgPadding: 7.0,
                      autoplayDuration: Duration(seconds: 3),
                      borderRadius: true,
                      noRadiusForIndicator: true,
                      images: [
                        // for (var i = 0; i < slidImg.length; i++)
                        AssetImage('images/logo.jpeg'),
                        AssetImage('images/sh1.png'),


                        // NetworkImage('${Api().baseImgURL + imgdata[2]['Images']}'),
                      ],
                    )),
                height: 220,
              ),
            ),
            Container(
              height: 50,
              child: Image.asset(
                'images/cut.jpeg',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 50,
                child: RaisedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => page1(),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.indigo.shade900,

                  child: Text(
                    'CUSTOMIZE YOUR CUT ',
                    style: TextStyle(
                        decorationThickness: 0.1,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  ),
                  elevation: 0.2,
                  // onPressed: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>  GetinTouch(),
                  //     ),
                  //   );
                  // },
                ),
              ),
            ),
            _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Column(children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: CategoryList.length,
                      /*CategoryList.length*/
                      /* gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: (MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            0.95)),
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10)*/
                      itemBuilder: (BuildContext context, int index) {
                        // items .clear();
                        items = maplist[CategoryList[index].id];

                        print("zezeze");
                        return Card(
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${CategoryList[index].name}',
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        'See All',
                                        style: TextStyle(
                                            color: Colors.orangeAccent,
                                            fontSize: 20),
                                      )
                                    ]),
                                items == null
                                    ? Column(
                                    children:[Text(
                                      "لا يوجد منتج في هذا الصنف",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 30),
                                    ),
                                      Icon(Icons.error_outline_sharp)
                                    ] )
                                    : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        itemCount: items.length > 4
                                            ? 4
                                            : items.length,
                                        gridDelegate:
                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio:
                                            MediaQuery.of(context)
                                                .size
                                                .width /
                                                (MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height /
                                                    1),
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 5),
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          return Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  2,
                                              child: InkWell(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         CategoryScreen(),
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Card(
                                                      elevation: 1,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                        children: [
                                                          Container(
                                                            child: Image.memory(
                                                                items[index]
                                                                    .images,
                                                                scale:
                                                                0.4,
                                                                height:
                                                                100,
                                                                fit: BoxFit
                                                                    .fill),
                                                            height: 100,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.all(
                                                                    5.0),
                                                                child:
                                                                Text(
                                                                  '${items[index].name} ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      15,
                                                                      fontWeight:
                                                                      FontWeight.bold),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.all(
                                                                    5.0),
                                                                child:
                                                                Text(
                                                                  'Kuwaiti livestock',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14,
                                                                      fontWeight:
                                                                      FontWeight.bold),
                                                                  textAlign:
                                                                  TextAlign.left,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.all(
                                                                    5.0),
                                                                child:
                                                                Text(
                                                                  'The price is 150 KD',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      15,
                                                                      fontWeight:
                                                                      FontWeight.bold),
                                                                ),
                                                              ),
                                                              RaisedButton(
                                                                child:
                                                                Text(
                                                                  'add To Cart',
                                                                  // '${AppController.strings.addToCart}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      16,
                                                                      color:
                                                                      Colors.white),
                                                                ),
                                                                onPressed:
                                                                    () {},
                                                                color: Colors
                                                                    .redAccent,
                                                                elevation:
                                                                2,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(
                                                                        18.0),
                                                                    side:
                                                                    BorderSide(color: Colors.red)),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ))));
                                        }))
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                /*    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: MediaQuery.of(context)
                                          .size
                                          .width /
                                      (MediaQuery.of(context).size.height / 1.3),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return CategoryListItem(
                              id: items[index].id,
                              name: items[index].name,
                              image: items[index].images,
                            );
                          }),
                    ),*/

                /* Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),

                          child: ListView.builder(
                            itemCount: CategoryList.length,
                            itemBuilder: (context, index) {


                              return
                                  Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${CategoryList[index].name}',
                                              style:
                                              TextStyle(color: Colors.blueAccent, fontSize: 20),
                                            ),
                                            Text(
                                              'See All',
                                              style: TextStyle(
                                                  color: Colors.orangeAccent, fontSize: 20),
                                            )
                                          ])
                                  );
                                  */
                /*Container(
                                      height: 300,
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: items.length,
                                        physics: ScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                                          mainAxisExtent: 180,
                                          crossAxisCount: 1,
                                          childAspectRatio: MediaQuery.of(context).size.width /
                                              (MediaQuery.of(context).size.height / 5),
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 150,
                                        ),
                                        itemBuilder: (context, index) {

                                          return Container(
                                              child: InkWell(
                                                  onTap: () {
                                                    */
                /**/
                /*Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ProductDetails(),
                                                      ),
                                                    );*/
                /**/
                /*
                                                  },
                                                  child: Card(
                                                      elevation: 1,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          Container(child: Image.asset(
                                                            'images/sh3.jpg',
                                                            fit: BoxFit.fill,
                                                          ),height: 140,),
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(
                                                                  '${items[index].name} ',
                                                                  style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(
                                                                  'Kuwaiti livestock',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.bold),
                                                                  textAlign: TextAlign.left,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(
                                                                  'The price is 150 KD',
                                                                  style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              RaisedButton(
                                                                child: Text('add To Cart',
                                                                  // '${AppController.strings.addToCart}',
                                                                  style: TextStyle(
                                                                      fontSize: 16, color: Colors.white),
                                                                ),
                                                                onPressed: () {},
                                                                color: Colors.redAccent,
                                                                elevation: 2,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                    BorderRadius.circular(18.0),
                                                                    side: BorderSide(color: Colors.red)),
                                                              )
                                                            ],
                                                          ),

                                                        ],
                                                      ))));
                                        },
                                      ))*/
                /*

                              ;
                            },
                          ),
                        )*/
              )
            ]),
            /* ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryScreen(categoryID: 1,)))
                          ;
                        },
                        child: Text(
                          'See All',
                          style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 20),
                        ),
                        padding: EdgeInsets.all(0),
                        textColor: Colors.orangeAccent,
                      ),
                      Text(
                        'New Zealand sheep>',
                        style:
                        TextStyle(color: Colors.orangeAccent, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 305,
                  child: GridView(
                    // itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    // primary: false,
                    // padding: const EdgeInsets.all(10),
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 1,
                    //     mainAxisSpacing: 18,
                    //     mainAxisExtent: 200),
                    // itemBuilder: (context, index) {
                    //   return ;
                    // },
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //
                    //     crossAxisCount: 1,
                    //     mainAxisSpacing: 18,
                    //     mainAxisExtent: 200),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 180,
                      crossAxisCount: 1,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 150,
                    ),
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                //       builder: (context) => ProductDetails(),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  child: Image.asset(
                                    'az.png',
                                    fit: BoxFit.fill,
                                  ),
                                  height: 140,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'New Zealand sheep ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Kuwaiti livestock',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'The price is 150 KD',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    RaisedButton(
                                      child: Text(
                                        'add To Cart',
                                        // '${AppController.strings.addToCart}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      onPressed: () {},
                                      color: Colors.redAccent,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                //builder: (context) => ProductDetails(),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  child: Image.asset(
                                    'images/sh3.jpg',
                                    fit: BoxFit.fill,
                                  ),
                                  height: 140,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'New Zealand sheep ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Kuwaiti livestock',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'The price is 150 KD',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    RaisedButton(
                                      child: Text(
                                        'add To Cart',
                                        // '${AppController.strings.addToCart}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      onPressed: () {},
                                      color: Colors.redAccent,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Roman sheep',
                        style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                      ),
                      Text(
                        'See All',
                        style:
                        TextStyle(color: Colors.orangeAccent, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 305,
                  child: GridView(
                    // itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    // primary: false,
                    // padding: const EdgeInsets.all(10),
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 1,
                    //     mainAxisSpacing: 18,
                    //     mainAxisExtent: 200),
                    // itemBuilder: (context, index) {
                    //   return ;
                    // },
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //
                    //     crossAxisCount: 1,
                    //     mainAxisSpacing: 18,
                    //     mainAxisExtent: 200),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 180,
                      crossAxisCount: 1,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 150,
                    ),
                    children: [
                      Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                //builder: (context) => ProductDetails(),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  child: Image.asset(
                                    'images/sh4.jpg',
                                    fit: BoxFit.fill,
                                  ),
                                  height: 140,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Roman sheep ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Kuwaiti livestock',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'The price is 150 KD',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    RaisedButton(
                                      child: Text(
                                        'add To Cart',
                                        // '${AppController.strings.addToCart}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      onPressed: () {},
                                      color: Colors.redAccent,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // builder: (context) => ProductDetails(),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  child: Image.asset(
                                    'images/sh5.jpg',
                                    fit: BoxFit.fill,
                                  ),
                                  height: 140,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Roman sheep',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Kuwaiti livestock',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'The price is 150 KD',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    RaisedButton(
                                      child: Text(
                                        'add To Cart',
                                        // '${AppController.strings.addToCart}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      onPressed: () {},
                                      color: Colors.redAccent,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),*/
          ],
        ),
      ),
    ));
  }
}
//  Divider(
//             thickness: 1,
//           ),

class CategoryModel {
  int id;
  String name;
  Uint8List images;

  CategoryModel({this.id, this.name, this.images});
}

