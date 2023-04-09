extends KinematicBody2D

signal interacted
signal level_changed

enum Facing {
	Up,
	Down,
	Left,
	Right,
}

onready var sprite = $Sprite

var velocity = Vector2.ZERO
var speed = 60
var speed_multiplier = 1
var can_move = true
export(Facing) var facing = Facing.Down

var touch_position = null
var touch_pressed = false

func _ready():
	if facing == Facing.Up:
		sprite.animation = "Back"
	elif facing == Facing.Down:
		sprite.animation = "Front"
	elif facing == Facing.Left:
		sprite.animation = "Left"
	elif facing == Facing.Right:
		sprite.animation = "Right"
	connect("level_changed", self, "disable_movement")

func _input(event):
	if event is InputEventScreenTouch:
		touch_pressed = event.pressed
		touch_position = event.position

	if event is InputEventScreenDrag:
		touch_position = event.position

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			touch_pressed = event.pressed
			touch_position = event.position

	if event is InputEventMouseMotion:
		if touch_pressed:
			touch_position = event.position

func _physics_process(delta):
	if Input.is_action_just_pressed("primary"):
		emit_signal("interacted")

	if Input.is_action_pressed("sprint"):
		speed_multiplier = 2
	else:
		speed_multiplier = 1

	if check_inputs():
		move_and_slide(velocity * speed * speed_multiplier * scale)
		velocity = Vector2.ZERO

func disable_movement():
	print("Disabled")
	can_move = false

func enable_movement():
	print("Enabled")
	can_move = true

func check_inputs():
	if not can_move:
		sprite.frame = 0
		sprite.stop()
		return false

	var override = false
	var check = false
	if Input.is_action_pressed("up"):
		check = true
		facing = Facing.Up
		velocity.y -= 1
		override = true
		if sprite.animation != "Back" or not sprite.playing:
			sprite.play("Back")
	elif Input.is_action_pressed("down"):
		check = true
		facing = Facing.Down
		velocity.y += 1
		override = true
		if sprite.animation != "Front" or not sprite.playing:
			sprite.play("Front")

	if Input.is_action_pressed("left"):
		check = true
		velocity.x -= 1
		if (sprite.animation != "Left" or not sprite.playing) and not override:
			facing = Facing.Left
			sprite.play("Left")
	elif Input.is_action_pressed("right"):
		check = true
		velocity.x += 1
		if (sprite.animation != "Right" or not sprite.playing) and not override:
			facing = Facing.Right
			sprite.play("Right")

	if check:
		return true

	if touch_pressed and touch_position:
		var level_camera = get_node("../LevelCamera")
		velocity = global_position.direction_to(level_camera.position + touch_position)

		override = false
		if velocity.y > 0.5:
			if sprite.animation != "Front" or not sprite.playing:
				sprite.play("Front")
			override = true
		elif velocity.y < -0.5:
			if sprite.animation != "Back" or not sprite.playing:
				sprite.play("Back")
			override = true

		if not override:
			if velocity.x > 0 and sprite.animation != "Right" or not sprite.playing:
				sprite.play("Right")
			elif velocity.x < 0 and sprite.animation != "Left" or not sprite.playing:
				sprite.play("Left")

		return true

	if sprite.playing:
		sprite.frame = 0
		sprite.stop()

	return false
