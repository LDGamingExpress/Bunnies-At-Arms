extends CharacterBody2D

var BloodP = preload("res://BloodParticles.tscn")
var dir = null
var SPEED = 100.0
var Damage = 1
var Team = null
var startpos = null

func _ready() -> void:
	startpos = position

func _physics_process(delta: float) -> void:
	velocity = dir * SPEED
	move_and_slide()
	if pow(startpos.x - position.x,2) + pow(startpos.y - position.y,2) > 250000:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team != Team:
			body.Health -= Damage
			var NewObj = BloodP.instantiate()
			NewObj.position = global_position
			get_parent().add_child(NewObj)
			queue_free()
	else:
		queue_free()
