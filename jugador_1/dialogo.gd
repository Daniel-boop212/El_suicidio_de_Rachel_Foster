extends CanvasLayer
class_name DialogoUI

signal opcion_elegida(indice: int, texto: String)

@onready var panel: Panel = _resolver_panel()
@onready var label: Label = _resolver_label()

var puede_cerrar: bool = false
var opciones_container: VBoxContainer
var opciones_actuales: Array[String] = []

func _ready() -> void:
	if panel == null or label == null:
		push_error("DialogoUI: No se encontró la ruta del Panel/Label. Revisa la jerarquía del nodo de diálogo.")
		set_process(false)
		return

	panel.visible = false
	_crear_contenedor_opciones()

func _resolver_panel() -> Panel:
	var panel_control: Panel = get_node_or_null("Control/Panel") as Panel
	if panel_control != null:
		return panel_control

	var panel_directo: Panel = get_node_or_null("Panel") as Panel
	if panel_directo != null:
		return panel_directo

	var panel_dialogo: Panel = get_node_or_null("Dialogo/Panel") as Panel
	return panel_dialogo

func _resolver_label() -> Label:
	var label_control: Label = get_node_or_null("Control/Panel/Label") as Label
	if label_control != null:
		return label_control

	var label_directo: Label = get_node_or_null("Panel/Label") as Label
	if label_directo != null:
		return label_directo

	var label_dialogo: Label = get_node_or_null("Dialogo/Panel/Label") as Label
	return label_dialogo

func _crear_contenedor_opciones() -> void:
	opciones_container = VBoxContainer.new()
	opciones_container.name = "Opciones"

	# Centrado en pantalla
	opciones_container.anchor_left = 0.5
	opciones_container.anchor_top = 0.5
	opciones_container.anchor_right = 0.5
	opciones_container.anchor_bottom = 0.5

	# Tamaño del contenedor
	opciones_container.offset_left = -150
	opciones_container.offset_top = -100
	opciones_container.offset_right = 150
	opciones_container.offset_bottom = 100

	opciones_container.alignment = BoxContainer.ALIGNMENT_CENTER
	opciones_container.visible = false

	# IMPORTANTE:
	add_child(opciones_container)

func mostrar_dialogo(texto: String, opciones: Array[String] = []) -> void:
	if panel == null or label == null:
		return

	panel.visible = true
	label.text = texto
	opciones_actuales = opciones.duplicate()
	_refrescar_opciones()

	puede_cerrar = false
	await get_tree().create_timer(0.2).timeout
	puede_cerrar = true

func ocultar_dialogo() -> void:
	if panel == null:
		return

	panel.visible = false
	_limpiar_opciones()
	opciones_actuales.clear()

func esta_abierto() -> bool:
	if panel == null:
		return false

	return panel.visible

func _process(_delta: float) -> void:
	if panel == null:
		return

	if panel.visible and puede_cerrar and Input.is_action_just_pressed("ui_accept"):
		ocultar_dialogo()

func _refrescar_opciones() -> void:
	_limpiar_opciones()

	if opciones_actuales.is_empty():
		opciones_container.visible = false
		return

	opciones_container.visible = true
	for indice: int in range(opciones_actuales.size()):
		var texto_opcion: String = opciones_actuales[indice]
		var boton: Button = Button.new()
		boton.text = texto_opcion
		boton.alignment = HORIZONTAL_ALIGNMENT_LEFT
		boton.pressed.connect(_on_boton_opcion_presionado.bind(indice, texto_opcion))
		opciones_container.add_child(boton)

func _limpiar_opciones() -> void:
	if opciones_container == null:
		return

	for child: Node in opciones_container.get_children():
		child.queue_free()

func _on_boton_opcion_presionado(indice: int, texto_opcion: String) -> void:
	opciones_actuales.clear()
	ocultar_dialogo()
	emit_signal("opcion_elegida", indice, texto_opcion)
