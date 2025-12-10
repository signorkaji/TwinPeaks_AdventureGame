# Hotspot_Porta_Ufficio.gd
extends Area2D

const CODICE_CORRETTO = 3450

func _input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		print("Entro nell'ufficio dello sceriffo!")
		# 1. Verifica se il giocatore ha l'indizio per giustificare l'azione
		if GlobalGame.has_item("Manuale_Truman"):
			
			# --- LOGICA DI RICHIESTA CODICE (FIX) ---
			# TODO: Implementare una vera UI (LineEdit/Pannello) per l'input utente.
			# Per ora, useremo un valore HARDCODED per testare la transizione.
			
			#var codice_inserito = GlobalGame.get_last_code_attempt() # Simula la richiesta di un codice
			
			# Se la richiesta viene fatta senza un input UI, assumiamo che vogliano inserirlo.
			# Per il test rapido, usiamo una funzione che assumeremo sia corretta
			
			# --- Qui useremo una funzione per simulare il check ---
			if check_user_input(): 
				GlobalGame.show_message("CLICK. La porta è sbloccata. Passo alla Tana del Leone.")
				# TRANSITION: Passaggio alla scena successiva
				get_tree().change_scene_to_file("res://SheriffOfficeTruman.tscn")
			else:
				GlobalGame.show_fail_message("Codice sbagliato. Maledetto caffè pomeridiano.")
			
		else:
			GlobalGame.show_message("La porta ha un blocco numerico. Devo trovare la sequenza.")

# Funzione per simulare o gestire l'inserimento del codice
# Quando implementerai l'UI, questa funzione chiamerà il pannello di input.
func check_user_input() -> bool:
	# Per ora, restituiamo un successo solo se l'utente ha l'indizio.
	# Quando aggiungerai l'UI, dovrai confrontare l'input dell'utente con CODICE_CORRETTO.
	if GlobalGame.has_item("Manuale_Truman"):
		# ASSUMIAMO che l'utente stia provando 3450 se ha l'indizio
		return true 
	return false
