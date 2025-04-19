extends CharacterBody2D
var Explosion = preload("res://ArtilleryImpact.tscn")
var Team = 1
var TargetPos = null
var SPEED = 250.0
var Damage = 60
var BombReady = true
var PassedTarget = false
var dir = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlaneSprite.look_at(TargetPos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(PassedTarget)
	if PassedTarget == false:
		$PlaneSprite.self_modulate.a = lerp($PlaneSprite.self_modulate.a,1.0,0.1)
		#print($PlaneSprite.self_modulate)
	else:
		$PlaneSprite.self_modulate.a = lerp($PlaneSprite.self_modulate.a,0.0,0.1)
		if $PlaneSprite.self_modulate.a == 0:
			queue_free()
	velocity = SPEED * dir
	move_and_slide()
	
	var dis = sqrt(pow(TargetPos.x - global_position.x,2) + pow(TargetPos.y - global_position.y,2))
	if dis <= 300 and BombReady:
		BombReady = false
		$BombTimer.start()
		var NewObj = Explosion.instantiate()
		NewObj.global_position = global_position
		NewObj.Team = Team
		NewObj.Damage = Damage
		NewObj.radius = 1
		get_parent().add_child(NewObj)
	if dis <= 100 and PassedTarget == false:
		await get_tree().create_timer(2).timeout
		PassedTarget = true


func _on_bomb_timer_timeout() -> void:
	BombReady = true
