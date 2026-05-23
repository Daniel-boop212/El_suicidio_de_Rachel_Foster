extends Control

const MINIGAMES = {
	"moderacion": {
		"title": "Moderar chat en vivo",
		"route": "res://jugador_2/minijuego_presiona.tscn",
		"brief": "Elimina mensajes agresivos antes de que escalen."
	},
	"toxicidad": {
		"title": "Clasificar mensajes",
		"route": "res://jugador_2/minijuego_detectar.tscn",
		"brief": "Marca que mensajes contienen acoso."
	},
	"conversacion": {
		"title": "Reconstruir conversacion",
		"route": "res://jugador_2/minijuego_chat.tscn",
		"brief": "Ordena el hilo para entender como empezo el ataque."
	},
	"busqueda": {
		"title": "Buscar evidencias",
		"route": "res://jugador_2/minijuego_busqueda.tscn",
		"brief": "Revisa archivos y encuentra las pruebas utiles."
	},
	"perfil": {
		"title": "Detectar cuenta falsa",
		"route": "res://jugador_2/minijuego_sospechoso.tscn",
		"brief": "Analiza perfiles y senala el sospechoso."
	},
	"testimonio": {
		"title": "Descubrir contradiccion",
		"route": "res://jugador_2/minijuego_descubrir.tscn",
		"brief": "Compara testimonios para encontrar quien miente."
	}
}

var minijuego_actual: Control = null
var tarea_actual := ""
var monedas := 0
var misiones_resueltas := 0
var misiones_fallidas := 0

var screen_panel: PanelContainer = null
var screen_content: MarginContainer = null
var status_label: Label = null
var task_title: Label = null
var task_brief: Label = null
var reward_label: Label = null
var log_list: VBoxContainer = null
var action_list: VBoxContainer = null

func _ready() -> void:
	_build_interface()
	_show_waiting_desktop()
	_add_log("Sistema listo. Esperando accion del jugador 1.")
	if not Global.tarea_jugador_2_solicitada.is_connected(trigger_task):
		Global.tarea_jugador_2_solicitada.connect(trigger_task)


func trigger_task(task_id: String) -> void:
	if not MINIGAMES.has(task_id):
		push_warning("Tarea desconocida para Jugador 2: " + task_id)
		return

	var task: Dictionary = MINIGAMES[task_id]
	tarea_actual = task_id
	task_title.text = task["title"]
	task_brief.text = task["brief"]
	status_label.text = "TAREA RECIBIDA"
	_add_log("Nueva asistencia: " + task["title"])
	mostrar_minijuego(task["route"])


func mostrar_minijuego(ruta: String) -> void:
	if minijuego_actual and is_instance_valid(minijuego_actual):
		minijuego_actual.queue_free()

	_clear_screen()
	_set_screen_padding(0)

	var escena := load(ruta)
	if escena == null:
		status_label.text = "ERROR DE CARGA"
		_add_log("No se pudo cargar: " + ruta)
		_show_waiting_desktop()
		return

	minijuego_actual = escena.instantiate()
	screen_content.add_child(minijuego_actual)
	minijuego_actual.set_anchors_preset(Control.PRESET_FULL_RECT)
	minijuego_actual.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	minijuego_actual.size_flags_vertical = Control.SIZE_EXPAND_FILL

	if minijuego_actual.has_signal("minijuego_terminado"):
		minijuego_actual.minijuego_terminado.connect(_on_minijuego_terminado)


func _on_minijuego_terminado(resultado: bool, recompensa: int) -> void:
	if resultado:
		monedas += recompensa
		misiones_resueltas += 1
		status_label.text = "CASO ACTUALIZADO"
		_add_log("Apoyo completado. +" + str(recompensa) + " monedas.")
	else:
		misiones_fallidas += 1
		status_label.text = "APOYO FALLIDO"
		_add_log("La tarea fallo. El caso no avanza.")

	Global.completar_tarea_jugador_2(tarea_actual, resultado, recompensa)
	reward_label.text = "Monedas: " + str(monedas) + " | Exitos: " + str(misiones_resueltas) + " | Fallos: " + str(misiones_fallidas)
	minijuego_actual = null
	task_title.text = "Esperando solicitud"
	task_brief.text = "Cuando el jugador 1 interactue con una pista, aqui aparecera la tarea de apoyo."

	await get_tree().create_timer(0.8).timeout
	_show_waiting_desktop()


