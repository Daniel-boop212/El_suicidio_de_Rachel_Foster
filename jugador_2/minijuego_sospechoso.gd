extends Control

signal minijuego_terminado(resultado, recompensa)

# ---------------- PERFILES ----------------
var perfiles = [
	{
		"nombre": "maria_2007",
		"desc": "Me gusta el arte",
		"seguidores": 234,
		"falso": false
	},
	{
		"nombre": "juan.real",
		"desc": "Fútbol y música",
		"seguidores": 180,
		"falso": false
	},
	{
		"nombre": "anonimo_xd777",
		"desc": "Todos dan cringe",
		"seguidores": 2,
		"falso": true
	},
	{
		"nombre": "sofia_art",
		"desc": "Dibujo digital",
		"seguidores": 540,
		"falso": false
	}
]

# ---------------- TIEMPO ----------------
var tiempo_total = 12.0
var tiempo_restante = 12.0
var terminado = false

# ---------------- INIT ----------------
func _ready():

	set_anchors_preset(Control.PRESET_FULL_RECT)

	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL

	set_process(true)

	crear_perfiles()

# ---------------- LOOP ----------------
func _process(delta):

	if terminado:
		return

	tiempo_restante -= delta

	if tiempo_restante <= 0:
		tiempo_restante = 0
		terminar(false)

	actualizar_barra()

# ---------------- TIMER BAR ----------------
func actualizar_barra():

	var ratio = tiempo_restante / tiempo_total

	$TimerBar.value = ratio

	if ratio < 0.2:
		$TimerBar.scale = Vector2(1.1, 1.1)
	else:
		$TimerBar.scale = Vector2(1, 1)

# ---------------- CREAR PERFILES ----------------
func crear_perfiles():

	perfiles.shuffle()

	for data in perfiles:
		crear_item(data)

# ---------------- CREAR ITEM ----------------
func crear_item(data):

	var panel = PanelContainer.new()

	# ocupar ancho
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# ---------------- ESTILO ----------------
	var estilo = StyleBoxFlat.new()

	estilo.bg_color = Color(0.12, 0.12, 0.12)

	# bordes redondeados
	estilo.corner_radius_top_left = 12
	estilo.corner_radius_top_right = 12
	estilo.corner_radius_bottom_left = 12
	estilo.corner_radius_bottom_right = 12

	panel.add_theme_stylebox_override("panel", estilo)

	# ---------------- HOVER ----------------
	panel.mouse_entered.connect(func():
		estilo.bg_color = Color(0.18, 0.18, 0.18)
	)

	panel.mouse_exited.connect(func():
		estilo.bg_color = Color(0.12, 0.12, 0.12)
	)

	# ---------------- MARGENES ----------------
	var margin = MarginContainer.new()

	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)

	# ---------------- CONTENIDO ----------------
	var vbox = VBoxContainer.new()

	vbox.add_theme_constant_override("separation", 6)

	# ---------------- NOMBRE ----------------
	var nombre = Label.new()
	nombre.text = "@" + data["nombre"]

	# texto blanco
	nombre.add_theme_color_override(
		"font_color",
		Color.WHITE
	)

	# ---------------- DESCRIPCION ----------------
	var desc = Label.new()
	desc.text = data["desc"]

	desc.add_theme_color_override(
		"font_color",
		Color(0.8, 0.8, 0.8)
	)

	# ---------------- SEGUIDORES ----------------
	var seguidores = Label.new()
	seguidores.text = "Seguidores: " + str(data["seguidores"])

	seguidores.add_theme_color_override(
		"font_color",
		Color(0.6, 0.6, 0.6)
	)

	# ---------------- CHECKBOX ----------------
	var checkbox = CheckBox.new()
	checkbox.text = "Cuenta sospechosa"

	checkbox.set_meta(
		"falso_real",
		data["falso"]
	)

	checkbox.add_theme_color_override(
		"font_color",
		Color.WHITE
	)

	# ---------------- AGREGAR ----------------
	vbox.add_child(nombre)
	vbox.add_child(desc)
	vbox.add_child(seguidores)
	vbox.add_child(checkbox)

	margin.add_child(vbox)

	panel.add_child(margin)

	$ScrollContainer/VBoxContainer.add_child(panel)

# ---------------- CONFIRMAR ----------------
func _on_Button_pressed():

	if terminado:
		return

	var correcto = true

	for panel in $ScrollContainer/VBoxContainer.get_children():

		var margin = panel.get_child(0)
		var vbox = margin.get_child(0)

		var checkbox = vbox.get_child(3)

		var marcado = checkbox.button_pressed
		var real = checkbox.get_meta("falso_real")

		if marcado != real:
			correcto = false

	terminar(correcto)

# ---------------- TERMINAR ----------------
func terminar(resultado):

	if terminado:
		return

	terminado = true

	if resultado:
		$Label.text = "✔ Encontraste la cuenta falsa"
	else:
		$Label.text = "✖ Identificación incorrecta"

	await get_tree().create_timer(1.5).timeout

	emit_signal(
		"minijuego_terminado",
		resultado,
		10 if resultado else 0
	)

	queue_free()
