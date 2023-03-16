# How to Compile

This is a tutorial on how to compile

first, install [Haxe](https://haxe.org/download/) and then install [HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)

Once your done with all those, run these lines in command prompt/terminal.

```
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
```

TIP: you can just copy all of this and paste it.

Ok this ones complicated so remember this!
Download [git-scm](https://git-scm.com/downloads)
and then run these extra lines in command prompt/terminal

```
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git flixel-leather https://github.com/Leather128/flixel.git
haxelib git scriptless-polymod https://github.com/SrtHero278/scriptless-polymod
haxelib git linc_luajit https://github.com/AndreiRudenko/linc_luajit
haxelib git hscript-improved https://www.github.com/YoshiCrafter29/hscript-improved
haxelib git openfl https://github.com/openfl/openfl
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons
```

Once your done, run these in command prompt/terminal

If you are running debug also run this too if you haven't!

```
haxelib install hxcpp-debug-server
```

## Windows Only

Theres some extra things you need to do to install Windows.

Install [Visual Studio 2019](https://my.visualstudio.com/Downloads?q=visual%20studio%202019&wt.mc_id=o~msft~vscom~older-downloads) and follow the instructions until it asks you to select packages.

Go to individual components and select these

* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)

And your done!

## Compiling the Game

Once you have done all of that run `lime test [platform name]` in the terminal
[platform name] is your platformm your running this on (Windows, Mac, Linux, etc)

Wait a bit then you're done!
It should automatically launch the game for you, if you close it you can just go to export/release/(Platform)/bin/Test Engine.exe/.app/.html/
