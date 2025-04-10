extends CharacterBody2D

var GunParticles = preload("res://GunParticles.tscn")
var UnitActor = preload("res://Bullet.tscn")
var DeathParticles = preload("res://DeathParticles.tscn")
var VehicleDeathP = preload("res://VehicleExplosionParticles.tscn")
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
var isVehicle = false

var GunOffsetX = 6
var GunOffsetY = -4
var GunBehind = true
var GunEnd = 10.0
var isBuilding = false

func _ready() -> void:
	$AnimatedSprite2D.animation = Type
	if isBuilding == false or Type == "Bunker1" or Type == "Bunker2":
		$AnimatedSprite2D/GunSprite.animation = Type
	else:
		$AnimatedSprite2D/GunSprite.visible = false
	$ReloadTimer.wait_time = ReloadTime
	$DetectArea/CollisionShape2D.shape = $DetectArea/CollisionShape2D.shape.duplicate()
	$DetectArea/CollisionShape2D.shape.radius = (GunRange)
	match Type:
		"Car1":
			#var NewShape = RectangleShape2D.new()
			#NewShape.set_size(Vector2(54,22))
			var NewShape = CircleShape2D.new()
			NewShape.set_radius(22)
			$CollisionShape2D.shape = NewShape
		"Car2":
			#var NewShape = RectangleShape2D.new()
			#NewShape.set_size(Vector2(54,22))
			var NewShape = CircleShape2D.new()
			NewShape.set_radius(22)
			$CollisionShape2D.shape = NewShape
		"Tank1":
			#var NewShape = RectangleShape2D.new()
			#NewShape.set_size(Vector2(57,20))
			var NewShape = CircleShape2D.new()
			NewShape.set_radius(21)
			$CollisionShape2D.shape = NewShape
		"Tank2":
			#var NewShape = RectangleShape2D.new()
			#NewShape.set_size(Vector2(57,20))
			var NewShape = CircleShape2D.new()
			NewShape.set_radius(21)
			$CollisionShape2D.shape = NewShape
		"MTank1":
			#var NewShape = RectangleShape2D.new()
			#NewShape.set_size(Vector2(54,20))
			var NewShape = CircleShape2D.new()
			NewShape.set_radius(22)
			$CollisionShape2D.shape = NewShape
		"MTank2":
			#var NewShape = RectangleShape2D.new()
			#NewShape.set_size(Vector2(54,20))
			var NewShape = CircleShape2D.new()
			NewShape.set_radius(22)
			$CollisionShape2D.shape = NewShape
		"HTank1":
			#var NewShape = RectangleShape2D.new()
			#NewShape.set_size(Vector2(55,28))
			var NewShape = CircleShape2D.new()
			NewShape.set_radius(28)
			$CollisionShape2D.shape = NewShape
		"HTank2":
			#var NewShape = RectangleShape2D.new()
			#NewShape.set_size(Vector2(55,28))
			var NewShape = CircleShape2D.new()
			NewShape.set_radius(28)
			$CollisionShape2D.shape = NewShape
		"Bunker1":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(32,32))
			$CollisionShape2D.shape = NewShape
		"Bunker2":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(32,32))
			$CollisionShape2D.shape = NewShape
		"Tent1":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(32,32))
			$CollisionShape2D.shape = NewShape
		"Tent2":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(32,32))
			$CollisionShape2D.shape = NewShape
		"MotorPool1":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(32,32))
			$CollisionShape2D.shape = NewShape
		"MotorPool2":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(32,32))
			$CollisionShape2D.shape = NewShape
		"Radio1":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(32,32))
			$CollisionShape2D.shape = NewShape
		"Radio2":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(32,32))
			$CollisionShape2D.shape = NewShape
		"Depot1":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(64,64))
			$CollisionShape2D.shape = NewShape
		"Depot2":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(64,64))
			$CollisionShape2D.shape = NewShape
		"HQ1":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(64,64))
			$CollisionShape2D.shape = NewShape
		"HQ2":
			var NewShape = RectangleShape2D.new()
			NewShape.set_size(Vector2(64,64))
			$CollisionShape2D.shape = NewShape
	$AnimatedSprite2D/GunSprite.position = Vector2(GunOffsetX,GunOffsetY)
	$AnimatedSprite2D/GunSprite.show_behind_parent = GunBehind
	if isVehicle == true:
		$AnimatedSprite2D/GunSprite.scale = Vector2(1.0,1.0)
	else:
		$AnimatedSprite2D/GunSprite.scale = Vector2(0.8,0.8)
	$AnimatedSprite2D/GunSprite/EffectStart.position.x = GunEnd
	#print(GunRange)
	#print($DetectArea/CollisionShape2D.shape.radius)

