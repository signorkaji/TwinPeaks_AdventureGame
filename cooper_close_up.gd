extends Node2D

# poi si vedono  laura e il nano
const SCENA_NANO_LAURA_WIDE = "res://nano_laura_wide.tscn"
const DURATA_RIGA_COOPER = 10.0 # tempo per eventuale battuta di Cooper 


# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalGame.dialogue_system == null:
		print("ERROR Global dialogue system not initialized.")
		get_tree().quit()
		return
	start_cooper_reaction()



# reazione di cooper e passaggio alla scena di Laura e il nano (closeup)
func start_cooper_reaction():
	
	
	# forza l'attesa della renderizzazioone del dialogo
	await get_tree().process_frame
	
	GlobalGame.show_line("Cooper", "?")
	
	#Attesa 
	await get_tree().create_timer(DURATA_RIGA_COOPER).timeout
	
	# leva la riga di dialogo
	#GlobalGame.hide_line()
	
	get_tree().change_scene_to_file(SCENA_NANO_LAURA_WIDE)
	
	