func _build_interface() -> void:
	for child in get_children():
		child.queue_free()

	set_anchors_preset(Control.PRESET_FULL_RECT)

	var background := ColorRect.new()
	background.color = Color(0.035, 0.045, 0.055)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var root_margin := MarginContainer.new()
	root_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_margin.add_theme_constant_override("margin_left", 14)
	root_margin.add_theme_constant_override("margin_top", 14)
	root_margin.add_theme_constant_override("margin_right", 14)
	root_margin.add_theme_constant_override("margin_bottom", 10)
	add_child(root_margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 16)
	root_margin.add_child(root)

	root.add_child(_create_top_bar())
	root.add_child(_create_body())
	root.add_child(_create_bottom_bar())


func _create_top_bar() -> Control:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 16)

	var title_box := VBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_box.add_theme_constant_override("separation", 2)
	bar.add_child(title_box)

	var title := Label.new()
	title.text = "CONSOLA DE ASISTENCIA - JUGADOR 2"
	title.add_theme_font_size_override("font_size", 23)
	title.add_theme_color_override("font_color", Color(0.92, 0.98, 1.0))
	title_box.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Terminal de apoyo para investigar ciberacoso"
	subtitle.add_theme_color_override("font_color", Color(0.55, 0.68, 0.72))
	title_box.add_child(subtitle)

	status_label = _pill_label("EN ESPERA", Color(0.12, 0.28, 0.24), Color(0.45, 0.95, 0.74))
	status_label.name = "StatusLabel"
	status_label.unique_name_in_owner = true
	bar.add_child(status_label)

	return bar


func _create_body() -> Control:
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)

	var main_area := VBoxContainer.new()
	main_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_area.add_theme_constant_override("separation", 10)
	main_area.add_child(_create_monitor())
	body.add_child(main_area)
	body.add_child(_create_right_panel())

	return body


func _create_case_strip() -> Control:
	var panel := _panel(Color(0.045, 0.06, 0.072), Color(0.12, 0.24, 0.28))
	panel.custom_minimum_size = Vector2(0, 86)

	var margin := _margin(12)
	panel.add_child(margin)

	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 18)
	margin.add_child(box)

	var case_text := Label.new()
	case_text.text = "CASO ACTIVO\nIncidente: hostigamiento digital\nEstado: investigacion inicial"
	case_text.custom_minimum_size = Vector2(260, 0)
	case_text.add_theme_color_override("font_color", Color(0.76, 0.88, 0.9))
	box.add_child(case_text)

	var task_box := VBoxContainer.new()
	task_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	task_box.add_theme_constant_override("separation", 4)
	box.add_child(task_box)

	task_title = Label.new()
	task_title.name = "TaskTitle"
	task_title.unique_name_in_owner = true
	task_title.text = "Esperando solicitud"
	task_title.add_theme_font_size_override("font_size", 18)
	task_title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.62))
	task_box.add_child(task_title)

	task_brief = Label.new()
	task_brief.name = "TaskBrief"
	task_brief.unique_name_in_owner = true
	task_brief.text = "Cuando el jugador 1 interactue con una pista, aqui aparecera la tarea de apoyo."
	task_brief.autowrap_mode = TextServer.AUTOWRAP_WORD
	task_brief.add_theme_color_override("font_color", Color(0.68, 0.78, 0.82))
	task_box.add_child(task_brief)

	return panel


func _create_left_panel() -> Control:
	var panel := _panel(Color(0.055, 0.075, 0.09), Color(0.15, 0.28, 0.32))
	panel.custom_minimum_size = Vector2(260, 0)
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var margin := _margin(16)
	panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	margin.add_child(box)

	box.add_child(_section_title("Caso activo"))

	var case_text := Label.new()
	case_text.text = "Incidente: hostigamiento digital\nEstado: investigacion inicial\nRol: asistencia remota"
	case_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	case_text.add_theme_color_override("font_color", Color(0.78, 0.88, 0.9))
	box.add_child(case_text)

	task_title = Label.new()
	task_title.name = "TaskTitle"
	task_title.unique_name_in_owner = true
	task_title.text = "Esperando solicitud"
	task_title.add_theme_font_size_override("font_size", 18)
	task_title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.62))
	box.add_child(task_title)

	task_brief = Label.new()
	task_brief.name = "TaskBrief"
	task_brief.unique_name_in_owner = true
	task_brief.text = "Cuando el jugador 1 interactue con una pista, aqui aparecera la tarea de apoyo."
	task_brief.autowrap_mode = TextServer.AUTOWRAP_WORD
	task_brief.add_theme_color_override("font_color", Color(0.68, 0.78, 0.82))
	box.add_child(task_brief)

	box.add_child(_separator())
	box.add_child(_section_title("Registro"))

	log_list = VBoxContainer.new()
	log_list.name = "LogList"
	log_list.unique_name_in_owner = true
	log_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	log_list.add_theme_constant_override("separation", 8)
	box.add_child(log_list)

	return panel


