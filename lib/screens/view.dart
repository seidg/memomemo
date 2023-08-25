import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/screens/edit.dart';
import 'package:memomemo/screens/home.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key,required this.id}) : super(key: key);

  final String id;

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  late BuildContext _context;
  String deleteId = ' ';

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => MyHomePage(title: '',)),(route)=>false);
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
                onPressed: (){
                  deleteId = widget.id;
                  showAlertDialog(context);
                },
                icon: const Icon(Icons.delete)
            ),
            IconButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => EditPage(id: widget.id,)));
                },
                icon: const Icon(Icons.edit)
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: LoadBuilder(),
        )
    );
  }
  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper(); //db.dart안에 들어있는 클래스
    return await sd.findMemo(id);
  }

  Future<void> Delmemo(String id) async {
    DBHelper sd = DBHelper(); //db.dart안에 들어있는 클래스
    await sd.deleteMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 경고'),
          content: Text("정말 삭제하시겠습니까?\n삭제된 메모는 복구되지 않습니다."),
          actions: <Widget>[
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.pop(context, "삭제");
                setState(() {
                  Delmemo(deleteId);
                });
                deleteId = '';
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => MyHomePage(title: '',)),(route)=>false);
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                deleteId = '';
                Navigator.pop(context, "취소");
              },
            ),
          ],
        );
      },
    );
  }

  Widget LoadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context,AsyncSnapshot<List<Memo>> snapshot){
        print(snapshot.data?.isEmpty ?? true);
        if (snapshot.data?.isEmpty ?? true) {
          print("데이터가 비어있습니다.");
          return Container(
            alignment: Alignment.center,
            child: Text("데이터를 불러올 수 없습니다."),
          );
        }
        else{
          Memo memo = snapshot.data![0];
          print("데이터가 있습니다.");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 100,
                child: SingleChildScrollView(
                  child: Text(memo.title, style: TextStyle(fontSize: 30,
                      fontWeight: FontWeight.w500),),
                ),
              ),
              Text("메모 만든 시간 : "+memo.createTime.split('.')[0], style: TextStyle(fontSize: 11,),textAlign: TextAlign.end,),
              Text("메모 수정 시간 : "+memo.editTime.split('.')[0], style: TextStyle(fontSize: 11,),textAlign: TextAlign.end,),
              Padding(padding: EdgeInsets.all(10)),
              Expanded(child:SingleChildScrollView(child: Text(memo.text),)),
            ],
          );
        }
      },
    );
  }
}


/*class ViewPage extends StatelessWidget {
  const ViewPage({Key? key,required this.id}) : super(key: key);

  final String id;
  //findMemo(id)[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.delete)
            ),
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.edit)
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: LoadBuilder(),
        )
    );
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper(); //db.dart안에 들어있는 클래스
    return await sd.findMemo(id);
  }

  Widget LoadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(id),
      builder: (BuildContext context,AsyncSnapshot<List<Memo>> snapshot){
        if (snapshot.data?.isEmpty ?? true) {
          print("0");
          return Container(
            alignment: Alignment.center,
            child: Text("데이터를 불러올 수 없습니다."),
          );
        } else{
          Memo memo = snapshot.data![0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 100,
                child: SingleChildScrollView(
                  child: Text(memo.title, style: TextStyle(fontSize: 30,
                      fontWeight: FontWeight.w500),),
                ),
              ),
              Text("메모 만든 시간 : "+memo.createTime.split('.')[0], style: TextStyle(fontSize: 11,),textAlign: TextAlign.end,),
              Text("메모 수정 시간 : "+memo.editTime.split('.')[0], style: TextStyle(fontSize: 11,),textAlign: TextAlign.end,),
              Padding(padding: EdgeInsets.all(10)),
              Expanded(child:SingleChildScrollView(child: Text(memo.text),)),
            ],
          );
        }
      },
    );
  }


} */
