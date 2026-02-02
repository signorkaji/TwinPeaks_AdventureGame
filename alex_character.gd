extends CharacterBody2D

# --- COSTANTI DI MOVIMENTO ---
const SPEED = 200.0 # Velocità di camminata
const STOPPING_DISTANCE = 5.0 # Distanza minima per considerare Alex arrivato
const HORIZONTAL_CLAM_TOLERANCE = 20.0 # Se il click è entro questa distanza verticale, viene bloccato in orizzontale.
const SPRITE_NODE_NAME = "Alex_Sprite"


@onready var alex_sprite: AnimatedSprite2D = $Alex_Sprite
var target_position: Vector2 # La destinazione dove Alex deve muoversi
var input_direction: Vector2 = Vector2.ZERO # Vettore per la direzione di movimento

func _ready():
	target_position = global_position
	alex_sprite.play("idle") 
	velocity = Vector2.ZERO 
	
# --- GESTIONE INPUT (CLICK DEL MOUSE) ---

# Chiamato dalla scena di test (Motel_Room.gd) per impostare la destinazione
func set_target(new_target: Vector2):
	
	
	
	# FIX: Se il click è quasi orizzontale (entro la tolleranza verticale),
	# blocca la destinazione Y sulla posizione attuale di Alex (global_position.y).
	var vertical_diff = abs(new_target.y - global_position.y)
	
	if vertical_diff < HORIZONTAL_CLAM_TOLERANCE:
		# Muovi orizzontalmente sulla stessa "altezza" del pavimento
		target_position = Vector2(new_target.x, global_position.y)
	else:
		# Muovi in profondità (su/giù)
		target_position = new_target

# --- GESTIONE FISICA (MOVIMENTO VERSO IL TARGET) ---

func _physics_process(delta):
	var distance_to_target = global_position.distance_to(target_position)
	
	if distance_to_target > STOPPING_DISTANCE:
		input_direction = (target_position - global_position).normalized()
	else:
		input_direction = Vector2.ZERO
	
	# Salviamo la posizione PRIMA di muoverci
	var previous_position = global_position
	
	apply_movement(delta)
	
	# --- CONTROLLO BLOCCAGGIO (STUCK CHECK) ---
	# Se stavamo cercando di muoverci...
	if input_direction != Vector2.ZERO:
		# ...ma ci siamo mossi di pochissimo (es. meno di 0.5 pixel), significa che abbiamo sbattuto
		var moved_distance = global_position.distance_to(previous_position)
		
		if moved_distance < 0.5:
			# Abbiamo sbattuto contro un muro/letto!
			# Fermiamo Alex resettando il target sulla posizione attuale
			target_position = global_position
			input_direction = Vector2.ZERO
			# Questo fermerà l'animazione di camminata al prossimo frame
			
	update_animation()
	

func apply_movement(delta):
	velocity = input_direction * SPEED
	move_and_slide()

# --- GESTIONE ANIMAZIONE ---

func update_animation():
	if input_direction != Vector2.ZERO:
		# Animazione di camminata
		var direction_name = "idle"
		if input_direction.y > 0.1: 
			direction_name = "walk_down"
		elif input_direction.y < -0.1: 
			direction_name = "walk_up"
		elif abs(input_direction.x) > 0.1: 
			direction_name = "walk_side"
			
			if input_direction.x < 0:
				alex_sprite.flip_h = true 
			else:
				alex_sprite.flip_h = false 
		
		if alex_sprite.get_animation() != direction_name:
			alex_sprite.play(direction_name)
	
	else:
		# Animazione Idle (fermo)
		alex_sprite.flip_h = false
		if alex_sprite.get_animation() != "idle":
			alex_sprite.play("idle")
