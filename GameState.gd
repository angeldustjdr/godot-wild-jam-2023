extends Node

var testVar:int = 3

var grid:Array
signal gridUpdateNeeded

func callUpdateGrid():
	emit_signal("gridUpdateNeeded")
