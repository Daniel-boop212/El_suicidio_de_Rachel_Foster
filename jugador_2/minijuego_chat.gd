extends Control

signal minijuego_terminado(resultado, recompensa)

# ---------------- CONFIG ----------------
var orden_correcto = [
	"Hola, vi tu perfil",
	"¿Por qué publicas eso?",
	"Das vergüenza",
    "Todos se burlan de ti"
]

var orden_actual = []

# ⏳ Tiempo
var tiempo_total = 7.0
var tiempo_restante = 7.0
var terminado = false

# ---------------- INIT ----------------
func _ready():
	set_anchors_preset(Control.PRESET_FULL_RECT)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	set_process(true)
	mezclar_mensajes()

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
	
	# efecto visual cuando queda poco tiempo
	if ratio < 0.2:
		$TimerBar.scale = Vector2(1.1, 1.1)
	else:
		$TimerBar.scale = Vector2(1, 1)

# ---------------- CREAR MENSAJES ----------------
func mezclar_mensajes():
	orden_actual = orden_correcto.duplicate()
	orden_actual.shuffle()
	
	for mensaje in orden_actual:
		crear_item(mensaje)

# ---------------- CREAR ITEM ----------------
func crear_item(texto):
	var contenedor = HBoxContainer.new()
	
	var label = Label.new()
	label.text = texto
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var btn_up = Button.new()
	btn_up.text = "↑"
	
	var btn_down = Button.new()
	btn_down.text = "↓"
	
	contenedor.add_child(label)
	contenedor.add_child(btn_up)
	contenedor.add_child(btn_down)
	
	$VBoxContainer.add_child(contenedor)
	
	btn_up.pressed.connect(func(): mover(contenedor, -1))
	btn_down.pressed.connect(func(): mover(contenedor, 1))

# ---------------- MOVER MENSAJES ----------------
func mover(nodo, direccion):
	var parent = nodo.get_parent()
	var index = nodo.get_index()
	var nuevo_index = index + direccion
	
	if nuevo_index < 0 or nuevo_index >= parent.get_child_count():
		return
	
	parent.move_child(nodo, nuevo_index)

# ---------------- CONFIRMAR ----------------
func _on_Button_pressed():
	if terminado:
		return
	
	var correcto = true
	
	for i in range($VBoxContainer.get_child_count()):
		var contenedor = $VBoxContainer.get_child(i)
		var texto = contenedor.get_child(0).text
		
		if texto != orden_correcto[i]:
			correcto = false
	
	terminar(correcto)

# ---------------- TERMINAR ----------------
func terminar(resultado):
	if terminado:
		return
	terminado = true
	
	if resultado:
		$Label.text = "✔ Correcto"
	else:
		$Label.text = "✖ Incorrecto"
	
	await get_tree().create_timer(1.5).timeout
	
	emit_signal("minijuego_terminado", resultado, 10 if resultado else 0)
	queue_free()
