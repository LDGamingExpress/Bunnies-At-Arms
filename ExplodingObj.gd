extends StaticBody2D
@export var Damage = 10
@export var radius = 0
var ImpactE = preload("res://ImpactExplosion.tscn")

func Destroy():
	var NewObj2 = ImpactE.instantiate()
	NewObj2.position = global_position
	NewObj2.Damage = Damage
	NewObj2.Team = 0
	NewObj2.radius = radius
	get_parent().call_deferred("add_child",NewObj2)
	queue_free()
