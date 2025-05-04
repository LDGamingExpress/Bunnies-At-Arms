extends Node2D
var UnitObj = preload("res://UnitObj.tscn")
@export var UnitType = "Inf"
@export var Team = 1
@export var WaveTime = 2.5
@export var IncreasingWaves = false
@export var UnitAmount = 1
var WavesDone = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = WaveTime
	MakeUnit()

func _on_timer_timeout() -> void:
	MakeUnit()
	WavesDone += 1

func MakeUnit():
	if IncreasingWaves == true:
		if WavesDone/3 == ceil(WavesDone/3):
			UnitAmount += 1
	for i in range(0,UnitAmount):
		var NewObj = UnitObj.instantiate()
		NewObj.global_position = global_position + Vector2(rng.randf_range(-60,60),rng.randf_range(-60,60))
		NewObj.Type = UnitType
		NewObj.Team = Team
		get_parent().add_child(NewObj)
