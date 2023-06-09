extends GenericBuilding
class_name myTree # Tree is already a class in godot4

func _ready():
	self.updateDescription()
	SoundManager.playSoundNamed("build")
	# Defining applicable patterns
	self.sprites = {"base": "res://asset/sheet/sheet_last_v/tree-sheet.png",
					"4TreesPattern":["res://asset/sheet/sheet_last_v/big_tree_upper_left-sheet.png",
									"res://asset/sheet/sheet_last_v/big_tree_upper_right-sheet.png",
									"res://asset/sheet/sheet_last_v/big_tree_lower_right-sheet.png",
									"res://asset/sheet/sheet_last_v/big_tree_lower_left-sheet.png"]}
	self.applicablePatterns = ["4TreesPattern","PermaCulturePattern"]
	self.applicablePatternsValues = {"FOOD":[0,0],
									"WATER":[0,0],
									"O2":[1,0],
									"POP":[0,0]}
	$AnimationPlayerBuilding.play("build")
	await $AnimationPlayerBuilding.animation_finished
	updateTooltip()
	GameState.actionnable_on()

func updateSprite():
	if not self.resetSprite():
		var p = self.computePosition()
		if self.isPatternAppliedName("4TreesPattern") or (self.isPatternAppliedName("4TreesPattern") and  self.isPatternAppliedName("PermaCulturePattern")):
			self.updateSpriteName("4TreesPattern",p)
		elif self.isPatternAppliedName("PermaCulturePattern"):
			self.updateSpriteName("base",p)
		else:
			print("Tree:updateSprite:WARNING: Unknown pattern combination.")
		$AnimationPlayerBuilding.play("pattern_up")

func updateDescription():
	if (self.isPatternAppliedName("4TreesPattern") 
		and self.isPatternAppliedName("PermaCulturePattern")):
		self.current_description = "A forest allowing permaculture in a nearby field."
	elif(self.isPatternAppliedName("4TreesPattern")):
		self.current_description = "A forest."
	elif(self.isPatternAppliedName("PermaCulturePattern")):
		self.current_description = "A beautiful tree allowing permaculture in a nearby field."
	else:
		self.resetDescription()

func _on_input_event(_viewport, _event, _shape_idx):
	pass

func applyEffectModifier(effectName):
	match effectName:
		"Heat" :
				modifier["O2"] -= 5
				hourglassTimer = 5
				setHourglass()
		"Pollution" :
				modifier["O2"] -= 5
				unsetHourglass()
		"Smoke" :
				modifier["O2"] -= 5
				hourglassTimer = 5
				setHourglass()
		"Spore" :
				modifier["O2"] -= 5
				unsetHourglass()
		"Fertilizer" :
				modifier["O2"] -= 0
				hourglassTimer = 5
				setHourglass()
		"Meat" :
				modifier["O2"] -= 0
				hourglassTimer = 5
				setHourglass()
		"Nothing" :
				modifier["O2"] = 0
				unsetHourglass()
	popLabel(getTotalStat())

