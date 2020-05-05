import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class StorageService{

  Future<String> profileImagePicker(BuildContext context) async{
    File file;
    String fileName = "";
    String url;
    try{
      file = await FilePicker.getFile(type: FileType.image);
      if(file == null)
        return null;
      fileName = path.basename(file.path);
      print(fileName);
      url = await _uploadProfileImage(file, fileName);
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

  Future<String> _uploadProfileImage(File file, String filename) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  Future<String> entryImagePicker(BuildContext context) async{
    File file;
    String fileName = "";
    String url;
    try{
      file = await FilePicker.getFile(type: FileType.image);
      if(file == null)
        return null;
      fileName = path.basename(file.path);
      print(fileName);
      url = await _uploadEntryImage(file, fileName);
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

  Future<String> _uploadEntryImage(File file, String filename) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child("menus/$filename");
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