# Chasing Dreams Code

This code was made in 4 days for a game jam by a very inexperienced programmer. It's not great sometimes! A lot of the time! I also don't wanna refactor literally everything though, so I'm keeping it as is, and just adding more comments.

The first thing that probably jumps out to you is that there is no folder structure! All the files are just thrown about! That's how I usually start projects, and then afterwards I refactor the folder system, but because of some uninteresting bullshit with the Bullets plugin refactoring crashes the whole thing.

# Bullets Plugin Bullshit

This game uses the [Godot Native Bullets Plugin](https://github.com/samdze/godot-native-bullets-plugin). I wanted a pre-packed bullets engine so I didn't have to code my own, and this one really jumped out to me. Its main advantage is that it is very fast, I can have hundreds of bullets and my not-particularly-fast computer still won't lag. Its main disadvantage is that it repearedly crashed the entire project. I assume both of those come with being written in C++.

For the record: it might not be entirely its fault. I did not code this in the native Godot code editor, I did it in VSCode with the Godot Tools extension. And with all due respect to the extreme difficulty of writing language support for a text editor, and knowing that I prefer it over the native Godot editor: that extension is more than a bit janky.

One of the advantages of using it was enjoying VSCode's Git support, and that basically pointed me to what was breaking: every once in a while, for some god forsaken reason, the `bullet_kit.tres` and `non_collision_bullets.tres` files (which contain crucial data on how the bullets work) would just... get wiped out. And left blank. Which would make the game unable to run. Only because of Git's diff view was I able to do that and quickly revert it, avoiding the whole shenaniganry.

I think it was a weird interaction between the janky Godot Tools extension and the "C++"y Native Bullets plugin, but either way, probably have a Version Control System in hand if you're gonna use that plugin!

# Dialogic

The game also uses the [Dialogic](https://github.com/coppolaemilio/dialogic) plugin for dialogues. Nothing too notable here, other than having to manually replace the image for the default dialogue box because of a bug.

Oh yeah, also, if you use this, remember to add `*.json, *.cfg` to "Filters to export non-resource files/folders" on the Resources tab of the export menu - otherwise the game will not export. Also, the dialogue files are not on the base filesystem, like all the other files - honestly, I don't really know where they are? Somewhere in the Dialogic plugin. Point is, use the Dialogic menu to navigate through them.

# Overall Code Philosophy

The code for the enemy bullets is written like a Danmakufu program. And by that I mean, the bullet patterns are mainly programmed with coroutines. A *lot* of coroutines. So many that I visually distinguish their signatures. If a funciton starts with a double underscore (eg. `__function`), it's a coroutine. Take `l3enemy.gd` for example. Its `ready()` function will choose a random pattern (those are the enemy types, every level has enemies that share the same script), and each pattern will yield for a set amount of time, then call a shooting function from the parent `Enemy` class, then yield again. Godot also throws an Error at you if a coroutine of a deleted enemy instance resumes, which means I'd often get hundreds of errors on debug builds. There's probably a better way to do that, safely. That's also why the game crashes on exit, actually.

# Listing every single file

I will not list the png files, because uh. Obvious reasons. Just note: They are all white by default. Colors are added through the modulate components of the Nodes.

- `another_kit.tres` - Leftover. Please ignore. But I think deleting it might break stuff?
- `Atkinson-Hyperlegible-Bold-102.otf` - Font data.
- `bullet_kit.tres` - Bullet kit data for the main bullets, the ones that kill you. See the documentation for the Native Bullets plugin.
- `enemy.gd` - Base Enemy class that is inherited by all enemies. Contains functions for handling the spawning of non-collision bullets, turning them into regular bullets after some time, etc.
- `font_data.tres` - More font data.
- `font.tres` - Leftover, see `true_font.tres`.
- `global.gd` - The main scene reloads every time the player dies. This script and its associated scene are an autoload that manage data that would be lost when the main scene resets - stuff like story progress and the death counter. Also handles saving and loading.
- `l0enemy.gd` - The "tutorial" enemy, that doesn't shoot at you.
- `l1enemy.gd` through `l3enemy.gd` - The regular enemies for N1, N2 and N3 sleep.
- `l4enemy.gd` - The REM Sleep - yeah, it's just implemented as regular enemies without hitboxes, that despawn after firing their pattern once.
- `main.gd` - Script for the main scene - handles enemy spawning, interacting with the Global autoload, and communicating with Dialogic timelines.
- `music.tres` - Music.
- `non-collision_bullets.tres` - The bullet data for bullets in their intangible phase.
- `player.gd` - Player code. Actually not bad.
- `save0.gd` - Please ignore. Remnant of an earlier attempt at a save system.
- `theme.tres` - I only created this so I wouldn't have to manually se the font for each Label.
- `true_font.tres` - The *actual* font data, though you should really just use `theme.tres`
  
# Closing thoughts

I swear most of my projects are better organized than this. It may be a mess, but it stayed this way because I didn't think anyone else would ever look at this code, and because I didn't have time to refactor it. Overall, I... Wouldn't recommend using this repository as a base for the new version. Maybe copy the player code, and some of the coroutines if you want to. Keep in mind this is something that lead to crashes and errors and failures to export - it did all work out in the end! But it's not a great base to build upon.
