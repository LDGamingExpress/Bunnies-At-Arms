extends CharacterBody2D

@onready var GrenadeObj = preload("res://Grenade.tscn")
const SPEED = 300.0
var SelectionStarted = false
var SelectionStartPos = null
@onready var SelectionSquare = $Sprite2D
var PossibleSelections = []
var AbilityUse = false
var AbilityRange = 100
var AllowAbility = false
var AbilityRadius = 30
var AbilitySelected = null
var UnitWAbility = null
var LandMines = []

func _physics_process(delta: float) -> void:
	
	# UI Update Code:
	$Camera2D/CanvasLayer/HBoxContainer/PanelContainer/BPLabel.text = "BunnyPower:\n" + str(Globals.BunnyPower[0])
	$Camera2D/CanvasLayer/HBoxContainer/PanelContainer2/MunitionsLabel.text = "Munitions:\n" + str(Globals.Munitions[0])
	$Camera2D/CanvasLayer/HBoxContainer/PanelContainer3/FuelLabel.text = "Fuel:\n" + str(Globals.Fuel[0])
	
	
	# End of UI Update Code
	
	#print(Globals.UnitsSelected)
	if Input.is_action_just_pressed("Select") and AbilityUse == true:
		if AllowAbility:
			var dis = sqrt(pow(Globals.MousePos.x - UnitWAbility.global_position.x,2) + pow(Globals.MousePos.y - UnitWAbility.global_position.y,2))
			match AbilitySelected:
				'Grenade':
					if Globals.GrenadeCost <= Globals.Munitions[0]:
						var NewObj = GrenadeObj.instantiate()
						NewObj.position = UnitWAbility.global_position
						NewObj.SPEED = 500.0
						NewObj.Team = 1
						NewObj.GunRange = dis
						# + Vector2(rng.randf_range(-Accuracy,Accuracy),rng.randf_range(-Accuracy,Accuracy))
						NewObj.dir = UnitWAbility.to_local(Globals.MousePos).normalized()
						NewObj.Damage = 4
						get_parent().add_child(NewObj)
						Globals.UnitPanelShow = null
						Globals.CurrentUnitIndex = null
						AbilityUse = false
						$AbilitySprite.visible = false
						Globals.Munitions[0] -= Globals.GrenadeCost
				'Satchel Charge':
					if Globals.SatchelCost <= Globals.Munitions[0]:
						var NewObj = GrenadeObj.instantiate()
						NewObj.position = UnitWAbility.global_position
						NewObj.SPEED = 200.0
						NewObj.Team = 1
						NewObj.GunRange = dis
						# + Vector2(rng.randf_range(-Accuracy,Accuracy),rng.randf_range(-Accuracy,Accuracy))
						NewObj.dir = UnitWAbility.to_local(Globals.MousePos).normalized()
						NewObj.Damage = 50
						get_parent().add_child(NewObj)
						Globals.UnitPanelShow = null
						Globals.CurrentUnitIndex = null
						AbilityUse = false
						$AbilitySprite.visible = false
						Globals.Munitions[0] -= Globals.SatchelCost
				'Minesweep':
					if Globals.MinesweepCost <= Globals.BunnyPower[0]:
						Globals.BunnyPower[0] -= Globals.MinesweepCost
						#print(LandMines)
						for i in range(0,LandMines.size()):
							if LandMines[i] != null:
								LandMines[i].queue_free()
						Globals.UnitPanelShow = null
						Globals.CurrentUnitIndex = null
						AbilityUse = false
						$AbilitySprite.visible = false
	
	if Globals.UnitsSelected.size() == 1:
		if Globals.UnitsSelected[0] != null:
			var ToSelect = Globals.UnitsSelected[0].Type
			ToSelect.left(ToSelect.length() - 1)
			Globals.UnitPanelShow = ToSelect
			Globals.CurrentUnitIndex = Globals.UnitTypeMatch.find(ToSelect)
			UnitWAbility = Globals.UnitsSelected[0]
		else:
			Globals.UnitPanelShow = null
			Globals.CurrentUnitIndex = null
			AbilityUse = false
			$AbilitySprite.visible = false
	else:
		Globals.UnitPanelShow = null
		Globals.CurrentUnitIndex = null
		AbilityUse = false
		$AbilitySprite.visible = false
	
	if Globals.UnitPanelShow != null:
		for i in range(0,Globals.UnitAbilities[Globals.CurrentUnitIndex].size()):
			match Globals.UnitAbilities[Globals.CurrentUnitIndex][i]:
				'Grenade':
					if Input.is_action_just_pressed("Ability1"):
						if AbilityUse == true:
							AbilityUse = false
							$AbilitySprite.visible = false
							AbilitySelected = null
						elif Globals.GrenadeCost <= Globals.Munitions[0]:
							AbilityUse = true
							$AbilitySprite.visible = true
							AbilityRange = 200
							AbilityRadius = 30.0
							AbilitySelected = 'Grenade'
							$AbilitySprite.scale = Vector2(AbilityRadius/60.0,AbilityRadius/60.0)
				'Satchel Charge':
					if Input.is_action_just_pressed("Ability1"):
						if AbilityUse == true:
							AbilityUse = false
							$AbilitySprite.visible = false
							AbilitySelected = null
						elif Globals.SatchelCost <= Globals.Munitions[0]:
							AbilityUse = true
							$AbilitySprite.visible = true
							AbilityRange = 150
							AbilityRadius = 40.0
							AbilitySelected = 'Satchel Charge'
							$AbilitySprite.scale = Vector2(AbilityRadius/60.0,AbilityRadius/60.0)
				'Minesweep':
					if Input.is_action_just_pressed("Ability1"):
						if AbilityUse == true:
							AbilityUse = false
							$AbilitySprite.visible = false
							AbilitySelected = null
						elif Globals.MinesweepCost <= Globals.BunnyPower[0]:
							LandMines = []
							AbilityUse = true
							$AbilitySprite.visible = true
							AbilityRange = 150
							AbilityRadius = 30.0
							AbilitySelected = 'Minesweep'
							$AbilitySprite.scale = Vector2(AbilityRadius/60.0,AbilityRadius/60.0)
	if AbilityUse == true:
		$AbilitySprite.global_position = Globals.MousePos
		if sqrt(pow(Globals.MousePos.x - Globals.UnitsSelected[0].global_position.x,2) + pow(Globals.MousePos.y - Globals.UnitsSelected[0].global_position.y,2)) <= AbilityRange:
			AllowAbility = true
			$AbilitySprite.self_modulate = Color8(0,255,0,255)
		else:
			AllowAbility = false
			$AbilitySprite.self_modulate = Color8(255,0,0,255)
	if Input.is_action_pressed("Up") or (get_local_mouse_position().y <= -get_viewport().size.y/2*0.95/$Camera2D.zoom.x):
		velocity.y -= SPEED
	if Input.is_action_pressed("Down") or (get_local_mouse_position().y >= get_viewport().size.y/2*0.95/$Camera2D.zoom.x):
		velocity.y += SPEED
	if Input.is_action_pressed("Left") or (get_local_mouse_position().x <= -get_viewport().size.x/2*0.95/$Camera2D.zoom.x):
		velocity.x -= SPEED
	if Input.is_action_pressed("Right") or (get_local_mouse_position().x >= get_viewport().size.x/2*0.95/$Camera2D.zoom.x):
		velocity.x += SPEED
	if Input.is_action_just_released("ZoomIn"):
		$Camera2D.zoom += Vector2(0.1,0.1)
	if Input.is_action_just_released("ZoomOut"):
		if $Camera2D.zoom.x > 0.1:
			$Camera2D.zoom -= Vector2(0.1,0.1)
	move_and_slide()
	velocity = Vector2(0,0)
	
	if Input.is_action_pressed("Select"):
		if SelectionStarted == false:
			SelectionStarted = true
			SelectionSquare.scale = Vector2(1/19,1/19)
			SelectionSquare.global_position = Globals.MousePos
			SelectionStartPos = Globals.MousePos
			SelectionSquare.visible = true
		else:
			var SelectionDis = Vector2(Globals.MousePos.x - SelectionStartPos.x,Globals.MousePos.y - SelectionStartPos.y)
			SelectionSquare.global_position = SelectionDis/2 + SelectionStartPos
			SelectionSquare.scale = Vector2(abs(SelectionDis.x)/19,abs(SelectionDis.y)/19)
	if Input.is_action_just_released("Select"):
		if Globals.UnitsSelected.size() > 0:
			for i in range(0,Globals.UnitsSelected.size()):
				if Globals.UnitsSelected[i] != null:
					Globals.UnitsSelected[i].UnSelect()
			Globals.UnitsSelected = []
		for i in range(0,PossibleSelections.size()):
			Globals.UnitsSelected.append(PossibleSelections[i])
			PossibleSelections[i].Select()
		$Sprite2D.visible = false
		SelectionStarted = false
		PossibleSelections = []


func _on_selection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team == 1 and PossibleSelections.find(body.get_parent()) == -1:
			PossibleSelections.append(body.get_parent())


func _on_selection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team == 1 and PossibleSelections.find(body.get_parent()) != -1:
			PossibleSelections.erase(body.get_parent())
		#print("left")


func _on_ability_area_area_entered(area: Area2D) -> void:
	#print(area.get_groups())
	if area.get_parent().is_in_group("Landmines") and AbilitySelected == 'Minesweep':
		if area.get_parent().Team != 1:
			LandMines.append(area.get_parent())


func _on_ability_area_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Landmines") and AbilitySelected == 'Minesweep':
		if area.get_parent().Team != 1:
			if LandMines.find(area.get_parent()) != -1:
				LandMines.erase(area.get_parent())
