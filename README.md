# Pokewars

## Members

**[Justin Frauböse](/Justin.md)**

**[Max Neubauer](/Max.md)**

**[Conrad Ferneding](/Conrad.md)**

**[Evan Fregeais](/Evan.md)**

## Code claims 
| | Justin | Max | Conrad | Evan |
|----|----|----|----|----|
|Map & Tilemap| Touched | All | Touched | Touched | 
|Laboratory| Touched | Touched | All | X |
|Military Buildings| All | Touched | Touched | Touched |
|Optimization| Touched | X | X | All|
|Navigation| Touched | Most | x | Some |
|Pikachu| X | Some | Some | Some |
|Sprites & Animation| Some | Some | Some | Some |
|Character Selection| Touched | Touched | All | Touched | 
|Military Units and battle| X | X | Some | Most | 
|Pokemon Spawner (+spawn rate)| Some | Some | Some | Some | 
|Win/Lose condition | Touched | Half | Some | Some | 
|Sound, Cursor| Some | Some | Some | Some | 
|Camera| X | X | Touched | All|
|GUI| Half | Touched | Half | Touched | 
|Dialogue| X | Touched | All | X |
|Controls & Key binds| Half | X | Half | Touched |
|Inheritance| X | Half | Some | Some |
|Farming | X | X | All | X |
|Bosses| X | Most | Touched | Some|
|Enemies| X | X | Some | Most|

## Video

There were issues with the audio on the recording, hence this video is without audio.

![Gameplay video](Documentation/Group_Video/2023-12-06_13-43-00.mp4)

## Concept

The concept behind the game is a mix between Age of Empires and Pokemon.
The goal of the game is to train Pokemon and defeat the bosses on the edge of the map.

**[Gamedesign](/Gamedesign.md)**

**[Artdesign](/Artdesign.md)**

## Game Engine

We started working with Unity in the begining but due to issues, we decided to switch to Godot.

## Controls
Commands can be executed with right "game mode".
Mode can be switched with:
R -> "Run": handling pokemon
B -> "Build": infrastructure, buildings

### Moving Pikachu:
#### Game Mode: R
 - select with left click (number of selected pikachus is displayed in the ui),
 - move selected pikachus by right clicking on the destination
 - select multiple pikachus by dragging the mouse over the screen while holding left click, they can then be moved all at once
 - deselect all currently selected pikachus by left clicking on "nothing" (somewhere where there is no pikachu).

### Controlling the military:
#### Game Mode: R
Military units can be controlled in the same fashion as pikachus.
If a military unit has "no current task" it will attack the closest enemy.

### Building:
#### Game Mode: B
When pressing B the ui changes and by clicking on the building buttons a building can be selected to be placed with leftclick on an empty place on the map. 
Buildings can also be deleted. 
Remember to press "R" again if you want to control units. 


## Discussion
### Game Engine
Godot is an intuitive and easy to use Gameengine. It provides an easy entry to professional game development.
Since it is an open source platform there are no controversies regarding management and payment. 
And Godot has an extensive inbuild documentation which makes it easy for the developer to understand inbuild functions. It also has excemptional community support to find answeres to most questions. Godot enables good performance through threads and developers can change the programming language. And Godot also has it's own programming language - Godot language - which is syntactically close to Python and hence easy to use. Debugging in Godot is easy because of the remote option to keep track of variable values on runtime.
On the other side Godot has some weaknesses. It does not support referencing variable and file renaming. Errors may occur when renaming files. Another major downside is the lack of inbuild Git support. 
Godot4 came out in early 2023 and came with a lot of functional changes. Henceforth, internet Q&A are outdated. Which makes researching harder. 
This includes AI support from ChatGPT and GitHub copilot.
Putting everything into account, we come to the conclusion that Godot is a solid option to start game development. 

### Communication systems
In order to have a static progress we worked with a light version of Scrum. Communication was made through Discord. We held meetings in person every week on wednesdey to consolidate the individual progress and resolve Git issues and handout tasks for the next week. The rest of the time we coded together. 

### Version control
Since our game contatins several files where multiple people work on simultanously we need to modulate our working. Therefore, we used GitLab. 
With GitLab we created branches that everyone can work on their own code. With issues we kept track of what to do.
For version control with Godot we use Sublime Merge.

### Unimplemented Features:
1. Mini Map:
	Despite our intentions, we were unable to implement a mini-map feature. This could have provided players with a broader view of the game environment for strategic planning.
2. Fog of War:
	The planned fog of war feature, which hides unexplored areas of the game map, was not implemented in the end as well. This could have added an element of mystery to the gameplay.  
3. Multiplayer:  
	This Game was originally not supposed to be a single player based Game but due to us not having enough time we needed to forget about these features