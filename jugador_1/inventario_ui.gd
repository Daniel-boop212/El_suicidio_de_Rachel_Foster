extends CanvasLayer

@onready var contenedor: Control = _resolver_contenedor()
@onready var lista_pistas: VBoxContainer = _resolver_lista_pistas()

func _ready() -> void:
	if contenedor == null or lista_pistas == null:
		push_error("InventarioUI: revisa la escena, no se encontro el contenedor o ListaPistas.")
		set_process_input(false)
		return

	contenedor.visible = false
	if not Global.pistas_actualizadas.is_connected(actualizar_inventario):
		Global.pistas_actualizadas.connect(actualizar_inventario)
	if not Global.idioma_actualizado.is_connected(actualizar_inventario):
		Global.idioma_actualizado.connect(actualizar_inventario)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("abrir_inventario"):
		contenedor.visible = not contenedor.visible
		if contenedor.visible:
			actualizar_inventario()

func actualizar_inventario() -> void:
	if lista_pistas == null:
		return

	for hijo in lista_pistas.get_children():
		hijo.queue_free()

	if Global.pistas_descubiertas.is_empty():
		var aviso := Label.new()
		aviso.text = Global.t("no_clues")
		aviso.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		aviso.autowrap_mode = TextServer.AUTOWRAP_WORD
		lista_pistas.add_child(aviso)
		return

	for pista in Global.pistas_descubiertas:
		var etiqueta := Label.new()
		etiqueta.text = Global.t("clue_prefix") + str(pista)
		etiqueta.autowrap_mode = TextServer.AUTOWRAP_WORD
		lista_pistas.add_child(etiqueta)

func _resolver_contenedor() -> Control:
	for ruta in ["Inventario", "ContenedorPrincipal"]:
		var nodo := get_node_or_null(ruta) as Control
		if nodo != null:
			return nodo

	return null

func _resolver_lista_pistas() -> VBoxContainer:
	for ruta in ["Inventario/ColorRect/ListaPistas", "ContenedorPrincipal/ColorRect/ListaPistas"]:
		var nodo := get_node_or_null(ruta) as VBoxContainer
		if nodo != null:
			return nodo

	return null
