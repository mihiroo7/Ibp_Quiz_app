import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../utils/random.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QueResult{
  Map<String, Object?> queres;
  QueResult({required this.queres});
}

class DatabaseUser {
  String uid;
  DatabaseUser({required this.uid});

  final CollectionReference usercollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference quecollection = FirebaseFirestore.instance.collection('queres');
  final CollectionReference resultcollection = FirebaseFirestore.instance.collection('res');


  Future<String> Updateuserdata () async{
        var code = randomcode();
        await usercollection.doc(uid).set({
          'code' : code,
          'uid' : uid
        });
        await quecollection.doc(code).set({
          'code' : code,
          'que' : 'no questions',
        });
        await resultcollection.doc(code).set({
          'code' : code,
          'que' : 'no questions',
        });
        return code;
  }
  Future<bool> checkExist() async {    
      var x = await ( usercollection.doc(uid).get());
      if(x==null || !x.exists){
        return false;
      }
      return true;
  }

  Future<String> getdata() async{
    var x =await usercollection.doc(uid).get().then((value){
      return value;
    });
    var y = x.data() as Map<String, Object?>;
    return y['code'].toString();

  }
}

class DatabaseQue {
  String code;
  DatabaseQue({required this.code});

  final CollectionReference quecollection = FirebaseFirestore.instance.collection('queres');
  final CollectionReference rescollection = FirebaseFirestore.instance.collection('res');
  final CollectionReference usercollection = FirebaseFirestore.instance.collection('user');
  final CollectionReference responsecollection = FirebaseFirestore.instance.collection('response');


  Future Updateque (List<String> data) async{
    Map<String, Object?> temp = {};
    Map<String, Object?> temp1 = {};
    temp['que'] = data[0];
    temp['code'] = code;
    temp1['que'] = data[0];
    temp1['code'] = code;
    data.remove(data[0]);
    int x=0;
    for(var i in data){
      temp[String.fromCharCode(x+65)]=i;
      temp1[String.fromCharCode(x+65)]=i;
      temp1['~'+String.fromCharCode(x+65)]=0;
      x=x+1;
    }
    await quecollection.doc(code).set(temp);
    await rescollection.doc(code).set(temp1);
    await responsecollection.doc(code).set({'dummy': 'dummy'});

  } 

  Stream<DocumentSnapshot<Object?>> get queresult{
    return quecollection.doc(code).snapshots();
  } 

  Stream<DocumentSnapshot<Object?>> get result{
    return rescollection.doc(code).snapshots();
  } 


  Future<bool> checkExist() async {    
      if(code==""){
        return false;
      }
      var x = await ( rescollection.doc(code).get());
      if(x==null || !x.exists){
        return false;
      }
      return true;
  }

  Future Updatedata(List<bool> data,String code) async {
    var x = await FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot freshsnapshot = await transaction.get(rescollection.doc(code));
      Map<String, Object?> y= await freshsnapshot.data() as Map<String, Object?> ;
      Map<String, Object?> newdata ={};
      var x = data as List<bool>;
      for(var i=0; i<x.length; i++){
        newdata[String.fromCharCode(65+i)]=  (y[String.fromCharCode(65+i)]);    


        if(x[i]){
          newdata['~'+ String.fromCharCode(65+i)]=  (y['~'+ String.fromCharCode(65+i)] as int) + 1;     
        }
        else{
          newdata['~'+ String.fromCharCode(65+i)]=  (y['~'+ String.fromCharCode(65+i)]);    
        }
      }
      newdata['code'] = y['code'];
      newdata['que'] = y['que'];
      await transaction.set(freshsnapshot.reference, newdata);
    });
  //   var freshsnapshot = await rescollection.doc(code).get();
  //   var y = freshsnapshot.data() as Map<String,Object?>; 
  //     Map<String, Object?> newdata ={};
  //     var x = data as List<bool>;
  //     for(var i=0; i<x.length; i++){
  //       newdata[String.fromCharCode(65+i)]=  (y[String.fromCharCode(65+i)]);    


  //       if(x[i]){
  //         newdata['~'+ String.fromCharCode(65+i)]=  (y['~'+ String.fromCharCode(65+i)] as int) + 1;     
  //       }
  //       else{
  //         newdata['~'+ String.fromCharCode(65+i)]=  (y['~'+ String.fromCharCode(65+i)]);    
  //       }
  //     }
  //     newdata['code'] = y['code'];
  //     newdata['que'] = y['que'];
  //     await rescollection.doc(code).set(newdata);
  // }
  }
}

class Response{
  String code;
  Response({required this.code});

  final CollectionReference usercollection = FirebaseFirestore.instance.collection('response');

  Future UpdatedataRes() async {
    var y= FirebaseAuth.instance.currentUser!.uid.toString();
    await usercollection.doc(code).update({y : true});
  }

  Future<bool> checkExist() async {    
      var y= FirebaseAuth.instance.currentUser!.uid.toString();
      var x = await ( usercollection.doc(code).get().then((value){
        return value;
      }) );
      var z = x.data() as Map<String, Object?>;
      bool res = z.containsKey(y);

      return res;
  }



}