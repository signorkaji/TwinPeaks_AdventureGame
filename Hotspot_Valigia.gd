# Hotspot_Valigia.gd
extends Area2D

var is_open = false


func _input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_open:
			GlobalGame.show_message("La mia valigia. Kit essenziale: registratore 'Roxanne' e nastro adesivo.")
			GlobalGame.add_item("Registratore_Roxanne")
			GlobalGame.add_item("Nastro_Adesivo")
			is_open = true
		else:
			GlobalGame.show_fail_message("Ho preso ciò che mi serve. Il resto può aspettare.")
