extends CharacterBody2D

var BloodP = preload("res://BloodParticles.tscn")
var SmokeP = preload("res://SmokeParticlesImpact.tscn")
var ImpactE = preload("res://ImpactExplosion.tscn")
var AltTexture1 = preload("res://Textures/FireParticle.png")
var dir = null
var SPEED = 100.0
var Damage = 1
var Team = null
var startpos = null
var GunRange = 150

func _ready() -> void:
	startpos = position
	if Damage >= 5:
		$Sprite2D.scale = Vector2(1.5,1.5)
	$Sprite2D.rotate(atan(dir.y/dir.x))
	if Damage == 0.8:
		$Sprite2D.texture = AltTexture1

func _physics_process(delta: float) -> void:
	velocity = dir * SPEED
	move_and_slide()
	if sqrt(pow(startpos.x - position.x,2) + pow(startpos.y - position.y,2)) > GunRange*1.2:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team != Team:
			body.Health -= Damage
			if body.isVehicle or body.isBuilding:
				var NewObj = SmokeP.instantiate()
				NewObj.position = global_position
				get_parent().add_child(NewObj)
			else:
				var NewObj = BloodP.instantiate()
				NewObj.position = global_position
				get_parent().add_child(NewObj)
			if Damage >= 5:
				var NewObj2 = ImpactE.instantiate()
				NewObj2.position = global_position
				NewObj2.Damage = Damage/2
				NewObj2.Team = Team
				get_parent().call_deferred("add_child",NewObj2)
				#get_parent().add_child(NewObj2)
			queue_free()
	else:
		if Damage >= 5:
			var NewObj2 = ImpactE.instantiate()
			NewObj2.position = global_position
			NewObj2.Damage = Damage/2
			NewObj2.Team = Team
			get_parent().call_deferred("add_child",NewObj2)
		var NewObj = SmokeP.instantiate()
		NewObj.position = global_position
		get_parent().add_child(NewObj)
		#var CellImpacted = body.local_to_map(body.to_local(global_position))
		#print(CellImpacted)
		queue_free()
