extends KinematicBody2D

var speed = 60
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	velocity = Vector2()
	
	if Input.is_action_pressed("left"):
		$playerAnimation.play("runLeft")

	elif Input.is_action_pressed("right"):
		$playerAnimation.play("runRight")
		
	elif Input.is_action_pressed("down"):
		$playerAnimation.play("runRight")

	elif Input.is_action_pressed("up"):
		$playerAnimation.play("runLeft")

	

	else:
		$playerAnimation.play("Idle")
	
	if Input.is_action_pressed("down"):
		velocity.y += speed
	if Input.is_action_pressed("up"):
		velocity.y -= speed
	if Input.is_action_pressed("left"):
		velocity.x -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
	
	if Input.is_key_pressed(KEY_X):
		$playerAnimation.play("fightingSequence")
		yield(get_tree().create_timer(1.2),"timeout")
		get_tree().change_scene("res://src/Battle.tscn")
	
		
	move_and_slide(velocity)

