extends Node2D


# VARIABLES

### Input handling & location variables: ###
# InpValues member format: [smallerCoordinate,biggerCoordinate,id]
const InpValuesX = [[1,155,"INP_ID_1"],[235,265,"INP_ID_2"],[180,225,"INP_ID_3"],[270,320,"INP_ID_4"],[485,515,"INP_ID_5"],[410,495,"INP_ID_6"],[540,605,"INP_ID_7"],[20,100,"INP_ID_8"],[20,100,"INP_ID_9"],[735,765,"INP_ID_10"],[680,765,"INP_ID_11"],[855,920,"INP_ID_12"],[1000,1279,"INP_ID_13"],[880,965,"INP_ID_14"],[420,580,"INP_ID_15"],[420,495,"INP_ID_16"],[510,580,"INP_ID_17"],[1000,1279,"INP_ID_18"],[1000,1279,"INP_ID_19"],[1000,1279,"INP_ID_20"],[1000,1279,"INP_ID_21"],[1000,1279,"INP_ID_22"]]
const InpValuesY = [[95,130,"INP_ID_1"],[195,285,"INP_ID_2"],[60,120,"INP_ID_3"],[40,110,"INP_ID_4"],[200,285,"INP_ID_5"],[40,120,"INP_ID_6"],[60,115,"INP_ID_7"],[540,620,"INP_ID_8"],[620,700,"INP_ID_9"],[200,285,"INP_ID_10"],[70,135,"INP_ID_11"],[25,115,"INP_ID_12"],[1,120,"INP_ID_13"],[615,700,"INP_ID_14"],[610,680,"INP_ID_15"],[530,605,"INP_ID_16"],[530,600,"INP_ID_17"],[120,240,"INP_ID_18"],[240,360,"INP_ID_19"],[360,480,"INP_ID_20"],[480,600,"INP_ID_21"],[600,719,"INP_ID_22"]]
var possibleValidInputIdsX = []
var possibleValidInputIdsY = []
# waitingSlots and piers formats: [x,x,x, ... ,x,x] where x = ("INP_ID", "SHIP_ID"||"Empty")
var piers = ["INP_ID_2","Empty","INP_ID_5","Empty","INP_ID_10","Empty"]
var waitingSlots = ["INP_ID_13","Empty","INP_ID_18","Empty","INP_ID_19","Empty","INP_ID_20","Empty","INP_ID_21","Empty","INP_ID_22","Empty"]
var playingFieldWaitingSlots = ["INP_ID_8","Empty","INP_ID_9","Empty","INP_ID_14","Empty"]
# shipSelected format: ["SHIP_ID", "INP_ID" of place where ship was clicked]
var shipSelected = ["None","Empty"]
var lastClickedObjCoords = Vector2(0,0)
const shipSpawningYCoords = [60,180,300,420,540,660]
var lastManagedList = []
var islandSlots = ["INP_ID_15","Empty","Empty"]

# Variables for texture handling:
var folders = ["cargo", "grain", "passenger"]
var ships = ["E", "D", "G", "EPlus", "GPlus", "DPlus", "EFire", "GFire", "DFire", "EPlusFire", "GPlusFire", "DPlusFire"]

# Timing related variables
onready var mainTimer = get_node("main_timer")
var secondsSinceLevelStart = 0

var rng = RandomNumberGenerator.new()

var freeShipsByIds = ["Ship01","Ship02","Ship03","Ship04","Ship05","Ship06","Ship07","Ship08","Ship09","Ship10","Ship11","Ship12","Ship13","Ship14"]

# MAIN PROGRAMME

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize() # gets a new seed for the rng so every single playthrough isn't the same
	
	for i in range(14):
		if i+1 < 10:
			get_node("Ships/Ship0" + str(i+1)).set_texture(preload("res://assets/temporary/game_view/invpix.png"))
			get_node("Ships/Ship0" + str(i+1)).global_position = Vector2(10, 10)
		else:
			get_node("Ships/Ship" + str(i+1)).set_texture(preload("res://assets/temporary/game_view/invpix.png"))
			get_node("Ships/Ship" + str(i+1)).global_position = Vector2(10, 10)
	
#	get_node("Ships/Ship01").set_texture(preload("res://assets/temporary/game_view/invpix.png"))
#	get_node("Ships/Ship01").global_position = Vector2(1070, 60)

	randShip()

	mainTimer.set_wait_time(1)
	mainTimer.start()


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

						for j in InpValuesX:
							if j[2] == i:
								lastClickedObjCoords.x = j[0]
						for j in InpValuesY:
							if j[2] == i:
								lastClickedObjCoords.y = j[0]

						action(i)

func randShip():
	var r1 = rng.randi_range(0, 2)
	var r2 = rng.randi_range(0, 11)
	var emptySlotFound = false
	#return "res://assets/temporary/game_view/" + folders[r1] + "/" + ships[r2] + ".png"

	var i = 1
	while i<waitingSlots.size():
		emptySlotFound = false
