extends Control

@onready var label = $Panel/Label
@onready var timer = $Timer
@onready var imagen = $TextureRect
@onready var fade = $Fade

var escena_actual := 0
var texto_actual := 0
var letra_actual := 0

var texto := ""

var escenas := []

func _ready():

	fade.modulate.a = 0.0

	cargar_final()

	cargar_texto()

func cargar_final():

	match Global.final_actual:

		"positivo":

			escenas = [
				{
					"imagen": preload("res://jugador_1/escenas/final_a (1).jpg"),
					"textos": [
						"Rachel dio un paso atrás del borde.",
						"Por primera vez en mucho tiempo...",
						"alguien realmente la escuchó."
					]
				}
			]

		"intermedio":

			escenas = [
				{
					"imagen": preload("res://jugador_1/escenas/final_b.jpg"),
					"textos": [
						"Rachel no saltó.",
						"Pero tampoco pudo sonreír.",
						"costara volver a sonreir....",
						"pero alguien la noto y por ahora eso basta"
					]
				}
			]

		"malo":

			escenas = [
				{
					"imagen": preload("res://jugador_1/escenas/final_c.jpg"),
					"textos": [
						"Las palabras llegaron demasiado tarde.",
						"El silencio ganó."
					]
				},
				{
					"imagen": preload("res://jugador_1/escenas/Black_colour.jpg.webp"),
					"textos": [
						"Rachel tomo una mala decision",
						"no lo lograron"
					]
				}
			]

func cargar_texto():

	imagen.texture = escenas[escena_actual]["imagen"]

	texto = escenas[escena_actual]["textos"][texto_actual]

	label.text = ""

	letra_actual = 0

	timer.start()

func _on_timer_timeout():

	if letra_actual < texto.length():

		label.text += texto[letra_actual]

		letra_actual += 1

	else:

		timer.stop()

		await get_tree().create_timer(3.0).timeout

		siguiente_texto()

func siguiente_texto():

	texto_actual += 1

	if texto_actual < escenas[escena_actual]["textos"].size():

		cargar_texto()

	else:

		escena_actual += 1
		texto_actual = 0

		if escena_actual < escenas.size():

			await transicion()

			cargar_texto()

		else:

			await volver_menu()

func transicion():

	while fade.modulate.a < 1.0:

		fade.modulate.a += 0.05

		await get_tree().process_frame

	while fade.modulate.a > 0.0:

		fade.modulate.a -= 0.05

		await get_tree().process_frame

func volver_menu():

	while fade.modulate.a < 1.0:

		fade.modulate.a += 0.03

		await get_tree().process_frame

	get_tree().change_scene_to_file("res://jugador_1/Victoria.tscn")
