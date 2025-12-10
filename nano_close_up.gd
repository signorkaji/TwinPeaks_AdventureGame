extends Node2D

@onready var nano_mouth = $Nano_Mouth

#Costanti
const SCENA_COOPER_CLOSEUP = "res://cooper_close_up.tscn"
const DURATA_RIGA_1 = 3.0 # tempo per la prima battuta del nano 

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalGame.dialogue_system == null:
		print("ERROR: Globala dialogue system not initialized. ")
		get_tree().quit()
		return
	
	#la musica persistente del nano è già attiva (grazie a prologo_loggia)
	nano_mouth.hide()
	
	
	start_nano_dialogue_part_1()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func start_nano_dialogue():
	GlobalGame.show_line("Il Nano", "Alcuni dei tuoi amici sono qui")
	nano_mouth.show()
	nano_mouth.play("speak")

func start_nano_dialogue_part_1():
	GlobalGame.show_line("Il Nano", "Alcuni dei tuoi amici sono qui")
	nano_mouth.show()
	nano_mouth.play("speak")
	await get_tree().create_timer(DURATA_RIGA_1).timeout 
	
	nano_mouth.hide() # Lo nascondiamo per sicurezza, anche se non è visibile
	await get_tree().create_timer(5).timeout
	GlobalGame.hide_line()
	
	get_tree().change_scene_to_file(SCENA_COOPER_CLOSEUP)
	
	
	#1 
