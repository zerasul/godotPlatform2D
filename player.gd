extends CharacterBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 400

const ANIMATIONS = ["idle","rigth", "left", "fall"]

@export var initialPos: Vector2

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var anim = ANIMATIONS[0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_axis(&"move_left", &"move_right"))
	
	
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	# TODO: This information should be set to the CharacterBody properties instead of arguments: snap, Vector2.DOWN, Vector2.UP
	# TODO: Rename velocity to linear_velocity in the rest of the script.
	move_and_slide()

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		velocity.y = -JUMP_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		anim=1
	else:
		if Input.is_action_pressed("move_left"):
			anim=2
		else:
			anim=0
	if is_on_floor():	
		$AnimatedSprite2D.play(ANIMATIONS[anim])
		$AnimatedSprite2D.flip_h=false
	else:
		if anim==2:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
		$AnimatedSprite2D.play("fall")
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if !is_on_floor():
			body.queue_free()
		else:
			position= initialPos
	
	pass # Replace with function body.
