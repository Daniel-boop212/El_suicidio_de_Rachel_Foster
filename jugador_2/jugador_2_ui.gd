extends Control

const MINIGAMES = {
	"moderacion": {
		"title_key": "task.moderacion.title",
		"route": "res://jugador_2/minijuego_presiona.tscn",
		"brief_key": "task.moderacion.brief"
	},
	"toxicidad": {
		"title_key": "task.toxicidad.title",
		"route": "res://jugador_2/minijuego_detectar.tscn",
		"brief_key": "task.toxicidad.brief"
	},
	"conversacion": {
		"title_key": "task.conversacion.title",
		"route": "res://jugador_2/minijuego_chat.tscn",
		"brief_key": "task.conversacion.brief"
	},
	"busqueda": {
		"title_key": "task.busqueda.title",
		"route": "res://jugador_2/minijuego_busqueda.tscn",
		"brief_key": "task.busqueda.brief"
	},
	"perfil": {
		"title_key": "task.perfil.title",
		"route": "res://jugador_2/minijuego_sospechoso.tscn",
		"brief_key": "task.perfil.brief"
	},
	"testimonio": {
		"title_key": "task.testimonio.title",
		"route": "res://jugador_2/minijuego_descubrir.tscn",
		"brief_key": "task.testimonio.brief"
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
var camera_texture: TextureRect = null
var camera_status: Label = null
var ultima_captura: ImageTexture = null

func _ready() -> void:
	Global.tarea_jugador_2_solicitada.connect(trigger_task)
	_build_interface()
	_show_waiting_desktop()
	_add_log(Global.t("system_ready"))
	if not Global.tarea_jugador_2_solicitada.is_connected(trigger_task):
		Global.tarea_jugador_2_solicitada.connect(trigger_task)
	if not Global.captura_jugador_1_actualizada.is_connected(_on_captura_jugador_1_actualizada):
		Global.captura_jugador_1_actualizada.connect(_on_captura_jugador_1_actualizada)
	if not Global.idioma_actualizado.is_connected(_on_idioma_actualizado):
		Global.idioma_actualizado.connect(_on_idioma_actualizado)

func trigger_task(task_id: String) -> void:
	if not MINIGAMES.has(task_id):
		push_warning(Global.t("unknown_task") + task_id)
		return

	var task: Dictionary = MINIGAMES[task_id]
	tarea_actual = task_id
	task_title.text = Global.t(str(task["title_key"]))
	task_brief.text = Global.t(str(task["brief_key"]))
	status_label.text = Global.t("task_received")
	_add_log(Global.t("new_support") + Global.t(str(task["title_key"])))
	mostrar_minijuego(str(task["route"]))


func mostrar_minijuego(ruta: String) -> void:
	if minijuego_actual and is_instance_valid(minijuego_actual):
		minijuego_actual.queue_free()

	_clear_screen()
	_set_screen_padding(0)

	var escena: Resource = load(ruta)
	if escena == null:
		status_label.text = Global.t("load_error")
		_add_log(Global.t("load_failed") + ruta)
		_show_waiting_desktop()
		return

	minijuego_actual = escena.instantiate()
	screen_content.add_child(minijuego_actual)
	minijuego_actual.set_anchors_preset(Control.PRESET_FULL_RECT)
	minijuego_actual.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	minijuego_actual.size_flags_vertical = Control.SIZE_EXPAND_FILL
	Global.traducir_arbol(minijuego_actual)

	if minijuego_actual.has_signal("minijuego_terminado"):
		minijuego_actual.minijuego_terminado.connect(_on_minijuego_terminado)


func _on_minijuego_terminado(resultado: bool, recompensa: int) -> void:
	if resultado:
		monedas += recompensa
		misiones_resueltas += 1
		status_label.text = Global.t("case_updated")
		_add_log(Global.t("support_done") % str(recompensa))
	else:
		misiones_fallidas += 1
		status_label.text = Global.t("support_failed")
		_add_log(Global.t("task_failed"))

	Global.completar_tarea_jugador_2(tarea_actual, resultado, recompensa)
	_update_rewards()
	minijuego_actual = null
	task_title.text = Global.t("waiting_request")
	task_brief.text = Global.t("waiting_brief")

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
	title.text = Global.t("assistant_title")
	title.add_theme_font_size_override("font_size", 23)
	title.add_theme_color_override("font_color", Color(0.92, 0.98, 1.0))
	title_box.add_child(title)

	var subtitle := Label.new()
	subtitle.text = Global.t("assistant_subtitle")
	subtitle.add_theme_color_override("font_color", Color(0.55, 0.68, 0.72))
	title_box.add_child(subtitle)

	status_label = _pill_label(Global.t("standby"), Color(0.12, 0.28, 0.24), Color(0.45, 0.95, 0.74))
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
	case_text.text = Global.t("active_case").to_upper() + "\n" + Global.t("case_text")
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
	task_title.text = Global.t("waiting_request")
	task_title.add_theme_font_size_override("font_size", 18)
	task_title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.62))
	task_box.add_child(task_title)

	task_brief = Label.new()
	task_brief.name = "TaskBrief"
	task_brief.unique_name_in_owner = true
	task_brief.text = Global.t("waiting_brief")
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

	box.add_child(_section_title(Global.t("active_case")))

	var case_text := Label.new()
	case_text.text = Global.t("case_text")
	case_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	case_text.add_theme_color_override("font_color", Color(0.78, 0.88, 0.9))
	box.add_child(case_text)

	task_title = Label.new()
	task_title.name = "TaskTitle"
	task_title.unique_name_in_owner = true
	task_title.text = Global.t("waiting_request")
	task_title.add_theme_font_size_override("font_size", 18)
	task_title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.62))
	box.add_child(task_title)

	task_brief = Label.new()
	task_brief.name = "TaskBrief"
	task_brief.unique_name_in_owner = true
	task_brief.text = Global.t("waiting_brief")
	task_brief.autowrap_mode = TextServer.AUTOWRAP_WORD
	task_brief.add_theme_color_override("font_color", Color(0.68, 0.78, 0.82))
	box.add_child(task_brief)

	box.add_child(_separator())
	box.add_child(_section_title("Log"))

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

	box.add_child(_section_title(Global.t("active_case")))

	var case_text := Label.new()
	case_text.text = Global.t("case_text")
	case_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	case_text.add_theme_color_override("font_color", Color(0.76, 0.88, 0.9))
	box.add_child(case_text)

	task_title = Label.new()
	task_title.name = "TaskTitle"
	task_title.unique_name_in_owner = true
	task_title.text = Global.t("waiting_request")
	task_title.add_theme_font_size_override("font_size", 17)
	task_title.add_theme_color_override("font_color", Color(1.0, 0.92, 0.62))
	box.add_child(task_title)

	task_brief = Label.new()
	task_brief.name = "TaskBrief"
	task_brief.unique_name_in_owner = true
	task_brief.text = Global.t("waiting_brief")
	task_brief.autowrap_mode = TextServer.AUTOWRAP_WORD
	task_brief.add_theme_color_override("font_color", Color(0.68, 0.78, 0.82))
	box.add_child(task_brief)

	box.add_child(_separator())
	box.add_child(_section_title(Global.t("event_simulator")))

	var note := Label.new()
	note.text = Global.t("event_note")
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
		button.text = Global.t(str(task["title_key"]))
		button.custom_minimum_size = Vector2(0, 34)
		button.tooltip_text = Global.t(str(task["brief_key"]))
		button.pressed.connect(trigger_task.bind(id))
		action_list.add_child(button)

	box.add_child(_separator())

	reward_label = Label.new()
	reward_label.name = "RewardLabel"
	reward_label.unique_name_in_owner = true
	_update_rewards()
	reward_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	reward_label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.62))
	box.add_child(reward_label)

	return panel


