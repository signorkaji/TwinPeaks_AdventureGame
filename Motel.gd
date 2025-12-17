extends Node2D

@onready var alex = $Alex_Character


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _input(event):
	# Controlla se l'evento è un click sinistro del mouse
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		# Ottiene la posizione del mouse nel mondo 2D
		var click_position = get_global_mouse_position()
		
		# Invia la destinazione al nodo Alex_Character
		alex.set_target(click_position)
