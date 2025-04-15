extends Node

@onready var GrenadeObj = preload("res://Grenade.tscn")
@onready var UnitObj = preload("res://UnitObj.tscn")
@onready var LandMineObj = preload("res://LandMines.tscn")
var Troops = []
var Buildings = []
var Engineers = []
var hasHQ = []
var hasTent = []
var hasMotorPool = []
var hasDepot = []
var hasRadio = []
var Enemies = []
var EnemyBuildings = []
var rng = RandomNumberGenerator.new()

var ResourcePoints = []
var VictoryPoints = []
var DefensePoints = []
@export var Team = 2

var Focus = "Resources"
# Resources - Focus on taking resource points
# Victory - Focus on achieving victory conditions
# Unit Production - Focus on producing units and not engaging too much
# Base Destruction - Focus on destroying enemy buildings
# Elimination - Sends units to attack nearest enemies (units and buildings)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_parent().get_children():
		if child.is_in_group("ControlPoints"):
			if child.ResourceType == "Victory Points":
				VictoryPoints.append(child)
			else:
				ResourcePoints.append(child)
		if child.is_in_group("DefensePoints"):
			DefensePoints.append(child)
	_on_enemy_d_timer_timeout()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_enemy_d_timer_timeout() -> void:
	#print(Focus)
	Troops = []
	Buildings = []
	Engineers = []
	hasHQ = []
	hasTent = []
	hasMotorPool = []
	hasDepot = []
	hasRadio = []
	Enemies = []
	EnemyBuildings = []
	for child in get_parent().get_children():
		if child.is_in_group("Units"):
			if child.Team == Team:
				match child.Type:
					'Infantry':
						Troops.append(child)
					'Rocket':
						Troops.append(child)
					'Recon':
						Troops.append(child)
					'SMG':
						Troops.append(child)
					'MG':
						Troops.append(child)
					'Eng':
						Troops.append(child)
						Engineers.append(child)
					'Car':
						Troops.append(child)
					'Tank':
						Troops.append(child)
					'MTank':
						Troops.append(child)
					'HTank':
						Troops.append(child)
					'Tent':
						Buildings.append(child)
						hasTent.append(child)
					'HQ':
						Buildings.append(child)
						hasHQ.append(child)
					'MotorPool':
						Buildings.append(child)
						hasMotorPool.append(child)
					'Depot':
						Buildings.append(child)
						hasDepot.append(child)
					'Radio':
						Buildings.append(child)
						hasRadio.append(child)
					'Bunker':
						Buildings.append(child)
			else:
				match child.Type:
					'Infantry':
						Enemies.append(child)
					'Rocket':
						Enemies.append(child)
					'Recon':
						Enemies.append(child)
					'SMG':
						Enemies.append(child)
					'MG':
						Enemies.append(child)
					'Eng':
						Enemies.append(child)
					'Car':
						Enemies.append(child)
					'Tank':
						Enemies.append(child)
					'MTank':
						Enemies.append(child)
					'HTank':
						Enemies.append(child)
					'Tent':
						EnemyBuildings.append(child)
						Enemies.append(child)
					'HQ':
						EnemyBuildings.append(child)
						Enemies.append(child)
					'MotorPool':
						EnemyBuildings.append(child)
						Enemies.append(child)
					'Depot':
						EnemyBuildings.append(child)
						Enemies.append(child)
					'Radio':
						EnemyBuildings.append(child)
						Enemies.append(child)
					'Bunker':
						EnemyBuildings.append(child)
						Enemies.append(child)
				Enemies.append(child)
	match Globals.GameMode:
		'Victory Points':
			if Troops.size() >= (Enemies.size() - EnemyBuildings.size())*1.8:
				Focus = "Elimination"
			elif Troops.size() >= (Enemies.size() - EnemyBuildings.size())*1.3:
				Focus = "Victory"
			else:
				if (hasHQ.size() + hasTent.size() + hasMotorPool.size() + hasDepot.size() + hasRadio.size()) >= 5:
					if Globals.BunnyPower[Team - 1] >= 500 and Globals.Fuel[Team - 1] >= 200 and Globals.Munitions[Team - 1] >= 300:
						Focus = "Unit Production"
					else:
						Focus = "Resources"
				else:
					Focus = "Resources"
		'Elimination':
			if Troops.size() >= (Enemies.size() - EnemyBuildings.size())*2.0 and Troops.size() > 4:
				Focus = "Elimination"
			elif Troops.size() >= (Enemies.size() - EnemyBuildings.size())*1.4 and Troops.size() > 4:
				Focus = "Base Destruction"
			else:
				if (hasHQ.size() + hasTent.size() + hasMotorPool.size() + hasDepot.size() + hasRadio.size()) >= 5:
					if Globals.BunnyPower[Team - 1] >= 500 and Globals.Fuel[Team - 1] >= 200 and Globals.Munitions[Team - 1] >= 300:
						Focus = "Unit Production"
					else:
						Focus = "Resources"
				else:
					Focus = "Resources"
		'Encircled':
			Focus = "Elimination"
	if Engineers.size() == 0 and CheckPrice(4):
		if hasHQ.size() >= 1:
			BuildUnit(4,'Eng',hasHQ[rng.randi_range(0,hasHQ.size()-1)])
		elif hasTent.size() >= 1:
			BuildUnit(4,'Eng',hasTent[rng.randi_range(0,hasTent.size()-1)])
	if Engineers.size() >= 1:
		if hasTent.size() == 0 and CheckPrice(10):
			BuildBuilding(10, 'Tent', Engineers[rng.randi_range(0,Engineers.size()-1)])
		elif hasDepot.size() == 0 and CheckPrice(12):
			BuildBuilding(12, 'Depot', Engineers[rng.randi_range(0,Engineers.size()-1)])
		elif hasMotorPool.size() == 0 and CheckPrice(11):
			BuildBuilding(11, 'MotorPool', Engineers[rng.randi_range(0,Engineers.size()-1)])
		elif hasRadio.size() == 0 and CheckPrice(13) and hasDepot.size() > 0:
			BuildBuilding(13, 'Radio', Engineers[rng.randi_range(0,Engineers.size()-1)])
			print("BuildRadio")
	var Factor = 1
	match Focus:
		"Resources":
			Factor = 0.5
			if Globals.BunnyPower[Team - 1] >= 400 and Globals.Munitions[Team - 1] >= 200 and Globals.Fuel[Team - 1] >= 200:
				Factor = 0.1
			for i in range(0,Troops.size()):
				#print("CheckingTroop")
				Troops[i].Behavior = "Defensive"
				var ClosestDis = 100000
				var ClosestPoint = null
				for a in range(0,ResourcePoints.size()):
					#print(Troops[i].GoToPos)
					var dis = sqrt(pow(ResourcePoints[a].global_position.x - Troops[i].GoToPos.x,2)+pow(ResourcePoints[a].global_position.y - Troops[i].GoToPos.y,2))
					if dis < ClosestDis and ResourcePoints[a].Owner != Team:
						ClosestDis = dis
						ClosestPoint = ResourcePoints[a]
				#print(ClosestDis)
				if ClosestDis > 100 and ClosestDis < 300:
					Troops[i].GoToPos = ClosestPoint.global_position + Vector2(rng.randf_range(-60,60),rng.randf_range(-60,60))
					Troops[i].FarAway = 0
					Troops[i].FirstMove = 1
					Troops[i].SetTarget()
				elif ClosestDis > 100 and ClosestDis <= 800 and ClosestPoint.Owner != Team:
					Troops[i].GoToPos = ClosestPoint.global_position + Vector2(rng.randf_range(-60,60),rng.randf_range(-60,60))
					Troops[i].FarAway = 0
					Troops[i].FirstMove = 1
					#print(ClosestPoint)
					Troops[i].SetTarget()
					#print("Closest")
				elif ClosestDis >= 300:
					Troops[i].GoToPos = ResourcePoints[rng.randi_range(0,ResourcePoints.size()-1)].global_position + Vector2(rng.randf_range(-60,60),rng.randf_range(-60,60))
					Troops[i].FarAway = 0
					Troops[i].FirstMove = 1
					Troops[i].SetTarget()
		"Unit Production":
			Factor = 0.9
			for i in range(0,Troops.size()):
				#print("CheckingTroop")
				Troops[i].Behavior = "Defensive"
				var ClosestDis = 100000
				var ClosestPoint = null
				for a in range(0,DefensePoints.size()):
					var dis = sqrt(pow(DefensePoints[a].global_position.x - Troops[i].GoToPos.x,2)+pow(DefensePoints[a].global_position.y - Troops[i].GoToPos.y,2))
					if dis < ClosestDis:
						ClosestDis = dis
						ClosestPoint = DefensePoints[a]
				#print(ClosestDis)
				if ClosestDis > 100 and ClosestDis < 250:
					Troops[i].GoToPos = ClosestPoint.global_position + Vector2(rng.randf_range(-100,100),rng.randf_range(-100,100))
					Troops[i].FarAway = 0
					Troops[i].FirstMove = 1
					Troops[i].SetTarget()
				elif ClosestDis >= 250:
					Troops[i].GoToPos = DefensePoints[rng.randi_range(0,DefensePoints.size()-1)].global_position + Vector2(rng.randf_range(-100,100),rng.randf_range(-100,100))
					Troops[i].FarAway = 0
					Troops[i].FirstMove = 1
					Troops[i].SetTarget()
		"Victory":
			for i in range(0,Troops.size()):
				#print("CheckingTroop")
				Troops[i].Behavior = "Aggressive"
				var ClosestDis = 100000
				var ClosestPoint = null
				for a in range(0,VictoryPoints.size()):
					var dis = sqrt(pow(VictoryPoints[a].global_position.x - Troops[i].GoToPos.x,2)+pow(VictoryPoints[a].global_position.y - Troops[i].GoToPos.y,2))
					if dis < ClosestDis:
						ClosestDis = dis
						ClosestPoint = VictoryPoints[a]
				#print(ClosestDis)
				if ClosestDis > 100 and ClosestDis < 250:
					Troops[i].GoToPos = ClosestPoint.global_position + Vector2(rng.randf_range(-100,100),rng.randf_range(-100,100))
					Troops[i].FarAway = 0
					Troops[i].FirstMove = 1
					Troops[i].SetTarget()
				elif ClosestDis >= 250:
					Troops[i].GoToPos = VictoryPoints[rng.randi_range(0,VictoryPoints.size()-1)].global_position + Vector2(rng.randf_range(-100,100),rng.randf_range(-100,100))
					Troops[i].FarAway = 0
					Troops[i].FirstMove = 1
					Troops[i].SetTarget()
		"Elimination":
			if Enemies.size() >= 1:
				for i in range(0,Troops.size()):
					#print("CheckingTroop")
					Troops[i].Behavior = "Aggressive"
					var ClosestDis = 100000
					var ClosestPoint = null
					for a in range(0,Enemies.size()):
						var dis = sqrt(pow(Enemies[a].global_position.x - Troops[i].GoToPos.x,2)+pow(Enemies[a].global_position.y - Troops[i].GoToPos.y,2))
						if dis < ClosestDis:
							ClosestDis = dis
							ClosestPoint = Enemies[a]
					#print(ClosestDis)
					if ClosestDis > 100 and ClosestDis < 350:
						Troops[i].GoToPos = ClosestPoint.global_position + Vector2(rng.randf_range(-100,100),rng.randf_range(-100,100))
						Troops[i].FarAway = 0
						Troops[i].FirstMove = 1
						Troops[i].SetTarget()
					elif ClosestDis >= 250:
						Troops[i].GoToPos = Enemies[rng.randi_range(0,Enemies.size()-1)].global_position + Vector2(rng.randf_range(-100,100),rng.randf_range(-100,100))
						Troops[i].FarAway = 0
						Troops[i].FirstMove = 1
						Troops[i].SetTarget()
		"Base Destruction":
			if EnemyBuildings.size() >= 1:
				for i in range(0,Troops.size()):
					#print("CheckingTroop")
					Troops[i].Behavior = "Aggressive"
					var ClosestDis = 100000
					var ClosestPoint = null
					for a in range(0,EnemyBuildings.size()):
						var dis = sqrt(pow(EnemyBuildings[a].global_position.x - Troops[i].GoToPos.x,2)+pow(EnemyBuildings[a].global_position.y - Troops[i].GoToPos.y,2))
						if dis < ClosestDis:
							ClosestDis = dis
							ClosestPoint = EnemyBuildings[a]
					#print(ClosestDis)
					if ClosestDis > 100 and ClosestDis < 350:
						Troops[i].GoToPos = ClosestPoint.global_position + Vector2(rng.randf_range(-100,100),rng.randf_range(-100,100))
						Troops[i].FarAway = 0
						Troops[i].FirstMove = 1
						Troops[i].SetTarget()
					elif ClosestDis >= 250:
						Troops[i].GoToPos = EnemyBuildings[rng.randi_range(0,EnemyBuildings.size()-1)].global_position + Vector2(rng.randf_range(-100,100),rng.randf_range(-100,100))
						Troops[i].FarAway = 0
						Troops[i].FirstMove = 1
						Troops[i].SetTarget()
	#print(Globals.BunnyPower[Team-1])
	#print(Globals.Munitions[Team-1])
	#print(Globals.Fuel[Team-1])
	if hasDepot.size() > 0 and CheckPriceSave(8,Factor):
		if CheckPrice(9):
			BuildUnit(9, 'HTank', hasDepot[rng.randi_range(0,hasDepot.size()-1)])
		else:
			BuildUnit(8, 'MTank', hasDepot[rng.randi_range(0,hasDepot.size()-1)])
	elif hasMotorPool.size() > 0 and ((CheckPriceSave(6,Factor) and Troops.size() < 10) or ((CheckPriceSave(6,Factor) and hasDepot.size() > 0))):
		if CheckPrice(7) and Troops.size() < 15:
			BuildUnit(7, 'Tank', hasMotorPool[rng.randi_range(0,hasMotorPool.size()-1)])
		elif Troops.size() < 9:
			BuildUnit(6, 'Car', hasMotorPool[rng.randi_range(0,hasMotorPool.size()-1)])
	elif hasTent.size() > 0 and ((CheckPriceSave(0,Factor) and Troops.size() < 7) or ((CheckPriceSave(0,Factor*0.3) and hasDepot.size() > 0))):
		var BetterUnit = rng.randi_range(1,5)
		if CheckPriceSave(BetterUnit,Factor):
			BuildUnit(BetterUnit, Globals.UnitTypeMatch[BetterUnit], hasTent[rng.randi_range(0,hasTent.size()-1)])
		elif rng.randi_range(0,100) > 60:
			BuildUnit(0, 'Infantry', hasTent[rng.randi_range(0,hasTent.size()-1)])

