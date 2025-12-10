extends Node2D

# Variabile per il percorso della prossima scena (il Motel)
const SCENA_MOTEL = preload("res://Motel.tscn")

const FADE_TIME = 2.0 # Durata del fade in secondi

# RIFERIMENTI AI NODI (AGGIUSTATI)
@onready var laura_palmer = $"Laura Palmer"
@onready var alex_riley = $Alex_Riley
@onready var cooper_buono = $Cooper_Buono
@onready var cooper_cattivo = $"Cooper__Cattivo" # Rinomino per la sintassi Godot
@onready var il_nano = $Il_Nano
@onready var bob_sprite = $Bob_Sprite
@onready var musica_loggia = $Loggia_Sound # Musica cupa di sottofondo
@onready var nano_jazz_player = $Nano_Jazz_Player # Musica jazz per il Nano
@onready var musica_greve_persistente = get_tree().root.get_node_or_null("Intro_Music") # Uso get_node_or_null per evitare crash se il nodo non è trovato
# ERA: @onready var musica_greve_persistente = get_tree().root.get_node("Intro_Music") 

# costanti di posizione e animazione
const POSIZIONE_FUORI_SX = Vector2(-200, 210)
const POSIZIONE_DANZA = Vector2(180, 210)
const POSIZIONE_NANO_SEDUTO = Vector2(140, 175)
const NOME_ANIM_CAMMINA = "camminata"
const NOME_ANIM_DANZA = "danza" # Verifica che sia questo il nome esatto nell'editor (D maiuscola/minuscola)

# Sprite statica nano a sedere
const NANO_SEDUTO_TEXTURE = preload("res://Assets/Sprites/nano_seduto_sprite.png")
const SCALA_NANO_DESIDERATA = 0.1

# variabile per il nano seduto istanzaito
var nano_seduto_instance: Sprite2D = null

var anello_dato = false
var timer_transizione = 0.0
var tempo_per_transizione = 5.0 # 5 secondi per il prologo 

# Called when the node enters the scene tree for the first time.
func _ready():
	 # 1 - configurazine iniziale
	cooper_cattivo.hide()
	bob_sprite.hide()
	laura_palmer.hide()
	alex_riley.hide()
	
	# il nano è fuori campo
	il_nano.position = POSIZIONE_FUORI_SX
	
	# Avvia la sequenza cinematica
	start_prologue_sequence()

# --- FUNZIONI AUDIO E FADE (DEVE ESSERE PRIMA DELLA CHIAMATA) ---

func start_nano_jazz_fade():
	
	# 1. Start Fade-Out della Musica Greve (Musica Loggia)
	# Controlla se il nodo persistente esiste
	if is_instance_valid(musica_greve_persistente):
		var tween_out = create_tween()
		tween_out.tween_property(musica_greve_persistente, "volume_db", -80.0, FADE_TIME)
	
	# 2. Prepara e Start Fade-In del Jazz del Nano
	nano_jazz_player.volume_db = -80 # CRUCIALE: Inizia da silenzio
	nano_jazz_player.play()
	
	var tween_in = create_tween()
	# Alza il volume fino a un livello di ascolto confortevole (es. -5 Db)
	tween_in.tween_property(nano_jazz_player, "volume_db", -5.0, FADE_TIME)
	
	# 3. Aspetta che il fade sia completato prima di procedere con l'azione
	await tween_in.finished
	
	print("Transizione Audio completata. Inizia la sequenza successiva.")

# --- SEQUENZA CINEMATICA PRINCIPALE ---

func start_prologue_sequence():
	# 1. AUDIO FADE-OUT GREVE e FADE-IN JAZZ
	start_nano_jazz_fade()
	
	# 2. Aspetta 0.2s (Breve attesa per permettere alla Loggia di stabilizzarsi)
	await get_tree().create_timer(0.2).timeout
	
	# 3. IL NANO ENTRA CAMMINANDO
	il_nano.show()
	il_nano.play(NOME_ANIM_CAMMINA)
	
	var camminata_tween = create_tween()
	# Durata 10.0 secondi (movimento lento)
	camminata_tween.tween_property(il_nano, "position", POSIZIONE_DANZA, 10.0)
	print("il nano cammina")
	await camminata_tween.finished
	
	# --- CORREZIONE QUI: Transizione immediata dalla Camminata alla Danza ---
	il_nano.stop() 
	
	# 4. DANZA
	il_nano.play(NOME_ANIM_DANZA) # INIZIA SUBITO DOPO LA CAMMINATA
	
	await get_tree().create_timer(10.0).timeout # Danza per 10 secondi
	il_nano.stop()
	
	# 5. NANO SI METTE A SEDERE
	# creiamo lo sprite del nano seduto 
	if not is_instance_valid(nano_seduto_instance):
		nano_seduto_instance = Sprite2D.new()
		nano_seduto_instance.texture = NANO_SEDUTO_TEXTURE
		nano_seduto_instance.scale = Vector2(SCALA_NANO_DESIDERATA, SCALA_NANO_DESIDERATA)
		nano_seduto_instance.flip_h = true
		add_child(nano_seduto_instance)
	
	nano_seduto_instance.position = POSIZIONE_NANO_SEDUTO
	il_nano.hide()
	nano_seduto_instance.show()
	
	# 6. PAUSA VISIVA PRIMA DEL CLOSE-UP
	await get_tree().create_timer(2.0).timeout
	
	# 7. TRANSIZIONE AL CLOSE-UP DEL NANO
	var canvas_layer = CanvasLayer.new()
	get_tree().root.add_child(canvas_layer)
	canvas_layer.layer = 100
	
	var fade_rect = ColorRect.new()
	fade_rect.color = Color(0,0,0,0)
	fade_rect.anchors_preset = Control.PRESET_FULL_RECT
	canvas_layer.add_child(fade_rect)
	
	# fade a nero effettivo 
	var tween_fade = create_tween()
	tween_fade.tween_property(fade_rect, "color:a", 1.0, 0.5)
	await tween_fade.finished
	
	# --- MODIFICA CRITICA QUI SOTTO ---
	# Rendi persistente il Jazz del Nano (lo sposta al Root)
	nano_jazz_player.get_parent().remove_child(nano_jazz_player)
	get_tree().root.add_child(nano_jazz_player)
	
	# NON LIBERARE IL NODO: COMMENTATA LA RIGA DI QUEUE_FREE()
	# nano_jazz_player.queue_free()
	# --- FINE MODIFICA CRITICA ---
	
	get_tree().change_scene_to_file("res://nano_close_up.tscn")
	canvas_layer.queue_free()


# --- FUNZIONI DI GIOCO NON CINEMATICHE ---

func _process(delta):
	# Controlla se l'anello è stato dato e il tempo è scaduto
	if anello_dato:
		pass
		timer_transizione += delta
		
		if timer_transizione >= tempo_per_transizione:
			transizione_a_motel()

func transizione_a_motel():
	# ... (funzione per la transizione al Motel)
	print("Transizione verso il Motel...")
	
	# PULIZIA FINALE: Cerca il nodo persistente e lo libera quando usciamo dalla Loggia
	if is_instance_valid(nano_jazz_player):
		nano_jazz_player.queue_free()
	
	# IMPORTANTE: Il percorso della SCENA_MOTEL deve esistere
	get_tree().change_scene_to_packed(SCENA_MOTEL)
