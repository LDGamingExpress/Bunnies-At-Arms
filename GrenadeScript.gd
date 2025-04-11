extends CharacterBody2D
var ImpactE = preload("res://ImpactExplosion.tscn")
var AltTexture = preload("res://Textures/SatchelCharge.png")
var dir = null
var SPEED = 80.0
var Damage = 1
var Team = null
var startpos = null
var GunRange = 150
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	startpos = position
	if Damage >= 5:
		$Sprite2D.texture = AltTexture
	#	$Sprite2D.scale = Vector2(1.5,1.5)
	$Sprite2D.rotate(atan(dir.y/dir.x) * randf_range(0.85,1.15))

func _physics_process(delta: float) -> void:
	velocity = dir * SPEED
	move_and_slide()
	if sqrt(pow(startpos.x - position.x,2) + pow(startpos.y - position.y,2)) > GunRange*1.2:
		var NewObj2 = ImpactE.instantiate()
		NewObj2.position = global_position
		NewObj2.Damage = Damage/2
		NewObj2.Team = Team
		get_parent().call_deferred("add_child",NewObj2)
		queue_free()
