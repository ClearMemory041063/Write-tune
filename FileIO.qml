import MuseScore 1.0
import QtQuick 2.1
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.0
import FileIO 1.0


MuseScore {
 menuPath: "Plugins.FileIO"
 version: "2.0"
 description: qsTr("This plugin tests FileIO.") 

ApplicationWindow {
 id:window
 flags:  Qt.Window |Qt.WindowStaysOnTopHint
 //|Qt.WindowTitleHint 
 visible: true
 width: 640
 height: 480
 title: qsTr("Demo App")
/////////////
 FileIO {
  id: readFile
  onError: console.log(msg + "  Filename = " + myFile.source)
 }//end FileIO

 FileDialog {
  id: fopenDialog
  title: qsTr("Please choose a file")
  onAccepted: {
   var filename = fopenDialog.fileUrl
   console.log("fn= ",filename);
   if(filename){
    readFile.source = filename;
    //read file and put it in the TextArea
    textEdit.text = readFile.read();
   }//end if filename
  }//end onAccepted
 }//end openFileDialog
 
 FileIO {
  id: savFile
  onError: console.log(msg + "  Filename = " + savFile.source)
 }//end FileIO


 FileDialog {
  id: saveFileDialog
  selectExisting: false
  nameFilters: ["Text files (*.txt)", "All files (*)"]
  onAccepted: {
var filename="C:/Users/jj/Documents/MuseScore2/Plugins/saved/test.txt";
console.log(filename)

   filename = saveFileDialog.fileUrl;
filename= filename.toString().replace("file://", "").replace(/^\/(.:\/)(.*)$/, "$1$2");
console.log(filename)

    console.log(filename);
   if(filename){
     savFile.source = filename;
     console.log( savFile.write("HelloJello"));
   }//end if filename
  }//end onAccepted
 }//end FileDialog


///////////////
 menuBar: MenuBar {
  Menu {
  title: qsTr("File")
   MenuItem {
    text: qsTr("&Open")
    onTriggered: fopenDialog.open()
   }//end Open
   MenuItem {
    text: qsTr("&Save")
    onTriggered: saveFileDialog.open()
   }//end Save
   MenuItem {
    text: qsTr("Exit")
    onTriggered: {window.close(); Qt.quit();}
   }//end Exit
   MenuItem {
    text: qsTr("Hide")
    onTriggered: {
     textEdit.visible=false;
     textEdit1.visible=true;
    }
   }//end Hide
   MenuItem {
    text: qsTr("Show")
    onTriggered: {
     textEdit.visible=true;
     textEdit1.visible=false;
    }
   }//end Hide
 }// end File menu
 }//end menuBar

 TextArea {
  id: textEdit
  anchors.fill: parent
  text: "Hello";
 }//end textEdit

 TextArea {
  id: textEdit1
  visible:false
  anchors.fill: parent
  text: "There";
 }//end textEdit1


}//end application window

/////////////////////////////////////////

}//end Musescore
// Source for this code
// https://stackoverflow.com/questions/17882518/reading-and-writing-files-in-qml-qt