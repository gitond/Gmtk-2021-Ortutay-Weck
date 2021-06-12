extends MarginContainer


# VARIABLES

# The input areas are saved into two arrays
# (One for x values and one for y values)
# in the following way:
# Let's say we have a clickable rectangle area from x125y90 to x380y145
# the coordinates of the x axis get saved into the array with the x values
# and we'll also add an ID so we can sync it with the y values
# and the same thing will be done to the y values of course.

# InpValues member format: [smallerCoordinate,biggerCoordinate,id]
var InpValuesX = [[50,380,"INP_ID_1"]]
var InpValuesY = [[90,145,"INP_ID_1"]]

var possibleValidInputIdsX = []
var possibleValidInputIdsY = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("PlayButton").global_position = Vector2(150, 150)
	get_node("TutorialButton").global_position = Vector2(150, 375)

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

func action(inpId):
	if inpId == "INP_ID_1":
		get_tree().change_scene("res://game_view.tscn")
