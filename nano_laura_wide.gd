extends Node2D


# per la transizione
const SCENA_LAURA_CLOSEUP_PROPHEVY = "res://laura_close_up_prophecy.tscn"
const DURATA_PAUSA = 10 # durata della scena prima di passare a quella dopo  

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalGame.hide_line()
	
	if GlobalGame.dialogue_system == null:
		print("Error: Global dialogue system not initialized.")
		get_tree().quit()
		return
		
	start_transition_pause()
		
	


func start_transition_pause():
	
	await get_tree().create_timer(DURATA_PAUSA).timeout
	
	get_tree().change_scene_to_file(SCENA_LAURA_CLOSEUP_PROPHEVY)
