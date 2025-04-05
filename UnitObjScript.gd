extends CharacterBody2D
var UnitActor = preload("res://UnitActor.tscn")
@export var Type = "Infantry"
@export var Team = 1
var PlayerHovering = 0
var Selected = 0
var GoToPos = global_position
var FarAway = 0
var Speed = 1
var FarAwayFrom = null
var FirstMove = 0
var SPEED = 50
var Behavior = "Defensive" # Can be Defensive, Aggressive, and Passive
var UnitsLeft = 4
var Pursuing = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match Type:
		"Car":
			UnitsLeft = 1
			Speed = 55
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 50.0
			NewObj.GunRange = 180
			NewObj.Team = Team
			NewObj.ReloadTime = 0.2
			NewObj.Accuracy = 10
			NewObj.Damage = 1
			NewObj.Health = 12
			NewObj.GunOffsetX = -13
			NewObj.GunOffsetY = 0
			NewObj.GunBehind = false
			add_child(NewObj)
		"SMG":
			UnitsLeft = 2
			Speed = 25
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 50.0
			NewObj.GunRange = 120
			NewObj.Team = Team
			NewObj.ReloadTime = 0.2
			NewObj.Accuracy = 13
			NewObj.Damage = 0.75
			NewObj.Health = 4.5
			add_child(NewObj)
			NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos2.global_position
			NewObj.pos2go = 2
			NewObj.SPEED = 50.0
			NewObj.GunRange = 120
			NewObj.Team = Team
			NewObj.ReloadTime = 0.2
			NewObj.Accuracy = 13
			NewObj.Damage = 0.75
			NewObj.Health = 3
			add_child(NewObj)
		"Recon":
			UnitsLeft = 1
			Speed = 1
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 50.0
			NewObj.GunRange = 300
			NewObj.Team = Team
			NewObj.ReloadTime = 0.8
			NewObj.Accuracy = 1
			NewObj.Damage = 2
			NewObj.Health = 3
			add_child(NewObj)
		"Infantry":
			UnitsLeft = 3
			Speed = 1
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 50.0
			NewObj.GunRange = 150
			NewObj.Team = Team
			NewObj.ReloadTime = 0.5
			NewObj.Accuracy = 10
			NewObj.Damage = 1
			NewObj.Health = 3
			add_child(NewObj)
			NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos2.global_position
			NewObj.pos2go = 2
			NewObj.SPEED = 50.0
			NewObj.GunRange = 150
			NewObj.Team = Team
			NewObj.ReloadTime = 0.5
			NewObj.Accuracy = 10
			NewObj.Damage = 1
			NewObj.Health = 3
			add_child(NewObj)
			NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos3.global_position
			NewObj.pos2go = 3
			NewObj.SPEED = 50.0
			NewObj.GunRange = 150
			NewObj.Team = Team
			NewObj.ReloadTime = 0.5
			NewObj.Accuracy = 10
			NewObj.Damage = 1
			NewObj.Health = 3
			add_child(NewObj)
	$UnitIcon.animation = (Type + str(Team))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if UnitsLeft <= 0:
		#print(Globals.HoveringOverClickable)
		if PlayerHovering == 1:
			Globals.HoveringOverClickable -= 1
			PlayerHovering = 0
		#print(Globals.HoveringOverClickable)
		queue_free()
	else:
		if Team == 1 and PlayerHovering == 0 and (Globals.MousePos.x >= (global_position.x - 16)) and (Globals.MousePos.x <= (global_position.x + 16)) and (Globals.MousePos.y >= (global_position.y - 16)) and (Globals.MousePos.y <= (global_position.y + 16)):
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			Globals.HoveringOverClickable += 1
			PlayerHovering = 1
		elif Team == 1 and PlayerHovering == 1:
			Globals.HoveringOverClickable -= 1
			PlayerHovering = 0
		if Pursuing != null:
			$NavigationAgent2D.target_desired_distance = 40
			$NavigationAgent2D.target_position = Pursuing.global_position
		else:
			$NavigationAgent2D.target_desired_distance = 8
		if abs(to_global($NavigationAgent2D.get_next_path_position()).x - global_position.x) + abs(to_global($NavigationAgent2D.get_next_path_position()).y - global_position.y) > 6:
			if FarAway > 0 and FirstMove != 1:
				#var posBefore = position
				var dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
				velocity = dir * SPEED
				
				if $NavigationAgent2D.avoidance_enabled:
					$NavigationAgent2D.set_velocity_forced(velocity)
				
				move_and_slide()
			else:
				FirstMove = 0
				var dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
				velocity = dir * SPEED
				
				if $NavigationAgent2D.avoidance_enabled:
					$NavigationAgent2D.set_velocity_forced(velocity)
				
				move_and_slide()
		else:
			$NavigationAgent2D.target_position = position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if PlayerHovering == 1:
			Globals.HoveringOverClickable -= 1
			PlayerHovering = 0
		if (Globals.MousePos.x >= ($UnitIcon.global_position.x - 18)) and (Globals.MousePos.x <= ($UnitIcon.global_position.x + 18)) and (Globals.MousePos.y >= ($UnitIcon.global_position.y - 18)) and (Globals.MousePos.y <= ($UnitIcon.global_position.y + 18)):
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			Globals.HoveringOverClickable += 1
			PlayerHovering = 1
		if Input.is_action_just_pressed("Select") and Team == 1:
			if PlayerHovering == 1:
				if Selected == 0:
					Selected = 1
					$UnitIcon/SelectIcon.visible = true
					if Globals.UnitsSelected.size() > 0:
						for i in range(0,Globals.UnitsSelected.size):
							get_node_or_null(Globals.UnitsSelected[i]).UnSelect()
				else:
					UnSelect()
		if Selected == 1:
			if (event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT):
				GoToPos = Globals.MousePos
				FarAway = 0
				FirstMove = 1
				#print(GoToPos)
				$NavigationAgent2D.target_position = GoToPos
				UnSelect()

func UnSelect():
	Selected = 0
	$UnitIcon/SelectIcon.visible = false
