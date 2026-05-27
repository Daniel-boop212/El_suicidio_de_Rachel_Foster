extends Control

const DETECTIVE_SCENE := "res://jugador_1/player_move.tscn"
const POLICIA_SCENE := "res://jugador_2/jugador_2_ui.tscn"

@onready var label = $Panel/Label
@onready var timer = $Timer
@onready var imagen = $TextureRect
@onready var fade = $Fade

var escena_actual := 0
var texto_actual := 0
var letra_actual := 0

var texto := ""

var escenas = [
	{
		"imagen": preload("res://jugador_1/escenas/inicio_1.png"),
		"textos": [
			"Rachel: No soporto más...",
			"Rachel: ¿Será que sí le importo a alguien?"
		]
	},
	{
		"imagen": preload("res://jugador_1/escenas/inicio_2.png"),
		"textos": [
			"Rachel: alguien......",
			"Rachel: ¿alguien me notará?",
			"¿Podrás salvarla?"
		]
	}
]

func _ready():

	# Fade inicia transparente
	fade.modulate.a = 0.0

	cargar_texto()

func cargar_texto():

	imagen.texture = escenas[escena_actual]["imagen"]

	texto = escenas[escena_actual]["textos"][texto_actual]

	label.text = ""

	letra_actual = 0

	timer.start()

func _on_timer_timeout():

	# Escribir letra por letra
	if letra_actual < texto.length():

		label.text += texto[letra_actual]

		letra_actual += 1

	# Cuando termina el texto
	else:

		timer.stop()

		# Tiempo para leer
		await get_tree().create_timer(3.0).timeout

		siguiente_texto()

func siguiente_texto():

	texto_actual += 1

	# Más textos en la misma imagen
	if texto_actual < escenas[escena_actual]["textos"].size():

		cargar_texto()

	else:

		# Cambiar imagen
		escena_actual += 1
		texto_actual = 0

		if escena_actual < escenas.size():

			await transicion()

			cargar_texto()

		else:

			await entrar_al_juego()

func transicion() -> void:

	# Fade a negro
	while fade.modulate.a < 1.0:

		fade.modulate.a += 0.05

		await get_tree().process_frame

	# Fade desde negro
	while fade.modulate.a > 0.0:

		fade.modulate.a -= 0.05

		await get_tree().process_frame

func entrar_al_juego():

	# Fade final
	while fade.modulate.a < 1.0:

		fade.modulate.a += 0.03

		await get_tree().process_frame

	if Global.rol_multijugador == "detective":

		get_tree().change_scene_to_file(DETECTIVE_SCENE)

	else:

		get_tree().change_scene_to_file(POLICIA_SCENE)