#		print(str(i) + " " + waitingSlots[i] + " ")
		if waitingSlots[i] == "Empty":
			emptySlotFound = true
			waitingSlots[i] = freeShipsByIds.pop_front()
			# Take into consideration! .pop_front() ***may*** return null.
			# Relevant documentation: https://docs.godotengine.org/fi/stable/classes/class_array.html
			# TODO: implement solution for what happens whn null gets returned. As this is unlikely, this task is low priority

			get_node("Ships/" + waitingSlots[i]).global_position = Vector2(1070, shipSpawningYCoords[(i-1)/2])
			get_node("Ships/" + waitingSlots[i]).set_texture(load("res://assets/temporary/game_view/" + folders[r1] + "/" + ships[r2] + ".png"))

			break
		i += 2
	
	if !emptySlotFound:
		print("No empty waiting slots left!")

	#get_node("Ships/Ship01").set_texture(load("res://assets/temporary/game_view/" + folders[r1] + "/" + ships[r2] + ".png"))

func movementManager(inpId, listToOperate):
	if shipSelected[0] != "None" and listToOperate[listToOperate.find(inpId) +1] == "Empty":
		listToOperate[listToOperate.find(inpId) +1] = shipSelected[0]
		lastManagedList[lastManagedList.find(shipSelected[1]) +1] = "Empty"
		if listToOperate == piers:
			get_node("Ships/" + shipSelected[0]).global_position = Vector2(lastClickedObjCoords.x-50, lastClickedObjCoords.y+50)
		if listToOperate == playingFieldWaitingSlots:
			get_node("Ships/" + shipSelected[0]).global_position = Vector2(lastClickedObjCoords.x+40, lastClickedObjCoords.y+40)
		shipSelected = ["None","Empty"]
	if listToOperate[listToOperate.find(inpId) +1] != "Empty":
		shipSelected = [listToOperate[listToOperate.find(inpId) +1],inpId]
		lastManagedList = listToOperate

func action(inpId):

	# FINALIZED CODE (more or less)
	if inpId in piers:
		movementManager(inpId, piers)

#		if shipSelected[0] != "None" and piers[piers.find(inpId) +1] == "Empty":
#			piers[piers.find(inpId) +1] = shipSelected[0]
#			waitingSlots[waitingSlots.find(shipSelected[1]) +1] = "Empty"
#			get_node("Ships/" + shipSelected[0]).global_position = Vector2(lastClickedObjCoords.x-50, lastClickedObjCoords.y+50)
#			shipSelected = ["None","Empty"]

	if inpId in waitingSlots:
		if waitingSlots[waitingSlots.find(inpId) +1] != "Empty":
			shipSelected = [waitingSlots[waitingSlots.find(inpId) +1],inpId]
			lastManagedList = waitingSlots

	if inpId in playingFieldWaitingSlots:
		movementManager(inpId, playingFieldWaitingSlots)

	if inpId == "INP_ID_15":
		if shipSelected[0] != "None" and islandSlots[1] == "Empty" and islandSlots[2] == "Empty":
			islandSlots[1] = shipSelected[0]
			lastManagedList[lastManagedList.find(shipSelected[1]) +1] = "Empty"
			get_node("Ships/" + shipSelected[0]).global_position = Vector2(lastClickedObjCoords.x+40, lastClickedObjCoords.y+40)
			shipSelected = ["None","Empty"]
		elif islandSlots[1] != "Empty" and islandSlots[2] == "Empty":
			if shipSelected[0] != "None":
				islandSlots[2] = shipSelected[0]
				lastManagedList[lastManagedList.find(shipSelected[1]) +1] = "Empty"
				get_node("Ships/" + shipSelected[0]).global_position = Vector2(lastClickedObjCoords.x+120, lastClickedObjCoords.y+40)
				shipSelected = ["None","Empty"]
			else:
				shipSelected = [islandSlots[1],inpId]
				lastManagedList = islandSlots
		else:
			# This is still buggy so I don't think it's possible to remove ships from the island if two ships are parked there.
			if shipSelected[0] == "None" and islandSlots[1] != "Empty" and islandSlots[2] != "Empty":
				shipSelected = [islandSlots[2],inpId]
				lastManagedList = islandSlots

#		if islandSlots[1] != "Empty" and islandSlots[2] == "Empty" and shipSelected[0] != islandSlots[1]:
#			print(islandSlots[1])
#			islandSlots[2] = shipSelected[0]
#			get_node("Ships/" + shipSelected[0]).global_position = Vector2(lastClickedObjCoords.x+120, lastClickedObjCoords.y+40)

#			if shipSelected[0] != "None":
#				if shipSelected[0] != islandSlots[1]:
#					islandSlots[2] = shipSelected[0]
#					get_node("Ships/" + shipSelected[0]).global_position = Vector2(lastClickedObjCoords.x+120, lastClickedObjCoords.y+40)
#					shipSelected = ["None","Empty"]
#				else:
#					shipSelected = [islandSlots[1],inpId]
#					lastManagedList = islandSlots
#		if shipSelected[0] == "None" and islandSlots[1] != "Empty" and islandSlots[2] != "Empty":
#			shipSelected = [islandSlots[2],inpId]
#			lastManagedList = islandSlots

	# TEST AREA
#	var str1 = randShip()
#	print(freeShipsByIds.size())
	#get_node("Ships/Ship01").set_texture(load(randShip()))
#	
#	print(piers)
	print(shipSelected)
#	print(waitingSlots)
#	print(inpId)

func on_main_timer_timeout():
	secondsSinceLevelStart += 1
	if secondsSinceLevelStart % 10 == 0:
		randShip()
