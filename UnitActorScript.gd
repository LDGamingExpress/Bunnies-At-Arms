extends CharacterBody2D

var GoToPos = global_position
const SPEED = 30.0
var Type = null
var pos2go = null
var FarAway = 0
var LastFar = 1000000000

func _ready() -> void:
	$AnimatedSprite2D.animation = Type

func _physics_process(delta: float) -> void:
	GoToPos = get_parent().get_child(pos2go - 1).global_position
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#print(get_angle_to(GoToPos))
	#print(global_rotation)
	#rotation = lerp_angle(global_rotation,get_angle_to(GoToPos),0.1)
	var Dis = pow(GoToPos.x - global_position.x,2) + pow(GoToPos.y - global_position.y,2)
	if get_parent().FarAway < Dis:
		get_parent().FarAway = Dis
		LastFar = Dis
		#get_parent().FarAwayFrom = name
	if get_parent().FarAway == LastFar and get_parent().FarAway > Dis:
		get_parent().FarAway = Dis
	look_at(GoToPos)
	if pow((GoToPos.x - global_position.x),2) + pow((GoToPos.y - global_position.y),2) > 50:
		velocity = SPEED * (GoToPos - global_position).normalized()
	move_and_slide()
	velocity = Vector2(0,0)
