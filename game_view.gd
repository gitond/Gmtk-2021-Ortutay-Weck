extends Node2D


# VARIABLES

# InpValues member format: [smallerCoordinate,biggerCoordinate,id]
var InpValuesX = [[1,155,"INP_ID_1"],[235,265,"INP_ID_2"],[180,225,"INP_ID_3"],[270,320,"INP_ID_4"],[485,515,"INP_ID_5"],[410,495,"INP_ID_6"],[540,605,"INP_ID_7"],[20,100,"INP_ID_8"],[20,100,"INP_ID_9"],[735,765,"INP_ID_10"],[680,765,"INP_ID_11"],[855,920,"INP_ID_12"],[1000,1279,"INP_ID_13"],[880,965,"INP_ID_14"],[420,580,"INP_ID_15"],[420,495,"INP_ID_16"],[510,580,"INP_ID_17"],[1000,1279,"INP_ID_18"],[1000,1279,"INP_ID_19"],[1000,1279,"INP_ID_20"],[1000,1279,"INP_ID_21"],[1000,1279,"INP_ID_22"]]
var InpValuesY = [[95,130,"INP_ID_1"],[195,285,"INP_ID_2"],[60,120,"INP_ID_3"],[40,110,"INP_ID_4"],[200,285,"INP_ID_5"],[40,120,"INP_ID_6"],[60,115,"INP_ID_7"],[540,620,"INP_ID_8"],[620,700,"INP_ID_9"],[200,285,"INP_ID_10"],[70,135,"INP_ID_11"],[25,115,"INP_ID_12"],[1,120,"INP_ID_13"],[615,700,"INP_ID_14"],[610,680,"INP_ID_15"],[530,605,"INP_ID_16"],[530,600,"INP_ID_17"],[120,240,"INP_ID_18"],[240,360,"INP_ID_19"],[360,480,"INP_ID_20"],[480,600,"INP_ID_21"],[600,719,"INP_ID_22"]]
var folders = ["cargo", "grain", "passenger"]
var ships = ["E", "D", "G", "EPlus", "GPlus", "DPlus", "EFire", "GFire", "DFire", "EPlusFire", "GPlusFire", "DPlusFire"]
var possibleValidInputIdsX = []
var possibleValidInputIdsY = []
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Ship01").set_texture(preload("res://assets/temporary/game_view/invpix.png"))
	get_node("Ship01").global_position = Vector2(100, 100)
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
		if event is InputEventMouseButton:

			possibleValidInputIdsX = []
			possibleValidInputIdsY = []

			if event.button_index == BUTTON_LEFT and event.pressed:
				for i in InpValuesX:
					if (event.position.x > i[0] and event.position.x < i[1]):
						possibleValidInputIdsX.append(i[2])
				for i in InpValuesY:
					if (event.position.y > i[0] and event.position.y < i[1]):
						possibleValidInputIdsY.append(i[2])

				for i in possibleValidInputIdsX:
					if i in possibleValidInputIdsY:
						action(i)
func randShip():
	var r1 = rng.randi_range(0, 2)
	var r2 = rng.randi_range(0, 11)
	return "res://assets/temporary/game_view/" + folders[r1] + "/" + ships[r2] + ".png"
	
func action(inpId):
	var str1 = randShip()
	print(typeof(str1))
	get_node("Ship01").set_texture(load(str1))
	
