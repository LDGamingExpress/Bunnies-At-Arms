extends Node
var MousePos = Vector2 (0,0)
var HoveringOverClickable = 0
var EnemySelectable = null
var UnitsSelected = []

var Fuel = [10,10]
var BunnyPower = [10,10]
var Munitions = [10,10]
var TeamColors = [[61, 204, 92],[204, 66, 61]]
# Infantry, 

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(UnitsSelected)
	if HoveringOverClickable <= 0:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
#	MousePos = get_viewport().get_global_mouse_position()
