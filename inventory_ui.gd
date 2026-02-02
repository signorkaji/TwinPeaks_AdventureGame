extends CanvasLayer

# --- INVENTORY UI ---
# Gestisce la visualizzazione dell'inventario con animazione a comparsa.

@onready var inventory_bar = $InventoryControl/InventoryBar
@onready var item_container = $InventoryControl/InventoryBar/ItemContainer

var is_open = false
const TWEEN_DURATION = 0.3
const HIDDEN_Y = -120 # Posizione fuori schermo (in alto)
const VISIBLE_Y = 10   # Posizione visibile (leggermente staccata dal bordo)

func _ready():
	# Inizializza la barra fuori dallo schermo
	inventory_bar.position.y = HIDDEN_Y
	
	# Si collega al segnale del GlobalGame per aggiornarsi automaticamente
	GlobalGame.inventory_changed.connect(_on_inventory_updated)
	
	# Popolamento iniziale (se Alex ha già oggetti)
	_on_inventory_updated()

func _input(event):
	# Apertura automatica al passaggio del mouse vicino al bordo superiore
	if event is InputEventMouseMotion:
		if event.position.y < 40 and not is_open:
			_toggle_inventory(true)
		elif event.position.y > 150 and is_open:
			_toggle_inventory(false)

func _toggle_inventory(open: bool):
	is_open = open
	var target_y = VISIBLE_Y if open else HIDDEN_Y
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(inventory_bar, "position:y", target_y, TWEEN_DURATION)

func _on_inventory_updated():
	# Svuota i vecchi slot
	for child in item_container.get_children():
		child.queue_free()
	
	# Crea le icone per ogni oggetto nell'inventario globale
	for item_id in GlobalGame.inventory:
		var slot = TextureRect.new()
		slot.custom_minimum_size = Vector2(48, 48) # Dimensione icona pixel art
		
		# FIX: In Godot 4 l'ExpandMode corretto per far sì che la texture ignori 
		# la dimensione originale e si adatti allo slot è EXPAND_IGNORE_SIZE.
		slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		# Prova a caricare l'icona specifica
		var texture_path = "res://Assets/Sprites/Items/" + item_id.to_lower() + ".png"
		if FileAccess.file_exists(texture_path):
			slot.texture = load(texture_path)
		else:
			# Placeholder se l'immagine manca (usa l'icona di Godot o un quadrato)
			slot.texture = preload("res://icon.svg")
			slot.modulate = Color.GRAY
		
		# Tooltip o effetti hover
		slot.tooltip_text = item_id.replace("_", " ")
		
		item_container.add_child(slot)
