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

signal updateTopUINeeded()
func updateTopUICall():
	updateTopUINeeded.emit()

