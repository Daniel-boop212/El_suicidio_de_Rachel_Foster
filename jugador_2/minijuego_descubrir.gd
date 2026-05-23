extends Control

signal minijuego_terminado(resultado, recompensa)

# =========================================================
# CASOS POSIBLES
# =========================================================

var casos = [

	# ---------------- CASO 1 ----------------
	[
		{
			"persona": "Laura",
			"texto": "Vi el meme por primera vez a las 8 PM.",
			"sospechoso": false
		},
		{
			"persona": "Carlos",
			"texto": "La cuenta fue creada a las 10 PM.",
			"sospechoso": true
		},
		{
			"persona": "Mateo",
			"texto": "A las 9 PM ya todos compartían la publicación.",
			"sospechoso": false
		}
	],

	# ---------------- CASO 2 ----------------
	[
		{
			"persona": "Sofía",
			"texto": "La captura fue subida en la mañana.",
			"sospechoso": false
		},
		{
			"persona": "Andrés",
			"texto": "El grupo fue creado después del almuerzo.",
			"sospechoso": true
		},
		{
			"persona": "Valeria",
			"texto": "Todos hablaban de la imagen antes del mediodía.",
			"sospechoso": false
		}
	],

	# ---------------- CASO 3 ----------------
	[
		{
			"persona": "Camilo",
			"texto": "El usuario borró la publicación a las 5 PM.",
			"sospechoso": false
		},
		{
			"persona": "Natalia",
			"texto": "Vi la publicación activa a las 7 PM.",
			"sospechoso": true
		},
		{
			"persona": "Daniel",
			"texto": "A las 6 PM ya nadie podía verla.",
			"sospechoso": false
		}
	]

]

# =========================================================
# DATOS DEL CASO ACTUAL
# =========================================================

var testimonios = []

# =========================================================
# TIEMPO
# =========================================================

var tiempo_total = 30.0
var tiempo_restante = 30.0

var terminado = false

# =========================================================
# INIT
# =========================================================

func _ready():

	set_process(true)

	# elegir caso aleatorio
	testimonios = casos.pick_random()

	# tiempo dinamico
	tiempo_total = testimonios.size() * 12.0
	tiempo_restante = tiempo_total

	crear_testimonios()

# =========================================================
# LOOP
# =========================================================

func _process(delta):

	if terminado:
		return

	tiempo_restante -= delta

	if tiempo_restante <= 0:

		tiempo_restante = 0

		terminar(false)

	actualizar_barra()

# =========================================================
# TIMER
# =========================================================

func actualizar_barra():

	$TimerBar.value = tiempo_restante / tiempo_total

# =========================================================
# CREAR TESTIMONIOS
# =========================================================

func crear_testimonios():

	for data in testimonios:

		var panel = PanelContainer.new()

		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# ---------------- ESTILO ----------------
		var estilo = StyleBoxFlat.new()

		estilo.bg_color = Color(0.08, 0.08, 0.08)

		estilo.corner_radius_top_left = 10
		estilo.corner_radius_top_right = 10
		estilo.corner_radius_bottom_left = 10
		estilo.corner_radius_bottom_right = 10

		estilo.border_width_left = 2
		estilo.border_width_top = 2
		estilo.border_width_right = 2
		estilo.border_width_bottom = 2

		estilo.border_color = Color(0.2, 0.2, 0.2)

		panel.add_theme_stylebox_override(
			"panel",
			estilo
		)

		# ---------------- MARGENES ----------------
		var margin = MarginContainer.new()

		margin.add_theme_constant_override(
			"margin_left",
			12
		)

		margin.add_theme_constant_override(
			"margin_top",
			12
		)

		margin.add_theme_constant_override(
			"margin_right",
			12
		)

		margin.add_theme_constant_override(
			"margin_bottom",
			12
		)

		# ---------------- CONTENIDO ----------------
		var vbox = VBoxContainer.new()

		vbox.add_theme_constant_override(
			"separation",
			8
		)

		# ---------------- NOMBRE ----------------
		var nombre = Label.new()

		nombre.text = data["persona"]

		nombre.add_theme_color_override(
			"font_color",
			Color.WHITE
		)

		# ---------------- TEXTO ----------------
		var texto = Label.new()

		texto.text = data["texto"]

		texto.autowrap_mode = TextServer.AUTOWRAP_WORD

		texto.add_theme_color_override(
			"font_color",
			Color(0.85, 0.85, 0.85)
		)

		# ---------------- CHECKBOX ----------------
		var checkbox = CheckBox.new()

		checkbox.text = "Testimonio sospechoso"

		checkbox.set_meta(
			"sospechoso_real",
			data["sospechoso"]
		)

		checkbox.add_theme_color_override(
			"font_color",
			Color.WHITE
		)

		# guardar referencia
		panel.set_meta(
			"checkbox",
			checkbox
		)

		# ---------------- AGREGAR ----------------
		vbox.add_child(nombre)
		vbox.add_child(texto)
		vbox.add_child(checkbox)

		margin.add_child(vbox)

		panel.add_child(margin)

		$ScrollContainer/VBoxContainer.add_child(panel)

# =========================================================
# CONFIRMAR
# =========================================================

func _on_ButtonConfirmar_pressed():

	if terminado:
		return

	var correcto = true

	for panel in $ScrollContainer/VBoxContainer.get_children():

		var checkbox = panel.get_meta("checkbox")

		var marcado = checkbox.button_pressed

		var real = checkbox.get_meta(
			"sospechoso_real"
		)

		if marcado != real:
			correcto = false

	terminar(correcto)

# =========================================================
# TERMINAR
# =========================================================

func terminar(resultado):

	if terminado:
		return

	terminado = true

	if resultado:
		$LabelResultado.text = "✔ Detectaste la contradicción"
	else:
		$LabelResultado.text = "✖ El análisis fue incorrecto"

	await get_tree().create_timer(2.0).timeout

	emit_signal(
		"minijuego_terminado",
		resultado,
		10 if resultado else 0
	)

	queue_free()
