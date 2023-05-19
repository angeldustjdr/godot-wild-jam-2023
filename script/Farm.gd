extends GenericBuilding
class_name Farm

func _ready():
	# Defining applicable patterns
	self.applicablePatterns = ["4FieldsPattern","IrrigatedPattern"]
	self.applicablePatternsValues = {"FOOD":[1,1],
									"WATER":[0,0],
									"O2":[0,0],
									"POP":[0,0]}
	$AnimationPlayerBuilding.play("build")
	await $AnimationPlayerBuilding.animation_finished
	RadioDiffusion.connect("updateTopUINeeded",updateTooltip)
	updateTooltip()

func _on_input_event(_viewport, _event, _shape_idx):
	pass

func applyEffectModifier(effectName):
	match effectName:
		"Heat" :
				modifier["FOOD"] = -5
				unsetHourglass()
		"Pollution" :
				modifier["FOOD"] = -5
				unsetHourglass()
		"Smoke" :
				modifier["FOOD"] = -5
				unsetHourglass()
		"Fertilizer" :
				modifier["FOOD"] = +3
				unsetHourglass()
		"Spore" :
				modifier["FOOD"] = 0
				unsetHourglass()
		"Meat" :
				modifier["FOOD"] = -5
				hourglassTimer = 5
				setHourglass()
		"Nothing" :
				modifier["FOOD"] = 0
				unsetHourglass()
	popLabel(getTotalStat())