func BuildUnit(BuildIndex,toBuild,Building):
	#print("BuildUnit")
	#print(Globals.UnitBPCost[BuildIndex])
	#print(Globals.BunnyPower[Team - 1])
	#print(CheckPrice(BuildIndex))
	Globals.BunnyPower[Team - 1] -= Globals.UnitBPCost[BuildIndex]
	Globals.Munitions[Team - 1] -= Globals.UnitMunitionCost[BuildIndex]
	Globals.Fuel[Team - 1] -= Globals.UnitFuelCost[BuildIndex]
	var NewObj = UnitObj.instantiate()
	NewObj.Team = Team
	NewObj.Type = toBuild
	NewObj.global_position = Building.global_position + Vector2(rng.randf_range(-64,64),rng.randf_range(64,96))
	NewObj.GoToPos = NewObj.global_position
	get_parent().add_child(NewObj)

func CheckPrice(BuildI):
	if Globals.BunnyPower[Team-1] >= Globals.UnitBPCost[BuildI] and Globals.Munitions[Team-1] >= Globals.UnitMunitionCost[BuildI] and Globals.Fuel[Team-1] >= Globals.UnitFuelCost[BuildI]:
		return(true)
	else:
		return(false)

func CheckPriceSave(BuildI,Factor):
	if Globals.BunnyPower[Team-1]*Factor >= Globals.UnitBPCost[BuildI] and Globals.Munitions[Team-1]*Factor >= Globals.UnitMunitionCost[BuildI] and Globals.Fuel[Team-1]*Factor >= Globals.UnitFuelCost[BuildI]:
		return(true)
	else:
		return(false)

