import 'dart:convert';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class StorageService{
   final _uuid = Uuid();

   Future<String> uploadImage(BuildContext context, String folder) async{
     File file;
     String fileName = "";
     String url, filePath;
     ScreenUtil.init(context, height: StaticStrings.screenHeight, width: StaticStrings.screenWidth, allowFontScaling: true);
     try{
       await showDialog(
           context: context,
           builder: (BuildContext context) {
             bool loading = false;
             return StatefulBuilder(
                 builder: (context, setState) { return SimpleDialog(
                   //title: Container( alignment: Alignment.center,child: Text("Seleccionar una foto", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(22),),)),
                   children: <Widget>[
                     Container(
                       height: 140.h,
                       child: loading? CircularLoading() : Column( mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: <Widget>[
                           GestureDetector(
                             onTap: ()async{
                               PickedFile f = await ImagePicker().getImage(source: ImageSource.camera);
                               if(f != null){
                                 setState((){
                                   loading = true;
                                 });
                                 filePath = f.path;
                                 file = File(filePath);
                                 fileName = path.basename(filePath);
                                 fileName = fileName.split(".").first + _uuid.v4() + "." + fileName.split(".").last;
                                 print(fileName);
                                 url = await _uploadImage(file, fileName, folder);
                                 print(url);
                                 Navigator.pop(context);
                               }
                             },
                             child: Row(
                               children: <Widget>[
                                 SizedBox(width: 20.w,),
                                 Container(
                                   height: 30.h,
                                   width: 30.w,
                                   child: SvgPicture.asset(
                                     "assets/iconos-camara_3.svg",
                                     color: Colors.lightBlueAccent,
                                   ),
                                 ),
                                 SizedBox(width: 20.w,),
                                 Text("Hacer foto", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(17),),)
                               ],
                             ),
                           ),
                           GestureDetector(
                             onTap: ()async{
                               file = await FilePicker.getFile(type: FileType.image);
                               if(file != null){
                                 setState((){
                                   loading = true;
                                 });
                                 filePath = file.path;
                                 fileName = path.basename(filePath);
                                 fileName = fileName.split(".").first + _uuid.v4() + "." + fileName.split(".").last;
                                 print(fileName);
                                 url = await _uploadImage(file, fileName, folder);
                                 print(url);
                                 Navigator.pop(context);
                               }
                             },
                             child: Row(
                               children: <Widget>[
                                 SizedBox(width: 20.w,),
                                 Container(
                                   height: 30.h,
                                   width: 30.w,
                                   child: SvgPicture.asset(
                                     "assets/iconos-camara_2.svg",
                                     color: Colors.lightBlueAccent,
                                   ),
                                 ),
                                 SizedBox(width: 20.w,),
                                 Text("Seleccionar desde galería", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(17),),)
                               ],
                             ),
                           )
                         ],
                       ),
                     ),
                   ],
                 );}
             );
           }
       );
       if(file == null)
         return null;
       return url;
     }
     catch(e){
       showDialog(
           context: context,
           builder: (BuildContext context) {
             return AlertDialog(
               title: Text('Sorry...'),
               content: Text('Unsupported exception: $e'),
               actions: <Widget>[
                 FlatButton(
                   child: Text('OK'),
                   onPressed: () {
                     Navigator.of(context).pop();
                   },
                 )
               ],
             );
           }
       );
       return "";
     }
   }


   Future<String> _uploadImage(File file, String filename, String folder) async {
     StorageReference storageReference = FirebaseStorage.instance.ref().child("$folder/$filename");
     final StorageUploadTask uploadTask = storageReference.putFile(file);
     final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
     final String url = (await downloadUrl.ref.getDownloadURL());
     return url;
   }


   Future removeFile(String url) async {
     StorageReference storageReference = await FirebaseStorage.instance.getReferenceFromUrl(url);
     storageReference.delete();
     print("removed $url");
   }

    Future<File> uploadNanonets(BuildContext context, String restaurant_id)async {
      File file;
      String fileName = "";
      String url, filePath;
      ScreenUtil.init(context, height: StaticStrings.screenHeight,
          width: StaticStrings.screenWidth,
          allowFontScaling: true);
      try {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              bool loading = false;
              return StatefulBuilder(
                  builder: (context, setState) {
                    return SimpleDialog(
                      //title: Container( alignment: Alignment.center,child: Text("Seleccionar una foto", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(22),),)),
                      children: <Widget>[
                        Container(
                          height: 170.h,
                          child: loading ? CircularLoading() : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[

                              GestureDetector(
                                onTap: () async {
                                  PickedFile f = await ImagePicker().getImage(
                                      source: ImageSource.camera);
                                  if (f != null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    filePath = f.path;
                                    file = File(filePath);
                                    file = await file.rename("/storage/emulated/0/Android/data/com.wt.lookinmeal/files/Pictures/$restaurant_id.jpg");
                                    /*var postUri = Uri.parse(StaticStrings.nanonets);
                                    var request = http.MultipartRequest("POST", postUri);
                                    request.headers.addAll({
                                      //"Authorization":"Basic " + base64.encode(utf8.encode('1Np9aBp8m9j8WCnN6reOjZTpaRD96eF-'))
                                      "Authorization":'1Np9aBp8m9j8WCnN6reOjZTpaRD96eF-'
                                    });
                                    print(request.headers);
                                    request.files.add(http.MultipartFile.fromBytes('files', await file.readAsBytes(), contentType: MediaType('image', 'jpg')));
                                    request.send().then((response) async {
                                      var r = await http.Response.fromStream(response);
                                      print(r.body);
                                    });
                                    */

                                    Navigator.pop(context);
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: 20.w,),
                                    Container(
                                      height: 30.h,
                                      width: 30.w,
                                      child: SvgPicture.asset(
                                        "assets/iconos-camara_3.svg",
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                    SizedBox(width: 20.w,),
                                    Text("Hacer foto", style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(17),),)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  file = await FilePicker.getFile(
                                      type: FileType.image);
                                  if (file != null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    filePath = file.path;
                                    /*fileName = restaurant_id;
                                    Map data = {
                                      "file":file
                                    };
                                    Map header = {
                                      "accept":"multipart/form-data",
                                      'Authorization' : 'Basic ' + ('1Np9aBp8m9j8WCnN6reOjZTpaRD96eF-' + ':')
                                    };
                                    var response = await http.post("${StaticStrings.nanonets}", body: data ,headers: header ,encoding: Encoding.getByName("base64"));
                                    print(response.body);*/
                                    Navigator.pop(context);
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(width: 20.w,),
                                    Container(
                                      height: 30.h,
                                      width: 30.w,
                                      child: SvgPicture.asset(
                                        "assets/iconos-camara_2.svg",
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                    SizedBox(width: 20.w,),
                                    Text("Seleccionar desde galería",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(17),),)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
              );
            }
        );
        if (file == null)
          return null;
        return file;
      }
      catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sorry...'),
                content: Text('Unsupported exception: $e'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
        return null;
      }
    }
}