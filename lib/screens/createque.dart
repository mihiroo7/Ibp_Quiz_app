import 'package:flutter/material.dart';
import 'package:quiz_app1/screens/prof.dart';
import 'package:quiz_app1/services/database.dart';

class CreateQue extends StatefulWidget{
  String code;
  CreateQue({Key ? key, required this.code}) :super(key: key);
  @override
  _CreateQue  createState() => _CreateQue(code: code);
}

class _CreateQue extends State<CreateQue>{
  String code;
  _CreateQue({required this.code});
  TextEditingController emailController = TextEditingController();
  var optioncontroller = [new TextEditingController(),new TextEditingController(),new TextEditingController(),new TextEditingController()];
  var x = 4;



  void constructoption(){
    optioncontroller.clear();
    for(var i=0; i<x; i++){
      optioncontroller.add(new TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context){
    MediaQueryData queryData =  MediaQuery.of(context);
    var size = queryData.size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: BackButton(
            onPressed: (){
                              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profscreen(code: code)));   
            }),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: size.width*0.9,
                    padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(20)) ,
                      boxShadow: [BoxShadow(offset: Offset(0,10),
                                blurRadius: 10,
                                color: Colors.yellow.withOpacity(0.4)
                  
                      )],
                            ),
                    child: TextFormField(
                      maxLines: 5,
                      controller: emailController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Question',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 180.0, top: 8.0),
                    child: Container(
                      child: Text("Number of options"),
                      padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(20)) ,
                        boxShadow: [BoxShadow(offset: Offset(0,10),
                                  blurRadius: 10,
                                  color: Colors.yellow.withOpacity(0.4)
                    
                        )],
                      ),
                      
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left :8.0),
                        child: Radio(
                          fillColor:   MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.blue;
                }),
                          value: 2, 
                          groupValue: x, 
                          onChanged: (value){
                            setState(() {
                                x = value as int;
                                constructoption();
                            });
                          },
                        ),
                      ),
                    Text("2", style: TextStyle(color: Colors.white),),
              
                    Radio(
                        
                        fillColor:   MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.blue;
                }),
                        
                        value: 3, 
                        groupValue: x, 
                        onChanged: (value){
                          setState(() {
                              x = value as int;
                              constructoption();
                          });
                        },
                    ),
                    Text("3",style: TextStyle(color: Colors.white),),
              
                    Radio(
                          fillColor:   MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.blue;
                }),
                          value: 4, 
                          groupValue: x, 
                          onChanged: (value){
                            setState(() {
                                x = value as int;
                                constructoption();
                            });
                          },
                    ),
                    Text("4",style: TextStyle(color: Colors.white),)
                    ],
                  ),
              
                  Column(
                    children: <Widget>[
                      for(var i=0; i<x; i++)
                        Container(
                    width: size.width*0.9,
                    padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20)) ,
                      boxShadow: [BoxShadow(offset: Offset(0,10),
                                blurRadius: 10,
                                color: Colors.blue.withOpacity(0.4)
                  
                      )],
                            ),
                          child: TextFormField(
                            controller: optioncontroller[i],
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Option' + String.fromCharCode(65+i),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                    ],
                  ),
                  ElevatedButton(
                    child: Text("Change"),
                    onPressed: () async{
                      List<String> ans = [];
                      ans.add(emailController.text.toString());
                      for(var i=0; i<x; i++){
                        ans.add(optioncontroller[i].text.toString());
                      }
                      await DatabaseQue(code: code).Updateque(ans);
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profscreen(code: code))); 
                    },
                  )
              
                ]
              ),
            ),
          ]),
      ),
    );
  }
}