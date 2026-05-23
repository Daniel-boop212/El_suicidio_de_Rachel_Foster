extends Control

signal minijuego_terminado(resultado, recompensa)

# ---------------- ARCHIVOS ----------------
var archivos = [
	{
		"nombre": "foto_vacaciones.png",
		"evidencia": false
	},
	{
		"nombre": "amenazas_chat.png",
		"evidencia": true
	},
	{
		"nombre": "tarea.docx",
		"evidencia": false
	},
	{
		"nombre": "captura_insultos.jpg",
		"evidencia": true
	},
	{
		"nombre": "meme.png",
		"evidencia": false
	},
	{
		"nombre": "cuenta_falsa.txt",
		"evidencia": true
	}
]

# ---------------- PROGRESO ----------------
var evidencias_encontradas = 0
var evidencias_necesarias = 3

# ---------------- TIEMPO ----------------
var tiempo_total = 15.0
var tiempo_restante = 15.0

var terminado = false

# ---------------- INIT ----------------
func _ready():

	set_anchors_preset(Control.PRESET_FULL_RECT)

	set_process(true)

	# grid como escritorio
	$ScrollContainer/GridContainer.columns = 3

	# separacion
	$ScrollContainer/GridContainer.add_theme_constant_override(
		"h_separation",
		15
	)

	$ScrollContainer/GridContainer.add_theme_constant_override(
		"v_separation",
		15
	)

	crear_archivos()

# ---------------- LOOP ----------------
func _process(delta):

	if terminado:
		return

	tiempo_restante -= delta

	if tiempo_restante <= 0:
		tiempo_restante = 0
		terminar(false)

	actualizar_barra()

# ---------------- TIMER ----------------
func actualizar_barra():

	$TimerBar.value = tiempo_restante / tiempo_total

# ---------------- CREAR ARCHIVOS ----------------
func crear_archivos():

	archivos.shuffle()

	for data in archivos:

		var boton = Button.new()

		# nombre archivo
		boton.text = data["nombre"]

		# tamaño escritorio
		boton.custom_minimum_size = Vector2(140, 100)

		# expandir
		boton.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# asegurar visibilidad
		boton.modulate = Color(1, 1, 1, 1)

		# ---------------- ESTILO NORMAL ----------------
		var estilo = StyleBoxFlat.new()

		# fondo negro oscuro
		estilo.bg_color = Color(0.05, 0.05, 0.05)

		# bordes redondeados
		estilo.corner_radius_top_left = 10
		estilo.corner_radius_top_right = 10
		estilo.corner_radius_bottom_left = 10
		estilo.corner_radius_bottom_right = 10

		# borde gris
		estilo.border_width_left = 2
		estilo.border_width_top = 2
		estilo.border_width_right = 2
		estilo.border_width_bottom = 2

		estilo.border_color = Color(0.2, 0.2, 0.2)

		boton.add_theme_stylebox_override(
			"normal",
			estilo
		)

		# ---------------- HOVER ----------------
		var hover = StyleBoxFlat.new()

		hover.bg_color = Color(0.25, 0.25, 0.25)

		hover.corner_radius_top_left = 10
		hover.corner_radius_top_right = 10
		hover.corner_radius_bottom_left = 10
		hover.corner_radius_bottom_right = 10

		hover.border_width_left = 2
		hover.border_width_top = 2
		hover.border_width_right = 2
		hover.border_width_bottom = 2

		hover.border_color = Color(0.4, 0.4, 0.4)

		boton.add_theme_stylebox_override(
			"hover",
			hover
		)

		# ---------------- PRESSED ----------------
		var pressed = StyleBoxFlat.new()

		pressed.bg_color = Color(0.15, 0.15, 0.15)

		pressed.corner_radius_top_left = 10
		pressed.corner_radius_top_right = 10
		pressed.corner_radius_bottom_left = 10
		pressed.corner_radius_bottom_right = 10

		pressed.border_width_left = 2
		pressed.border_width_top = 2
		pressed.border_width_right = 2
		pressed.border_width_bottom = 2

		pressed.border_color = Color(0.5, 0.5, 0.5)

		boton.add_theme_stylebox_override(
			"pressed",
			pressed
		)

		# ---------------- TEXTO ----------------
		boton.add_theme_color_override(
			"font_color",
			Color.WHITE
		)

		# ---------------- CLICK ----------------
		boton.pressed.connect(func():

			abrir_archivo(data, boton)

		)

		# agregar al grid
		$ScrollContainer/GridContainer.add_child(boton)

# ---------------- ABRIR ARCHIVO ----------------
func abrir_archivo(data, boton):

	if data["evidencia"]:

		evidencias_encontradas += 1

		$Label.text = (
			"Evidencias: "
			+ str(evidencias_encontradas)
			+ "/"
			+ str(evidencias_necesarias)
		)

		boton.disabled = true

		# cambiar color
		var encontrado = StyleBoxFlat.new()

		encontrado.bg_color = Color(0.1, 0.4, 0.1)

		encontrado.corner_radius_top_left = 10
		encontrado.corner_radius_top_right = 10
		encontrado.corner_radius_bottom_left = 10
		encontrado.corner_radius_bottom_right = 10

		boton.add_theme_stylebox_override(
			"normal",
			encontrado
		)

		# popup
		$Popup.visible = true

		$Popup/Label.text = (
			"✔ Encontraste evidencia:\n"
			+ data["nombre"]
		)

		if evidencias_encontradas >= evidencias_necesarias:
			terminar(true)

	else:

		$Popup.visible = true

		$Popup/Label.text = (
			"Este archivo no contiene evidencia."
		)

# ---------------- TERMINAR ----------------
func terminar(resultado):

	if terminado:
		return

	terminado = true

	if resultado:
		$Label.text = "✔ Caso actualizado"
	else:
		$Label.text = "✖ No encontraste suficientes pruebas"

	await get_tree().create_timer(1.5).timeout

	emit_signal(
		"minijuego_terminado",
		resultado,
		10 if resultado else 0
	)

	queue_free()
