extends Node
var MousePos = Vector2 (0,0)
var HoveringOverClickable = 0
var EnemySelectable = null
var UnitsSelected = []
var UnitPanelShow = null
var CurrentUnitIndex = null
var GameMode = 'Victory Points'

var PointsNeeded = 50000
var ChangedMesh = false
var DefaultCursor = preload("res://Textures/BAADefaultCursor.png")
var AttackCursor = preload("res://Textures/BAAAttackCursor.png")
var MoveCursor = preload("res://Textures/BAAMoveCursor.png")
# Victory Points - Conquer a series of victory points and hold them till you gain a certain number of points
# Elimination - Eliminate all enemy buildings and units
# Encircled - Hold out for as long as possible against waves of enemies

var Fuel = [100,100]
var BunnyPower = [500,500]
var Munitions = [100,100]
var VictoryPoints = [0,0]
var TeamColors = [[61, 204, 92],[204, 66, 61]]
# Infantry, Recon, SMG, MG, Engineer, AT, Car, Light Tank, Medium Tank, Heavy Tank, Tent, Motor Pool, Depot, Radio, Mines, Bunker, HQ
var UnitBPCost = [70, 100, 100, 125, 150, 125, 150, 200, 350, 550, 200, 250, 300, 250, 0, 180]
var UnitMunitionCost = [25, 50, 75, 100, 15, 150, 70, 100, 200, 350, 50, 150, 250, 50, 50, 100]
var UnitFuelCost = [0, 0, 0, 0, 0, 0, 50, 100, 250, 350, 0, 100, 280, 50, 0, 0]
var UnitTypeMatch = ['Infantry', 'Recon', 'SMG', 'MG', 'Eng', 'Rocket', 'Car', 'Tank', 'MTank', 'HTank', 'Tent', 'MotorPool', 'Depot', 'Radio', 'Mines', 'Bunker', 'HQ']
# Used to get the index based on the string tag for referencing other arrays (i.e. an infantry unit will find it's index to be 0 and can use that to find it's abilities

#                    Infantry,       Recon,         SMG,            MG,                  Engineer,                                                           AT,         Vehicles(No Abilities)                   Tent,                              Motor Pool,         Depot,                Radio,     Mines & Bunker (No Abilities),  HQ
var UnitAbilities = [['Grenade'], ['Grenade'], ['Satchel Charge'], ['Grenade'], ['Minesweep','Tent', 'MotorPool', 'Depot', 'Radio', 'Mines', 'Bunker'], ['Satchel Charge'], [], [], [], [], ['Infantry', 'Recon', 'SMG', 'MG', 'Eng', 'Rocket'], ['Car', 'Tank'], ['MTank', 'HTank'], ['Artillery','Airstrike'], [], [], ['Infantry','Eng']]
var GrenadeCost = 25 # Munitions
var SatchelCost = 40 # Munitions
var MinesweepCost = 15 # BunnyPower
var ArtilleryCost = 180
var PlaneMCost = 250
var PlaneFCost = 150
# This contains the abilities/build options for every unit and building

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(HoveringOverClickable)
	if HoveringOverClickable <= 0:
		if UnitsSelected.size() > 0:
			if EnemySelectable != null:
				Input.set_custom_mouse_cursor(AttackCursor)
			else:
				Input.set_custom_mouse_cursor(MoveCursor)
		else:
			Input.set_custom_mouse_cursor(DefaultCursor)
	for i in UnitsSelected:
		#var item = UnitsSelected[i]
		var count = UnitsSelected.count(i)
		if count > 1:
			for a in range(0,count-1):
				UnitsSelected.erase(i)
	#print(UnitsSelected)
#	MousePos = get_viewport().get_global_mouse_position()
