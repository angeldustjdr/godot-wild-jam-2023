extends GenericBuilding
class_name Farm

func _ready():
	super()
	SoundManager.playSoundNamed("build")
	# Defining applicable patterns
	self.sprites = {"base": "res://asset/sheet/sheet_last_v/crops-sheet.png",
					"4FieldsPattern":["res://asset/sheet/sheet_last_v/big_farm_upper_left-sheet.png",
									"res://asset/sheet/sheet_last_v/big_farm_upper_right-sheet.png",
									"res://asset/sheet/sheet_last_v/big_farm_lower_right-sheet.png",
									"res://asset/sheet/sheet_last_v/big_farm_lower_left-sheet.png"],
					"IrrigatedPattern": "res://asset/sheet/sheet_last_v/crops_irrigated-sheet.png",
					"Irrigated4FieldsPattern":["res://asset/sheet/sheet_last_v/big_farm_irrigated_upper_left-sheet.png",
											"res://asset/sheet/sheet_last_v/big_farm_irrigated_upper_right-sheet.png",
											"res://asset/sheet/sheet_last_v/big_farm_irrigated_lower_right-sheet.png",
											"res://asset/sheet/sheet_last_v/big_farm_irrigated_lower_left-sheet.png"],}
	self.applicablePatterns = ["4FieldsPattern","IrrigatedPattern","PermaCulturePattern"]
	self.applicablePatternsValues = {"FOOD":[1,1,1],
									"WATER":[0,0,0],
									"O2":[0,0,0],
									"POP":[0,0,0]}
	$AnimationPlayerBuilding.play("build")
	await $AnimationPlayerBuilding.animation_finished
	updateTooltip()
	GameState.actionnable_on()


func _on_input_event(_viewport, _event, _shape_idx):
	pass

func updateSprite():
	var need_update = not self.resetSprite()
	if need_update:
		var p = self.computePosition()
		if ((self.isPatternAppliedName("4FieldsPattern") and self.isPatternAppliedName("IrrigatedPattern"))
		or (self.isPatternAppliedName("4FieldsPattern") and self.isPatternAppliedName("PermaCulturePattern"))):
			self.updateSpriteName("Irrigated4FieldsPattern",p)
		elif self.isPatternAppliedName("IrrigatedPattern") or self.isPatternAppliedName("PermaCulturePattern"):
			self.updateSpriteName("IrrigatedPattern",p)
		elif self.isPatternAppliedName("4FieldsPattern"):
			self.updateSpriteName("4FieldsPattern",p)
		else:
			print("Farm:updateSprite:WARNING: Unknown pattern combination.")
		$AnimationPlayerBuilding.play("pattern_up")

func updateDescription():
	if (self.isPatternAppliedName("4FieldsPattern") 
		and self.isPatternAppliedName("IrrigatedPattern")
		and self.isPatternAppliedName("PermaCulturePattern")):
		self.current_description = "An irrigated parcel of farm in permaculture."
	elif(self.isPatternAppliedName("4FieldsPattern") 
		and self.isPatternAppliedName("IrrigatedPattern")):
		self.current_description = "An irrigated parcel of farm."
	elif(self.isPatternAppliedName("4FieldsPattern") 
		and self.isPatternAppliedName("PermaCulturePattern")):
		self.current_description = "A parcel of farm in permaculture."
	elif self.isPatternAppliedName("4FieldsPattern"):
		self.current_description = "A parcel of farm."
	elif self.isPatternAppliedName("PermaCulturePattern"):
		self.current_description = "Some crops in permaculture."
	elif self.isPatternAppliedName("IrrigatedPattern"):
		self.current_description = "Some irrigated crops."
	else:
		self.resetDescription()

func applyEffectModifier(effectName):
	match effectName:
		"Heat" :
				modifier["FOOD"] = -5
				hourglassTimer = 5
				setHourglass()
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
