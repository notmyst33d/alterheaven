extends KinematicBody2D

signal level_changed

var velocity = Vector2.ZERO
var speed = 60
var speed_multiplier = 1
var can_move = true

func _ready():
	connect("level_changed", self, "_level_changed")

func _level_changed():
	can_move = false

func _physics_process(delta):
	if Input.is_action_pressed("sprint"):
		speed_multiplier = 2
	else:
		speed_multiplier = 1

	if _check_inputs():
		move_and_slide(velocity * speed * speed_multiplier * scale)
		velocity = Vector2.ZERO

func _check_inputs():
	if not can_move:
		$Sprite.frame = 0
		$Sprite.stop()
		return false

	var check = false

	if Input.is_action_pressed("up"):
		velocity.y -= 1
		$Sprite.animation = "Back"
		$Sprite.play()
		check = true
	if Input.is_action_pressed("down"):
		velocity.y += 1
		$Sprite.animation = "Front"
		$Sprite.play()
		check = true
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		$Sprite.animation = "Left"
		$Sprite.play()
		check = true
	if Input.is_action_pressed("right"):
		velocity.x += 1
		$Sprite.animation = "Right"
		$Sprite.play()
		check = true

	if not check:
		$Sprite.frame = 0
		$Sprite.stop()

	return check
