extends AnimatedSprite2D

var ImpactE = preload("res://ImpactExplosion.tscn")
@export var Team = 1
var Damage = 15

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team != Team:
			var NewObj2 = ImpactE.instantiate()
			NewObj2.position = global_position
			NewObj2.Damage = Damage/2
			NewObj2.Team = Team
			get_parent().call_deferred("add_child",NewObj2)
			queue_free()
