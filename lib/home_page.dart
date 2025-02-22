import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_database/data/local/db_helper.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String,dynamic>>allnotes=[];
  DBHelper ?dbRef;
  TextEditingController titleController=TextEditingController();
  TextEditingController descController=TextEditingController();
  @override
  void initState() {

    super.initState();//it will run for first time before any func while opening app and then donot run and cannot be async
    dbRef=DBHelper.getInstance();
    getNotes();
    print(allnotes.toString());


  }
  void getNotes()async{
    allnotes=await dbRef!.getAllNotes();
    setState(() {

    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(


        title: Text('Notes'),

      ),
      //all notes will visible here
      body:allnotes.isNotEmpty? ListView.builder(itemBuilder: (context,index){
        return ListTile(
          leading: Text(allnotes[index][DBHelper.COLUMN_NOTE_SNO].toString()),
          title: Text(allnotes[index][DBHelper.COLUMN_NOTE_TITLE]),
          subtitle: Text(allnotes[index][DBHelper.COLUMN_NOTE_DESCRIPTION]),
          trailing: SizedBox(
            width: 60,
            child: Row(
              children: [
                InkWell(
                    onTap: (){ showModalBottomSheet(context: context, builder: (context)
                    {
                      titleController.text = allnotes[index][DBHelper
                          .COLUMN_NOTE_TITLE]; //,text is right side then it  set the controller
                      descController.text = allnotes[index][DBHelper
                          .COLUMN_NOTE_DESCRIPTION]; //if text is left side then it get value
                      return getBottomSheetView(
                          '', false, allnotes[index][DBHelper
                          .COLUMN_NOTE_SNO]);
                    },scrollControlDisabledMaxHeightRatio: 0.81); },
                    child: Icon(Icons.edit,color: Colors.green,)),
                SizedBox(width: 4,),
                InkWell(child: Icon(Icons.delete,

                  color: Colors.red,),
                onTap: ()async{
                 bool check=await dbRef!.deleteNote(sno: allnotes[index][DBHelper.COLUMN_NOTE_SNO]);
                 if(check){
                   getNotes();
                 }
                },)
              ],
            ),
          ),
        );

      },itemCount: allnotes.length,

      ):Center(
        child: Text("No Notes Yet!!"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{
        String errorMessage='';
        //note to be added from here
       // bool check=await dbRef!.addNote(mTitle: 'New Note 1', mDesc: 'Do what your love or love what you do');
       // if(check){
       //  getNotes();
       // }
        showModalBottomSheet(context: context, builder: (context){
          titleController.clear();
          descController.clear();
          return getBottomSheetView(errorMessage,true,0) ;

        },scrollControlDisabledMaxHeightRatio: 0.81);

      },child: Icon(Icons.add),),

    );
  }
  Widget getBottomSheetView(String errorMessage,bool condition,int sno){
    return Container(
      padding: EdgeInsets.all(11),
      width: double.infinity,
      child: Column(
        children: [
          Text(condition?"Add Note":"Edit Note",style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 21,)
          ,
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                label: Text('Title *'),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                )
            ),
          ),

          SizedBox(height: 21,),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: InputDecoration(
                label: Text('Description *'),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                )
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: ()async{
                var myyTitle=titleController.text.toString();
                var myyDesc=descController.text.toString();
                if(myyTitle.isNotEmpty&&myyDesc.isNotEmpty){
                  bool check= condition?await dbRef!.addNote(mTitle: myyTitle, mDesc: myyDesc):await dbRef!.updateNote(sno:sno,title: myyTitle,desc: myyDesc );
                  if(check){
                    getNotes();
                  }


                }
                else{
                  errorMessage='please fill all the fields';
                  setState(() {

                  });
                }
                titleController.clear();
                descController.clear();
                Navigator.pop(context);

              },
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 3
                          )
                      )
                  ),
                  child: Text( condition?'Add Note':'Update Note'))),
              SizedBox(width: 20,),

              Expanded(
                child: OutlinedButton(onPressed: (){
                  Navigator.pop(context);



                },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 3
                            )
                        )
                    ),
                    child: Text('Cancel')),

              )

            ],
          ),
          Text('$errorMessage')
        ],
      ),

    );
  }
}