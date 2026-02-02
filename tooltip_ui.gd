extends CanvasLayer

@onready var label = $Label
@onready var tooltip_offset = Vector2(15,10)

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ""
	visible = false
	
	# check che la label on blocchi i click del mouse
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# ascolta il segnale del GlobalGame
	GlobalGame.tooltip_changed.connect(_on_tooltip_changed)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		label.global_position = label.get_global_mouse_position()+tooltip_offset
	
func _on_tooltip_changed(text:String):
	if text == "":
		visible = false
		label.text = ""
	else:
		label.text = text
		visible = true
		
	
