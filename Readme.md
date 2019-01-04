## Writetune1.qml (Under construction)
## Adds many functions to MuseScore 2
### Added functions:

1. File import export of duration and pitch information in a text format.

2. Copy from score to a text window

![CopyingSegment.png](https://github.com/ClearMemory041063/Write-tune/blob/master/CopyingSegment.png " ")

3. Paste from text window to score

4. Paste from text window to score and halve the durations of elements.

4. Paste from text window to score and double the durations of elements.

5. Paste from text window the melodic inversion.

![PastingAndInversion.png](https://github.com/ClearMemory041063/Write-tune/blob/master/PastingAndInversion.png " ")

6. Allow the entry of rests, notes and chords into the score.

![InsertRestsNotesChords.png](https://github.com/ClearMemory041063/Write-tune/blob/master/InsertRestsNotesChords.png " ")

7. Create scales in the score

![InsertScales.png](https://github.com/ClearMemory041063/Write-tune/blob/master/InsertScales.png " ")


![DemoScore.pdf](https://github.com/ClearMemory041063/Write-tune/blob/master/DemoScore.pdf " ")

8. Paste Reverse

![PasteReverse.png](https://github.com/ClearMemory041063/Write-tune/blob/master/PasteReverse.png " ")

9. Knit a rest, note or chord into a tune (scale example)
![KnitRestsNotesandChords.png](https://github.com/ClearMemory041063/Write-tune/blob/master/KnitRestsNotesandChords.png " ")

10. Knit Tunes combine two tunes together alternating notes

![KnitTunes.png](https://github.com/ClearMemory041063/Write-tune/blob/master/KnitTunes.png " ")


### Pay attention to the Synchronization field 

This code depends on a selection being made in the score. The synchronization field and the Sync button, allow this plugin to synchronize the insertion point in the score with the selection in Musescore.

Best practice: Use mouse to mark a selection in th4e score, then click on the Sync button in the plugin. 


### Sonic Pi data

The stegtest.rb file contains Sonic Pi code that creates a song using steganography. It has been altered to produce the strings to import the two staffs into MuseScore 2 using this plug in.
The two strings were copied from Sonic Pi and pasted into the file stegtest.txt. This file was opened with the plugin and pasted into an empty score and the score was then titled etc. and saved, and exported into pdf and wav formats.

The playBeethoven.rb is a Sonic Pi program that takes the exported text format and plays the music using Sonic Pi. It uses the file atest.txt. The playbeethoven.rb code will need to be altered to reflect the file path to the atest.txt file.



### Acknowledgements

[MuseScore2-Plugins](https://github.com/pconrad/MuseScore2-Plugins)

[Original-examples](https://github.com/pconrad/MuseScore2-Plugins/tree/master/original-examples)

[Sonic Pi](https://sonic-pi.net/)
