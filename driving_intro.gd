extends Node2D


@onready var title_label = $CanvasLayer/TitleLabel
@onready var credits_label = $CanvasLayer/CreditsLabel
@onready var recorder_text = $CanvasLayer/RecorderText

@onready var parallax_bg = $ParallaxBackground
@onready var alex_closeup = $AlexxCloseup
@onready var panoramasprite = $PanoramaView

@onready var colonna_sonora = $AudioStreamPlayer

const scena_diner = "res://DoubleRDiner.tscn"
const VELOCITA_SCROLL = 160.0



# Called when the node enters the scene tree for the first time.
func _ready():
	# all'inizio tutto nero 
	self.modulate.a  = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
