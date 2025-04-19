extends GPUParticles2D

var BloodP = preload("res://BloodParticles.tscn")
var SmokeP = preload("res://SmokeParticlesImpact.tscn")
var Team = 0
var Damage = 0
var AllowDamage = true
@export var radius = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	$GPUParticles2D.emitting = true
	await get_tree().create_timer(0.75).timeout
	AllowDamage = false



func _on_finished() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if AllowDamage == true:
		if body.is_in_group("Units"):
			if body.Team != Team:
				body.Health -= Damage
				if body.isVehicle or body.isBuilding:
					var NewObj = SmokeP.instantiate()
					NewObj.position = body.global_position
					get_parent().add_child(NewObj)
				else:
					var NewObj = BloodP.instantiate()
					NewObj.position = body.global_position
					get_parent().add_child(NewObj)
		if body.is_in_group("Explosive"):
				body.Destroy()
		if body.is_in_group("Props"):
			var CellImpacted = body.local_to_map(body.to_local(global_position))
			#print(CellImpacted)
			body.set_cell(CellImpacted,-1,Vector2i(-1,-1),0)
			#var tile = body.local_to_map()
			for x in range(-radius,radius):
				for y in range(-radius,radius):
					body.set_cell(CellImpacted+Vector2i(x,y),-1,Vector2i(-1,-1),0)
			Globals.ChangedMesh = true
