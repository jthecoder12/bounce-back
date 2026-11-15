extends CharacterBody2D

const SPEED = 900.0
const JUMP_VELOCITY = -800.0

@export var can_fly = false
@export var can_double_jump = true
var jump_count = 0

var reset_position = Vector2()

func reset() -> void:
	self.position = reset_position

func _process(_delta: float) -> void:
	if can_fly:
		var player_sprite: Sprite2D = get_node("Sprite2D")
		player_sprite.texture = preload("res://sprites/fly.png")
	
	if self.position.y > 450: reset()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (jump_count < 2 or can_fly):
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	
	if !can_double_jump and jump_count == 1: jump_count = 2
		
	if jump_count != 0 and is_on_floor() and !Input.is_action_just_pressed("jump"):
		jump_count = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
