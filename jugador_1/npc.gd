extends Node2D
class_name NpcConversador

const DialogosElPrecipicio = preload("res://jugador_1/dialogos_el_precipicio.gd")

@export var dialogo: Node
@export var npc_id: int = 0
@export var mostrar_opciones_bloqueadas: bool = true

@export var nombre_de_la_pista: String = "Juan mando un mensaje a las 11PM"
@export var tarea_jugador_2: String = "toxicidad"
@export var texto_dialogop: String = "Hola detective, encontre algo..."
@export var texto_dialogo_antes: String = "Detective he perdido mi celular si lo encuentras podrias descubrir algo"

@onready var area: Area2D = $Area2D

var player_near: bool = false
var esperando_opcion: bool = false
var indicador_interaccion: Label
var npc_id_actual: int = 0
var dialogo_actual: Dictionary = {}
var opciones_actuales: Array[Dictionary] = []
var tarea_pendiente := ""
var pista_pendiente := ""

const TECLA_INTERACCION: Key = KEY_E
const OPCION_PREGUNTAR: String = "Preguntar por la pista"
const OPCION_DESPEDIRSE: String = "Despedirse"

func _ready() -> void:
	Global.tarea_jugador_2_completada.connect(_on_tarea_completada)
	npc_id_actual = _resolver_npc_id()
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	_crear_indicador_interaccion()
	_conectar_dialogo()
	_configurar_cuadro_dialogo()
	if not Global.idioma_actualizado.is_connected(_actualizar_textos):
		Global.idioma_actualizado.connect(_actualizar_textos)

func _resolver_npc_id() -> int:
	if npc_id > 0:
		return npc_id

	var nombre_nodo: String = String(name)
	if nombre_nodo == "NPC":
		return 1

	if nombre_nodo.begins_with("NPC"):
		var numero: int = nombre_nodo.substr(3).to_int()
		if numero > 0:
			return numero

	return 0

func _crear_indicador_interaccion() -> void:
	indicador_interaccion = Label.new()
	indicador_interaccion.text = Global.t("press_talk")
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

	if _es_evento_interaccion(event):
		abrir_dialogo_interactivo()
		get_viewport().set_input_as_handled()

func _es_evento_interaccion(event: InputEvent) -> bool:
	if event.is_action_pressed("ui_accept"):
		return true

	if event is InputEventKey:
		var evento_tecla: InputEventKey = event as InputEventKey
		return evento_tecla.pressed and not evento_tecla.echo and evento_tecla.keycode == TECLA_INTERACCION

	return false

func abrir_dialogo_interactivo() -> void:
	if dialogo == null or not dialogo.has_method("mostrar_dialogo"):
		return

	dialogo_actual = DialogosElPrecipicio.obtener_npc(npc_id_actual)
	if dialogo_actual.is_empty():
		abrir_dialogo_legacy()
		return

	if npc_id_actual == 20 and dialogo_actual.has("tarea_inicio"):
		_solicitar_tarea_unica(str(dialogo_actual["tarea_inicio"]))

	_mostrar_menu_dialogo()

func abrir_dialogo_legacy() -> void:
	esperando_opcion = true
	opciones_actuales = [
		{"texto": Global.t("ask_question"), "legacy": OPCION_PREGUNTAR},
		{"texto": Global.t("goodbye"), "legacy": OPCION_DESPEDIRSE}
	]
	dialogo.call("mostrar_dialogo", Global.t("what_ask"), [Global.t("ask_question"), Global.t("goodbye")])

func _mostrar_menu_dialogo() -> void:
	esperando_opcion = true
	opciones_actuales.clear()

	var opciones_texto: Array[String] = []
	var opciones_data: Array = dialogo_actual.get("opciones", [])
	for opcion_data: Variant in opciones_data:
		if not opcion_data is Dictionary:
			continue

		var opcion: Dictionary = opcion_data
		var bloqueada: bool = not _opcion_disponible(opcion)
		if bloqueada and not mostrar_opciones_bloqueadas:
			continue

		opciones_actuales.append({"opcion": opcion, "bloqueada": bloqueada})

		var texto_opcion: String = str(opcion.get("texto", "Continuar"))
		if bloqueada:
			texto_opcion = "[Bloqueada] " + texto_opcion
		opciones_texto.append(texto_opcion)

	if npc_id_actual == 20:
		opciones_actuales.append({"opcion": {"texto": "Cerrar caso con Rachel", "finalizar": true}, "bloqueada": false})
		opciones_texto.append("Cerrar caso con Rachel")

	var encabezado: String = "%s (%s)\n%s\n\n¿Qué quieres preguntar?" % [
		str(dialogo_actual.get("nombre", "NPC")),
		str(dialogo_actual.get("rol", "Testigo")),
		str(dialogo_actual.get("intro", ""))
	]
	dialogo.call("mostrar_dialogo", encabezado, opciones_texto)

