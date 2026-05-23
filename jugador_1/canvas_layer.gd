extends CanvasLayer

@onready var panel = $Control/Panel
@onready var label = $Control/Panel/Label
func _ready():
	print(panel)
	print(label)

func mostrar_dialogo(texto):
	panel.visible = true
	label.text = texto

func ocultar_dialogo():
	panel.visible = false

func _process(delta):
	if panel.visible and Input.is_action_just_pressed("ui_accept"):
		ocultar_dialogo()
