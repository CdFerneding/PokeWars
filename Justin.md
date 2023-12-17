# Game Programming IMT 3603

# Individual Report - Justin Frauböse

##Bad Code
###Structure of training building
The way I created the building scene, is that there only a single scene for all the different buildings and depending on the name of the building in the main scene it decides what part of the code should be run. What that does is that, since all the functions are present in the only script file it makes the code unneccesary big and also adds redundancy to the code. 
Here is an example of what I mean with it.
<pre>
func training_finished(evolution):
	currently_training = false
	if "PokeCenter" in self.name:
		unitBuilder._build_unit(main,"Pikachu",self.position, 16,0)
	if "Fire Arena" in self.name:
		match evolution:
			0: unitBuilder._build_unit(main,"Charmander",self.position, 48,0)
			1: unitBuilder._build_unit(main,"Charmander",self.position, 48,1)
			2: unitBuilder._build_unit(main,"Charmander",self.position, 48,2)
	if "Water Arena" in self.name:
		match evolution:
			0: unitBuilder._build_unit(main,"Squirtle",self.position, 48,0)
			1: unitBuilder._build_unit(main,"Squirtle",self.position, 48,1)
			2: unitBuilder._build_unit(main,"Squirtle",self.position, 48,2)
	if "Plant Arena" in self.name:
			match evolution:
				0: unitBuilder._build_unit(main,"Bulbasaur",self.position,48,0)
				1: unitBuilder._build_unit(main,"Bulbasaur",self.position, 48,1)
				2: unitBuilder._build_unit(main,"Bulbasaur",self.position, 48,2)
	# increase unit counter
	Game.friendlyUnits += 1
</pre>
