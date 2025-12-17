extends Area2D

# Collega il nodo audio e l'animazione (creati nel Motel.tscn)
@export var window_audio_player: AudioStreamPlayer
@export var lightning_animation_player: AnimationPlayer
var looked_at_window  = false
'''
func _input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if not looked_at_window:
			# anccora non ho guardato la ifnestra, Alex parla e avviamo gli effetti
			GlobalGame.show_message("Fuori c'è un ronzio che non è di questo mondo. Quella luce, quel tremolio...")
			#avvia il ronzio
			window_audio_player.play()
			
			# 2 Avvia l'animazione visiva delle scariche (es: un TextureRect che lampeggia)
			lightning_animation_player.play("Scariche")
			looked_at_window = true
		else:
			GlobalGame.show_message("E' ancora lì; meglio non guardare troppo a lungo")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
'''
