import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/screens/write.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/screens/view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String deleteId ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 20),
            child: Text(
              '모든 노트',
              style: TextStyle(fontSize: 36, color: Colors.blue),
            ),
          ),
          Expanded(child: memoBuilder(context))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => WritePage()),
          );
        },
        tooltip: '노트를 추가하려면 클릭하세요',
        label: Text("메모 추가"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper(); //db.dart안에 들어있는 클래스
    return await sd.memos();
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

  Widget memoBuilder(BuildContext parentcontext) {
    return FutureBuilder(
      builder: (context,AsyncSnapshot? projectSnap) {
        if (projectSnap?.data?.isEmpty ?? true) {
          print("0");
          return Container(
            alignment: Alignment.center,
            child: Text("메모 추가를 눌러서 메모를 추가해보세요!"),
          );
        }
        else{
          print("1");
          return ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          itemCount: projectSnap?.data?.length,
          itemBuilder: (context, index) {
            Memo memo = projectSnap?.data?[index];
            return InkWell(
              onTap: (){
                Navigator.push(parentcontext, CupertinoPageRoute(builder: (parentcontext)=>ViewPage(id:memo.id)));
              }, //클릭했을때 편집기능
              onLongPress: (){
                deleteId = memo.id;
                showAlertDialog(parentcontext);
              }, //길게 눌렀을때 삭제기능
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black,blurRadius: 3)],
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                    width : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(memo.title,
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        ),
                        Text(memo.text,
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(("최종 수정 시간")+memo.editTime.split('.')[0],
                        style: TextStyle(fontSize: 11),textAlign: TextAlign.end,)
                      ],
                    ),
                ],
              )),
            );
          },
        );}
      },
      future: loadMemo(),
    );
  }
}
