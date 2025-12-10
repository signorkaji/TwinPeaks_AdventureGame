extends CanvasLayer

@onready var dialog_text = $Sfondo_Box/Dialog_Text
@onready var sfondo_box = $Sfondo_Box

signal initialized

func set_text(testo:String):
	dialog_text.call_deferred("set", "text", testo)

func show_ui():
	visible = true
	sfondo_box.modulate.a = 1.0
	
func hide_ui():
	visible = false

func _ready():
	# Quando tutte le variabili @onready sono state assegnate, emetti il segnale
	emit_signal("initialized")	
