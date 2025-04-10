extends Node
var MousePos = Vector2 (0,0)
var HoveringOverClickable = 0
var EnemySelectable = null
var UnitsSelected = []

var Fuel = [10,10]
var BunnyPower = [10,10]
var Munitions = [10,10]
var TeamColors = [[61, 204, 92],[204, 66, 61]]
# Infantry, Recon, SMG, MG, Engineer, AT, Car, Light Tank, Medium Tank, Heavy Tank, Tent, Motor Pool, Depot, Radio, Mines, Bunker, HQ
var UnitBPCost = [50, 75, 75, 100, 100, 75, 100, 150, 250, 500, 150, 200, 400, 250, 0, 100]
var UnitMunitionCost = [25, 50, 75, 100, 15, 150, 70, 100, 200, 350, 50, 150, 250, 50, 50, 100]
var UnitFuelCost = [0, 0, 0, 0, 0, 0, 50, 100, 250, 400, 0, 100, 300, 50, 0, 0]
#                    Infantry,       Recon,         SMG,            MG,                  Engineer,                                                           AT,         Vehicles(No Abilities)                   Tent,                                Motor Pool,                 Depot,                      Radio,     Mines & Bunker (No Abilities),  HQ
var UnitAbilities = [['Grenade'], ['Grenade'], ['Satchel Charge'], ['Grenade'], ['Tent', 'Motor Pool', 'Depot', 'Radio', 'Mines', 'Bunker','Minesweep'], ['Satchel Charge'], [], [], [], [], ['Infantry', 'Recon', 'SMG', 'MG', 'Engineer', 'AT'], ['Car', 'Light Tank'], ['Medium Tank', 'Heavy Tank'], ['Artillery','Airstrike'], [], [], ['Infantry','Engineer']]
# This contains the abilities/build options for every unit and building

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(UnitsSelected)
	if HoveringOverClickable <= 0:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
#	MousePos = get_viewport().get_global_mouse_position()
