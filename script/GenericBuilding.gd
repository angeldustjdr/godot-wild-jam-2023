extends Area2D
class_name GenericBuilding

@export_multiline var description:String
@export var effect:String = "Nothing"
@export var playIdle:bool

@export var base_stat = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
var modifier = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
var patternModifier = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}				
var totalStat = {"POP" : 0,
				"WATER" : 0,
				"FOOD" : 0,
				"O2" : 0}
@export var negativeStat = false
@export var hasHourglass = false
@export var hourglassTimer = 50
@export var locked = false
@export var locakable = true
@export var swapable = true
@export var outcomeAllowed = true
@export var particuleAllowed = false

@onready var effectDescription = {"Heat" : "The air temperature is pretty high here!",
	"Pollution" : "The floor is covered with polluted water!",
	"Smoke" : "Toxic smoke in the air!",
	"Spore" : "Some weird spores float in the air!",
	"Fertilizer" : "The crops grow better here for some reasons!",
	"Meat" : "Something horrible tries to feed !"}

var i
var j
var cellEffect = "Nothing"
var firstTime = true
@onready var juicyLabel = preload("res://scene/JuicyLabel.tscn")

# PATTERNS
var appliedPatterns = []
var applicablePatterns = []
var applicablePatternsValues = []

func _ready():
	var random = randf_range(0,100)
	if random < 20 :
		locked = true
	if hasHourglass:
		setHourglass()
	if locked:
		setLock()
	if playIdle: 
		$AnimationPlayerBuilding.speed_scale = randf_range(0.9,1.1)
		$AnimationPlayerBuilding.play("idle")
	RadioDiffusion.connect("updateTopUINeeded",updateTooltip)
	updateTooltip()

# PATTERNS ####
func isPatternApplied(pattern):
	return pattern in self.appliedPatterns

func isApplicablePattern(pattern):
	for p in self.applicablePatterns:
		if p in pattern.name:
			return true
	return false

func getPatternModifierValue(pattern,stat):
	if stat in self.applicablePatternsValues.keys():
		var modifiers = self.applicablePatternsValues[stat]
		if self.isApplicablePattern(pattern):
			var index = self.applicablePatterns.find(pattern,0)
			return modifiers[index]
		else:
			print("GenericBuilding:getPatternValue:ERROR: Pattern is not applicable.")

func applyPattern(pattern):
	if not self.isPatternApplied(pattern):
		self.appliedPatterns.append(pattern)
		for stat in patternModifier.keys():
			patternModifier[stat] += self.getPatternModifierValue(pattern,stat)
		popLabel(getTotalStat())

func unApplyPattern(pattern):
	if self.isPatternApplied(pattern):
		self.appliedPatterns.erase(pattern)
		for stat in patternModifier.keys():
			patternModifier[stat] -= self.getPatternModifierValue(pattern,stat)
		popLabel(getTotalStat())
	else:
		print("GenericBuilding:unApplyPattern:WARNING: Try to unapply a not applied pattern...")
		
###############

func _on_input_event(_viewport, event, _shape_idx):
	if not locked :
		if event is InputEventMouseButton and GameState.actionnable:
			if event.button_index==MOUSE_BUTTON_LEFT:
				GameState.actionnable_off()
				GameState.actionnable_off()
				createConfirmMenu(self)

func createConfirmMenu(obj):
	RadioDiffusion.createConfirmMenuCall(obj)

func selfDestruct(type):
	#print(i,j)
	GameState.actionnable_off()
	RadioDiffusion.gridUpdateCall(i,j,type)
	if outcomeAllowed : RadioDiffusion.generateOutcomeCall(i,j)
	queue_free()

func updateTooltip():
	var updatedDescription = description
	updatedDescription += getTotalStat()
	if getTotalStat() =="" : 
		for n in base_stat.keys():
			if base_stat[n]!=0: updatedDescription += "\nIt's supposed to produce "+n+" but it's not!"
	updatedDescription += getCellEffect()
	updatedDescription += getLocked()
	$Tooltip.tooltip_text = updatedDescription

func getTotalStat():
	var returnStat = ""
	for n in GameState.ressourceName:
		if negativeStat: totalStat[n] = base_stat[n]+modifier[n]+patternModifier[n]
		else : totalStat[n] = clamp(base_stat[n]+modifier[n]+patternModifier[n],0,GameState.maxStat)
		if totalStat[n]!=0:
			var plus = ""
			if totalStat[n]>0: plus="+" 
			returnStat += "\n"+plus+str(int(100*totalStat[n]/(GameState.maxStat/2)))+"% "+n
	return returnStat

func getCellEffect():
	var returned = ""
	if cellEffect != "Nothing":
		returned = "\n"+effectDescription[cellEffect]
	return returned

func popLabel(text):
	RadioDiffusion.popLabelCall(self.global_position,text,"UP")
#	var l = juicyLabel.instantiate()
#	l.playAnimation("UP")
#	l.text = text
#	add_child(l)
	pass

func cleanParticules():
	for n in get_children():
		if n is CPUParticles2D:
			n.queue_free()

func applyCellEffect(myEffect):
	if myEffect!=cellEffect or firstTime:
		applyEffectModifier(myEffect)
		if particuleAllowed:
			var particules = null
			match myEffect:
				"Heat":
					particules = load("res://scene/HeatParticules.tscn")
				"Pollution":
					particules = load("res://scene/PoisonParticules.tscn")
				"Smoke":
					particules = load("res://scene/SmokeParticules.tscn")
				"Spore":
					particules = load("res://scene/SporeParticules.tscn")
				"Fertilizer":
					particules = load("res://scene/EngraisParticules.tscn")	
				"Meat":
					particules = load("res://scene/MeatParticules.tscn")
			if particules!=null:
				var p = particules.instantiate()
				add_child(p)
		cellEffect = myEffect
		updateTooltip()
		firstTime = false	

func setHourglass():
	hasHourglass = true
	var hourglass = load("res://scene/Hourglass.tscn")
	var h = hourglass.instantiate()
	h.setTimer(hourglassTimer)
	add_child(h)

func unsetHourglass():
	hasHourglass = false
	if self.has_node("Hourglass") :
		$Hourglass.queue_free()

func setLock():
	if locakable:
		unsetLock()
		hasHourglass = true
		hourglassTimer = 6
		locked = true
		$Chain.visible = true
		setHourglass()

func unsetLock():
	if locakable:
		hasHourglass = false
		$Chain.visible = false
		locked = false
		unsetHourglass()

func getLocked():
	var returned = ""
	if locked: returned="\nThis building is locked."
	return returned

func applyEffectModifier(_effectName):
	pass

func swap(arrivee_x,arrivee_y,size):
	cellEffect = "InTransition"
	var tween = create_tween()
	tween.tween_property(self, "position",Vector2(arrivee_x*size,arrivee_y*size),0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func _on_tooltip_mouse_entered():
	$Sprite.material.set_shader_parameter("width",2.)


func _on_tooltip_mouse_exited():
	$Sprite.material.set_shader_parameter("width",0.)