func _physics_process(delta: float) -> void:
	if Health <= 0:
		get_parent().UnitsLeft -= 1
		if isVehicle == true or isBuilding == true:
			var NewObj = VehicleDeathP.instantiate()
			NewObj.global_position = global_position
			get_parent().get_parent().add_child(NewObj)
		else:
			var NewObj = DeathParticles.instantiate()
			NewObj.global_position = global_position
			get_parent().get_parent().add_child(NewObj)
		queue_free()
	if isBuilding == false:
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
					get_parent().FarAway = 0
				
				var dir = to_local($NavigationAgent2D.get_next_path_position()).normalized()
				if abs($NavigationAgent2D.get_next_path_position().x - LastTar.x) + abs($NavigationAgent2D.get_next_path_position().y - LastTar.y) > 0.9:
					$AnimatedSprite2D.look_at(GoToPos)
					#add sound effect where idling
				LastTar = $NavigationAgent2D.get_next_path_position()
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
				if abs($NavigationAgent2D.get_next_path_position().x - LastTar.x) + abs($NavigationAgent2D.get_next_path_position().y - LastTar.y) > 0.9:
					$AnimatedSprite2D.look_at(GoToPos)
					#add sfx where moving
				#print(EnemyTarget)
				#print(EnemiesNearby)
				if EnemyTarget != null:
					if isVehicle == false:
						$AnimatedSprite2D.look_at(EnemyTarget.global_position)
					else:
						$AnimatedSprite2D/GunSprite.look_at(EnemyTarget.global_position)
					if Reloaded == 1:
						Reloaded = 0
						var NewObj1 = GunParticles.instantiate()
						NewObj1.position = Vector2(0,0)
						$AnimatedSprite2D/GunSprite/EffectStart.add_child(NewObj1)
						var NewObj = UnitActor.instantiate()
						NewObj.position = $AnimatedSprite2D/GunSprite.global_position
						NewObj.SPEED = 700.0
						NewObj.Team = Team
						NewObj.GunRange = GunRange
						# + Vector2(rng.randf_range(-Accuracy,Accuracy),rng.randf_range(-Accuracy,Accuracy))
						#NewObj.dir = to_local(EnemyTarget.global_position).normalized()
						NewObj.dir = (EnemyTarget.global_position - $AnimatedSprite2D/GunSprite.global_position).normalized()
						NewObj.Damage = Damage
						get_parent().get_parent().add_child(NewObj)
						$ReloadTimer.start()
				LastTar = $NavigationAgent2D.get_next_path_position()
				#if abs($NavigationAgent2D.get_next_path_position().x - global_position.x) + abs($NavigationAgent2D.get_next_path_position().y - global_position.y) > 1:
				velocity = dir * SPEED
			"Aggressive":
				if EnemiesNearby.size() > 0:
					if get_parent().Pursuing == null:
						get_parent().Pursuing = GetClosestEnemy()
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
				if abs($NavigationAgent2D.get_next_path_position().x - LastTar.x) + abs($NavigationAgent2D.get_next_path_position().y - LastTar.y) > 0.9:
					$AnimatedSprite2D.look_at(GoToPos)
					#add sfx where moving
				#print(EnemyTarget)
				#print(EnemiesNearby)
				if EnemyTarget != null:
					if isVehicle == false:
						$AnimatedSprite2D.look_at(EnemyTarget.global_position)
					else:
						$AnimatedSprite2D/GunSprite.look_at(EnemyTarget.global_position)
					if Reloaded == 1:
						Reloaded = 0
						var NewObj = UnitActor.instantiate()
						NewObj.position = $AnimatedSprite2D/GunSprite.global_position
						NewObj.SPEED = 700.0
						NewObj.Team = Team
						NewObj.GunRange = GunRange
						# + Vector2(rng.randf_range(-Accuracy,Accuracy),rng.randf_range(-Accuracy,Accuracy))
						NewObj.dir = to_local(EnemyTarget.global_position).normalized()
						NewObj.Damage = Damage
						get_parent().get_parent().add_child(NewObj)
						$ReloadTimer.start()
				LastTar = $NavigationAgent2D.get_next_path_position()
				velocity = dir * SPEED
		move_and_slide()
	else:
		if Type == "Bunker1" or Type == "Bunker2":
			EnemyTarget = null
			if EnemiesNearby.size() > 0:
				EnemyTarget = GetClosestEnemy()
				if EnemyTarget != null:
					$AnimatedSprite2D/GunSprite.look_at(EnemyTarget.global_position)
					if Reloaded == 1:
						Reloaded = 0
						var NewObj = UnitActor.instantiate()
						NewObj.position = $AnimatedSprite2D/GunSprite.global_position
						NewObj.SPEED = 700.0
						NewObj.Team = Team
						NewObj.GunRange = GunRange
						# + Vector2(rng.randf_range(-Accuracy,Accuracy),rng.randf_range(-Accuracy,Accuracy))
						NewObj.dir = to_local(EnemyTarget.global_position).normalized()
						NewObj.Damage = Damage
						get_parent().get_parent().add_child(NewObj)
						$ReloadTimer.start()


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team != Team and EnemiesNearby.find(body) == -1:
			EnemiesNearby.append(body)


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Units"):
		if body.Team != Team and EnemiesNearby.find(body) != -1:
			EnemiesNearby.erase(body)
			if get_parent().Pursuing == body:
				get_parent().Pursuing = null

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
