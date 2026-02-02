extends CanvasLayer

@onready var dialogue_control = $DialogueControl
@onready var dialogue_box = $DialogueControl/NinePatchRect
@onready var text_label = $DialogueControl/NinePatchRect/Label
@onready var name_label = $DialogueControl/NinePatchRect/NameLabel


func _ready(): 
# all'avvio nascondo tutto 
	visible = false
	
	# --- MODIFICHE ESTETICHE VIA CODICE ---
	# Forza il colore bianco per il testo principale
	text_label.add_theme_color_override("font_color", Color.WHITE)
	# Allineamento orizzontale centrato (opzionale, se lo preferisci per box piccoli)
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# connessione ai segnali del singleton GlobalGame
	# globalgame deve avere i segnali dialogue_started e dialogue_finished
	if GlobalGame.has_signal("dialogue_started"):
		GlobalGame.dialogue_started.connect(_on_dialogue_started)
	
	if GlobalGame.has_signal("dialogue_finished"):
		GlobalGame.dialogue_finished.connect(_on_dialogue_finished)
	

func _on_dialogue_started(character_name: String,message:String):
	# aggiorna il nome del personaggio e il testo
	name_label.text = character_name
	text_label.text = message
	
	#mostra il canvas layer
	visible = true
	
	# effetto di comparsa fluida
	dialogue_control.modulate.a = 0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(dialogue_control, "modulate:a",1.0,0.2)
	
#chiamata quando GlobalGame.hide_line() emette il segnale, o se scade il tempo
func _on_dialogue_finished():
	#Effetto di scomparsa fluida applicata al dialogue control
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(dialogue_control, "modulate:a", 0.0,0.2)
	
	#aspetta che l'animazione finisca prima di nascondere il nodo 
	await tween.finished
	visible = false
	text_label.text = ""
	
