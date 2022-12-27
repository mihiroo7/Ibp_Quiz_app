import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app1/screens/student.dart';
import '../services/database.dart';

class ShowQue extends StatefulWidget{
  String code;
  bool submit;
  ShowQue({Key ? key, required this.code, required this.submit}) :super(key: key);
  @override
  _ShowQue  createState() => _ShowQue(code: code, submit: submit);
}

class _ShowQue extends State<ShowQue>{
  String code;
  bool submit;
  _ShowQue({required this.code, required this.submit});
  List<bool> check=[false, false, false, false];
  



  @override
  Widget build(BuildContext context){
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
                      MaterialPageRoute(builder: (context) => StudentScreen()));   
            }),
        ),
        body: Center(
          child: StreamBuilder<DocumentSnapshot<Object?>>(
            stream: DatabaseQue(code: code).queresult,
            builder: ((context, snapshot) {
              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }
              var data = snapshot.data!.data() as Map<String, Object?>;
              var y =[];
              for(var i in data.keys){
                if(i[0]=='~' || i=='que' || i=='code'){
                  y.add(i);
                }
              }
              var d = data.keys.toList();
              for(var i in y){
                d.remove(i);
              }
              d.sort();
              
        
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top : 8.0),
                    child: Container(
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
                      child: Text(data['que'].toString())),
                  ),   
                  for(var i=0; i<d.length; i++) 
                  Padding(
                    padding: const EdgeInsets.only(top : 8.0),
        
                      child: Container(
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
                        child: Row(
                          children: [
                            Checkbox(
                              value: check[i],
                              onChanged: ((bool? value){
                                setState(() {
                                  check[i] = value!;
                                });
                              }),
                            ),
                            Container(
                              width: size.width*0.7,
                              child: Text(String.fromCharCode(65+i)+" "+data[String.fromCharCode(65+i)].toString()))
                          ],
                        ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      width: size.width*0.9,
                      color: Colors.blue,
                      child: ElevatedButton(
                        child: Text((!submit ? "submit": "submitted")),
                        onPressed:(submit==true ? null : ()async{
                          submit = true;
                          List<bool> check2=[];
                          for(var i=0; i<d.length; i++){
                            check2.add(check[i]);                                            
                          }
                          await DatabaseQue(code: code).Updatedata(check2, code);
                          await Response(code: code).UpdatedataRes();
                          setState((){
                            submit = true;
                          });
                        }) ,
                      ),
                    ),
                  )            
                ],
    
              );
    
            })
            ) 
          ),
        
      ),
    );
  }
}