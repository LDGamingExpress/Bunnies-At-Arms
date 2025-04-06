extends CharacterBody2D


const SPEED = 300.0
var SelectionStarted = false
var SelectionStartPos = null
@onready var SelectionSquare = $Sprite2D
var PossibleSelections = []

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("Down"):
		velocity.y += SPEED
	if Input.is_action_pressed("Left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("Right"):
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
		if body.Team == 1 and PossibleSelections.find(body) == -1:
			PossibleSelections.append(body.get_parent())


func _on_selection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team == 1 and PossibleSelections.find(body) != -1:
			PossibleSelections.erase(body.get_parent())
