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
var Actors = []
var isBuilding = false
var isVehicle = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	match Type:
		"HQ":
			UnitsLeft = 1
			SPEED = 0.0
			isBuilding = true
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos5.global_position
			NewObj.pos2go = 5
			NewObj.SPEED = 0.0
			NewObj.GunRange = 0
			NewObj.Team = Team
			NewObj.ReloadTime = 0.1
			NewObj.Accuracy = 15
			NewObj.Damage = 1.2
			NewObj.Health = 60
			NewObj.GunEnd = 15.0
			NewObj.GunOffsetX = 0
			NewObj.GunOffsetY = 0
			NewObj.isBuilding = true
			add_child(NewObj)
			Actors.append(get_child(7))
		"Depot":
			UnitsLeft = 1
			SPEED = 0.0
			isBuilding = true
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos5.global_position
			NewObj.pos2go = 5
			NewObj.SPEED = 0.0
			NewObj.GunRange = 0
			NewObj.Team = Team
			NewObj.ReloadTime = 0.1
			NewObj.Accuracy = 15
			NewObj.Damage = 1.2
			NewObj.Health = 40
			NewObj.GunEnd = 15.0
			NewObj.GunOffsetX = 0
			NewObj.GunOffsetY = 0
			NewObj.isBuilding = true
			add_child(NewObj)
			Actors.append(get_child(7))
		"Radio":
			UnitsLeft = 1
			SPEED = 0.0
			isBuilding = true
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos5.global_position
			NewObj.pos2go = 5
			NewObj.SPEED = 0.0
			NewObj.GunRange = 0
			NewObj.Team = Team
			NewObj.ReloadTime = 0.1
			NewObj.Accuracy = 15
			NewObj.Damage = 1.2
			NewObj.Health = 25
			NewObj.GunEnd = 15.0
			NewObj.GunOffsetX = 0
			NewObj.GunOffsetY = 0
			NewObj.isBuilding = true
			add_child(NewObj)
			Actors.append(get_child(7))
		"MotorPool":
			UnitsLeft = 1
			SPEED = 0.0
			isBuilding = true
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos5.global_position
			NewObj.pos2go = 5
			NewObj.SPEED = 0.0
			NewObj.GunRange = 0
			NewObj.Team = Team
			NewObj.ReloadTime = 0.1
			NewObj.Accuracy = 15
			NewObj.Damage = 1.2
			NewObj.Health = 25
			NewObj.GunEnd = 15.0
			NewObj.GunOffsetX = 0
			NewObj.GunOffsetY = 0
			NewObj.isBuilding = true
			add_child(NewObj)
			Actors.append(get_child(7))
		"Tent":
			UnitsLeft = 1
			SPEED = 0.0
			isBuilding = true
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos5.global_position
			NewObj.pos2go = 5
			NewObj.SPEED = 0.0
			NewObj.GunRange = 0
			NewObj.Team = Team
			NewObj.ReloadTime = 0.1
			NewObj.Accuracy = 15
			NewObj.Damage = 1.2
			NewObj.Health = 25
			NewObj.GunEnd = 15.0
			NewObj.GunOffsetX = 0
			NewObj.GunOffsetY = 0
			NewObj.isBuilding = true
			add_child(NewObj)
			Actors.append(get_child(7))
		"Bunker":
			UnitsLeft = 1
			SPEED = 0.0
			isBuilding = true
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos5.global_position
			NewObj.pos2go = 5
			NewObj.SPEED = 0.0
			NewObj.GunRange = 150
			NewObj.Team = Team
			NewObj.ReloadTime = 0.1
			NewObj.Accuracy = 15
			NewObj.Damage = 1.2
			NewObj.Health = 35
			NewObj.GunEnd = 15.0
			NewObj.GunOffsetX = 0
			NewObj.GunOffsetY = 0
			NewObj.isBuilding = true
			add_child(NewObj)
			Actors.append(get_child(7))
		"MG":
			UnitsLeft = 1
			SPEED = 40.0
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 40.0
			NewObj.GunRange = 170
			NewObj.Team = Team
			NewObj.ReloadTime = 0.1
			NewObj.Accuracy = 15
			NewObj.Damage = 1.2
			NewObj.Health = 5
			NewObj.GunEnd = 15.0
			add_child(NewObj)
			Actors.append(get_child(7))
		"Eng":
			UnitsLeft = 2
			SPEED = 50
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 50.0
			NewObj.GunRange = 100
			NewObj.Team = Team
			NewObj.ReloadTime = 0.08
			NewObj.Accuracy = 8
			NewObj.Damage = 0.8
			NewObj.Health = 4
			NewObj.GunEnd = 15.0
			add_child(NewObj)
			NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos2.global_position
			NewObj.pos2go = 2
			NewObj.SPEED = 50.0
			NewObj.GunRange = 50
			NewObj.Team = Team
			NewObj.ReloadTime = 0.08
			NewObj.Accuracy = 8
			NewObj.Damage = 0.8
			NewObj.Health = 4
			NewObj.GunEnd = 15.0
			add_child(NewObj)
			Actors.append(get_child(7))
			Actors.append(get_child(8))
		"HTank":
			UnitsLeft = 1
			SPEED = 45
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 45.0
			NewObj.GunRange = 310
			NewObj.Team = Team
			NewObj.ReloadTime = 2.5
			NewObj.Accuracy = 10
			NewObj.Damage = 15
			NewObj.Health = 80
			NewObj.GunOffsetX = -2
			NewObj.GunOffsetY = 0
			NewObj.GunEnd = 61.0
			NewObj.isVehicle = true
			NewObj.GunBehind = false
			add_child(NewObj)
			Actors.append(get_child(7))
			isVehicle = true
		"MTank":
			UnitsLeft = 1
			SPEED = 68
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 68.0
			NewObj.GunRange = 300
			NewObj.Team = Team
			NewObj.ReloadTime = 1.5
			NewObj.Accuracy = 10
			NewObj.Damage = 8
			NewObj.Health = 40
			NewObj.GunOffsetX = 3
			NewObj.GunOffsetY = 0
			NewObj.GunEnd = 42.0
			NewObj.isVehicle = true
			NewObj.GunBehind = false
			add_child(NewObj)
			Actors.append(get_child(7))
			isVehicle = true
		"Tank":
			UnitsLeft = 1
			SPEED = 60
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 60.0
			NewObj.GunRange = 250
			NewObj.Team = Team
			NewObj.ReloadTime = 1
			NewObj.Accuracy = 10
			NewObj.Damage = 5
			NewObj.Health = 25
			NewObj.GunOffsetX = 4
			NewObj.GunOffsetY = -0.5
			NewObj.GunEnd = 16.0
			NewObj.isVehicle = true
			NewObj.GunBehind = false
			add_child(NewObj)
			Actors.append(get_child(7))
			isVehicle = true
		"Car":
			UnitsLeft = 1
			SPEED = 100
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 100.0
			NewObj.GunRange = 180
			NewObj.Team = Team
			NewObj.ReloadTime = 0.2
			NewObj.Accuracy = 10
			NewObj.Damage = 1
			NewObj.Health = 15
			NewObj.GunOffsetX = -13
			NewObj.GunOffsetY = -0.5
			NewObj.GunEnd = 16.0
			NewObj.isVehicle = true
			NewObj.GunBehind = false
			add_child(NewObj)
			Actors.append(get_child(7))
			isVehicle = true
		"SMG":
			UnitsLeft = 2
			SPEED = 68
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 68.0
			NewObj.GunRange = 120
			NewObj.Team = Team
			NewObj.ReloadTime = 0.2
			NewObj.Accuracy = 13
			NewObj.Damage = 0.75
			NewObj.Health = 4.5
			NewObj.GunEnd = 15.0
			add_child(NewObj)
			NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos2.global_position
			NewObj.pos2go = 2
			NewObj.SPEED = 68.0
			NewObj.GunRange = 120
			NewObj.Team = Team
			NewObj.ReloadTime = 0.2
			NewObj.Accuracy = 13
			NewObj.Damage = 0.75
			NewObj.Health = 4.5
			NewObj.GunEnd = 15.0
			add_child(NewObj)
			Actors.append(get_child(7))
			Actors.append(get_child(8))
		"Rocket":
			UnitsLeft = 1
			SPEED = 45.0
			var NewObj = UnitActor.instantiate()
			NewObj.Type = (Type + str(Team))
			NewObj.position = $Pos1.global_position
			NewObj.pos2go = 1
			NewObj.SPEED = 45.0
			NewObj.GunRange = 280
			NewObj.Team = Team
			NewObj.ReloadTime = 1.8
			NewObj.Accuracy = 5
			NewObj.Damage = 10
			NewObj.Health = 3
			NewObj.GunEnd = 15.0
			add_child(NewObj)
			Actors.append(get_child(7))
		"Recon":
			UnitsLeft = 1
			SPEED = 50.0
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
			NewObj.GunEnd = 15.0
			add_child(NewObj)
			Actors.append(get_child(7))
		"Infantry":
			UnitsLeft = 3
			SPEED = 50.0
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
			NewObj.GunEnd = 15.0
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
			NewObj.GunEnd = 15.0
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
			NewObj.GunEnd = 15.0
			add_child(NewObj)
			Actors.append(get_child(7))
			Actors.append(get_child(8))
			Actors.append(get_child(9))
	$UnitIcon.animation = (Type + str(Team))
	#print($NavigationAgent2D.navigation_layers)
	if isVehicle == true:
		$NavigationAgent2D.navigation_layers = 2

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
		if Selected == 1:
			if Globals.UnitsSelected.size() > 1 and isBuilding == true:
				print(Globals.UnitsSelected)
				print("Unselecting")
				UnSelect()
		if Team == 1 and PlayerHovering == 0 and (Globals.MousePos.x >= ($UnitIcon.global_position.x - 16)) and (Globals.MousePos.x <= ($UnitIcon.global_position.x + 16)) and (Globals.MousePos.y >= ($UnitIcon.global_position.y - 16)) and (Globals.MousePos.y <= ($UnitIcon.global_position.y + 16)):
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
		#if Type == "Car":
		#	print(sqrt(pow($NavigationAgent2D.get_next_path_position().x - global_position.x,2) + pow($NavigationAgent2D.get_next_path_position().y - global_position.y,2)))
		if abs($NavigationAgent2D.get_next_path_position().x - global_position.x) + abs($NavigationAgent2D.get_next_path_position().y - global_position.y) > 1 and isBuilding == false:
			if FarAway > 20 and FirstMove != 1:
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
		if isBuilding == false:
			var MaxDis = 0
			var AvailableActor = null
			for i in range(0,Actors.size()):
				if Actors[i] != null:
					var ActorDis = sqrt(pow(Actors[i].global_position.x - global_position.x,2)+pow(Actors[i].global_position.y - global_position.y,2))
					if ActorDis > MaxDis:
						MaxDis = ActorDis
						AvailableActor = Actors[i]
			if MaxDis <= 30:
				$UnitIcon.global_position = global_position
			else:
				$UnitIcon.global_position = lerp($UnitIcon.global_position,AvailableActor.global_position,0.5)
		else:
			$UnitIcon.global_position = global_position + Vector2(0,-32)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if PlayerHovering == 1:
			#Globals.HoveringOverClickable -= 1
			PlayerHovering = 0
			if Globals.EnemySelectable == self:
				Globals.EnemySelectable = null
			else:
				Globals.HoveringOverClickable -= 1
		if (Globals.MousePos.x >= ($UnitIcon.global_position.x - 18)) and (Globals.MousePos.x <= ($UnitIcon.global_position.x + 18)) and (Globals.MousePos.y >= ($UnitIcon.global_position.y - 18)) and (Globals.MousePos.y <= ($UnitIcon.global_position.y + 18)):
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			#Globals.HoveringOverClickable += 1
			PlayerHovering = 1
			if Team != 1:
				Globals.EnemySelectable = self
			else:
				Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
				Globals.HoveringOverClickable += 1
		if Input.is_action_just_pressed("Select") and Team == 1:
			if PlayerHovering == 1:
				if Selected == 0:
					Selected = 1
					$UnitIcon/SelectIcon.visible = true
					if Globals.UnitsSelected.size() > 0:
						for i in range(0,Globals.UnitsSelected.size()):
							if Globals.UnitsSelected[i] != null:
								Globals.UnitsSelected[i].UnSelect()
						Globals.UnitsSelected = []
					await get_tree().create_timer(0.11).timeout
					Globals.UnitsSelected.append(self)
				else:
					UnSelect()
			elif Selected == 1:
				UnSelect()
		if Selected == 1:
			if (event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT) and isBuilding == false:
				var IndexInList = Globals.UnitsSelected.find(self) + 1
				var ListLength = Globals.UnitsSelected.size() + 1
				if ListLength == 1:
					GoToPos = Globals.MousePos
				else:
					#if ListLength % 2 == 0:
					GoToPos = Globals.MousePos - (ListLength/2 - IndexInList)*Vector2(20,-20)
				FarAway = 0
				FirstMove = 1
				#print(GoToPos)
				$NavigationAgent2D.target_position = GoToPos
				if Globals.EnemySelectable != null:
					Pursuing = Globals.EnemySelectable
				UnSelect()

func UnSelect():
	Selected = 0
	$UnitIcon/SelectIcon.visible = false
	var IndexInList = Globals.UnitsSelected.find(self)
	if IndexInList != -1:
		Globals.UnitsSelected.remove_at(IndexInList)

func Select():
	Selected = 1
	$UnitIcon/SelectIcon.visible = true

func SetTarget():
	$NavigationAgent2D.target_position = GoToPos
