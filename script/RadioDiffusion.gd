extends Node

#### DIFFUSION DES SIGNAUX

signal gridUpdateNeeded(x,y,t)
func gridUpdateCall(i,j,type):
	gridUpdateNeeded.emit(i,j,type)

signal cleanSelectionNeeded
func cleanSelectedCall():
	cleanSelectionNeeded.emit()

signal createBuildMenuNeeded(object)
func createBuildMenuCall(obj):
	createBuildMenuNeeded.emit(obj)
	
signal createConfirmMenuNeeded(object)
func createConfirmMenuCall(obj):
	createConfirmMenuNeeded.emit(obj)

signal updateTopUINeeded()
func updateTopUICall():
	updateTopUINeeded.emit()

signal recalculateEffectNeeded
func recalculateEffectCall():
	recalculateEffectNeeded.emit()

signal calculateRessourcesNeeded
func calculateRessourcesCall():
	calculateRessourcesNeeded.emit()

signal generateOutcomeNeeded(i,j)
func generateOutcomeCall(i,j):
	generateOutcomeNeeded.emit(i,j)

signal nextDialogPlease(text)
func nextDialogNeeded(text):
	nextDialogPlease.emit(text)

signal popLabelNeeded(pos,text,dir)
func popLabelCall(pos,text,dir):
	popLabelNeeded.emit(pos,text,dir)

signal endDialogue
func callEndDialogue():
	endDialogue.emit()
	
signal rideau(sens)
func rideauCall(sens):
	rideau.emit(sens)

signal rideauFinished
func rideauFinishedCall():
	rideauFinished.emit()

signal endGame
func endGameCall():
	MusicManager.playMusicNamed("end")
	endGame.emit()
