extends Node2D
class_name CelularInteractivo

@onready var area: Area2D = $AreaCelular2D
var player_near: bool = false

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	visible = false

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_near = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_near = false

func _process(_delta: float) -> void:
	visible = Global.paso_actual == 1

	if player_near and Input.is_action_just_pressed("ui_accept"):
		Global.tiene_celular = true
		Global.paso_actual = 2