func _create_monitor() -> Control:
	var outer := VBoxContainer.new()
	outer.custom_minimum_size = Vector2(800, 0)
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_theme_constant_override("separation", 4)

	var shell := _panel(Color(0.015, 0.018, 0.02), Color(0.18, 0.26, 0.28))
	shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_child(shell)

	var shell_margin := _margin(6)
	shell.add_child(shell_margin)

	screen_panel = _panel(Color(0.02, 0.035, 0.04), Color(0.1, 0.48, 0.52))
	screen_panel.name = "ScreenPanel"
	screen_panel.unique_name_in_owner = true
	screen_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	screen_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shell_margin.add_child(screen_panel)

	screen_content = MarginContainer.new()
	screen_content.name = "ScreenContent"
	screen_content.unique_name_in_owner = true
	screen_content.set_anchors_preset(Control.PRESET_FULL_RECT)
	_set_screen_padding(16)
	screen_panel.add_child(screen_content)

	var stand := ColorRect.new()
	stand.custom_minimum_size = Vector2(0, 10)
	stand.color = Color(0.1, 0.13, 0.14)
	outer.add_child(stand)

	return outer


func _create_right_panel() -> Control:
	var panel := _panel(Color(0.055, 0.065, 0.078), Color(0.18, 0.22, 0.28))
	panel.custom_minimum_size = Vector2(250, 0)
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var margin := _margin(16)
	panel.add_child(margin)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(scroll)

	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 10)
	scroll.add_child(box)

	box.add_child(_section_title("Caso activo"))

	var case_text := Label.new()
	case_text.text = "Incidente: hostigamiento digital\nEstado: investigacion inicial"
	case_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	case_text.add_theme_color_override("font_color", Color(0.76, 0.88, 0.9))
	box.add_child(case_text)

	task_title = Label.new()
	task_title.name = "TaskTitle"
	task_title.unique_name_in_owner = true
	task_title.text = "Esperando solicitud"
	task_title.add_theme_font_size_override("font_size", 17)
	task_title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.62))
	box.add_child(task_title)

	task_brief = Label.new()
	task_brief.name = "TaskBrief"
	task_brief.unique_name_in_owner = true
	task_brief.text = "Cuando el jugador 1 interactue con una pista, aqui aparecera la tarea de apoyo."
	task_brief.autowrap_mode = TextServer.AUTOWRAP_WORD
	task_brief.add_theme_color_override("font_color", Color(0.68, 0.78, 0.82))
	box.add_child(task_brief)

	box.add_child(_separator())
	box.add_child(_section_title("Simulador de eventos"))

	var note := Label.new()
	note.text = "Pruebas temporales. Luego se reemplazan por eventos del jugador 1."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD
	note.add_theme_color_override("font_color", Color(0.65, 0.75, 0.78))
	box.add_child(note)

	action_list = VBoxContainer.new()
	action_list.name = "ActionList"
	action_list.unique_name_in_owner = true
	action_list.add_theme_constant_override("separation", 8)
	box.add_child(action_list)

	for id in MINIGAMES.keys():
		var task: Dictionary = MINIGAMES[id]
		var button := Button.new()
		button.text = task["title"]
		button.custom_minimum_size = Vector2(0, 34)
		button.tooltip_text = task["brief"]
		button.pressed.connect(trigger_task.bind(id))
		action_list.add_child(button)

	box.add_child(_separator())

	reward_label = Label.new()
	reward_label.name = "RewardLabel"
	reward_label.unique_name_in_owner = true
	reward_label.text = "Monedas: 0 | Exitos: 0 | Fallos: 0"
	reward_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	reward_label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.62))
	box.add_child(reward_label)

	return panel


func _create_bottom_bar() -> Control:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 10)

	var text := Label.new()
	text.text = "Conexion local: modo prototipo | Fuente de video: simulada | Integracion futura: trigger_task(id)"
	text.add_theme_color_override("font_color", Color(0.45, 0.56, 0.6))
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(text)

	var version := Label.new()
	version.text = "v0.2"
	version.add_theme_color_override("font_color", Color(0.45, 0.56, 0.6))
	bar.add_child(version)

	return bar