func _on_dialogo_opcion_elegida(indice: int, _texto_opcion: String) -> void:
	if not esperando_opcion:
		return

	esperando_opcion = false

	if indice < 0 or indice >= opciones_actuales.size():
		return

	var seleccion: Dictionary = opciones_actuales[indice]
	var opcion: Dictionary = seleccion.get("opcion", {})

	if opcion.has("legacy"):
		_responder_legacy(str(opcion["legacy"]))
		return

	if bool(seleccion.get("bloqueada", false)):
		_mostrar_texto("Todavía falta información para preguntar eso.\n\nNecesitas: " + _texto_requisito(opcion))
		return

	if bool(opcion.get("finalizar", false)):
		_mostrar_final_rachel()
		return

	_responder_opcion(opcion)

func _responder_opcion(opcion: Dictionary) -> void:
	var respuesta: String = str(opcion.get("respuesta", "No hay respuesta registrada."))
	var pista: String = str(opcion.get("pista", ""))
	var pista_final: String = str(opcion.get("pista_final", ""))
	var tarea: String = str(opcion.get("tarea", ""))
	var extras: Array[String] = []

	if tarea.is_empty() and not pista.is_empty():
		var pista_nueva: bool = Global.add_pista(pista)
		if pista_nueva:
			extras.append("Pista obtenida: " + pista)
		else:
			extras.append("Pista ya registrada: " + pista)

	if not pista_final.is_empty():
		Global.registrar_pista_final(pista_final)
		extras.append("Usaste una pista clave para hablar con Rachel.")

	if not tarea.is_empty():

	# Evita duplicar solicitudes
		if tarea_pendiente == tarea:
			_mostrar_texto("El policía ya está investigando esta pista.")
			return

		tarea_pendiente = tarea
		pista_pendiente = pista

		_solicitar_tarea_unica(tarea)

		_mostrar_texto("El policía está investigando esto...")
		return

	if opcion.has("desbloquea"):
		extras.append(str(opcion["desbloquea"]))

	if not extras.is_empty():
		respuesta += "\n\n" + _unir_textos(extras, "\n")

	_mostrar_texto(respuesta)

func _mostrar_final_rachel() -> void:
	var pistas_usadas: int = Global.contar_pistas_finales_usadas()
	var resultado: String = Global.finalizar_el_precipicio(pistas_usadas)
	mostrar_final.rpc(resultado)

@rpc("authority", "call_local", "reliable")
func mostrar_final(resultado: String) -> void:
	Global.final_actual = resultado
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://finales.tscn")

func _opcion_disponible(opcion: Dictionary) -> bool:
	if opcion.has("requiere"):
		return Global.tiene_pista(str(opcion["requiere"]))

	if opcion.has("requiere_alguna"):
		var requisitos: Array = opcion["requiere_alguna"]
		return Global.tiene_alguna_pista(requisitos)

	return true

func _texto_requisito(opcion: Dictionary) -> String:
	if opcion.has("requiere"):
		return str(opcion["requiere"])

	if opcion.has("requiere_alguna"):
		var partes: Array[String] = []
		var requisitos: Array = opcion["requiere_alguna"]
		for requisito: Variant in requisitos:
			partes.append(str(requisito))
		return "una de estas pistas: " + _unir_textos(partes, ", ")

	return "una pista relacionada"

func _solicitar_tarea_unica(task_id: String) -> void:
	Global.solicitar_tarea_jugador_2(task_id)

func _mostrar_texto(texto: String) -> void:
	if dialogo != null and dialogo.has_method("mostrar_dialogo"):
		dialogo.call("mostrar_dialogo", texto)

func _unir_textos(textos: Array[String], separador: String) -> String:
	var resultado: String = ""
	for indice: int in range(textos.size()):
		if indice > 0:
			resultado += separador
		resultado += textos[indice]

	return resultado

func _responder_legacy(texto_opcion: String) -> void:
	if texto_opcion == OPCION_PREGUNTAR:
		_responder_con_pista()
		return

	if texto_opcion == OPCION_DESPEDIRSE:
		_mostrar_texto(Global.t("talk_later"))

func _responder_con_pista() -> void:
	if Global.tiene_celular:
		Global.add_pista(nombre_de_la_pista)
		_solicitar_tarea_unica(tarea_jugador_2)
		Global.tiene_celular = false
		Global.paso_actual = 1
		_mostrar_texto(Global.traducir_texto_directo(texto_dialogop))
	else:
		Global.paso_actual = 1
		_mostrar_texto(Global.traducir_texto_directo(texto_dialogo_antes))

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

func _actualizar_textos() -> void:
	if indicador_interaccion != null:
		indicador_interaccion.text = Global.t("press_talk")
		
func _on_tarea_completada(task_id: String, resultado: bool, recompensa: int) -> void:
	if task_id != tarea_pendiente:
		return
	if resultado:
		if pista_pendiente != "":
			Global.add_pista(pista_pendiente)
		_mostrar_texto("El policía encontró nueva evidencia.")
	else:
		_mostrar_texto("El policía no logró completar la investigación.")
	tarea_pendiente = ""
	pista_pendiente = ""
