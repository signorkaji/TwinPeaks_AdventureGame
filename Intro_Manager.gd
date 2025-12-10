# Intro_Manager.gd
extends Control

# Riferimenti ai nodi
@onready var meanwhile_text = $FadeLayer/Meanwhile_Text
@onready var black_screen = $FadeLayer/Black_Screen
@onready var intro_music = $Intro_Music 

# Scene
const SCENA_PROLOGO_LOGGIA = preload("res://Prologo_Loggia.tscn")

# VARIABILI DI TEMPO (In Secondi)
const TEMPO_PAUSA_INIZIALE = 20.0 
const DURATA_TESTO_FADE = 1.0     
const DURATA_NERO_FADE = 4.0      
const DURATA_MUSICA_FINALE = 5.0  

# Variabile per tenere l'istanza della Loggia
var loggia_instance: Node = null


func _ready():
	black_screen.modulate.a = 1.0  
	meanwhile_text.modulate.a = 0.0 
	
	intro_music.volume_db = 0.0
	intro_music.play()
	
	await get_tree().create_timer(TEMPO_PAUSA_INIZIALE).timeout
	start_text_sequence()


func start_text_sequence():
	var text_tween = create_tween()
	text_tween.tween_property(meanwhile_text, "modulate:a", 1.0, DURATA_TESTO_FADE)
	
	await get_tree().create_timer(2.0).timeout 
	
	text_tween = create_tween()
	text_tween.tween_property(meanwhile_text, "modulate:a", 0.0, DURATA_TESTO_FADE)
	
	await text_tween.finished
	start_loggia_fade()


func start_loggia_fade():
	# 1. Rende visibile la Loggia in background (SOTTO il nero)
	_load_loggia_visual()
	
	# 2. Fade-out del Nero (rivela la Loggia)
	var fade_tween = create_tween()
	fade_tween.tween_property(black_screen, "modulate:a", 0.0, DURATA_NERO_FADE)
	
	await fade_tween.finished
	
	# 3. Transizione e Fade-out Audio
	finalize_transition()


# Carica la Loggia in background
func _load_loggia_visual():
	if loggia_instance == null:
		loggia_instance = SCENA_PROLOGO_LOGGIA.instantiate()
		# LA AGGIUNGE ALLA RADICE: in questo modo è già lì quando il nero svanisce
		get_tree().root.add_child(loggia_instance)
		loggia_instance.show()


# Gestisce la transizione e il fade audio persistente (CORRETTO)
func finalize_transition():
	
	# 1. Mette in pausa e rende l'audio persistente
	intro_music.stop() 
	intro_music.get_parent().remove_child(intro_music)
	get_tree().root.add_child(intro_music)
	
	# 2. **SOLUZIONE CRASH:** Non cambiamo scena. Eliminiamo solo la scena Intro (questo nodo)
	# La Loggia è già la scena attiva.
	queue_free()
	
	# 3. RI-AVVIA la riproduzione persistente e avvia il Fade-out Audio
	intro_music.play() 
	
	var music_tween = create_tween()
	music_tween.tween_property(intro_music, "volume_db", -80.0, DURATA_MUSICA_FINALE)
	
	# 4. Pulizia
	await music_tween.finished
	intro_music.queue_free()
