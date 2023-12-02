# Pokewars

## Members
Justin Frauböse (J), Max Neubauer (M), Conrad Ferneding (C), Evan Fregeais (E)

## Code claims 
choose between All, Most, Half, Some, Touched
| | Justin | Max | Conrad | Evan |
|----|----|----|----|----|
|Map, Building & Tilemap|x| x | x | x | 
|Wall of Death| x | x | x | x |  
|Navigation| x | x | x | x |
|Pikachu| x | x | x | x |
|Sprites & Animation| x | x | x | x |
|Character Selection| x |x | x | x | 
|Military Units and battle| x | x | x | x | 
|Pokemon Spawner (+spawn rate)| x | x | x | x | 
|Win/Loose condition trigger| x | x | x | x | 
|Music, Cursor| x | x | x | x | 
|GUI| x | x | x | x | 

## Concept

The concept behind the game is a mix between Age of Empires and Pokemon

## Game Engine

We started working with Unity in the begining but with what is happening to Unity, we decided to switch to Godot.

## Controlls
Commands can be executed with right "game mode".
Mode can be switched with:
R -> "Run": handling pokemon
B -> "Build": infrastructure, buildings
P -> "Place": placing new pokemon (SHOULD NOT BE NECESSARY IN THE FINAL VERSION!)

### Moving Pikachu:
#### Game Mode: R
select with left click (number of selected pikachus is displayed in the ui),
move selected pikachus by right clicking on the destination.
Select multiple pikachus by dragging the mouse over the screen while holding left click, they can then be moved all at once.
Deselect all currently selected pikachus by left clicking on "nothing" (somewhere where there is no pikachu).

### Controlling the military:
#### Game Mode: R
military units can be controlled in the same fashion as pikachus.
If a military unit has "no current task" it will attack the closest enemy.

### Building:
#### Game Mode: B
When pressing B the ui changes and by clicking on the building buttons a building can be selected to be placed with leftclick on an empty place on the map. 
Buildings can also be deleted. 
Remember to press "R" again if you want to control units. 

### Placement Mode
Press P to enter Placement mode. 
Press "1" to place Pikachu with left click. "2" for Charmander. "3" for Squirtle. "4" for Bulbasaur.

