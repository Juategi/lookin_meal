import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class StorageService{
   final _uuid = Uuid();

  Future<String> uploadImage(BuildContext context, String folder) async{
    File file;
    String fileName = "";
    String url;
    try{
      file = await FilePicker.getFile(type: FileType.image);
      if(file == null)
        return null;
      fileName = path.basename(file.path);
      fileName = fileName.split(".").first + _uuid.v4() + "." + fileName.split(".").last;
      print(fileName);
      url = await _uploadImage(file, fileName, folder);
      print(url);
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
  }

}