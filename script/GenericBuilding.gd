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
@export var lockable = true
@export var swapable = true
@export var outcomeAllowed = true
@export var particuleAllowed = false
@export var animationDestroy = ""

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
@onready var animationDestroyNode = preload("res://scene/AnimationPlayerDestroy.tscn")
@export var destroyable = true
var dust

# PATTERNS
signal buildingDestruction(i,j)
var sprites = {}
var appliedPatterns = []
var appliedPatternsNames = []
var applicablePatterns = []
var applicablePatternsValues = []

func _ready():
	$AnimationPlayerBuilding.play("build")
	await $AnimationPlayerBuilding.animation_finished
	var random = randf_range(0,100)
	if random < 20 and lockable :
		locked = true
	if hasHourglass:
		setHourglass()
	if locked:
		setLock()
	if playIdle: 
		$AnimationPlayerBuilding.speed_scale = randf_range(0.9,1.1)
		$AnimationPlayerBuilding.play("idle")
	if destroyable: 
		var ad = animationDestroyNode.instantiate()
		add_child(ad)
		dust = $AnimationPlayerDestroy.get_node("DustParticule")
	RadioDiffusion.connect("updateTopUINeeded",updateTooltip)
	updateTooltip()

# PATTERNS ####
func resetSprite():
	if self.appliedPatterns.is_empty():
		self.applyBaseSprite()
		return true
	return false

func updateSpriteName(name, pos=-1):
	if pos != -1:
		self.get_node("Sprite").texture = load(self.sprites[name][pos])
	else:
		self.get_node("Sprite").texture = load(self.sprites[name])

func applyBaseSprite():
	self.get_node("Sprite").texture = load(self.sprites["base"])

func isPatternApplied(pattern): # Not robust for instanciation... don't use it
	return pattern in self.appliedPatterns

func isPatternAppliedName(pattern_name):
	return pattern_name in self.appliedPatternsNames

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
	if not self.isPatternAppliedName(pattern.name):
		self.appliedPatternsNames.append(pattern.name)
		self.appliedPatterns.append(pattern.duplicate())
		for stat in patternModifier.keys():
			patternModifier[stat] += self.getPatternModifierValue(pattern,stat)
		popLabel(getTotalStat())

#untested
func unApplyPattern(pattern):
	if self.isPatternAppliedName(pattern.name):
		var index = self.appliedPatternsNames.find(pattern.name,0)
		self.appliedPatternsNames.remove(index)
		self.appliedPatterns.remove(index)
		for stat in patternModifier.keys():
			patternModifier[stat] -= self.getPatternModifierValue(pattern,stat)
		popLabel(getTotalStat())
	else:
		print("GenericBuilding:unApplyPattern:WARNING: Try to unapply a not applied pattern...")

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
	GameState.actionnable_off()
	if destroyable:
		buildingDestruction.emit(self.j,self.i)
		if animationDestroy!="": RadioDiffusion.nextDialogNeeded(animationDestroy)
		dust.global_position = self.global_position + Vector2(34,68)
		dust.visible = true
		$AnimationPlayerDestroy.play("destroy"+animationDestroy)
		await $AnimationPlayerDestroy.animation_finished
		dust.visible = false
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
	if lockable:
		unsetLock()
		hasHourglass = true
		hourglassTimer = randi_range(3,7)
		locked = true
		$Chain.visible = true
		setHourglass()

func unsetLock():
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
