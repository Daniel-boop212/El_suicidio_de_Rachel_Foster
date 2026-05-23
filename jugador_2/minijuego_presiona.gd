extends Control

signal minijuego_terminado(resultado, recompensa)

# =========================================================
# MENSAJES
# =========================================================

var mensajes = [
	{
		"texto": "Hola",
		"toxico": false
	},
	{
		"texto": "Das pena",
		"toxico": true
	},
	{
		"texto": "Buen trabajo",
		"toxico": false
	},
	{
		"texto": "Nadie te quiere",
		"toxico": true
	},
	{
		"texto": "JAJA qué ridículo",
		"toxico": true
	},
	{
		"texto": "Cómo estás?",
		"toxico": false
	},
	{
		"texto": "Todos se burlan de ti",
		"toxico": true
	}
]

# =========================================================
# DATOS
# =========================================================

var puntos = 0
var errores = 0

var terminado = false

# =========================================================
# TIEMPO
# =========================================================

var tiempo_total = 20.0
var tiempo_restante = 20.0

# =========================================================
# SPAWN
# =========================================================

var spawn_timer = 0.0

# =========================================================
# INIT
# =========================================================

func _ready():

	randomize()

	set_process(true)

	$LabelFinal.visible = false

	actualizar_ui()

# =========================================================
# LOOP
# =========================================================

func _process(delta):

	if terminado:
		return

	# ---------------- TIEMPO ----------------
	tiempo_restante -= delta

	if tiempo_restante <= 0:

		tiempo_restante = 0

		finalizar()

	actualizar_barra()

	# ---------------- SPAWN ----------------
	spawn_timer -= delta

	if spawn_timer <= 0:

		spawn_timer = 1.2

		spawn_mensaje()

# =========================================================
# UI
# =========================================================

func actualizar_ui():

	$LabelInfo.text = (
		"Puntos: "
		+ str(puntos)
		+ " | Errores: "
		+ str(errores)
		+ " | Tiempo: "
		+ str(int(tiempo_restante))
	)

# =========================================================
# TIMER BAR
# =========================================================

func actualizar_barra():

	var porcentaje = (
		tiempo_restante / tiempo_total
	) * 100

	$TimerBar.value = porcentaje

	if porcentaje < 25:

		$TimerBar.modulate = Color(1, 0.3, 0.3)

	else:

		$TimerBar.modulate = Color.WHITE

	actualizar_ui()

# =========================================================
# CREAR MENSAJE
# =========================================================

func spawn_mensaje():

	if terminado:
		return

	var data = mensajes.pick_random()

	var boton = Button.new()
	
	boton.alignment = HORIZONTAL_ALIGNMENT_CENTER

	boton.text = data["texto"]

	# tamaño tipo whatsapp
	boton.custom_minimum_size = Vector2(240, 55)

	# =====================================================
	# POSICION DENTRO DEL SPAWN AREA
	# =====================================================

	var area_size = $SpawnArea.size

	var max_x = area_size.x - 260
	var max_y = area_size.y - 70

	boton.position = Vector2(
		randi_range(20, max_x),
		randi_range(20, max_y)
	)

	# =====================================================
	# ESTILO WHATSAPP
	# =====================================================

	var estilo = StyleBoxFlat.new()

	if data["toxico"]:

		# verde oscuro toxico
		estilo.bg_color = Color(0.25, 0.45, 0.25)

	else:

		# gris whatsapp
		estilo.bg_color = Color(0.15, 0.15, 0.15)

	# bordes redondos
	estilo.corner_radius_top_left = 18
	estilo.corner_radius_top_right = 18
	estilo.corner_radius_bottom_left = 18
	estilo.corner_radius_bottom_right = 18

	# borde
	estilo.border_width_left = 2
	estilo.border_width_top = 2
	estilo.border_width_right = 2
	estilo.border_width_bottom = 2

	estilo.border_color = Color(0.3, 0.3, 0.3)

	boton.add_theme_stylebox_override(
		"normal",
		estilo
	)

	# texto blanco
	boton.add_theme_color_override(
		"font_color",
		Color.WHITE
	)

	# alineacion
	boton.alignment = HORIZONTAL_ALIGNMENT_LEFT

	# click
	boton.pressed.connect(func():

		click_mensaje(
			data["toxico"],
			boton
		)

	)

	# agregar
	$SpawnArea.add_child(boton)

	# =====================================================
	# AUTO ELIMINAR
	# =====================================================

	desaparecer_mensaje(
		boton,
		data["toxico"]
	)

# =========================================================
# DESAPARECER
# =========================================================

func desaparecer_mensaje(boton, toxico):

	await get_tree().create_timer(4.0).timeout

	if terminado:
		return

	if is_instance_valid(boton):

		if toxico:

			errores += 1

		boton.queue_free()

		actualizar_ui()

# =========================================================
# CLICK
# =========================================================

func click_mensaje(toxico, boton):

	if terminado:
		return

	if toxico:

		puntos += 1

	else:

		errores += 1

	if is_instance_valid(boton):

		boton.queue_free()

	actualizar_ui()

# =========================================================
# FINAL
# =========================================================

func finalizar():

	if terminado:
		return

	terminado = true

	# borrar mensajes restantes
	for nodo in $SpawnArea.get_children():

		nodo.queue_free()

	var gano = (
		puntos >= 5
		and errores < 4
	)

	$LabelFinal.visible = true

	if gano:

		$LabelFinal.text = "✔ Chat moderado correctamente"

	else:

		$LabelFinal.text = "✖ El chat se salió de control"

	await get_tree().create_timer(2.5).timeout

	emit_signal(
		"minijuego_terminado",
		gano,
		10 if gano else 0
	)

	queue_free()
