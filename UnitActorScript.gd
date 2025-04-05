extends CharacterBody2D

var UnitActor = preload("res://Bullet.tscn")
var GoToPos = global_position
var SPEED = 50.0
var Type = null
var pos2go = null
var FarAway = 0
var LastFar = 1000000000
var LastTar = global_position
var GunRange = 150
var EnemiesNearby = []
var Team = null
var State = "Standing" # Standing, Moving, Attacking
var EnemyTarget = null
var ReloadTime = 0.5
var Reloaded = 1
var Accuracy = 10
var Damage = 1
var Health = 3
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$AnimatedSprite2D.animation = Type
	$ReloadTimer.wait_time = ReloadTime

func _physics_process(delta: float) -> void:
	if Health <= 0:
		get_parent().UnitsLeft -= 1
		queue_free()
	match get_parent().Behavior:
		"Passive":
			if get_parent().get_child(pos2go).global_position != GoToPos:
				GoToPos = get_parent().get_child(pos2go).global_position
				$NavigationAgent2D.target_position = GoToPos

			var Dis = pow(GoToPos.x - global_position.x,2) + pow(GoToPos.y - global_position.y,2)
			if get_parent().FarAway < Dis:
				get_parent().FarAway = Dis
				LastFar = Dis
				#get_parent().FarAwayFrom = name
			if get_parent().FarAway == LastFar and get_parent().FarAway > Dis:
				get_parent().FarAway = Dis
			
			var dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
			if abs(to_global($NavigationAgent2D.get_next_path_position()).x - LastTar.x) + abs(to_global($NavigationAgent2D.get_next_path_position()).y - LastTar.y) > 2:
				$AnimatedSprite2D.look_at(GoToPos)
			LastTar = to_global($NavigationAgent2D.get_next_path_position())
			velocity = dir * SPEED
		"Defensive":
			if get_parent().get_child(pos2go).global_position != GoToPos:
				GoToPos = get_parent().get_child(pos2go).global_position
				$NavigationAgent2D.target_position = GoToPos

			var Dis = pow(GoToPos.x - global_position.x,2) + pow(GoToPos.y - global_position.y,2)
			if get_parent().FarAway < Dis:
				get_parent().FarAway = Dis
				LastFar = Dis
				#get_parent().FarAwayFrom = name
			if get_parent().FarAway == LastFar and get_parent().FarAway > Dis:
				get_parent().FarAway = Dis
			
			EnemyTarget = null
			if EnemiesNearby.size() > 0:
				EnemyTarget = GetClosestEnemy()
			
			var dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
			if abs(to_global($NavigationAgent2D.get_next_path_position()).x - LastTar.x) + abs(to_global($NavigationAgent2D.get_next_path_position()).y - LastTar.y) > 2:
				$AnimatedSprite2D.look_at(GoToPos)
			#print(EnemyTarget)
			#print(EnemiesNearby)
			if EnemyTarget != null:
				$AnimatedSprite2D.look_at(EnemyTarget.global_position)
				if Reloaded == 1:
					Reloaded = 0
					var NewObj = UnitActor.instantiate()
					NewObj.position = $AnimatedSprite2D/GunSprite.global_position
					NewObj.SPEED = 700.0
					NewObj.Team = Team
					# + Vector2(rng.randf_range(-Accuracy,Accuracy),rng.randf_range(-Accuracy,Accuracy))
					NewObj.dir = to_local(EnemyTarget.global_position).normalized()
					NewObj.Damage = Damage
					get_parent().get_parent().add_child(NewObj)
					$ReloadTimer.start()
			LastTar = to_global($NavigationAgent2D.get_next_path_position())
			velocity = dir * SPEED
	move_and_slide()


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team != Team and EnemiesNearby.find(body) == -1:
			EnemiesNearby.append(body)


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team != Team and EnemiesNearby.find(body) != -1:
			EnemiesNearby.erase(body)

func GetClosestEnemy():
	var ClosestDis = 1000000000
	var ClosestEnemy = null
	var Enemies2Erase = []
	for i in range(0,EnemiesNearby.size()):
		if EnemiesNearby[i] != null:
			var EnemyPos = EnemiesNearby[i].global_position
			if pow(EnemyPos.x - global_position.x,2) + pow(EnemyPos.y - global_position.y,2) < ClosestDis:
				ClosestDis = pow(EnemyPos.x - global_position.x,2) + pow(EnemyPos.y - global_position.y,2)
				ClosestEnemy = EnemiesNearby[i]
		else:
			Enemies2Erase.append(EnemiesNearby[i])
	for a in range(0,Enemies2Erase.size()):
		ClosestEnemy.erase(Enemies2Erase[a])
	return(ClosestEnemy)

func _on_reload_timer_timeout() -> void:
	Reloaded = 1
