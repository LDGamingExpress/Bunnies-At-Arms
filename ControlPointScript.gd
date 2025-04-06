extends StaticBody2D
var Owner = 0
var TeamsPresent = []
var TeamMembersPresent = []
var Contested = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if Contested == false and TeamsPresent.size() == -1:
			Owner = body.Type
		else:
			if TeamsPresent.find(body.Team) != -1:
				var index = TeamsPresent.find(body.Team)
				TeamMembersPresent[index] += 1
			else:
				Contested = true
				TeamsPresent.append(body.Team)
				TeamMembersPresent.append(1)


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_resource_timer_timeout() -> void:
	pass # Replace with function body.
