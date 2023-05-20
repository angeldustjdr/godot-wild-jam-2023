extends GenericBuilding
class_name Well

func _ready():
	SoundManager.playSoundNamed("build")
	# Defining applicable patterns
	self.sprites = {"base": "res://asset/sheet/well-sheet-1.png",
					"IrrigatedPattern": "res://asset/sheet/irrigated_well.png",
					"IrrigatedChannelPattern": ["res://asset/sheet/left_irrigated_channel.png",
									"res://asset/sheet/middle_irrigated_channel.png",
									"res://asset/sheet/right_irrigated_channel.png"],
					"ChannelPattern":["res://asset/sheet/left_channel.png",
										"res://asset/sheet/middle_channel.png",
										"res://asset/sheet/right_channel.png"]}
	self.applicablePatterns = ["IrrigatedPattern","ChannelPattern"]
	self.applicablePatternsValues = {"FOOD":[0,0],
									"WATER":[-1,1],
									"O2":[0,0],
									"POP":[0,0]}
	$AnimationPlayerBuilding.play("build")
	await $AnimationPlayerBuilding.animation_finished
	RadioDiffusion.connect("updateTopUINeeded",updateTooltip)
	updateTooltip()

func _on_input_event(_viewport, _event, _shape_idx):
	pass

func getOrientation():
	var index = self.appliedPatternsNames.find("ChannelPattern",0)
	if index != -1:
		return self.alphas[index]
	return 0

func updateSprite():
	if not self.resetSprite():
		var p = self.computePosition()
		var ori = self.getOrientation()
		if self.isPatternAppliedName("ChannelPattern") and self.isPatternAppliedName("IrrigatedPattern"):
			self.updateSpriteName("IrrigatedChannelPattern",p,ori)
		elif  self.isPatternAppliedName("ChannelPattern"):
			self.updateSpriteName("ChannelPattern",p,ori)
		elif self.isPatternAppliedName("IrrigatedPattern"):
			self.updateSpriteName("IrrigatedPattern",p,0)
		else:
			print("Well:updateSprite:WARNING: Unknown pattern combination.")
		$AnimationPlayerBuilding.play("pattern_up")

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


