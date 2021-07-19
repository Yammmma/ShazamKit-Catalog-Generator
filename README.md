# ShazamKit Catalog/Signature Generator
###### A helper tool to make generating custom ShazamKit catalogs/signatures easier by Yuma Soerianto.

This ShazamKit tool is an easier way of generating ShazamKit *.shazamcatalog* or *.shazamsignature* files. I made this for a YouTube tutorial on ShazamKit (you can watch it [here](https://www.youtube.com/watch?v=XMnH1vVzqWU)), however this is available for anyone to use.

*Note: This app may have a few bugs, however I am working towards polishing this app and releasing it on the App Store. In the meantime, I will be updating this repository.*



## How to use:
The tool is extremely easy to use! You will need Xcode 13 Beta and MacOS 12 Monterey (or later) to compile and run the .xcproject.

### Selecting files

![File Selection Screen](/image/fileselection.png)

Click the *add files* button on the bottom-left corner to add some audio files. If you would like to remove any files, just select the desired files on the list and press the *delete (-)* button.
Once you are ready to generate the catalog, simply click "Generate catalog".

### Testing and saving the catalog/signatures

![Catalog Generated Screen](/image/catalogGenerated.png)

Once the catalog along with its signatures have been generated, you can use the *Test Catalog* button to test the catalog (this requires microphone access). If it recognises an audio signature, the file's name will be displayed on the bottom of the window.

Finally, you can click the *Save Signatures* and *Save Catalog* buttons to either save the signatures or catalog!

### Known bugs/issues
* Testing the catalog without adding any audio files will cause it to crash.
* *Generating Catalog...* progress text does not update.



## Support Me!
Any support would help me out, so here's some links if you want to help me.

[Website](http://madebyyuma.com)

[Donate on Ko-Fi](https://ko-fi.com/anyonecancode)

[YouTube](https://youtube.com/c/AnyoneCanCode)

Thanks for using the ShazamKit Catalog/Signature Generator!
