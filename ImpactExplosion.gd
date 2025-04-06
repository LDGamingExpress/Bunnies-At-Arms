extends GPUParticles2D

var BloodP = preload("res://BloodParticles.tscn")
var SmokeP = preload("res://SmokeParticlesImpact.tscn")
var Team = 0
var Damage = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	$GPUParticles2D.emitting = true



func _on_finished() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team != Team:
			body.Health -= Damage
			if body.isVehicle:
				var NewObj = SmokeP.instantiate()
				NewObj.position = body.global_position
				get_parent().add_child(NewObj)
			else:
				var NewObj = BloodP.instantiate()
				NewObj.position = body.global_position
				get_parent().add_child(NewObj)
