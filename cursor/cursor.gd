extends Node2D

@onready var cursor = preload("res://assets/sprites/crosshair.png")
@onready var cursor_firing = preload("res://assets/sprites/crosshair_firing.png")

func _ready():
	Input.set_custom_mouse_cursor(cursor)

func _process(event):
	if Input.is_mouse_button_pressed(1):
		Input.set_custom_mouse_cursor(cursor_firing)
	else:
		Input.set_custom_mouse_cursor(cursor)
