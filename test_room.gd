extends Node2D

@onready var alex = $Alex_Character

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Scena di test caricata. Clicca per muovere Alex")


# gestione punta e clicca
func _input(event):
	# controlla se l'eventop è il click sx del mouse 
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var click_position = get_global_mouse_position()
		print("vai")
		alex.set_target(click_position)
