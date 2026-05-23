extends Node

func _ready():
	var ui = preload("res://jugador_2/jugador_2_ui.tscn").instantiate()
	add_child(ui)
	
	await get_tree().create_timer(1).timeout
	
	ui.mostrar_minijuego("res://jugador_2/minijuego_presiona.tscn")
