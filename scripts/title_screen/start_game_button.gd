extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Input handling
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var play_x = event.position.x
			var play_y = event.position.y
			print(event.position)
			if (play_x > 125 and play_x < 380 and play_y > 90 and play_y < 145):
				get_tree().change_scene("res://game_view.tscn")
