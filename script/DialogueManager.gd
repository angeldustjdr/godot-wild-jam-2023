extends Node

var Dialogues = {}
var isReady = false
var rawDialogue

func _ready():
	rawDialogue = "start/Let's get to work ! Destroy buildings by clicking on it./end
lock/Something has become inaccessible.../end
swap/What? The layout of the city just changed!/end
wait_turn/A timer has decreased./end
ras/Nothing bad happened./end
strangeNoise/A strange noise is heard. Let's hope it's not too bad./end
pipes/Some pipings broke but nobody was injured./end
toaster/The connected toaster went down. Nobody seems to care./end
wifi/The wifi went down. A day of mourning has been declared./end
bank/The banking system went down. Everyone's debt has been cleared./end
ai/AI bots do not work anymore. Not a bad thing./end
light/The lights went down. Let's get candles./end
socialMedia/The Main Social Media went down. Now, where can we post those stories?/end
tuto1/A long time ago, technopriests made a pact with an unknown entity./tuto2
tuto2/The entity granted them advanced technologies to sustain their population./tuto3
tuto3/However, these structures are now crumbling, and the technopriests are no longer present./tuto4
tuto4/If you don't act quickly, resources will soon be scarce/end
tuto5/Destroy seemingly useless buildings to free up space/tuto6
tuto6/and replace them with low-tech resource providers./tuto7
tuto7/Some buildings emit negative effects if not destroyed. /tuto8
tuto8/Be cautious: demolishing a building may have unforeseen consequences./tuto9
tuto9/Remember to read tooltips and attempt to replace your old resources with new ones before the timer expires. Good luck!/end
Heat/A techno-furnace has been destroyed!/end
Pollution/A contaminated factory has been destroyed!/end
Spore/A techno-spore farm has been destroyed!/end
EndGame/Congratulations! You have completed your tasks. Hopefuly people live a better live now./end
pop_neg/All the population died.../end"
	readDialogueFile()

func readDialogueFile():
	rawDialogue = rawDialogue.replace("\r","")
	rawDialogue = rawDialogue.split("\n")
	for line in rawDialogue: 
		if line != "":
			line = line.split("/")
			Dialogues[line[0]] = [line[1],line[2]]
	isReady = true