func _create_bottom_bar() -> Control:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 10)

	var text := Label.new()
	text.text = Global.t("bottom_status")
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
	status_label.text = Global.t("standby")

	var desktop := VBoxContainer.new()
	desktop.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	desktop.size_flags_vertical = Control.SIZE_EXPAND_FILL
	desktop.add_theme_constant_override("separation", 12)
	screen_content.add_child(desktop)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	desktop.add_child(header)

	var live := _pill_label(Global.t("player1_view"), Color(0.12, 0.18, 0.2), Color(0.58, 0.86, 0.92))
	header.add_child(live)

	var hint := Label.new()
	hint.text = Global.t("feed_waiting")
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
	scene_title.text = Global.t("camera_title")
	scene_title.add_theme_font_size_override("font_size", 22)
	scene_title.add_theme_color_override("font_color", Color(0.88, 0.98, 1.0))
	feed_box.add_child(scene_title)

	camera_texture = TextureRect.new()
	camera_texture.name = "PlayerOneCapture"
	camera_texture.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	camera_texture.size_flags_vertical = Control.SIZE_EXPAND_FILL
	camera_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	camera_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	camera_texture.texture = ultima_captura
	feed_box.add_child(camera_texture)

	camera_status = Label.new()
	camera_status.text = Global.t("feed_waiting") if ultima_captura == null else ""
	camera_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	camera_status.add_theme_color_override("font_color", Color(0.68, 0.78, 0.8))
	feed_box.add_child(camera_status)


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


func _on_captura_jugador_1_actualizada(bytes: PackedByteArray) -> void:
	var image: Image = Image.new()
	var error: Error = image.load_jpg_from_buffer(bytes)
	if error != OK:
		return

	ultima_captura = ImageTexture.create_from_image(image)
	if camera_texture != null:
		camera_texture.texture = ultima_captura
	if camera_status != null:
		camera_status.text = ""


func _on_idioma_actualizado() -> void:
	if minijuego_actual != null:
		return

	_build_interface()
	_show_waiting_desktop()


func _update_rewards() -> void:
	if reward_label != null:
		reward_label.text = Global.t("rewards") % [str(monedas), str(misiones_resueltas), str(misiones_fallidas)]


func _add_log(text: String) -> void:
	if log_list == null:
		return

	while log_list.get_child_count() >= 6:
		var old_entry: Node = log_list.get_child(0)
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
