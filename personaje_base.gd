extends Control

signal seleccionado(personaje)

@onready var boton = $Button

@onready var cuerpo = $CenterContainer/Node2D/Cuerpo
@onready var ropa = $CenterContainer/Node2D/Ropa
@onready var cabello = $CenterContainer/Node2D/Cabello

func _ready():

	boton.pressed.connect(_on_pressed)

	cuerpo.play("Cuerpo")

func _process(delta):

	# sincronizar capas
	ropa.frame = cuerpo.frame
	cabello.frame = cuerpo.frame

func configurar(cuerpo_frame, cabello_frame):

	cuerpo.sprite_frames = preload("res://jugador_1/menu/cuerpo.tres")
	ropa.sprite_frames = preload("res://jugador_1/menu/ropa.tres")
	cabello.sprite_frames = preload("res://jugador_1/menu/cabello.tres")

	cuerpo.play("default")
	ropa.play("default")
	cabello.play("default")

	cuerpo.frame = cuerpo_frame
	cabello.frame = cabello_frame
	
func _on_pressed():
	emit_signal("seleccionado", self)
