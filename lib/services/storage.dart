import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookinmeal/shared/loading.dart';
import 'package:lookinmeal/shared/strings.dart';
import 'package:permission/permission.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'app_localizations.dart';

class StorageService{
   final _uuid = Uuid();
   AppLocalizations tr;
   Future<String> uploadImage(BuildContext context, String folder) async{
     File file;
     String fileName = "";
     String url, filePath;
     try{
       await showDialog(
           context: context,
           builder: (BuildContext context) {
             bool loading = false;
             return StatefulBuilder(
                 builder: (context, setState) {
                   tr = AppLocalizations.of(context);
                   return SimpleDialog(
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
                                 Text(tr.translate("takepic"), style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(17),),)
                               ],
                             ),
                           ),
                           GestureDetector(
                             onTap: ()async{
                               file = File((await FilePicker.platform.pickFiles(type: FileType.image)).files.single.path);
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
                                 Text(tr.translate("fromgallery"), style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: ScreenUtil().setSp(17),),)
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
     Reference storageReference = FirebaseStorage.instance.ref().child("$folder/$filename");
     final UploadTask uploadTask = storageReference.putFile(file);
     final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));
     final String url = (await downloadUrl.ref.getDownloadURL());
     return url;
   }


   Future removeFile(String url) async {
     Reference storageReference = await FirebaseStorage.instance.refFromURL(url);
     storageReference.delete();
     print("removed $url");
   }

    Future<File> uploadNanonets(BuildContext context, String restaurant_id)async {
      File file;
      String fileName = "";
      String url, filePath;
      try {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              bool loading = false;
              return StatefulBuilder(
                  builder: (context, setState) {
                    tr = AppLocalizations.of(context);
                    return SimpleDialog(
                      //title: Container( alignment: Alignment.center,child: Text("Seleccionar una foto", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: ScreenUtil().setSp(22),),)),
                      children: <Widget>[
                        Container(
                          height: 240.h,
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
                                    Text(tr.translate("takepic"), style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(17),),)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  file =  File((await FilePicker.platform.pickFiles(type: FileType.image)).files.single.path);
                                  if (file != null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    filePath = file.path;
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
                                    Text(tr.translate("fromgallery"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(17),),)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  file = File((await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions:['pdf'])).files.single.path);
                                  if (file != null) {
                                    setState(() {
                                      loading = true;
                                    });
                                    filePath = file.path;
                                    //Modo pdf
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
                                    Text(tr.translate("pickpdf"),
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

   Future<bool> sendNanonets(String restaurant_id, String user_id, Uint8List file) async{
     Reference storageReference = FirebaseStorage.instance.ref().child("$restaurant_id-$user_id-");
     final UploadTask uploadTask = storageReference.putData(file);
     final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));
     final String url = (await downloadUrl.ref.getDownloadURL());
     print(url);
     var response = await http.post(Uri.http(StaticStrings.api, "/nanonets"), body: {"restaurant_id": restaurant_id, "user_id": user_id, "file": url});
     print(response.body);
     removeFile(url);
     if(response.body == "OK"){
       return true;
     }
     else
       return false;
   }
}