extends Node2D

@onready var location_container = $LocationContiner as VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Replace with function body.
	if GlobalGame.dialogue_system == null:
		await get_tree().process_frame

# Called every frame. 'delta' is the elapsed time since the previous frame.


func setup_map_buttons():
	# cancelliamo i vecchi pulsanti così un ci sono duplicatio
	for child in location_container.get_children():
		child.queue_free()
		
	# recupera i nomi delle location sbloccate 
	var locations = GlobalGame.unlocked_locations.keys()
	
	# ordina le location (ordine alfabetico ) 
	locations.sort() 
	
	#iteriamo su tutte le locations sbloccate nel global game
	for location_name in locations:
		var button = Button.new()
		button.text = location_name
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.flat = false
		
		# Connessione: quando clicca, chiama la funzione travel_to nel GlobalGame
		button.pressed.connect(func() : GlobalGame.travel_to(location_name))
		
		location_container.add_child(button)
		
	# pulsante di prova aggiunto per sblocco rapido  (SOLO SVIL!!!!)
	
	var unlock_button = Button.new()
	unlock_button.text = "UNLOCK SAW MILL (DEV)"
	unlock_button.pressed.connect(func(): 
		GlobalGame.unlock_location("Packard Sawmill")
		setup_map_buttons() # ricarico la mappa per mostrare il pulsante nuovo	
	)
	
	
	# in produzione si toglie 
	#location_container.add_child(unlock_button) 
	
		
	
	

func _process(delta):
	pass