func BuildBuilding(BuildingI, BuildingT, Eng):
	if BuildingT == 'Depot' or BuildingT == 'HQ':
		$EnemyAreaChecker.scale = Vector2(2,2)
		#print("ScaledUp")
	else:
		$EnemyAreaChecker.scale = Vector2(1,1)
	for i in range(0,25):
		if Eng != null:
			var NewPos = Eng.global_position + Vector2(rng.randf_range(-96.0,96.0),rng.randf_range(-96.0,96.0))
			$EnemyAreaChecker.global_position = NewPos
			await get_tree().create_timer(0.05).timeout
			if $EnemyAreaChecker.has_overlapping_bodies() == false and CheckPrice(BuildingI):
				Globals.BunnyPower[Team - 1] -= Globals.UnitBPCost[BuildingI]
				Globals.Munitions[Team - 1] -= Globals.UnitMunitionCost[BuildingI]
				Globals.Fuel[Team - 1] -= Globals.UnitFuelCost[BuildingI]
				if BuildingT != 'Mines':
					var NewObj = UnitObj.instantiate()
					NewObj.Team = Team
					NewObj.Type = BuildingT
					NewObj.global_position = NewPos
					get_parent().add_child(NewObj)
				else:
					var NewObj = LandMineObj.instantiate()
					NewObj.Team = Team
					NewObj.global_position = NewPos
					get_parent().add_child(NewObj)
				i = 26
				return
			#else:
			#	print("Colliding!")
