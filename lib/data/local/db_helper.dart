import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  ///singleton
  DBHelper._();///now constructor is private so no multiple instance cannot be made

    static DBHelper getInstance(){
    return DBHelper._();
  }
  ///table note
  static final String TABLE_NOTE="note";
   static final String COLUMN_NOTE_SNO='s_no';
   static final String COLUMN_NOTE_TITLE='title';
   static final String COLUMN_NOTE_DESCRIPTION='description';

  Database ?myDb;//it is nullable means it can be null

  ///db open(path -> if exits then open else create db)

  Future<Database> getDB()async{//??means if it is null
   // myDb = myDb??await openDB();
  //  return myDb!;

  //  short form of below is in above
    if(myDb!=null){

      return myDb!;
    }
    else{

     myDb=  await openDB();
     return myDb!;
    }

  }
 Future<Database> openDB()async{
  Directory appDir=await getApplicationDocumentsDirectory();

  String dbPath=join(appDir.path,"noteDb.db");

 return await openDatabase(dbPath,onCreate: (db,version){
    ///create all your tables here
    db.execute("Create table $TABLE_NOTE ($COLUMN_NOTE_SNO integer primary key AUTOINCREMENT,$COLUMN_NOTE_TITLE text,$COLUMN_NOTE_DESCRIPTION text)");
    print('table created ducessfulyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
    //we can create many table by doing execute



  },version: 1);///version can be upgraded is schema(strucutre) of table is changed ..not mandatory





  }


///all queries
  ///insertion
Future<bool> addNote({required String mTitle,required String mDesc})async{
    var db= await getDB();
    int rowsEffected=await db.insert(TABLE_NOTE, {//here table id is auto increment
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESCRIPTION:mDesc
    });//values are in key value form
    print("Row inserted : $rowsEffected");
    return rowsEffected>0;
}
///reading data
Future<List<Map<String,dynamic>>> getAllNotes()async{//* (in sql) represents the all column name not row
    var db= await getDB();
   //List<Map<String,dynamic>> mData=await db.query(TABLE_NOTE,columns: [COLUMN_NOTE_TITLE]);//whire retriving//we can put where condition also like column condition here
    List<Map<String,dynamic>> mData=await db.query(TABLE_NOTE);//it represetnt select*from note
  return mData;
}
///update data
Future<bool>  updateNote({ String ?title, String ?desc,required int sno})async{
    var db=await getDB();
    if(title!=""&&desc!=""){
    int rowEffected=await db.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE:title,
    COLUMN_NOTE_DESCRIPTION:desc

    },where: "$COLUMN_NOTE_SNO=$sno");
   return rowEffected>0;
    }
    return false;


}
///delete
Future<bool> deleteNote({required int sno})async{
    var db=await getDB();
    int rowsEffected = await db.delete(TABLE_NOTE,where: "$COLUMN_NOTE_SNO= ?",whereArgs: ['$sno']);
    return rowsEffected>0;

}




}