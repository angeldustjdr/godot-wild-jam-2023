extends GenericBuilding
class_name Well

func _ready():
	# Defining applicable patterns
	self.sprites = {"base": "res://asset/sheet/well-sheet-1.png",
					"IrrigatedPattern": "res://asset/sheet/irrigated_well.png"}
	self.applicablePatterns = ["IrrigatedPattern"]
	self.applicablePatternsValues = {"FOOD":[0],
									"WATER":[-1],
									"O2":[0],
									"POP":[0]}
	$AnimationPlayerBuilding.play("build")
	await $AnimationPlayerBuilding.animation_finished
	RadioDiffusion.connect("updateTopUINeeded",updateTooltip)
	updateTooltip()

func _on_input_event(_viewport, _event, _shape_idx):
	pass

func updateSprite():
	if not self.resetSprite():
		var p = self.computePosition()
		if self.isPatternAppliedName("IrrigatedPattern"):
			self.updateSpriteName("IrrigatedPattern",p)
		else:
			print("Well:updateSprite:WARNING: Unknown pattern combination.")

func applyEffectModifier(effectName):
	match effectName:
		"Heat" :
				modifier["WATER"] -= 5
				hourglassTimer = 5
				setHourglass()
		"Pollution" :
				modifier["WATER"] -= 5
				hourglassTimer = 5
				setHourglass()
		"Spore" :
				modifier["WATER"] -= 5
				unsetHourglass()
		"Smoke" :
				modifier["WATER"] -= 5
				hourglassTimer = 5
				setHourglass()
		"Fertilizer" :
				modifier["WATER"] -= 5
				hourglassTimer = 5
				setHourglass()
		"Meat" :
				modifier["WATER"] -= 5
				hourglassTimer = 5
				setHourglass()
		"Nothing" :
				modifier["WATER"] = 0
				unsetHourglass()
	popLabel(getTotalStat())

