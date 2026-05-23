extends Node2D
class_name NpcConversador

@export var dialogo: Node
@export var nombre_de_la_pista: String = "Juan mando un mensaje a las 11PM"
@export var tarea_jugador_2: String = "toxicidad"
@export var texto_dialogop: String = "Hola detective, encontré algo..."
@export var texto_dialogo_antes: String = "Detective he perdido mi celular si lo encuentras podrias descubrir algo"

@onready var area: Area2D = $Area2D

var player_near: bool = false
var esperando_opcion: bool = false
var indicador_interaccion: Label

const TECLA_INTERACCION: Key = KEY_E
const OPCION_PREGUNTAR: String = "Preguntar por la pista"
const OPCION_DESPEDIRSE: String = "Despedirse"

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	_crear_indicador_interaccion()
	_conectar_dialogo()
	_configurar_cuadro_dialogo()

func _crear_indicador_interaccion() -> void:
	indicador_interaccion = Label.new()
	indicador_interaccion.text = "Pulsa E para hablar"
	indicador_interaccion.position = Vector2(85.0, -305.0)
	indicador_interaccion.visible = false
	indicador_interaccion.z_index = 10
	indicador_interaccion.modulate = Color(1.0, 0.95, 0.6, 1.0)
	add_child(indicador_interaccion)

func _conectar_dialogo() -> void:
	if dialogo == null:
		return

	if dialogo.has_signal("opcion_elegida") and not dialogo.is_connected("opcion_elegida", Callable(self, "_on_dialogo_opcion_elegida")):
		dialogo.connect("opcion_elegida", Callable(self, "_on_dialogo_opcion_elegida"))

func _configurar_cuadro_dialogo() -> void:
	if dialogo == null:
		return

	var control_node: Control = null
	if dialogo.has_node("Control"):
		control_node = dialogo.get_node("Control") as Control
	elif dialogo.has_node("Dialogo"):
		control_node = dialogo.get_node("Dialogo") as Control

	if control_node == null:
		return

	control_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	control_node.offset_left = 0.0
	control_node.offset_top = 0.0
	control_node.offset_right = 0.0
	control_node.offset_bottom = 0.0

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_near = true
		_actualizar_indicador()

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_near = false
		esperando_opcion = false
		_actualizar_indicador()

func _process(_delta: float) -> void:
	_actualizar_indicador()

func _unhandled_input(event: InputEvent) -> void:
	if not player_near:
		return

	if _dialogo_esta_abierto():
		return

	if event is InputEventKey:
		var evento_tecla: InputEventKey = event as InputEventKey
		if evento_tecla != null and evento_tecla.pressed and not evento_tecla.echo and evento_tecla.keycode == TECLA_INTERACCION:
			abrir_dialogo_interactivo()
			get_viewport().set_input_as_handled()

func abrir_dialogo_interactivo() -> void:
	if dialogo == null:
		return

	if not dialogo.has_method("mostrar_dialogo"):
		return

	esperando_opcion = true
	var opciones: Array[String] = [OPCION_PREGUNTAR, OPCION_DESPEDIRSE]
	dialogo.call("mostrar_dialogo", "¿Qué quieres preguntar?", opciones)

func _on_dialogo_opcion_elegida(_indice: int, texto_opcion: String) -> void:
	if not esperando_opcion:
		return

	esperando_opcion = false

	if texto_opcion == OPCION_PREGUNTAR:
		_responder_con_pista()
		return

	if texto_opcion == OPCION_DESPEDIRSE:
		if dialogo != null and dialogo.has_method("mostrar_dialogo"):
			dialogo.call("mostrar_dialogo", "Hablamos luego, detective.")

func _responder_con_pista() -> void:
	if dialogo == null or not dialogo.has_method("mostrar_dialogo"):
		return

	if Global.tiene_celular:
		Global.add_pista(nombre_de_la_pista)
		Global.solicitar_tarea_jugador_2(tarea_jugador_2)
		Global.tiene_celular = false
		Global.paso_actual = 1
		dialogo.call("mostrar_dialogo", texto_dialogop)
	else:
		Global.paso_actual = 1
		dialogo.call("mostrar_dialogo", texto_dialogo_antes)

func _dialogo_esta_abierto() -> bool:
	if dialogo == null:
		return false

	if dialogo.has_method("esta_abierto"):
		var abierto: Variant = dialogo.call("esta_abierto")
		if abierto is bool:
			return abierto

	return false

func _actualizar_indicador() -> void:
	if indicador_interaccion == null:
		return

	indicador_interaccion.visible = player_near and not _dialogo_esta_abierto()
