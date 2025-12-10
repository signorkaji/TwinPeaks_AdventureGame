# Hotspot_SediaLucy.gd
extends Area2D

var is_blocked = true

func on_item_used(item_name: String):
	if item_name == "Glassa_Ciambella" and is_blocked:
		GlobalGame.show_message("La glassa rende le ruote incredibilmente scivolose. Ottimo lavoro, Lucy! Il cassetto è libero.")
		is_blocked = false
		# Rimuove l'oggetto dalla sprite di Lucy o la muove leggermente.
		# Rende la libreria cliccabile:
		get_parent().get_node("Hotspot_Libreria").monitorable = true 
		GlobalGame.remove_item("Glassa_Ciambella") 
	else:
		GlobalGame.show_fail_message()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if is_blocked:
			if GlobalGame.has_item("Glassa_Ciambella"):
				on_item_used("Glassa_Ciambella")
				GlobalGame.show_message("La sedia è libera, ma Lucy non lo ha notato.")
			else:
				GlobalGame.show_message("Probabilmente c'è bisogno di qualcosa per muoverla.")
		
				
		
	
		
