extends Area2D

func _input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if not GlobalGame.has_item("Cenere_Zucchero"):
			GlobalGame.show_message("Sotto il bancone. Una bustina di zucchero, ma piena di cenere. Molto Twin Peaks.")
			GlobalGame.add_item("Cenere_Zucchero")
			monitorable = false
		else: 
			GlobalGame.show_fail_message("Ho già la prova bizzarra")
