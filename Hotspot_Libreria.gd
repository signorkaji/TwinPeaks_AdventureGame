# Hotspot_Libreria.gd
extends Area2D

var has_manual = false

func _ready():
	monitorable = false # Inizialmente bloccato
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if not has_manual:
			GlobalGame.show_message("Il manuale amministrativo di Truman! Ah, '05:43 - Momento Magico (PM)' per il caffè. Il codice è al contrario. 3-4-5-0.")
			GlobalGame.add_item("Manuale_Truman") # Aggiunge l'indizio visuale
			has_manual = true
		else:
			GlobalGame.show_message("Ho l'indizio. Ora la porta.")
