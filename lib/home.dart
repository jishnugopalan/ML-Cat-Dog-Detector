
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading=true;
  File _image;
  List _output;
  final picker=ImagePicker();
  
  @override
  void initState(){
    super.initState();
    loadModel().then((value){
      setState((){

      });
    });
  }
  detectImage(File image) async {
    print("in detect");
    print(image.path);
    var output=await Tflite.runModelOnImage(path: image.path,numResults: 2,threshold: 0.6,imageMean: 127.5,imageStd: 127.5,);
    setState(() {
      print("in set state");
      _output=output;
      _loading=false;
    });
  }
  loadModel() async{
    print("in load model");
    await Tflite.loadModel(model: 'assets/model_unquant.tflite',labels: 'assets/labels.txt',numThreads: 1,
        isAsset: true,
        useGpuDelegate: false);
  }
  @override
  void dispose(){
    super.dispose();
  }
  pickImage() async{
    var image=await picker.getImage(source: ImageSource.camera);
    if(image==null) return null;
    setState(() {
      _image=File(image.path);
    });
    detectImage(_image);
  }
  pickGalleryImage() async{
    var image=await picker.getImage(source: ImageSource.gallery);
    if(image==null) return null;
    setState(() {
      _image=File(image.path);
    });
    print("in detect");
    print(image.path);
    var output=await Tflite.runModelOnImage(path: image.path,numResults: 2,threshold: 0.6,imageMean: 127.5,imageStd: 127.5,);
    setState(() {
      print("in set state");
      _output=output;
      _loading=false;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body:Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          //Text("Coding Cafe",style:TextStyle(color: Colors.yellow,fontSize: 20)),
          SizedBox(height: 5,),
          Text("Cat and Dog Detector App",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 25)),
          SizedBox(
            height: 10,
          ),
          Center(
            child: _loading ?
            Container(
              width: 350,
              child: Column(children: [
              // Image.asset('assets/cat_dog_icon.png'),
              //   SizedBox(height: 10,)
              ],),
            ):Container(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    child: Image.file(_image),
                  ),
                  SizedBox(height: 20,),
                  _output !=null ? Text('${_output[0]['label']}',style: TextStyle(color: Colors.white,fontSize: 15),) : Container(),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    pickImage();
                  },
                  child: Container(width: MediaQuery.of(context).size.width-250,alignment: Alignment.center,padding: EdgeInsets.symmetric(horizontal: 25,vertical: 18),
                    decoration: BoxDecoration(
                        color: Colors.yellowAccent,borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text("Open Camera",style: TextStyle(color: Colors.black),),
                  ),


                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){
                    pickGalleryImage();
                  },
                  child: Container(width: MediaQuery.of(context).size.width-250,alignment: Alignment.center,padding: EdgeInsets.symmetric(horizontal: 25,vertical: 18),
                    decoration: BoxDecoration(
                        color: Colors.yellowAccent,borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text("Select Photo",style: TextStyle(color: Colors.black),),
                  ),


                ),

              ],
            ),
          )

        ],
        ),

      )
    );
  }
}
