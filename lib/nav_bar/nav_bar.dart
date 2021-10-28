
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/ShoppingCartButton.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:kuwait_livestock/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login_Page.dart';
import '../page1.dart';
import 'Category.dart';
import 'Shopping_cart.dart';
import 'more.dart';
import 'package:scroll_navigation/scroll_navigation.dart';

class navigation_bar extends StatefulWidget {


  @override
  _navigation_barState createState() => _navigation_barState();
}



class _navigation_barState extends State<navigation_bar> {


 String  s='ss';


  int _currentIndex = 1;


 // var daoa;
 // Future<void> initdata() async{
 //   WidgetsFlutterBinding.ensureInitialized();
 //   final database =await $FloorAppDatabase.databaseBuilder('edmt_cart_system.db').build();
 //   final daoa =database.cartDAO;
 // }

 bool isLogin = false;
 getLoggedInState() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   isLogin = preferences.containsKey('isLogin');
   setState(() {
     return isLogin;

   });
 }
  @override
  void initState() {
    super.initState();
    langState();
    getLoggedInState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: AppController.textDirection,
          child: AlertDialog(
            title: Text('${AppController.strings.alertExitTitle}'),
            content: Text('${AppController.strings.exitapp}'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('${AppController.strings.no}'),
              ),
              FlatButton(
                onPressed: () => SystemNavigator.pop(),
                //exit(0) ,//Navigator.of(context).pop(true),
                child: Text('${AppController.strings.yes}'),
              ),
            ],
          ),
        ))) ?? false;
  }

 var languageState;
 void langState() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();

   languageState = preferences.getString("lng");
   print(languageState);
 }

  @override
  Widget build(BuildContext context) {
    return
      // Directionality(
      //   textDirection:  languageState == "Ar" ?TextDirection.rtl :TextDirection.ltr ,
      //   child:
        WillPopScope(
      onWillPop:_onWillPop ,
      child: Scaffold(

          appBar: AppBar(
            elevation: 0,
            shadowColor: Colors.white,
            leading: Container(),
            actions: [
              isLogin==false?   InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('${AppController.strings.login}',
                    // '${AppController.strings.login}',
                    style: TextStyle(
                      color: Color(0xffb94c4c),
                      fontSize: 18,
                    ),)),
                ),
              ): Container()

            ],
            iconTheme: IconThemeData(color: Colors.black87),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Image.asset(
              'images/logo.jpeg',
              height: 190,
              fit: BoxFit.cover,
            ),
          ),
         body: ScrollNavigation(
           identiferStyle: NavigationIdentiferStyle(color: Color(0xfff50000),),
           showIdentifier: true,
           physics: true,
           bodyStyle: NavigationBodyStyle(
             dragStartBehavior: DragStartBehavior.start,
             background: Colors.white,
           ),
           barStyle: NavigationBarStyle(
             verticalPadding:5 ,
             activeColor: Color(0xffcd1313),
             background: Colors.white70,
             elevation: 0.0,
           ),
           pages: [
             page1(),
             Category_Page(),
             ShoppingCart(),
             MorePage()

           ],
           items:  [
             ScrollNavigationItem(icon: Icon(Icons.home_outlined,color: Colors.grey,),title: '${AppController.strings.home}',activeIcon: Icon(Icons.home_outlined,color: Color(0xffcd1313),), ),
             ScrollNavigationItem(icon: Icon(Icons.category_rounded,color: Colors.grey,),title: '${AppController.strings.category}',activeIcon: Icon(Icons.category_rounded,color: Color(0xffcd1313),), ),
             ScrollNavigationItem(icon: shoppingCartButton() ,title: '${AppController.strings.shoppingCart}',activeIcon: shoppingCartButton()),
             ScrollNavigationItem(icon: Icon(FontAwesomeIcons.bars,color: Colors.grey,),title: '${AppController.strings.category}',activeIcon: Icon(FontAwesomeIcons.bars,color: Color(0xffcd1313),),),
           ],
         )
        // FFNavigationBar(
        //   theme: FFNavigationBarTheme(
        //     barBackgroundColor: Colors.white70,
        //     selectedItemBorderColor: Colors.transparent,
        //     selectedItemBackgroundColor: Colors.green,
        //     selectedItemIconColor: Colors.white,
        //     selectedItemLabelColor: Colors.black,
        //     showSelectedItemShadow: false,
        //     barHeight: 60,
        //   ),
        //   selectedIndex: _currentIndex,
        //   onSelectTab: (index) {
        //     setState(() {
        //       _currentIndex = index;
        //     });
        //   },
        //   items: [
        //     FFNavigationBarItem(
        //       iconData: Icons.notes,
        //       label: '${AppController.strings.more}',
        //       selectedBackgroundColor: Colors.blue,
        //     ),
        //     FFNavigationBarItem(
        //       iconData: Icons.category,
        //       label: '${AppController.strings.category}',
        //     ),
        //     FFNavigationBarItem(
        //       iconData: Icons.home,
        //       label: '${AppController.strings.home}',
        //       selectedBackgroundColor: Colors.purple,
        //     ),
        //     FFNavigationBarItem(
        //       iconData: Icons.shopping_cart_outlined,
        //       label: '${AppController.strings.cart}',
        //       selectedBackgroundColor: Colors.blue,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
