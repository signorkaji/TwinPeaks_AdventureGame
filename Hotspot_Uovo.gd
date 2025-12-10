extends Area2D

# collega il noso Sprite per farlo sparire quando viene raccolto 
@onready var uovo_sprite = $Uovo_Sprite

func _input_event(viewport: Node, event: InputEvent, shape_idx: int):
	print("Qualcosa accade")
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		print("Uovo Fritto intercettato!")
		if not GlobalGame.has_item("Uovo_Fritto_Truman"):
			GlobalGame.show_message("Un uovo fritto solitario. L'arte non dovrebbe mai essere lasciata al freddo. Lo prendo.")
			GlobalGame.add_item("Uovo_Fritto_Truman")
			uovo_sprite.visible = false # nasconde lo sprite
			monitorable = false # disabilita l'hotspot
		else:
			GlobalGame.show_fail_message()



