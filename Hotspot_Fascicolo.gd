extends Area2D


func _input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		GlobalGame.unlock_location("Double_R_Diner")
		GlobalGame.unlock_location("Great_Northern")
		# Il giocatore è ora libero di scegliere dove andare.
		get_tree().change_scene_to_file("res://MapScene.tscn")
