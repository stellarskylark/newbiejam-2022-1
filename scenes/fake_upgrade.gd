extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var dialogue = load("res://scenes/Dialogue.tscn").instance()
	dialogue.ink_script = load("res://assets/dialogue/fakeupgrade.ink")
	add_child(dialogue)
	dialogue.get_node("TileMap").queue_free()
