extends StaticBody2D
var Owner = 0
var TeamsPresent = []
var TeamMembersPresent = []
var Contested = false
var CaptureTimerOn = false
@export var ResourceType = "BunnyPower"
@export var ResourceAmount = 10

func _ready() -> void:
	$CPLabel2.text = ("+" + str(ResourceAmount) + "\n" + ResourceType)

func _process(delta: float) -> void:
	if TeamsPresent.size() > 1:
		Contested = true
	else:
		Contested = false
		if TeamsPresent.size() == 1:
			if CaptureTimerOn == false:
				$CaptureTime.start()
				CaptureTimerOn = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if TeamsPresent.find(body.Team) != -1:
			var index = TeamsPresent.find(body.Team)
			TeamMembersPresent[index] += 1
		else:
			TeamsPresent.append(body.Team)
			TeamMembersPresent.append(1)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if TeamsPresent.find(body.Team) != -1:
			var index = TeamsPresent.find(body.Team)
			TeamMembersPresent[index] -= 1
			if TeamMembersPresent[index] <= 0:
				TeamMembersPresent.remove_at(index)
				TeamsPresent.remove_at(index)


func _on_resource_timer_timeout() -> void:
	if Owner != 0:
		match ResourceType:
			"BunnyPower":
				Globals.BunnyPower[Owner-1] += ResourceAmount
			"Fuel":
				Globals.Fuel[Owner-1] += ResourceAmount
			"Munitions":
				Globals.Munitions[Owner-1] += ResourceAmount
			"Victory Points":
				Globals.VictoryPoints[Owner-1] += ResourceAmount


func _on_capture_time_timeout() -> void:
	CaptureTimerOn = false
	if TeamsPresent.size() == 1:
		Owner = TeamsPresent[0]
		var TeamColor = Globals.TeamColors[Owner-1]
		#print($ControlArea.self_modulate)
		$ControlArea.self_modulate = Color8(TeamColor[0],TeamColor[1],TeamColor[2],191)
		#print($ControlArea.self_modulate)
