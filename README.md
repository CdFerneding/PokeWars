# Pokewars

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

