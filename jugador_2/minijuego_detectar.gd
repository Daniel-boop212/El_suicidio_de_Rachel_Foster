extends Control

signal minijuego_terminado(resultado, recompensa)

# ---------------- MENSAJES ----------------
var mensajes = [
	{
		"texto": "Hola, ¿cómo estás?",
		"toxico": false
	},
	{
		"texto": "Das vergüenza",
		"toxico": true
	},
	{
		"texto": "Todos se burlan de ti",
		"toxico": true
	},
	{
		"texto": "Buen trabajo hoy",
		"toxico": false
	}
]

# ---------------- TIEMPO ----------------
var tiempo_total = 10.0
var tiempo_restante = 10.0
var terminado = false

# ---------------- INIT ----------------
func _ready():

	set_anchors_preset(Control.PRESET_FULL_RECT)

	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL

	set_process(true)

	crear_mensajes()

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

# ---------------- CREAR MENSAJES ----------------
func crear_mensajes():

	mensajes.shuffle()

	for data in mensajes:
		crear_item(data)

# ---------------- CREAR ITEM ----------------
func crear_item(data):

	var contenedor = HBoxContainer.new()

	# mensaje
	var label = Label.new()
	label.text = data["texto"]
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# checkbox
	var checkbox = CheckBox.new()
	checkbox.text = "Tóxico"

	# guardar dato real
	checkbox.set_meta("toxico_real", data["toxico"])

	# agregar
	contenedor.add_child(label)
	contenedor.add_child(checkbox)

	$VBoxContainer.add_child(contenedor)

# ---------------- CONFIRMAR ----------------
func _on_Button_pressed():

	if terminado:
		return

	var correcto = true

	for contenedor in $VBoxContainer.get_children():

		var checkbox = contenedor.get_child(1)

		var marcado = checkbox.button_pressed
		var real = checkbox.get_meta("toxico_real")

		# si el jugador se equivoca
		if marcado != real:
			correcto = false

	terminar(correcto)

# ---------------- TERMINAR ----------------
func terminar(resultado):

	if terminado:
		return

	terminado = true

	if resultado:
		$Label.text = "✔ Detectaste el acoso"
	else:
		$Label.text = "✖ Algunas respuestas fueron incorrectas"

	await get_tree().create_timer(1.5).timeout

	emit_signal(
		"minijuego_terminado",
		resultado,
		10 if resultado else 0
	)

	queue_free()
