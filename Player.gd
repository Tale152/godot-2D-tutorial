extends Area2D

signal hit
export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window
var intra_frame_mouse_delta


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	intra_frame_mouse_delta = Vector2.ZERO
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = intra_frame_mouse_delta
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	intra_frame_mouse_delta = Vector2.ZERO
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = velocity.y > 0
			
func _input(event):
	if event is InputEventScreenDrag:
		intra_frame_mouse_delta += event.relative
		
func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
