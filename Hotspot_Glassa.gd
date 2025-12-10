# Hotspot_Glassa.gd
extends Area2D

func _input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.is_pressed():
		if not GlobalGame.has_item("Glassa_Ciambella"):
			GlobalGame.show_message("Un avanzo di glassa. Viscoso, dolce e molto, molto scivoloso.")
			GlobalGame.add_item("Glassa_Ciambella")
			
			# NASCONDIAMO LA SPRITE DELLA GLASSA:
			$Glassa_Sprite.visible = false # Rende la sprite invisibile
			# Oppure: queue_free() se vuoi rimuovere completamente il nodo.
			
			# Disabilita l'hotspot per evitare ulteriori interazioni
			monitorable = false 
		else:
			GlobalGame.show_fail_message("Non mi serve altra glassa, Alex.")
