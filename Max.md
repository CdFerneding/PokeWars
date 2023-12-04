# Game Programming IMT 3603

# Individual Report - Max Neubauer (106077)



## Bad Code

For my bad code I chose the inheritance. In order to structure the code I wrote a Pokemon class. This class contains basic attributes that every pokemon has. E. G. speed, health or type and takes care of the animation.
The Pokemon class is extended by GoodPokemon and BadPokemon. BadPokemon is extended by the BigBadPokemon and the enemies. GoodPokemon is Extended by the military Pokemon and Pikachu.

This way it is possible to use these classes as Types to work with different Pokemon that belong to the same Type.

(This code is not from me)
![Inheritance used](Documentation/Max_Neubauer_Personal_Report_Assets/_inheritance_description.png)

Unortunately, there are still some functions left at the bottom of the inheritance (inside of Pikachu, Squirtle, Bulbasaur) that could be outsourced in GoodPokemon. This way redundant boilerplate code is avoided and the codebase becomes cleaner.

![Boiler Plate Code](Documentation/Max_Neubauer_Personal_Report_Assets/bad_code_redundant_not_inherited.png)

Due to the lack of outsourcing and abstraction the GoodPokemon class is currently almost empty. 

![Empty Inheritance](Documentation/Max_Neubauer_Personal_Report_Assets/bad_code_empty_inheritance.png )


Another example of bad code is the use of global flag variables. Global flag variables may seem like a propper solution in the first place. But when the code becomes more and the number of flag variables increases, the complexity of the code increases sigificantly. 

Although I tried to use as few global flag variables as possible there are still some left. For example: I wanted to make sure that bad Pokemon only spawn after a certain amount of time.

## Good Code




## Reflextion




