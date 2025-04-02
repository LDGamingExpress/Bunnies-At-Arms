extends AnimatedSprite2D
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Type == "Infantry":
		Speed = 1
		var NewObj = UnitActor.instantiate()
		NewObj.Type = (Type + str(Team))
		NewObj.position = $Pos1.position
		NewObj.pos2go = 1
		add_child(NewObj)
		NewObj = UnitActor.instantiate()
		NewObj.Type = (Type + str(Team))
		NewObj.position = $Pos2.position
		NewObj.pos2go = 2
		add_child(NewObj)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(FarAway)
	#print(Globals.MousePos.x)
	#print(global_position.x)
	if PlayerHovering == 0 and (Globals.MousePos.x >= (global_position.x - 16)) and (Globals.MousePos.x <= (global_position.x + 16)) and (Globals.MousePos.y >= (global_position.y - 16)) and (Globals.MousePos.y <= (global_position.y + 16)):
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		Globals.HoveringOverClickable += 1
		PlayerHovering = 1
	elif PlayerHovering == 1:
		Globals.HoveringOverClickable -= 1
		PlayerHovering = 0
	if FarAway > 0 and FirstMove != 1:
		#var posBefore = position
		if GoToPos.x > global_position.x:
			position.x += 1*(log(400/FarAway))
		if GoToPos.x < global_position.x:
			position.x -= 1*(log(400/FarAway))
		if GoToPos.y > global_position.y:
			position.y += 1*(log(400/FarAway))
		if GoToPos.y < global_position.y:
			position.y -= 1*(log(400/FarAway))
	else:
		FirstMove = 0
		if GoToPos.x > global_position.x:
			position.x += 1
		if GoToPos.x < global_position.x:
			position.x -= 1
		if GoToPos.y > global_position.y:
			position.y += 1
		if GoToPos.y < global_position.y:
			position.y -= 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
			if PlayerHovering == 0 and (Globals.MousePos.x >= ($SelectIcon.global_position.x - 16)) and (Globals.MousePos.x <= ($SelectIcon.global_position.x + 16)) and (Globals.MousePos.y >= ($SelectIcon.global_position.y - 16)) and (Globals.MousePos.y <= ($SelectIcon.global_position.y + 16)):
				Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
				Globals.HoveringOverClickable += 1
				PlayerHovering = 1
			elif PlayerHovering == 1:
				Globals.HoveringOverClickable -= 1
				PlayerHovering = 0
			if PlayerHovering == 1:
				if Selected == 0:
					Selected = 1
					$SelectIcon.visible = true
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
				print(GoToPos)
				UnSelect()

func UnSelect():
	Selected = 0
	$SelectIcon.visible = false
