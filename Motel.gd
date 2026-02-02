extends "res://Scripts/RoomBase.gd"


# riferimenti ai nodi / oggeti
@onready var insegna_neon = $Insegna_Neon
@onready var hotspot_telefono = $Hotspot_telefono
@onready var hotspot_nota = $Hotspot_Nota
@onready var hotspot_phon  = $Hotspot_Phon
@onready var hotspot_cavi = $Hotspot_Cavi
@onready var hotspot_zerbino = $HotSpot_Zerbino_uscita

#Variabili di stato dell'enigma 
var telefono_spostato: bool = false
var nota_presa: bool = false
var phon_preso: bool = false
var cavi_riparati: bool = false
var enigma_risolto: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	print("--- Inizio Scena Motel ---- ")
	if insegna_neon:
		insegna_neon.play("sfrigolio")
		
	# Configurazione tooltip centralizzata
	setup_hotspot_tooltip(hotspot_telefono, "Telefono")
	setup_hotspot_tooltip(hotspot_phon, "Asciugacapelli")
	setup_hotspot_tooltip(hotspot_zerbino,"Zerbino (Esci)")
	setup_hotspot_tooltip(hotspot_nota, "Nota Misteriosa")
		
	# la nota è nascosta sotto il telefono
	if hotspot_nota:
		hotspot_nota.visible = false
		hotspot_nota.monitorable = false # finchè un si vede un si clicca


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _input(event):
	# Controlla se l'evento è un click sinistro del mouse
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		# Ottiene la posizione del mouse nel mondo 2D
		var click_position = get_global_mouse_position()
		
		# Invia la destinazione al nodo Alex_Character
		alex.set_target(click_position)


func _on_hotspot_telefono_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# blocca il movimento di Alex verso il click
		get_viewport().set_input_as_handled()
		
		if not telefono_spostato: 
			GlobalGame.show_line("Alex", "Provo a chiamare... niente. Linea morta. Però la base sembra storta...")
			_muovi_telefono()
		else: 
			GlobalGame.show_line("Alex", "Un pezzo di plastica inutile. Almeno ha smesso di squillare nei miei sogni. ")

func _muovi_telefono():
	telefono_spostato = true
	#spostiamo il telefono 
	var tween = create_tween()
	tween.tween_property(hotspot_telefono, "position:x", hotspot_telefono.position.x +40, 0.6).set_trans(Tween.TRANS_SINE)
	await tween.finished
	if hotspot_nota:
		hotspot_nota.visible = true
		hotspot_nota.monitorable = true
		print("Nota rivelata sotto al telefono")
	
func _on_hotspot_finestra_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_hotspot_valigia_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_hotspot_nota_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		
		if not nota_presa:
			nota_presa = true
			GlobalGame.show_line("Alex", "C'è qscritto: 'La verità non è nell'ordine. cerca la stazione.")
			GlobalGame.add_item("Biglietto Misterioso")
			
			#sblocca il dipartimento dello sceriffo sulla mappa
			GlobalGame.unlock_location("Double R Diner","res://DoubleRDiner.tscn")
			
			# rimuovo l'oggetto fisico dalla stanza
			hotspot_nota.queue_free()
			


func _on_hotspot_phon_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
	
		if not phon_preso:
			phon_preso = true
			GlobalGame.show_line("Alex", "Un asciugacapelli anni '80. Il cavo è tutto mangiucchiato, ma il motore sembra OK. ")
			GlobalGame.add_item("Phon Rotto")
			hotspot_phon.queue_free()


func _on_hotspot_cavi_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		
		if cavi_riparati:
			GlobalGame.show_line("Alex", "La corrente ora scorre correttamente, sento odore di ozono.")
			return
			
			# controllo se il giocatore ha gli oggetti giusti
		if GlobalGame.has_item("Phon Rotto"):
			_risolvi_enigma_cavi()
		else:
			GlobalGame.show_line("Alex", "Questi cavi partono dalla finestra. Se riuscissi a creare un ponte elettrico...")
				


func _risolvi_enigma_cavi():
	cavi_riparati = true
	GlobalGame.show_line("Alex", "Uso il motore del phon per stabilizzare la tensione... ecco fatto!")
	
	if insegna_neon:
		insegna_neon.play("accesa_fissa")
		
	# feedback sonoro (TODO per logica futura) 
	print("Enigma risolto: Insegna stabilizzata" )
	
	#sblocco finale per uscire dalla stanza
	GlobalGame.show_line("Alex", "Ora che c'è luce, posso vedere meglio la porta. E' ora di andarsene.")



func _on_hot_spot_zerbino_uscita_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		
		if GlobalGame.has_item("Biglietto Misterioso") and cavi_riparati:
			GlobalGame.show_line("Alex", "E' ora di muoversi. Quello zerbino ha visto giorni migliori... come me. Prima, però. ho bisogno di un caffè al Double R!")
			_esci_verso_viaggio()
		elif not GlobalGame.has_item("Biglietto Misterioso"):
			GlobalGame.show_line("Alex", "Non posso andarmene ancora. Sento che c'è qualcosa di importante qui che mi sfugge.")
		elif not cavi_riparati: 
			GlobalGame.show_line("Alex","Non posso andarmene ancora. Sento che c'è ancora qualcosa di importante in questa stanza che mi sfugge.")
		

func _esci_verso_viaggio():
	# input disabilitati per il fade
	set_process_input(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.5)
	
	await tween.finished
	get_tree().change_scene_to_file("res://driving_intro.tscn")
	
