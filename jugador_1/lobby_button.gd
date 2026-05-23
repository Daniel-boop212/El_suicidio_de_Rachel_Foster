extends Control

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("CLICK PLAY")
		get_tree().change_scene_to_file("res://jugador_1/main_menu.tscn")
