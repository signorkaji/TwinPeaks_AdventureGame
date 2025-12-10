# GlobalGame.gd (Caricato come Autoload)
extends Node

const DIALOGUE_UI_SCENE = preload("res://dialog_ui.tscn")
var dialogue_system: CanvasLayer = null
var is_dialogue_system_ready = false

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

# funzione per sbloccare una nuova destinazione 
func unlock_location(location_name: String):
	# verifica che la location esista e che non sia già sbloccata
	if LOCATIONS.has(location_name) and not luoghi_sbloccati.has(location_name):
		unlocked_locations[location_name] = LOCATIONS[location_name]
		show_message(location_name + "è ora disponibile sulla Mappa")


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

func add_item(item_name: String):
	if not inventory.has(item_name):
		inventory.append(item_name)
		show_message(item_name + " aggiunto all'inventario.")


func remove_item(item_name: String):
	# da implementare la rimozione per nome 
	show_message(item_name + " aggiunto all'inventario.")
		
func has_item(item_name: String) -> bool:
	return inventory.has(item_name)
	
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



func _ready():
	# ... (altri setup)
	
	# 1. Istanzia la UI
	var ui_instance = DIALOGUE_UI_SCENE.instantiate()
	
	# 2. Aggiunge la UI in modo differito (risolvendo l'errore)
	# L'azione viene posticipata al frame successivo, quando l'albero è libero.
	ui_instance.initialized.connect(_on_dialogue_ui_ready)
	
	# 3. Assegna il riferimento all'istanza (cruciale!)
	dialogue_system = ui_instance
	
	get_tree().root.call_deferred("add_child", ui_instance) 
	
	# Nascondiamo la UI in modo differito, per sicurezza, dopo che è stata aggiunta.
	await get_tree().create_timer(0.1).timeout
	dialogue_system.hide_ui()
	
	# ... (il resto del ready)
	
func show_line(character_name: String, text: String):
	
	# Se il sistema non è pronto (ad esempio, se chiamato da un altro nodo prima del setup)
	if not is_dialogue_system_ready:
		print("ATTENZIONE: Dialogo chiamato prima del setup. Ritardo l'esecuzione.")
		# Utilizziamo un timer per riprovare in un frame successivo
		await get_tree().create_timer(0.01).timeout 

		# Riprova ricorsivamente (ma attenzione a non creare loop infiniti se fallisce sempre)
		if not is_dialogue_system_ready:
			print("ERRORE CRITICO: Il sistema di dialogo non è pronto. Chiamata fallita.")
			return

	# Se arriviamo qui, il sistema è pronto:
	dialogue_system.set_text(character_name + ": " + text)
	dialogue_system.show_ui()
	
	
func hide_line():
	dialogue_system.hide_ui()

func _on_dialogue_ui_ready():
	# 1. Ora è sicuro chiamare qualsiasi metodo sul dialogue_system
	dialogue_system.hide_ui()
	is_dialogue_system_ready = true # Settiamo il flag su pronto
	print("Sistema di Dialogo Globalmente Pronto.")
