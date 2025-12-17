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
	await  get_tree().create_timer(0.05).timeout
	start_cooper_reaction()


	

# reazione di cooper e passaggio alla scena di Laura e il nano (closeup)
func start_cooper_reaction():
	GlobalGame.show_line("Cooper", "?")
	
	# CRUCIALE: Forziamo l'attesa di UN frame per garantire che la UI venga disegnata
	# Questo stabilizza i riferimenti UI dopo il cambio di scena.
	await get_tree().process_frame
	
	# 2. Attesa del tempo di reazione (la riga è visibile per 3.0 secondi)
	await get_tree().create_timer(DURATA_RIGA_COOPER).timeout
	
	# 3. Transizione
	# NON chiamiamo GlobalGame.hide_line() qui! La riga rimane visibile durante il cambio.
	
	# Transizione alla scena successiva (dopo l'attesa)
	get_tree().change_scene_to_file(SCENA_NANO_LAURA_WIDE)
	
	
	
