extends GenericBuilding
class_name Farm

func _ready():
	# Defining applicable patterns
	self.sprites = {"base": "res://asset/sheet/crops-1-sheet.png",
					"4FieldsPattern":["res://asset/sheet/big_farm_upper_left.png",
									"res://asset/sheet/big_farm_upper_right.png",
									"res://asset/sheet/big_farm_lower_right.png",
									"res://asset/sheet/big_farm_lower_left.png"],
					"IrrigatedPattern": "res://asset/sheet/crops_irrigated.png",
					"Irrigated4FieldsPattern":["res://asset/sheet/big_farm_upper_left.png",
											"res://asset/sheet/big_farm_upper_right.png",
											"res://asset/sheet/big_farm_lower_right.png",
											"res://asset/sheet/big_farm_lower_left.png"],}
	self.applicablePatterns = ["4FieldsPattern","IrrigatedPattern","PermaCulturePattern"]
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

func updateSprite(pos=-1):
	if not self.resetSprite():
		if ((self.isPatternAppliedName("4FieldsPattern") and self.isPatternAppliedName("IrrigatedPattern"))
		or (self.isPatternAppliedName("4FieldsPattern") and self.isPatternAppliedName("PermaCulturePattern"))):
			self.updateSpriteName("Irrigated4FieldsPattern",pos)
		elif self.isPatternAppliedName("IrrigatedPattern") or self.isPatternAppliedName("PermaCulturePattern"):
			self.updateSpriteName("IrrigatedPattern",pos)
		elif self.isPatternAppliedName("4FieldsPattern"):
			self.updateSpriteName("4FieldsPattern",pos)
		else:
			print("Farm:updateSprite:WARNING: Unknown pattern combination.")

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
