# How to start your mod

make a folder and make a file in it called *modData.xml*
modData.xml is the base of your mod basialy what loads your mod
in modData.xml put this and edit it

```
<!DOCTYPE test-engine-modData>
<mod titleBarName="Friday Night Funkin' - Test Engine - Mod Name Here" charXmlPaths="Chars here">
	<week name="Week Name Here" image="Week Image Here" songs="Week Songs Here" songPaths="Song Paths Here" icons="Icons Here" diffs="Difficultys Here">
		<char path="campaign_menu_UI_characters" idle="Dad" xOffset="20" yOffset="100" scale="0.5"/>
		<char default="gf"/>
		<char default="bf"/>
	</week>
</mod>
```

ok now that you have put this in your mod you can use https://github.com/504brandon/Test-Engine-V1---FNF/blob/master/example_mods/random%20example%20mod/modData.xml to assist you

# Makeing a song

ok now that you have made your mod heres how to make a song
first you need yo go too your mod and make two folders named *songs* and *data*
now that you have made those folders you need to go in those folders and make a folder thats named your song so for example i am porting isotope i would make a folder at data/isotope and songs/isotope and now you need to put your song and song chart in there for your song you need to put the oggs in songs/isotope and for the songs chart put your jsons in data/isotope *keep in mind make isotope your song name i am useing isotope as a example here* now you need to go in your modData.xml and replace Week Songs and Song Paths with your paths for example my modData.hx will look like `<week name="You have taken everything from me" image="idk" songs="Isotope" songPaths="Isotope" icons="dad" diffs="Hard">`
and your done your song should work

# Makeing a stage

ok now that you have made your song lets make a stage go to your mod and make a folder called stages and make a file in your stages called whatever you want and replace *.txt* with *.hx*
ok now that you did that you can put function create(){} this is where you will put moast of your code for your stage
now go to your songs jsons and make a new var called *"stage":"stage"* and now make a image in your stage to make a image in your stake you can put for example `var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Files.image('stageback')); add(bg);` this will make a image.