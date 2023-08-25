import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/db.dart';
import '../database/memo.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'home.dart';

class WritePage extends StatefulWidget {
  const WritePage({Key? key}) : super(key: key);

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  late BuildContext _context;

  String title = '';
  String text = '';
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.delete)
            ),
            IconButton(
                onPressed: saveDB,
                icon: const Icon(Icons.save)
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                onChanged: (String title){ this.title = title;},
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                decoration: InputDecoration(
                    hintText: '제목을 적어주세요.'
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              TextField(
                onChanged: (String text){ this.text = text;},
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                    hintText: '메모의 내용을 적어주세요'
                ),
              ),
            ],
          ),
        )
    );
  }
  Future<void> saveDB() async {

    DBHelper sd = DBHelper();

    var fido = Memo(
      id: Str2sha512(DateTime.now().toString()),
      title: this.title,
      text: this.text,
      createTime: DateTime.now().toString(),
      editTime: DateTime.now().toString(),
    );

    await sd.insertMemo(fido);

    print(await sd.memos());
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => MyHomePage(title: '',)),(route)=>false);
  }


  String Str2sha512(String text){
    var bytes = utf8.encode(text);
    var digest = sha512.convert(bytes);
    return digest.toString();
  }
}
