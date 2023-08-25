import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/screens/view.dart';
import '../database/memo.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key,required this.id}) : super(key: key);
  final String id;
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late BuildContext _context;

  String title = '';
  String text = '';
  String createTime = '';
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: (){
                setState(() {
                  updateDB();
                });
              },
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: loadBuilder()
        )
    );
  }
  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  loadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        if (snapshot.data?.isEmpty ?? true) {
          return Container(child: Text("데이터를 불러올 수 없습니다."));
        } else {
          Memo memo = snapshot.data![0];

          var tecTitle = TextEditingController();
          title = memo.title;
          tecTitle.text = title;

          var tecText = TextEditingController();
          text = memo.text;
          tecText.text = text;

          createTime = memo.createTime;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: tecTitle,
                maxLines: 2,
                onChanged: (String title) {
                  this.title = title;
                },
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                //obscureText: true,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 제목을 적어주세요.',
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              TextField(
                controller: tecText,
                maxLines: 8,
                onChanged: (String text) {
                  this.text = text;
                },
                //obscureText: true,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 내용을 적어주세요.',
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void updateDB() {
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: widget.id,
      title: this.title,
      text: this.text,
      createTime: this.createTime,
      editTime: DateTime.now().toString(),
    );

    sd.updateMemo(fido);
    Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => ViewPage(id: widget.id,)));
  }
}


/* class EditPage extends StatelessWidget {
  String title = '';
  String text = '';
  @override
  Widget build(BuildContext context) {
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

  }

  String Str2sha512(String text){
    var bytes = utf8.encode(text);
    var digest = sha512.convert(bytes);
    return digest.toString();
  }
} */
