import 'package:flutter/material.dart';
import 'package:quiz_app1/screens/home_screen.dart';
import 'package:quiz_app1/screens/showque.dart';
import 'package:quiz_app1/services/database.dart';
showAlertDialog(BuildContext context) {

  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
                                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StudentScreen())); 
     },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Wrong Code"),
    content: Text("Please type wrong code"),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  _StudentScreen createState() => _StudentScreen();
}

class _StudentScreen extends State<StudentScreen> {

  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData =  MediaQuery.of(context);
    var size = queryData.size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: BackButton(
            onPressed: (){
                              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));   
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                height: size.height*0.25,
              )
                    , Container(
                                                width: size.width*0.9,
                            padding: EdgeInsets.only(left: 30),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(Radius.circular(20)) ,
                  boxShadow: [BoxShadow(offset: Offset(0,10),
                                blurRadius: 10,
                                color: Colors.blue.withOpacity(0.4)
                  
                  )],
                            ),
                      child: TextField(
                      controller: codeController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Code',
                        hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
              
                    Padding(
                      padding: const EdgeInsets.only(top : 8.0),
                      child: ElevatedButton(
                        child: Text("Next"),
                        onPressed: () async{
                          bool a =await DatabaseQue(code: codeController.text.toString()).checkExist();
                          if(a){
                            var submit = (await Response(code: codeController.text).checkExist());
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ShowQue(code: codeController.text.toString(), submit: submit,))); 
                          }
                          else{
                            showAlertDialog(context);
                          } 
                        },
                      ),
                    )
    
                  ]
          ) 
          ),
      ),
    );

  }
}