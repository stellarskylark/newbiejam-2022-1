extends KinematicBody2D

var velocity = Vector2.ZERO
var move_speed = 1200
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
			rotation_degrees = 0
			velocity = Vector2(0, -move_speed)
			input_locked = true
		elif Input.is_action_just_pressed("move_down"):
			rotation_degrees = 180
			velocity = Vector2(0, move_speed)
			input_locked = true
		elif Input.is_action_just_pressed("move_right"):
			rotation_degrees = 90
			velocity = Vector2(move_speed, 0)
			input_locked = true
		elif Input.is_action_just_pressed("move_left"):
			rotation_degrees = 270
			velocity = Vector2(-move_speed, 0)
			input_locked = true
	
	if input_locked and not move_and_slide(velocity):
		velocity = Vector2.ZERO
		input_locked = false
