# GlobalGame.gd (Caricato come Autoload)
extends Node

const DIALOGUE_UI_SCENE = preload("res://dialog_ui.tscn")
var dialogue_system: CanvasLayer = null
var is_dialogue_system_ready = false
var is_dialogue_active: bool = false

var _auto_hide_timer: Timer = null
var current_tooltip: String = ""

signal inventory_changed
signal dialogue_started(character, text)
signal dialogue_finished
# Struttura dati per gli oggetti: { "id": { "name": "Nome", "icon": "res://path/to/icon.png" } }
signal tooltip_changed(text) # segnale per aggiornare il nome dell'oggetto a schermo


# costanti pe rle location 

const LOCATIONS = {
	"Motel": "res://Motel.tscn",
	"Sheriff's Department": "res://Anticamera.tscn",
	"Double R Diner":  "res://GreatNorthern.tscn",
	"Packard Sawmill": "res://Sawmmill.tscn",
	"The Roadhouse": "res://Roadhouse.tscn",
	"Palmer House": "res://LockedScene.tscn",
	"Glastonbury Grove": "res://LockedScene.tscn"
}

# dizionario che tiene traccia delle location SBLOCCATE
var unlocked_locations = {
	"Motel":LOCATIONS.Motel, 
	"Sheriff's Department": LOCATIONS["Sheriff's Department"], 
	"Double R Diner": LOCATIONS["Double R Diner"]}

# Dizionari per gestire i testi
const FAIL_RESPONSES = [
	"Non funziona così, Alex.",
	"Non credo che questo oggetto voglia collaborare.",
	"Non qui e non ora.",
	"Potrei farlo, ma non risolverebbe nulla.",
	"Se fosse così facile, non sarei in un Motel di Twin Peaks."
]

func _ready():
	# creiamo un timer per la scomparsa automatica (opzionale, come backup)
	_auto_hide_timer = Timer.new()
	_auto_hide_timer.one_shot = true
	_auto_hide_timer.timeout.connect(hide_line)
	add_child(_auto_hide_timer)

# funzione per sbloccare una nuova destinazione 
func unlock_location(location_name: String, scene_path: String =""):
	# verifica che la location esista e che non sia già sbloccata
	if not unlocked_locations.has(location_name):
		unlocked_locations[location_name] = scene_path


# funzione per viaggiare (chiamata cliccando sulla Mappa)
func travel_to(location_name: String):
	if location_name in luoghi_sbloccati:
		var scene_path = luoghi_sbloccati[location_name]
		
		# transizione rapida al nero (per l'effetto di viaggio)
		var fade_rect = ColorRect.new()
		fade_rect.color = Color(0,0,0,0)
		fade_rect.anchors_preset = Control.PRESET_FULL_RECT
		get_tree().root.add_child(fade_rect)
		
		var tween_fade = create_tween()
		# fade a nero in 0.3 s
		tween_fade.tween_property(fade_rect, "color:a", 1.0,0.3)
		await tween_fade.finished
		
		get_tree().change_scene_to_file(scene_path)
	else:
		show_message("Accesso negato. Questa location è bloccata")
		
		


# Inventario
var inventory = []

# --- Funzioni di Sistema ---


func show_message(text: String):
	# QUI AGGIUNGIAMO LA LOGICA PER MOSTRARE IL TESTO SULL'HUD DEL GIOCO
	# Per ora:
	print("ALEX: " + text)

func show_fail_message(specific_text = ""):
	var text_to_show = specific_text
	if specific_text == "":
		var index = randi() % FAIL_RESPONSES.size()
		text_to_show = FAIL_RESPONSES[index]

	show_message(text_to_show)

func try_remove_ring():
	# L'anello non può essere rimosso, logica RIT-M04
	show_fail_message("Non riesco a toglierlo. Mi sento un po' meno Alex e un po' più... legato.")

# --- GESTIONE INVENTARIO ---

func add_item(item_id: String):
	# Evitiamo duplicati se necessario
	if not inventory.has(item_id):
		inventory.append(item_id)
		print("Inventario: Aggiunto ", item_id)
		inventory_changed.emit() # Avvisa la UI di aggiornarsi

func remove_item(item_id: String):
	if inventory.has(item_id):
		inventory.erase(item_id)
		inventory_changed.emit()

func has_item(item_id: String) -> bool:
	return inventory.has(item_id)
	
# Dizionario che tiene traccia delle location sbloccate e dei loro percorsi.
# Usiamo i nomi delle scene per coerenza.
var luoghi_sbloccati = {
	"Motel": "res://Motel.tscn", 
	"Sheriff_Office_Anticamera": "res://Anticamera.tscn",
	# Aggiungeremo le altre man mano che le sblocchiamo:
	# "Double_R_Diner": "res://DoubleRDiner.tscn",
	# "Great_Northern": "res://GreatNorthern.tscn",
}

# Funzione per sbloccare una nuova destinazione (chiamata dai puzzle risolti)
func unlock_location_func(location_name: String, scene_path: String):
	if not luoghi_sbloccati.has(location_name):
		luoghi_sbloccati[location_name] = scene_path
		show_message(location_name + " è ora disponibile sulla Mappa.")
		
		# Esempio di segnale per aggiornare la UI della mappa, se fosse aperta:
		# emit_signal("location_unlocked", location_name)




	
	# ... (il resto del ready)
	
func show_line(character_name: String, text: String, duration: float = 5.0):
	
	is_dialogue_active = true
	dialogue_started.emit(character_name, text)
	
	# avvia il timer, se l'utente non clicca sparisce dopo duration secondi 
	_auto_hide_timer.start(duration)
	print("[Dialogo] "+character_name+": "+text)
	

	
	
func hide_line():
	if is_dialogue_active: 
		is_dialogue_active  = false
		_auto_hide_timer.stop()
		dialogue_finished.emit()
		print("[Dialogo] Chiuso dall'utente o dal timer.")

func _on_dialogue_ui_ready():
	# 1. Ora è sicuro chiamare qualsiasi metodo sul dialogue_system
	dialogue_system.hide_ui()
	is_dialogue_system_ready = true # Settiamo il flag su pronto
	print("Sistema di Dialogo Globalmente Pronto.")
	
func set_tooltip(text: String):
	if current_tooltip != text:
		current_tooltip = text
		tooltip_changed.emit(text)
