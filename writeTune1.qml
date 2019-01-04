//AwriteTuneXa.qml
// 4 Jan 2019
// Copyright (C) 2019 Joe McCarty

import QtQuick 2.1
import QtQuick.Controls 1.0
import MuseScore 1.0
import FileIO 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1

MuseScore {
 menuPath: "Plugins.writeTune1"
 version: "2.0"
 description: qsTr("This plugin exports from a Score to 
text in a file.") 
ApplicationWindow{
 id:window
 flags:  Qt.Window |Qt.WindowStaysOnTopHint|Qt.WindowTitleHint 
 visible: true
 width:  500; height: 500;
////
 menuBar: MenuBar {
  id:menubar1
  Menu {
   title: "File"
   MenuItem { text: "Open..." 
    onTriggered: {
     fileDialog.open();
    }
   }//end Open
   MenuItem { text: "Save As..." 
    onTriggered: {
     saveFileDialog.open();
    }

   }//end SaveAs
   MenuItem { text: "Close"
    onTriggered: {window.close(); Qt.quit();}
   }//end close
  }//end file menu
  Menu {
   title: "Edit"
   MenuItem { text: "Copy..." 
    onTriggered: {
    if (typeof curScore === 'undefined')  return;
     findSegment(0,0); //(voice,staff)
     copyFromSelection(ta0);//.text);
     findSegment(0,0); //(voice,staff)
   }
   }//end Copy
   MenuItem { text: "Paste..." 
    onTriggered: {
     findSegment(0,0); //(voice,staff)
     pasteit(ta0.text,0);
     findSegment(0,0); //(voice,staff)
    }
   }//end Paste
   MenuItem { text: "Paste Reverse..." 
    onTriggered: {
     findSegment(0,0); //(voice,staff)
     pasteit(ta0.text,1);
     findSegment(0,0); //(voice,staff)
    }
   }//end Paste Reverse
   MenuItem { text: "Paste Half Time..." 
    onTriggered: {
     findSegment(0,0); //(voice,staff)
     pastehalf(ta0.text,1,2);
     findSegment(0,0); //(voice,staff)
    }
   }//end PasteHalf
   MenuItem { text: "Paste Double Time..." 
    onTriggered: {
     findSegment(0,0); //(voice,staff)
     pastehalf(ta0.text,2,1);
     findSegment(0,0); //(voice,staff)
   }
   }//end PasteDouble
   MenuItem { text: "Invert tune..." 
    onTriggered: {
     findSegment(0,0); //(voice,staff)
     showPage1();
     findSegment(0,0); //(voice,staff)
    }
   }//end invert
  }//end Edit Menu
  Menu {
   title: "Edit2"
   MenuItem { text: "Chords,Notes, Rests..." 
    onTriggered: {
     showPage2();
     findSegment(0,0); 
    }
   }//end chords,notes,rests
   MenuItem { text: "Scales..." 
    onTriggered: {
     findSegment(0,0); 
     showPage3();
    }
   }//end scales
  }//end edit2
  Menu {
   title: "Knit"
   MenuItem { text: "Knit Chords,Notes, Rests..." 
    onTriggered: {
     showPage4();
     findSegment(0,0); 
    }
   }//end chords,notes,rests
   MenuItem { text: "Knit Tunes..." 
    onTriggered: {
     showPage5();
     findSegment(0,0); 
    }
   }//tunes
  }//end knit
 }//end Menu bar

 FileIO {
  id: myFile
  onError: console.log(msg + "  Filename = " + myFile.source)
 }//end FileIO

 FileDialog {
  id: fileDialog
  title: qsTr("Please choose a file")
  onAccepted: {
   var filename = fileDialog.fileUrl
   console.log("fn= ",filename);
   if(filename){
    myFile.source = filename;
    //read file and put it in the TextArea
    ta0.text = myFile.read();
   }//end if filename
  }//end onAccepted
 }//end FileDialog
 
  FileIO {
  id: savFile
  source: tempPath() + "/my_file.xml"
  //      onError: console.log(msg)
  onError: console.log(msg + "  Filename = " + savFile.source)
 }//end FileIO

    FileDialog {
        id: saveFileDialog
        selectExisting: false
        nameFilters: ["Text files (*.txt)", "All files (*)"]
  onAccepted: {
   var filename = saveFileDialog.fileUrl;
filename= filename.toString().replace("file://", "").replace(/^\/(.:\/)(.*)$/, "$1$2");
console.log(filename)
    console.log(filename);
   if(filename){
     savFile.source = filename;
     console.log( savFile.write(ta0.text));
   }//end if filename
  }//end onAccepted
 }//end FileDialog

////
Rectangle {
 id:rect0
 visible:true
 color: "lightgrey"
 anchors.top:menubar1.bottom
 anchors.left: window.left
 anchors.right:window.right
 anchors.bottom: window.bottom
////
 Column {
  width:window.width
  spacing:10
  TextArea {
   id:ta0
   visible:true
   anchors.topMargin: 10
   anchors.bottomMargin: 10
   anchors.leftMargin: 10
   anchors.rightMargin: 10
   width:parent.width
   height:150
   wrapMode: TextEdit.WrapAnywhere
   textFormat: TextEdit.PlainText
  }//end TextArea ta0
////
  TextArea {
   id:ta1
   visible:true
   anchors.topMargin: 10
   anchors.bottomMargin: 10
   anchors.leftMargin: 10
   anchors.rightMargin: 10
   width:parent.width
   height:150
   wrapMode: TextEdit.WrapAnywhere
   textFormat: TextEdit.PlainText
  }//end TextArea ta1
////
  GroupBox {
   id:chordtypeGroupbox
   title: "Select Chord Type"
   visible:true
   anchors.leftMargin: 10
   anchors.topMargin: 10
   ComboBox {
    id: chordType
    model: ListModel {
     id: chordTypeList
 ListElement { text : "major"; note: "0, 4, 7";}
 ListElement { text : "minor"; note: "0, 3, 7";}
 ListElement { text : "major7"; note: "0, 4, 7, 11";}
 ListElement { text : "minor7"; note: "0, 3, 7, 10";}
 ListElement { text : "augmented"; note: "0, 4, 8";}
 ListElement { text : "diminished"; note: "0, 3, 6";}
 ListElement { text : "diminished7"; note: "0, 3, 6, 9";}
//
 ListElement { text : "+5"; note: "0, 4, 8";}
 ListElement { text : "1"; note: "0";}
 ListElement { text : "11"; note: "0, 4, 7, 10, 14, 17";}
 ListElement { text : "11+"; note: "0, 4, 7, 10, 14, 18";}
 ListElement { text : "13"; note: "0, 4, 7, 10, 14, 17, 21";}
 ListElement { text : "5"; note: "0, 7";}
 ListElement { text : "6"; note: "0, 4, 7, 9";}
 ListElement { text : "6*9"; note: "0, 4, 7, 9, 14";}
 ListElement { text : "7"; note: "0, 4, 7, 10";}
 ListElement { text : "7+5"; note: "0, 4, 8, 10";}
 ListElement { text : "7+5-9"; note: "0, 4, 8, 10, 13";}
 ListElement { text : "7-10"; note: "0, 4, 7, 10, 15";}
 ListElement { text : "7-11"; note: "0, 4, 7, 10, 16";}
 ListElement { text : "7-13"; note: "0, 4, 7, 10, 20";}
 ListElement { text : "7-5"; note: "0, 4, 6, 10";}
 ListElement { text : "7-9"; note: "0, 4, 7, 10, 13";}
 ListElement { text : "7sus2"; note: "0, 2, 7, 10";}
 ListElement { text : "7sus4"; note: "0, 5, 7, 10";}
 ListElement { text : "9"; note: "0, 4, 7, 10, 14";}
 ListElement { text : "9+5"; note: "0, 10, 13";}
 ListElement { text : "9sus4"; note: "0, 5, 7, 10, 14";}
 ListElement { text : "M"; note: "0, 4, 7";}
 ListElement { text : "M7"; note: "0, 4, 7, 11";}
 ListElement { text : "a"; note: "0, 4, 8";}
 ListElement { text : "add11"; note: "0, 4, 7, 17";}
 ListElement { text : "add13"; note: "0, 4, 7, 21";}
 ListElement { text : "add2"; note: "0, 2, 4, 7";}
 ListElement { text : "add4"; note: "0, 4, 5, 7";}
 ListElement { text : "add9"; note: "0, 4, 7, 14";}
 ListElement { text : "dim"; note: "0, 3, 6";}
 ListElement { text : "dim7"; note: "0, 3, 6, 9";}
 ListElement { text : "dom7"; note: "0, 4, 7, 10";}
 ListElement { text : "halfdim"; note: "0, 3, 6, 10";}
 ListElement { text : "halfdiminished"; note: "0, 3, 6, 10";}
 ListElement { text : "i"; note: "0, 3, 6";}
 ListElement { text : "i7"; note: "0, 3, 6, 9";}
 ListElement { text : "m"; note: "0, 3, 7";}
 ListElement { text : "m+5"; note: "0, 3, 8";}
 ListElement { text : "m11"; note: "0, 3, 7, 10, 14, 17";}
 ListElement { text : "m11+"; note: "0, 3, 7, 10, 14, 18";}
 ListElement { text : "m13"; note: "0, 3, 7, 10, 14, 17, 21";}
 ListElement { text : "m6"; note: "0, 3, 7, 9";}
 ListElement { text : "m6*9"; note: "0, 3, 9, 7, 14";}
 ListElement { text : "m7"; note: "0, 3, 7, 10";}
 ListElement { text : "m7+5"; note: "0, 3, 8, 10";}
 ListElement { text : "m7+5-9"; note: "0, 3, 8, 10, 13";}
 ListElement { text : "m7+9"; note: "0, 3, 7, 10, 14";}
 ListElement { text : "m7-5"; note: "0, 3, 6, 10";}
 ListElement { text : "m7-9"; note: "0, 3, 7, 10, 13";}
 ListElement { text : "m7b5"; note: "0, 3, 6, 10";}
 ListElement { text : "m9"; note: "0, 3, 7, 10, 14";}
 ListElement { text : "m9+5"; note: "0, 10, 14";}
 ListElement { text : "madd11"; note: "0, 3, 7, 17";}
 ListElement { text : "madd13"; note: "0, 3, 7, 21";}
 ListElement { text : "madd2"; note: "0, 2, 3, 7";}
 ListElement { text : "madd4"; note: "0, 3, 5, 7";}
 ListElement { text : "madd9"; note: "0, 3, 7, 14";}
 ListElement { text : "maj"; note: "0, 4, 7";}
 ListElement { text : "maj11"; note: "0, 4, 7, 11, 14, 17";}
 ListElement { text : "maj9"; note: "0, 4, 7, 11, 14";}
 ListElement { text : "min"; note: "0, 3, 7";}
 ListElement { text : "sus2"; note: "0, 2, 7";}
 ListElement { text : "sus4"; note: "0, 5, 7";}
    }//end model
    currentIndex: 0
   }//end combobox
  }//end chordtypeGroupbox
///
  GroupBox {
   id:scaletypeGroupbox
   title: "Select Scale Type"
   visible:true
   anchors.leftMargin: 10
   anchors.topMargin: 10
   ComboBox {
    id: scaleType
    width:100
    model: ListModel {
     id: scaleTypeList
  ListElement { text:" major "; note:" 60,62,64,65,67,69,71,72" ;} 
 ListElement { text:" minor "; note:" 60,62,63,65,67,68,70,72" ;} 
 ListElement { text:" chromatic "; note:" 60,61,62,63,64,65,66,67,68,69,70,71,72" ;} 

///
 ListElement { text:" aeolian "; note:" 60,62,63,65,67,68,70,72" ;} 
 ListElement { text:" ahirbhairav "; note:" 60,61,64,65,67,69,70,72" ;} 
 ListElement { text:" augmented "; note:" 60,63,64,67,68,71,72" ;} 
 ListElement { text:" augmented2 "; note:" 60,61,64,65,68,69,72" ;} 
 ListElement { text:" bartok "; note:" 60,62,64,65,67,68,70,72" ;} 
 ListElement { text:" bhairav "; note:" 60,61,64,65,67,68,71,72" ;} 
 ListElement { text:" blues_major "; note:" 60,62,63,64,67,69,72" ;} 
 ListElement { text:" blues_minor "; note:" 60,63,65,66,67,70,72" ;} 
 ListElement { text:" chinese "; note:" 60,64,66,67,71,72" ;} 
 ListElement { text:" diatonic "; note:" 60,62,64,65,67,69,71,72" ;} 
 ListElement { text:" diminished "; note:" 60,61,63,64,66,67,69,70,72" ;} 
 ListElement { text:" diminished2 "; note:" 60,62,63,65,66,68,69,71,72" ;} 
 ListElement { text:" dorian "; note:" 60,62,63,65,67,69,70,72" ;} 
 ListElement { text:" egyptian "; note:" 60,62,65,67,70,72" ;} 
 ListElement { text:" enigmatic "; note:" 60,61,64,66,68,70,71,72" ;} 
 ListElement { text:" gong "; note:" 60,62,64,67,69,72" ;} 
 ListElement { text:" harmonic_major "; note:" 60,62,64,65,67,68,71,72" ;} 
 ListElement { text:" harmonic_minor "; note:" 60,62,63,65,67,68,71,72" ;} 
 ListElement { text:" hex_aeolian "; note:" 60,63,65,67,68,70,72" ;} 
 ListElement { text:" hex_dorian "; note:" 60,62,63,65,67,70,72" ;} 
 ListElement { text:" hex_major6 "; note:" 60,62,64,65,67,69,72" ;} 
 ListElement { text:" hex_major7 "; note:" 60,62,64,67,69,71,72" ;} 
 ListElement { text:" hex_phrygian "; note:" 60,61,63,65,68,70,72" ;} 
 ListElement { text:" hex_sus "; note:" 60,62,65,67,69,70,72" ;} 
 ListElement { text:" hindu "; note:" 60,62,64,65,67,68,70,72" ;} 
 ListElement { text:" hirajoshi "; note:" 60,62,63,67,68,72" ;} 
 ListElement { text:" hungarian_minor "; note:" 60,62,63,66,67,68,71,72" ;} 
 ListElement { text:" indian "; note:" 60,64,65,67,70,72" ;} 
 ListElement { text:" ionian "; note:" 60,62,64,65,67,69,71,72" ;} 
 ListElement { text:" iwato "; note:" 60,61,65,66,70,72" ;} 
 ListElement { text:" jiao "; note:" 60,63,65,68,70,72" ;} 
 ListElement { text:" kumoi "; note:" 60,62,63,67,69,72" ;} 
 ListElement { text:" leading_whole "; note:" 60,62,64,66,68,70,71,72" ;} 
 ListElement { text:" locrian "; note:" 60,61,63,65,66,68,70,72" ;} 
 ListElement { text:" locrian_major "; note:" 60,62,64,65,66,68,70,72" ;} 
 ListElement { text:" lydian "; note:" 60,62,64,66,67,69,71,72" ;} 
 ListElement { text:" lydian_minor "; note:" 60,62,64,66,67,68,70,72" ;} 
 ListElement { text:" major_pentatonic "; note:" 60,62,64,67,69,72" ;} 
 ListElement { text:" marva "; note:" 60,61,64,66,67,69,71,72" ;} 
 ListElement { text:" melodic_major "; note:" 60,62,64,65,67,68,70,72" ;} 
 ListElement { text:" melodic_minor "; note:" 60,62,63,65,67,69,71,72" ;} 
 ListElement { text:" melodic_minor_asc "; note:" 60,62,63,65,67,69,71,72" ;} 
 ListElement { text:" melodic_minor_desc "; note:" 60,62,63,65,67,68,70,72" ;} 
 ListElement { text:" messiaen1 "; note:" 60,62,64,66,68,70,72" ;} 
 ListElement { text:" messiaen2 "; note:" 60,61,63,64,66,67,69,70,72" ;} 
 ListElement { text:" messiaen3 "; note:" 60,62,63,64,66,67,68,70,71,72" ;} 
 ListElement { text:" messiaen4 "; note:" 60,61,62,65,66,67,68,71,72" ;} 
 ListElement { text:" messiaen5 "; note:" 60,61,65,66,67,71,72" ;} 
 ListElement { text:" messiaen6 "; note:" 60,62,64,65,66,68,70,71,72" ;} 
 ListElement { text:" messiaen7 "; note:" 60,61,62,63,65,66,67,68,69,71,72" ;} 
 ListElement { text:" minor_pentatonic "; note:" 60,63,65,67,70,72" ;} 
 ListElement { text:" mixolydian "; note:" 60,62,64,65,67,69,70,72" ;} 
 ListElement { text:" neapolitan_major "; note:" 60,61,63,65,67,69,71,72" ;} 
 ListElement { text:" neapolitan_minor "; note:" 60,61,63,65,67,68,71,72" ;} 
 ListElement { text:" octatonic "; note:" 60,62,63,65,66,68,69,71,72" ;} 
 ListElement { text:" pelog "; note:" 60,61,63,67,68,72" ;} 
 ListElement { text:" phrygian "; note:" 60,61,63,65,67,68,70,72" ;} 
 ListElement { text:" prometheus "; note:" 60,62,64,66,71,72" ;} 
 ListElement { text:" purvi "; note:" 60,61,64,66,67,68,71,72" ;} 
 ListElement { text:" ritusen "; note:" 60,62,65,67,69,72" ;} 
 ListElement { text:" romanian_minor "; note:" 60,62,63,66,67,69,70,72" ;} 
 ListElement { text:" scriabin "; note:" 60,61,64,67,69,72" ;} 
 ListElement { text:" shang "; note:" 60,62,65,67,70,72" ;} 
 ListElement { text:" spanish "; note:" 60,61,64,65,67,68,70,72" ;} 
 ListElement { text:" super_locrian "; note:" 60,61,63,64,66,68,70,72" ;} 
 ListElement { text:" todi "; note:" 60,61,63,66,67,68,71,72" ;} 
 ListElement { text:" whole "; note:" 60,62,64,66,68,70,72" ;} 
 ListElement { text:" whole_tone "; note:" 60,62,64,66,68,70,72" ;} 
 ListElement { text:" yu "; note:" 60,63,65,67,70,72" ;} 
 ListElement { text:" zhi "; note:" 60,62,65,67,69,72" ;} 
    }//end model
    currentIndex: 0
   }
  }//end scaletype groupbox
////
  GroupBox {
   id:chordinvGroupbox
   title: "Select Chord Inversion"
   visible:true
   anchors.leftMargin: 10
   anchors.topMargin: 10
   Label {
    id:cib3Labela
    anchors.leftMargin: 10
    anchors.topMargin: 10
    text: "Chord Inversion = "
   }//end Label
   Label {
    id:cib3Label
    anchors.left:cib3Labela.right
    anchors.leftMargin: 10
    anchors.topMargin: 10
    text: "0"
   }//end Label
   Button{
    id:ciupButton
    anchors.left:cib3Label.right
    anchors.leftMargin: 10
    anchors.topMargin: 10
    text: qsTranslate("PrefsDialogBase", "Up")
    onClicked: {
     var x=cib3Label.text;
     if(x<8){
      x++;
     }
     cib3Label.text=x;
    }//end on clicked
   }//end upbutton
   Button{
    id:cidownButton
    anchors.left:ciupButton.right
    anchors.leftMargin: 10
    anchors.topMargin: 10
    text: qsTranslate("PrefsDialogBase", "Down")
    onClicked: {
     var x=cib3Label.text;
     if(x>-8){
      x--;        //pitch=pitch-12;//+(gb3Label.text-4)*12;
     }
     cib3Label.text=x;
    }//end on clicked
   }//end downButton
  }//end chordinvGroupbox
///
  GroupBox {
   id:pitchGroupbox
   visible:true
   title: "Enter Note or Chord Pitch"
   anchors.leftMargin: 10
   anchors.topMargin: 10
   Column{   
    GroupBox {
     id:pitchGroupbox1
     visible:true
     title: "Enter Note or Chord Pitch"
     anchors.leftMargin: 10
     anchors.topMargin: 10
     Label {
      id:gb3Labela
      anchors.leftMargin: 10
      anchors.topMargin: 10
      text: "Octave = "
     }//end Label
     Label {
      id:gb3Label
      anchors.left:gb3Labela.right
      anchors.leftMargin: 10
      anchors.topMargin: 10
      text: "4"
     }//end Label
     Button{
      id:upButton
      anchors.left:gb3Label.right
      anchors.leftMargin: 10
      anchors.topMargin: 10
      text: qsTranslate("PrefsDialogBase", "Up")
      onClicked: {
       var x=gb3Label.text;
       if(x<10){
        x++;
        pitch=pitch+12;
       }
       gb3Label.text=x;
       keyboard.title=getnotename(pitch);
      }//end on clicked
     }//end upbutton
     Button{
      id:downButton
      anchors.left:upButton.right
      anchors.leftMargin: 10
      anchors.topMargin: 10
      text: qsTranslate("PrefsDialogBase", "Down")
      onClicked: {
       var x=gb3Label.text;
       if(x>0){
        x--;
        pitch=pitch-12;//+(gb3Label.text-4)*12;
       }
       gb3Label.text=x;
       keyboard.title=getnotename(pitch);
      }//end on clicked
     }//end downButton
    }//end pitchGB1
///
    GroupBox {
     id:keyboard
     title: "60 C4"
     anchors.leftMargin: 10
     anchors.topMargin: 10
     Row{ 
      Button{
       id:cnote
       text: "C"
       onClicked:{setnote(0);}
      }//end button
      Button{
       id:csnote
       text: "C#"
       onClicked:{setnote(1);}
      }//end button
      Button{
       id:dnote
       text: "D"
       onClicked:{setnote(2);}
      }//end button
      Button{
       id:dsnote
       text: "D#"
       onClicked:{setnote(3);}
      }//end button
      Button{
       id:enote
       text: "E"
       onClicked:{setnote(4);}
      }//end button
      Button{
       id:fnote
       text: "F"
       onClicked:{setnote(5);}
      }//end button
      Button{
       id:fsnote
       text: "F#"
       onClicked:{setnote(6);}
      }//end button
      Button{
       id:gnote
       text: "G"
       onClicked:{setnote(7);}
      }//end button
      Button{
       id:gsnote
       text: "G#"
       onClicked:{setnote(8);}
      }//end button
      Button{
       id:anote
       text: "A"
       onClicked:{setnote(9);}
      }//end button
      Button{
       id:asnote
       text: "A#"
       onClicked:{setnote(10);}
      }//end button
      Button{
       id:bnote
       text: "B"
       onClicked:{setnote(11);}
      }//end button
      Button{
       id:c5snote
       text: "C"
       onClicked:{setnote(12);}
      }//end button
     }//end row
    }//end keyboard groupbox
   }//end column
  }//end pitchgb
///
  GroupBox {
   id:durationGroupbox
   visible:true
   title: "Select Note, Chord or Rest Duration"
   anchors.leftMargin: 10
   anchors.topMargin: 10
   Column{
    GroupBox{
     id:durGB
     visible:true
     anchors.leftMargin: 10
     anchors.topMargin: 10
     Row{
      Button{
       id:ndNumupButton
       anchors.leftMargin: 10
       anchors.topMargin: 10
       text: qsTranslate("PrefsDialogBase", "Up")
       onClicked: {
        var x=ndNumLabel.text;
        x++;
        ndNumLabel.text=x;
       }//end on clicked
      }//end upbutton
      Button{
       id:ndNumdownButton
       anchors.leftMargin: 10
       anchors.topMargin: 10
       text: qsTranslate("PrefsDialogBase", "Down")
       onClicked: {
       var x=ndNumLabel.text;
        if(x>1){
         x--;  
        }
        ndNumLabel.text=x;
       }//end on clicked
      }//end downButton
///
      Label {
       id:ndNumLabela
       anchors.leftMargin: 10
       anchors.topMargin: 10
       text: "Note Duration = "
      }//end Label
      Label {
       id:ndNumLabel
       anchors.leftMargin: 10
       anchors.topMargin: 10
       text: "1"
      }//end Label
      Label {
       id:ndNumLabelb
       anchors.leftMargin: 10
       anchors.topMargin: 10
       text: "/"
      }//end Label
      Label {
       id:ndDenLabel
       anchors.leftMargin: 10
       anchors.topMargin: 10
       text: "8"
      }//end Label
      Button{
       id:ndDenupButton
       anchors.leftMargin: 10
       anchors.topMargin: 10
       text: qsTranslate("PrefsDialogBase", "Up")
       onClicked: {
        var x=ndDenLabel.text;
        if(x<32)x=x*2;
        ndDenLabel.text=x;
       }//end on clicked
      }//end upbutton
      Button{
       id:ndDendownButton
       anchors.leftMargin: 10
       anchors.topMargin: 10
       text: qsTranslate("PrefsDialogBase", "Down")
       onClicked: {
        var x=ndDenLabel.text;
        if(x>1)x=x/2;  
        ndDenLabel.text=x;
       }//end on clicked
      }//end downButton
     }//end row
    }//end duroupbox
    GroupBox {
     id:tkeys  
     visible:true
     anchors.leftMargin: 10
     anchors.topMargin: 10
     Row{
      Button{
       id:thirty2
       text: "1/32"
       onClicked:{
        ndDenLabel.text=32;
        ndNumLabel.text=1;
       }
      }//end button
      Button{
       id:sixteenth
       text: "1/16"
       onClicked:{
        ndDenLabel.text=16;
        ndNumLabel.text=1;
       }
      }//end button
      Button{
       id:eighth
       text: "1/8"
       onClicked:{
        ndDenLabel.text=8;
        ndNumLabel.text=1;
       }
      }//end button
      Button{
       id:quarter
       text: "1/4"
       onClicked:{
        ndDenLabel.text=4;
        ndNumLabel.text=1;
       }
      }//end button
      Button{
       id:half
       text: "1/2"
       onClicked:{
        ndDenLabel.text=2;
        ndNumLabel.text=1;
       }
      }//end button
      Button{
       id:whole
       text: "1/1"
       onClicked:{
        ndDenLabel.text=1;
        ndNumLabel.text=1;
       }
      }//end button
     }//end row
    }//end tkeys GB
   }//end Column
  }//end durationb GB
////
  GroupBox {
   id: useOctshiftGB
   visible:true
   title: "Use Octave Shift After Inversion"
   width:parent.width
   Column {
    spacing: 10
    CheckBox {
     id:useOctaveShiftCB
     text: "Use Octave Shift"
     checked: true
    }//end cb
   }//end Column
  }//end useOctshiftGB
////
  GroupBox {
   id:scaledir
   title: "Scale Direction"
   visible:true
   Row {
    ExclusiveGroup { id: scale1Group }
    RadioButton {
     id:scaleup
     text: "Up"
     checked: true
     exclusiveGroup: scale1Group
    }//end radiobutton
    RadioButton {
     id:scaledown
     text: "Down"
     exclusiveGroup: scale1Group
    }//end radiobutton
   }//end Row
  }//end scaledir groupbox
////
  GroupBox {
   id:msSyncGB
   visible:true
   title: "Musecore Selection Sync"
   Row{
    spacing:100
    Button{
     id:syncButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Sync")
     onClicked: {
      findSegment(0,0); 
     }//end on clicked
    }//end syncButton
    Label {
     id:syncLabel
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: "Full Score Selected"
    }//end syncLabel
   }//end row
  }//end msSyncGB
////
  Row{
   GroupBox {
    id:page1contol
    visible:true
    anchors.leftMargin: 10
    anchors.topMargin: 10
    Button {
     id: applyButton
     text: qsTranslate("PrefsDialogBase", "Invert")
     onClicked: {
      invertTune(ta0.text,pitch);//pivot);
    }//end onclicked
   }//end apply button
  }//end page1control
////
  GroupBox {
   id:page2contol
   visible:true
   anchors.leftMargin: 10
   anchors.topMargin: 10
   Row{
    Button{
     id:restButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Rest") 
     onClicked: {
      var sss="-1,Staff,0,Voice,0;";//1,8,60;
      sss+=ndNumLabel.text;
      sss+=",";
      sss+=ndDenLabel.text;
      sss+=",-1;";
      console.log("Rest= ",sss);
      pasteit(sss,0);
      nextNote();
     }//end on clicked
    }//end restButton
    Button{
     id:noteButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Note")
     onClicked: {
      var sss="-1,Staff,0,Voice,0;";//1,8,60;
      sss+=ndNumLabel.text;
      sss+=",";
      sss+=ndDenLabel.text;
      sss+=",";
      sss+=pitch;
      sss+=";";
      pasteit(sss,0);
      nextNote();
     }//end on clicked
    }//end noteButton
    Button{
     id:chordButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Chord")
     onClicked:{
      var i;
      var ichord,chordsx;
      var chords=[];
      var sss;
      chordsx=chordType.model.get(chordType.currentIndex).note;
      chordsx=chordsx.split(",");
      for(i=0;i<chordsx.length;i++)
       chords.push(parseInt(chordsx[i],10));
      ichord=invertChord(chords,cib3Label.text);
      sss="-1,Staff,0,Voice,0;";//1,8,60;
      sss+=ndNumLabel.text;
      sss+=",";
      sss+=ndDenLabel.text;
      for(i=0;i<ichord.length;i++){
       sss+=",";
       sss+=pitch+ichord[i];
      }//next i   
      sss+=";";
      pasteit(sss,0);
      nextNote();
     }//end on clicked
    }//end chordButton
   }//end row
  }//end page2contol groupbox
////
  GroupBox {
   id:page3contol
   visible:true
   anchors.leftMargin: 10
   anchors.topMargin: 10
   Button{
    id:scaleButton
    anchors.leftMargin: 10
    anchors.topMargin: 10
    text: qsTranslate("PrefsDialogBase", "Scales") 
    onClicked: {
     var sss="-1,Staff,0,Voice,0;";//msg header
     var i;
     var scale1,scale2;
     var scale3=[];
     var scale;
     findSegment(0,0); 
     scale1=scaleType.model.get(scaleType.currentIndex).note;
     console.log("Scale= ",scale1);
     scale2=scale1.split(",");
     for(i=0;i<scale2.length;i++)
      scale3.push(parseInt(scale2[i],10));
     scale=scale3;
     if(scaledown.checked)scale=scale3.reverse(); 
     for(i=0;i<scale.length;i++){
      sss+=ndNumLabel.text;
      sss+=",";
      sss+=ndDenLabel.text;
      sss+=",";
      sss+=scale[i]-60+pitch;
      sss+=";";
     }//next i
     sss+=":,";
     pasteit(sss,0);
     nextNote();
   }//end on clicked
  }//end restButton
 }//end page3control groupbox
////
  GroupBox {
   id:page4contol
   visible:true
   anchors.leftMargin: 10
   anchors.topMargin: 10
   Row{
    Button{
     id:krestButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Rest") 
     onClicked: {
      var sss="-1,Staff,0,Voice,0;";//1,8,60;
      sss+=ndNumLabel.text;
      sss+=",";
      sss+=ndDenLabel.text;
      sss+=",-1;";
      console.log("Rest= ",sss);
  kpaste(sss);
 //     pasteit(sss,0);
 //     nextNote();
     }//end on clicked
    }//end restButton
    Button{
     id:knoteButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Note")
     onClicked: {
      var sss="-1,Staff,0,Voice,0;";//1,8,60;
      sss+=ndNumLabel.text;
      sss+=",";
      sss+=ndDenLabel.text;
      sss+=",";
      sss+=pitch;
      sss+=";";
kpaste(sss);
//      pasteit(sss,0);
//      nextNote();
     }//end on clicked
    }//end noteButton
    Button{
     id:kchordButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Chord")
     onClicked:{
      var i;
      var ichord,chordsx;
      var chords=[];
      var sss;
      chordsx=chordType.model.get(chordType.currentIndex).note;
      chordsx=chordsx.split(",");
      for(i=0;i<chordsx.length;i++)
       chords.push(parseInt(chordsx[i],10));
      ichord=invertChord(chords,cib3Label.text);
      sss="-1,Staff,0,Voice,0;";//1,8,60;
      sss+=ndNumLabel.text;
      sss+=",";
      sss+=ndDenLabel.text;
      for(i=0;i<ichord.length;i++){
       sss+=",";
       sss+=pitch+ichord[i];
      }//next i   
      sss+=";";
kpaste(sss);
     // pasteit(sss,0);
     // nextNote();
     }//end on clicked
    }//end chordButton
   }//end row
  }//end page4contol groupbox
////
  GroupBox {
   id:page5contol
   visible:true
   anchors.leftMargin: 10
   anchors.topMargin: 10
   Row{
    Button{
     id:kcopy0tButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Copy 0") 
     onClicked: {
      if (typeof curScore === 'undefined')  return;
      findSegment(0,0); //(voice,staff)
      copyFromSelection(ta0);//.text);
      findSegment(0,0); //(voice,staff)
     }//end on clicked
    }//end kcopy0tButton
    Button{
     id:kcopy1tButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Copy 1") 
     onClicked: {
      if (typeof curScore === 'undefined')  return;
      findSegment(0,0); //(voice,staff)
      copyFromSelection(ta1);//.text);
      findSegment(0,0); //(voice,staff)
     }//end on clicked
    }//end kcopy1tButton
    Button{
     id:ktuneButton
     anchors.leftMargin: 10
     anchors.topMargin: 10
     text: qsTranslate("PrefsDialogBase", "Knit Tunes") 
     onClicked: {
      console.log("Knit tune code goes here");
knittunes();
      findSegment(0,0); //(voice,staff)
     }//end on clicked
    }//end ktuneButton

   }//end row
  }//end page5control
////
 GroupBox {
  id:exitHome
  anchors.leftMargin: 10
  anchors.topMargin: 10
  Row{
   Button{
    id:homeButton
    anchors.leftMargin: 10
    anchors.topMargin: 10
    text: qsTranslate("PrefsDialogBase", "Home")
    onClicked: {
     findSegment(0,0); //(voice,staff)
     showPage0();
    }//end on clicked
   }//end homeButton
   Button{
    id:page2exit
    anchors.leftMargin: 10
    anchors.topMargin: 10
    text: qsTranslate("PrefsDialogBase", "Exit")
    onClicked: {
     window.close(); Qt.quit();
    }//end on clicked
   }//end page2exit
  }//end row
 }//end exitHome groupbox
}//end row
}//end column
}//end rect0
}//end myWindow
/////////////////////////

////////////////////
// Copy all chords/notes/rests from the selection or entire score
// this section leveraged from colornotes.qml
 function copyFromSelection(result) {
var chord,note,i;
    var cursor = curScore.newCursor();
  cursor.rewind(1); // beginning of selection
  var startStaff;
  var endStaff;
  var endTick;
  var fullScore = false;
  var btext=""
  result.text="";  
  if (!cursor.segment) { // no selection
   fullScore = true;
   startStaff = 0; // start with 1st staff
   endStaff = curScore.nstaves - 1; // and end with last
  } else {
   startStaff = cursor.staffIdx;
   cursor.rewind(2); // end of selection
   if (cursor.tick == 0) { 
    // selection includes last measure of score
    endTick = curScore.lastSegment.tick + 1;
   } else {
     endTick = cursor.tick;
   }//end if (cursor.tick == 0) 
   endStaff = cursor.staffIdx;
  }// if (!cursor.segment) 
  console.log(startStaff + " - " + endStaff + " - " + endTick)
  for (var staff = startStaff; staff <= endStaff; staff++) { 
   // each staff
   for (var voice = 0; voice < 4; voice++) { // each voice
    btext+="-1,Staff,"+staff+",Voice,"+voice+";";
    cursor.rewind(1); // start over 
    cursor.voice = voice; // select voice
    cursor.staffIdx = staff; // select staff
    if (fullScore) cursor.rewind(0); // unclear why needed
   while (cursor.segment && (fullScore ||
    cursor.tick < endTick)) {
    // each cursor position in selection
    if (cursor.element){ // only copy chords/notes/rests...
     chord = cursor.element; 
//console.log("Element duration ",chord.duration.numerator,
//chord.duration.denominator);
     btext+=chord.duration.numerator+",";
     btext+=chord.duration.denominator;
     if (cursor.element.type == Element.CHORD){
//console.log("CHORD ");
//      console.log(chord.notes[0].pitch); 
//console.log("len",chord.notes.length);
      for(i=0;i<chord.notes.length;i++){
       btext+=","+chord.notes[i].pitch;
//console.log(chord.notes[i].pitch);
      }//next i
     }//end if CHORD
     if (cursor.element.type == Element.REST){
//console.log("REST");
      btext+=",-1";
     }//end if Rest
     btext+=";";
    }//end if (cursor.element
    cursor.next();
   }//end while
  result.append(btext+":");
  btext="";
  }//next voice
 }//next staff
 result.text+="/n";
}//end function copyFromSelection
///////////////////////////////
////////////////////
// function to create and return a new Note element with given (midi) pitch, tpc1, tpc2 and headtype
 function createNote(pitch, tpc1, tpc2, head){
  var note = newElement(Element.NOTE);
  console.log("pitch= ",pitch);
  note.pitch = pitch;
  var pitch_mod12 = pitch%12; 
  var pitch2tpc=[14,21,16,23,18,13,20,15,22,17,24,19]; //get tpc from pitch... yes there is a logic behind these numbers :-p
  if (tpc1){
   note.tpc1 = tpc1;
   note.tpc2 = tpc2;
  }else{
   note.tpc1 = pitch2tpc[pitch_mod12];
   note.tpc2 = pitch2tpc[pitch_mod12];
  }//endif
  if (head) note.headType = head; 
  else note.headType = NoteHead.HEAD_AUTO;
   console.log("  created note with tpc: ",note.tpc1," ",note.tpc2," pitch: ",note.pitch);
  return note;
 }//end createNote 
////////////////////////////////////////////////////////// 
 function setCursorToTime(cursor, time){
  cursor.rewind(0);
  while (cursor.segment) { 
   var current_time = cursor.tick;
   if(current_time>=time){
    return true;
   }//endif
   cursor.next();
  }//end while
  cursor.rewind(0);
  return false;
 }//end setCursorTo Time
/////////////////////////////////////////////////////////////
// global variables to allow apply to repeat
 property var rflag: false
 property var cursor: 0
 property var cscore: 0 
 property var endTick: 0
 property var startTick: 0
 property var fullScore: false;
 property var startStaff: 0
 property var endStaff: 0

///////////////////////////////////////////
// Apply the given function to all notes in selection
// or, if nothing is selected, in the entire score

 function apply(nt,ichord,staff,voice){
  var slen; 
  var i=0;
  var next_time;
  var chord; 
  var cur_time;
  var rest; 
  cursor.staffIdx = staff; 
  cursor.voice = voice; //voice has to be set after goTo
  if(ichord[0]>-1){
   slen=ichord.length;
   cur_time=cursor.tick;
   //console.log("chord= ",nt,ichord);   
   cursor.setDuration(nt[0],nt[1]);
   cursor.addNote(ichord[0]); //add 1st note
   next_time=cursor.tick;
   setCursorToTime(cursor, cur_time);
    //rewind to this note
    //get the chord created when 1st note was inserted
   chord = cursor.element; 
   for(var i=1; i<ichord.length; i++){
    //add notes to the chord
    chord.add(createNote(ichord[i])); 
   }//next i
   setCursorToTime(cursor, next_time);
  }else{ // add a rest
   // add a note to beep
   cur_time=cursor.tick;
   cursor.setDuration(nt[0],nt[1]);
   cursor.addNote(60); //add 1st note
   next_time=cursor.tick;
   setCursorToTime(cursor, cur_time); //rewind to this note
   //replace note with rest
   rest = newElement(Element.REST);
   rest.durationType = cursor.element.durationType;
   rest.duration = cursor.element.duration;cursor.add(rest);
   cursor.next();
  }//end else
console.log("xxxxxxxxxxxxxx ",cursor.tick,endTick);
  if(cursor.tick<endTick)return 1;
  if(fullScore)return 1;
  return 0;
 }//end apply function
/////////////////////////////////////////////////
function pasteit(tune9,direction){
   var tune1=tune9.split(":");//tune1 is array of tracks
   var tune=tune1[0].split(";"); 
   var nt=[];
   var ichord=[];
   var a,b; 
   var i,j,k,staff,voice;
   var staff1=0;
   var voice1=0;
   var skip=1;
// Loop thru the staffs and voices present in tune1
  for(k=0;k<tune1.length;k++){
console.log("pasteit ",k); 
console.log("startStaff ",startStaff," endStaff ",endStaff);
// if startstaff== endstaff, both 0 staff=0, both 1 staff=1
// start=0 and end=1 or more? 
    setCursorToTime(cursor, startTick); 
    tune=tune1[k].split(";");
    a=tune[0].split(","); //get the staff,voice header
    if(a[0]!= -1){// not the correct info
     return;
    }
    if(direction){//a reverse paste
     var tt=tune.slice(0, tune.length-1);
     tt.push(tune[0]);
     tt=tt.reverse();
//     tt.pop();
     tune=tt;
    }//endif direction
    staff1=a[2];
    if(startStaff == endStaff)staff1=startStaff;
    voice1=a[4];
    skip=1;
    for(i=1;i<tune.length-1;i++){ //tune[0] is track voice info
     a=tune[i].split(",");
     nt=[];
     nt.push(a[0]);nt.push(a[1]);
     ichord=[];
     for(j=2;j<a.length;j++)ichord.push(a[j]);
     if(skip>0){
      cscore.startCmd();
      skip=apply(nt,ichord,staff1,voice1);
      cscore.endCmd();
     }//end if skip
    }//next i
   
   }//next k
}//end pasteit

 function findSegment(voice,staff){
  fullScore = false;
   cscore=curScore;
   //cscore.startCmd();
   cursor = curScore.newCursor();
console.log("ctick ",cursor.tick);
console.log("cStaff ",cursor.staffIdx);
   cursor.rewind(1); //to start of segment
   if (!cursor.segment) { // no selection
    fullScore = true;
    startStaff = 0; // start with 1st staff
    endStaff = curScore.nstaves - 1; // and end with last
    startTick=cursor.tick;
   } else {
    startStaff = cursor.staffIdx;
    startTick=cursor.tick;
    cursor.rewind(2);//end of selection
    if (cursor.tick == 0) {
// this happens when the selection includes
// the last measure of the score.
// rewind(2) goes behind the last segment (where
// there's none) and sets tick=0
     endTick = curScore.lastSegment.tick + 1;
   } else {
    endTick = cursor.tick;
   }//end if cursor.tick
   endStaff = cursor.staffIdx;
  }//end cursor.segment
  console.log(startStaff + " - " + endStaff + " - " + endTick)
  cursor.rewind(1); // sets voice to 0
  cursor.voice = voice; //voice has to be set after goTo
  cursor.staffIdx = staff; 
  if (fullScore)
   cursor.rewind(0);//no selection, beginning of score
  cursor.staffIdx = startStaff; //staff; 
  cursor.voice = voice; //voice has to be set after goTo

console.log("staff ",staff," voice ",voice);
console.log("cursor.tick ",cursor.tick," cursor.staffIdx ",cursor.staffIdx);
console.log("startTick",startTick," endTick ",endTick);
console.log("fullScore ",fullScore); 
 if(fullScore){
  syncLabel.text = "Full Score Selected";
  return;
 }else{
   syncLabel.text = "Start tick= "+startTick+" End Tick= "+endTick;
  }//end else
 }//end findSegemnt

/////////////////
 onRun: {
  //adjust horizontal position of plugin window
  window.x=window.x * 2.0-50;//-250;
  showPage0();
 }//end onRun
//////////////////////////////////////////////
function pastehalf(tune9,num,den){
 var tune="";
 var tune1="";
 var tune2="";
 var tune3;
 var i,j,k,n;
 findSegment(0,0); //(voice,staff)
 tune1=tune9.split(":");
 for(n=0;n<tune1.length;n++){
  tune="";
  tune2=tune1[n].split(";");
  for(i=0;i<tune2[0].length;i++)tune+=tune2[0][i];
  tune+=";";
  //console.log("xxx ",tune," xxx");
  for(j=1;j<tune2.length-1;j++){
   tune3=tune2[j].split(","); 
   tune+=num*tune3[0];
   tune+=",";
   tune+=den*tune3[1];
   for(k=2;k<tune3.length;k++)tune+=","+tune3[k];
   tune+=";";
  }//next i
  tune+-":/n";
  //console.log(tune);
  pasteit(tune,0); 
 }//next n 
}//end pastehalf
//////////////////////////////////////////////
function invertTune(tune9,pivot){
 var tune="";
 var tune1="";
 var tune2="";
 var tune3=[];
 var tstaff;
 var i,j,k,n,f;
 var shift=0;
 findSegment(0,0); //(voice,staff)
 tune1=tune9.split(":");
 for(n=0;n<tune1.length;n++){
  tune="";
  tune2=tune1[n].split(";");//into items
  console.log("tune1[n] ",tune1[n]);
  //copy first item staff voice info
  tune+=tune2[0];
  tune+=";";
  if(useOctaveShiftCB.checked){
   tstaff=tune2[0].split(",");
//   console.log("tstaff= ",tstaff);   
   if(tstaff[2]==0)shift=12;
   if(tstaff[2]==1)shift=-12;
//   console.log(tstaff[2],shift,"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
  }//endif
  for(i=1;i<tune2.length-1;i++){
  console.log("tune2[i] ",tune2[i]);
   tune3=tune2[i].split(",");
   tune+=tune3[0];//numerator
   tune+=",";
   tune+=tune3[1];//numerator
//   tune+=",";
  console.log("xxx ",tune3," xxx");
   for(j=2;j<tune3.length;j++){
    tune+=",";
    if(tune3[j]<0){
     tune+=tune3[j];
    }else{
console.log("ttt ",pivot,tune3[j],2*pivot-tune3[j]+shift);
     tune+= 2*pivot-tune3[j]+shift; 
    }//end if else  
   }//next j 
   tune+=";";
  }//next i
  tune+=":/n";
  console.log(tune);
  pasteit(tune,0); 
 }//next n 
}//end invertTune
///////////////////////////////////
/////////////////////////////////////////
 property var pitch:60
 function setnote(n){
  pitch=n+60+(gb3Label.text-4)*12;
  keyboard.title=getnotename(pitch);
 }
 ////
//// 

  function copyarray(a){
   var b=[];
   for(var i=0;i<a.length;i++) b.push(a[i]);
   return b;
  }//end copyarray

  function invertChord(a,n){
   var b=[];
   var i;
   var c;
   var d=[];
   if (n>=0){
    b=copyarray(a);
    i=0;
    while (i<n){
      c=b[0];
      b=b.slice(1,b.length);
      b.push(c+12);
      i+=1;
    }//end while
    return b;
   }//end if
   n=-n;
   b=copyarray(a);
   i=0;
   while (i<n){
    c=b.pop();
    d=[];
    d.push(c-12);
for(var j=0;j<b.length;j++) d.push(b[j]);
    b=copyarray(d)//d.flatten;
    i+=1;
   }//end while
   return b;
  }//end invertChord
function nextNote(){
 if(cscore)cscore.startCmd();
 if(cursor){
//  cursor.next();
  startTick=cursor.tick;
 } 
 if(cscore) cscore.endCmd();
}//end
 property var  notename:"C,C#/Db,D,D#/Eb,E,F,F#/Gb,G,G#/Ab,A,A#/Bb,B"
 function getnotename(n){
  var sss="";
  var notename1=notename.split(",");
  sss+= n;
  sss+= " ";
  sss+= notename1[n%12];
  sss+= " ";
  sss+= (n-(n%12))/12-1;
  return sss
 }//end getnotename
////
////
 function kpaste(sss){
  var tune1=ta0.text.split(":");//tune1 is array of tracks
  var tune=tune1[0].split(";");
  var tune2="" 
  var i;
  for(i=1;i<tune.length-1;i++){
   tune2="-1,Staff,0,Voice,0;"+tune[i]+";";
   pasteit(tune2,0);
   nextNote();
   pasteit(sss,0);
   nextNote();
  }//next i
 }//end kpaste
 
 function showPage0(){
  hideall();
  ta0.visible=true;
  ta0.height=350;//200;
 }//end showPage0
////
 function showPage1(){
  hideall();
  page1contol.visible=true;
  pitchGroupbox.visible=true;
  useOctshiftGB.visible=true;
 }//end showpage1
//// 
 function showPage2(){
  hideall();
  page2contol.visible=true;
  chordtypeGroupbox.visible=true;
  chordinvGroupbox.visible=true;
  pitchGroupbox.visible=true;
  durationGroupbox.visible=true;
  tkeys.visible=true;
 }//end showpage2
////
 function showPage3(){
  hideall();
  page3contol.visible=true;
  scaletypeGroupbox.visible=true;
  pitchGroupbox.visible=true;
  durationGroupbox.visible=true;
  tkeys.visible=true;
  scaledir.visible=true;
 }//end showpage3
////
 function showPage4(){
  hideall();
  page4contol.visible=true;
  chordtypeGroupbox.visible=true;
  chordinvGroupbox.visible=true;
  pitchGroupbox.visible=true;
  durationGroupbox.visible=true;
  tkeys.visible=true;
 }//end showpage4
////
 function showPage5(){
  hideall();
  ta0.visible=true;
  ta0.height=200;
  ta1.visible=true;
  page5contol.visible=true;
 }//end showPage5
////
 function hideall(){
  ta0.visible=false;
  ta1.visible=false;
  page1contol.visible=false;
  page2contol.visible=false;
  page3contol.visible=false;
  page4contol.visible=false;
  chordtypeGroupbox.visible=false;
  scaletypeGroupbox.visible=false;
  chordinvGroupbox.visible=false;
  pitchGroupbox.visible=false;
  durationGroupbox.visible=false;
  tkeys.visible=false;
  scaledir.visible=false;
  useOctshiftGB.visible=false;
  page5contol.visible=false;
 }//end hideall
////
function knittunes(){
var atune0=ta0.text.split(":");
var atune1=ta1.text.split(":");
var btune0=atune0[0].split(";");
var btune1=atune1[0].split(";");
var i=1;
var j=1;
var rrr="";
//console.log("knittunes");
//console.log(btune0[0]);
//console.log(btune1[0]);
while(i<btune0.length-1){
  rrr="-1,Staff,0,Voice,0;"+btune0[i]+";";
// console.log(rrr);
   pasteit(rrr,0);
   nextNote();
  rrr="-1,Staff,0,Voice,0;"+btune1[j]+";";
// console.log(rrr);
   pasteit(rrr,0);
   nextNote();
 i++;
 j++;
 if(j>btune1.length-1)return;

}//end while

}//end knittunes

////
}//end Musescore
