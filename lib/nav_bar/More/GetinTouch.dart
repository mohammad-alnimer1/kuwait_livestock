
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuwait_livestock/AppHelper/AppController.dart';
import 'package:kuwait_livestock/AppHelper/staticWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AppHelper/Constants.dart';

class GetinTouch extends StatefulWidget {
  @override
  _GetinTouchState createState() => _GetinTouchState();
}

class _GetinTouchState extends State<GetinTouch> {
  TextEditingController TitleController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneNumController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  bool isLogin=false;

  getLoggedInState()async  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isLogin = preferences.getBool('isLogin');
    });
    print(isLogin);
    return isLogin;

  }

  getpref() async {

    SharedPreferences pre = await SharedPreferences.getInstance();
    if(isLogin==true){
    emailController.text = pre.getString('login');
    phoneNumController.text = pre.getString('phone');}
  }
  @override
  void initState() {
    getLoggedInState();
    getpref() ;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppController.textDirection,
        //debugShowCheckedModeBanner: false,
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Text(
          '${AppController.strings.GetinTouch}',
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Text(
                  '${AppController.strings.GetInTouchParagraph} ',
                  style: TextStyle(color: Colors.grey, fontSize: 19),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     '${AppController.strings.Title}' '*',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                        validator: staticWidget().validEmpty,

                        controller: TitleController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {},
                        decoration: KDecoration),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppController.strings.email}'  '*',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    TextFormField(
                        validator: staticWidget().validEmpty,

                        controller: emailController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {},
                        decoration: KDecoration),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${AppController.strings.phoneNum}' '*',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    TextFormField(
                        validator: staticWidget().validEmpty,

                        controller: phoneNumController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {},
                        decoration: KDecoration),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(

                       '${AppController.strings.GetTouchmessage}' '*',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    TextFormField(
                      validator: staticWidget().validEmpty,
                        controller: messageController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {},
                        maxLines: 10,
                        decoration: KDecoration),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.red)
                    ) ,
                    color: Color(0xfff50000),

                    child: Text(
                      '${AppController.strings.send}',
                      style: TextStyle(color:Colors.white,
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    elevation: 0.2,
                    onPressed: () {
                      if(  formkey.currentState.validate()){
                        _showMaterialDialog() {
                          showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                title: new Text("{AppController.strings.CommentedSuccessfully}"),
                                content:
                                new Text("{AppController.strings.Waitingadminapproval}"),
                                // actions: <Widget>[
                                //   FlatButton(
                                //     child: Text('${AppController.strings.ok}'),
                                //     onPressed: () {
                                //       setState(() {
                                //
                                //       });
                                //     },
                                //   )
                                // ],
                              ));
                        }

                      }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>  GetinTouch(),
                      //   ),
                      // );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
