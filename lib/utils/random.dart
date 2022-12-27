import 'dart:math';

Random random = new Random();
String randomcode() {
  var x='';
  for(int a1=0; a1<8 ;a1++){
    x = x+ String.fromCharCode(random.nextInt(26)+97);
  }
  return x;

}