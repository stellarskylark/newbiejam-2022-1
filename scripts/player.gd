extends KinematicBody2D

var velocity = Vector2.ZERO
var move_speed = 1800
var input_locked = false
var won = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if won:
		return
	if not input_locked:
		if Input.is_action_just_pressed("move_up"):
			velocity = Vector2(0, -move_speed)
			input_locked = true
		elif Input.is_action_just_pressed("move_down"):
			velocity = Vector2(0, move_speed)
			input_locked = true
		elif Input.is_action_just_pressed("move_right"):
			velocity = Vector2(move_speed, 0)
			input_locked = true
		elif Input.is_action_just_pressed("move_left"):
			velocity = Vector2(-move_speed, 0)
			input_locked = true
	
	if input_locked and not move_and_slide(velocity):
		velocity = Vector2.ZERO
		input_locked = false
