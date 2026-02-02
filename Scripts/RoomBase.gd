extends Node2D

#riferimento a Alex, tanto serve sempre 
@onready var alex = $Alex_Character

# Called when the node enters the scene tree for the first time.
func _ready():
	# configurazione input
	set_process_input(true)
	
	# controlliamo se alex è a posto come inizializzazione
	if not is_instance_valid(alex):
		push_warning("Attenzione, Alex non ancora inizializzato nella scena "+name)
	else: 
		print("Roombase configurata correttamente per "+name)
		
# gestione movimento
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_movement_click()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func handle_movement_click():
	if is_instance_valid(alex):
		var click_pos = get_global_mouse_position()
		alex.set_target(click_pos)
		
func setup_hotspot_tooltip(node:Area2D, tooltip_text:String):
	if is_instance_valid(node):
		node.mouse_entered.connect(func(): GlobalGame.set_tooltip(tooltip_text))
		node.mouse_exited.connect(func(): GlobalGame.set_tooltip(""))
		# rimuove il tooltip se l'oggetto viene rimosso
		node.tree_exiting.connect(func(): GlobalGame.set_tooltip(""))