func _show_waiting_desktop() -> void:
	_clear_screen()
	_set_screen_padding(16)
	status_label.text = "EN ESPERA"

	var desktop := VBoxContainer.new()
	desktop.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	desktop.size_flags_vertical = Control.SIZE_EXPAND_FILL
	desktop.add_theme_constant_override("separation", 12)
	screen_content.add_child(desktop)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	desktop.add_child(header)

	var live := _pill_label("VISTA SIMULADA JUGADOR 1", Color(0.12, 0.18, 0.2), Color(0.58, 0.86, 0.92))
	header.add_child(live)

	var hint := Label.new()
	hint.text = "Aqui ira el feed real cuando exista la conexion entre PCs."
	hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hint.add_theme_color_override("font_color", Color(0.56, 0.68, 0.7))
	header.add_child(hint)

	var feed := PanelContainer.new()
	feed.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	feed.size_flags_vertical = Control.SIZE_EXPAND_FILL
	feed.add_theme_stylebox_override("panel", _style(Color(0.018, 0.028, 0.035), Color(0.07, 0.22, 0.26), 8, 2))
	desktop.add_child(feed)

	var feed_margin := _margin(18)
	feed.add_child(feed_margin)

	var feed_box := VBoxContainer.new()
	feed_box.add_theme_constant_override("separation", 12)
	feed_margin.add_child(feed_box)

	var scene_title := Label.new()
	scene_title.text = "Camara de investigacion"
	scene_title.add_theme_font_size_override("font_size", 22)
	scene_title.add_theme_color_override("font_color", Color(0.88, 0.98, 1.0))
	feed_box.add_child(scene_title)

	var fake_view := GridContainer.new()
	fake_view.columns = 2
	fake_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fake_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	fake_view.add_theme_constant_override("h_separation", 12)
	fake_view.add_theme_constant_override("v_separation", 12)
	feed_box.add_child(fake_view)

	_add_feed_card(fake_view, "Habitacion", "Jugador 1 revisa un computador prestado.")
	_add_feed_card(fake_view, "Chat abierto", "Hay mensajes hostiles pendientes de analisis.")
	_add_feed_card(fake_view, "Carpeta local", "Posibles capturas y archivos relacionados.")
	_add_feed_card(fake_view, "Red social", "Una cuenta anonima aparece varias veces.")


func _add_feed_card(parent: Control, title: String, body: String) -> void:
	var card := _panel(Color(0.04, 0.065, 0.075), Color(0.1, 0.22, 0.25))
	card.custom_minimum_size = Vector2(220, 110)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(card)

	var margin := _margin(12)
	card.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	margin.add_child(box)

	var title_label := Label.new()
	title_label.text = title
	title_label.add_theme_color_override("font_color", Color(0.92, 0.96, 0.84))
	title_label.add_theme_font_size_override("font_size", 17)
	box.add_child(title_label)

	var body_label := Label.new()
	body_label.text = body
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	body_label.add_theme_color_override("font_color", Color(0.68, 0.78, 0.8))
	box.add_child(body_label)


func _clear_screen() -> void:
	for child in screen_content.get_children():
		child.queue_free()


func _set_screen_padding(amount: int) -> void:
	if screen_content == null:
		return

	screen_content.add_theme_constant_override("margin_left", amount)
	screen_content.add_theme_constant_override("margin_top", amount)
	screen_content.add_theme_constant_override("margin_right", amount)
	screen_content.add_theme_constant_override("margin_bottom", amount)


func _add_log(text: String) -> void:
	if log_list == null:
		return

	while log_list.get_child_count() >= 6:
		var old_entry := log_list.get_child(0)
		log_list.remove_child(old_entry)
		old_entry.queue_free()

	var label := Label.new()
	label.text = "- " + text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.add_theme_color_override("font_color", Color(0.64, 0.78, 0.8))
	log_list.add_child(label)


func _section_title(text: String) -> Label:
	var label := Label.new()
	label.text = text.to_upper()
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color(0.38, 0.9, 0.88))
	return label


func _pill_label(text: String, bg: Color, fg: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(150, 36)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", fg)
	label.add_theme_stylebox_override("normal", _style(bg, Color(0.18, 0.48, 0.48), 6, 1))
	return label


func _panel(bg: Color, border: Color) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(bg, border, 8, 1))
	return panel


func _style(bg: Color, border: Color, radius: int, border_width: int = 1) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.border_width_left = border_width
	style.border_width_top = border_width
	style.border_width_right = border_width
	style.border_width_bottom = border_width
	style.border_color = border
	return style


func _margin(amount: int) -> MarginContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", amount)
	margin.add_theme_constant_override("margin_top", amount)
	margin.add_theme_constant_override("margin_right", amount)
	margin.add_theme_constant_override("margin_bottom", amount)
	return margin


func _separator() -> HSeparator:
	var sep := HSeparator.new()
	sep.add_theme_constant_override("separation", 8)
	return sep
