extends Label

func _process(_delta):
	text = str(get_parent().i) + str(get_parent().j)
