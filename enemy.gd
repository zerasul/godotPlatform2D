extends CharacterBody2D

const WALK_SPEED = 1000

const LEFT= -1
const RIGHT = 1
const STOP = 0

const DIRECTIONS = [LEFT,STOP,RIGHT]

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var currentDir = 0
var direction = LEFT

func _ready() -> void:
	$directiontimer.start()
	$AnimatedSprite2D.play("move")
	add_to_group("enemy")
	
func _physics_process(delta: float) -> void:
	var walk = WALK_SPEED* direction
	
	velocity.x = walk * delta

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta
	
	move_and_slide()
	

	


func _on_directiontimer_timeout() -> void:
	currentDir+=1
	direction= DIRECTIONS[currentDir % DIRECTIONS.size()]
	if direction!=0 :
		$AnimatedSprite2D.play("move")
	else:
		$AnimatedSprite2D.play("idle")
		
	if(direction<0):
		$AnimatedSprite2D.flip_h=false
	else:
		$AnimatedSprite2D.flip_h=true
	pass # Replace with function body.
