extends CanvasLayer

@onready var contenedor = $ContenedorPrincipal 

func _ready() -> void:
	contenedor.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("abrir_menu"):
		contenedor.visible = not contenedor.visible

func _on_button_pressed() -> void:
	contenedor.visible = false

func _on_button_salir_pressed() -> void:
	Global.salir_partida()
