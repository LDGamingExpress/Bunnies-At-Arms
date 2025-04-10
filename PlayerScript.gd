extends CharacterBody2D


const SPEED = 300.0
var SelectionStarted = false
var SelectionStartPos = null
@onready var SelectionSquare = $Sprite2D
var PossibleSelections = []

func _physics_process(delta: float) -> void:
	
	# UI Update Code:
	$Camera2D/CanvasLayer/HBoxContainer/PanelContainer/BPLabel.text = "BunnyPower:\n" + str(Globals.BunnyPower[0])
	$Camera2D/CanvasLayer/HBoxContainer/PanelContainer2/MunitionsLabel.text = "Munitions:\n" + str(Globals.Munitions[0])
	$Camera2D/CanvasLayer/HBoxContainer/PanelContainer3/FuelLabel.text = "Fuel:\n" + str(Globals.Fuel[0])
	
	
	# End of UI Update Code
	#print("Mouse:")
	#print(Globals.MousePos.y)
	#print("Size:")
	print(get_viewport().size.y/2*0.95)
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
