extends CharacterBody2D

var speedUpgAmount : float
var _rotation = 0.0
var rotTween = create_tween()
var camTween = create_tween()
var isPreHyperSpace : bool = false


@export var HORIZONTAL_SPEED : float = 200.0
@export var VERTICAL_SPEED : float = 300.0
@export var BACKWARD_SPEED : float = 50.0
@export var rotation_speed : float = TAU * 0.5
@export var PREHYPERSPACE_SPEED : float = VERTICAL_SPEED * 2.5 #mostly Vertical speed times two and a half

var speed = 400

func _ready() -> void:
	rotTween.set_trans(Tween.TRANS_SINE)
	rotTween.set_ease(Tween.EASE_OUT)
	camTween.set_trans(Tween.TRANS_SINE)
	camTween.set_ease(Tween.EASE_OUT)
func get_input():
	if Input.is_action_just_pressed("in_s"):
		speed = BACKWARD_SPEED
	elif Input.is_action_just_pressed("in_w"):
		if isPreHyperSpace:
			speed = PREHYPERSPACE_SPEED
		else:
			speed = VERTICAL_SPEED
	rotation = (deg_to_rad(_rotation))
	velocity = transform.x * Input.get_axis("in_s", "in_w") * speed

func _physics_process(delta):
	get_input()
	
	if rotTween:
		rotTween.kill()
	else: 
		rotTween.tween_property(self,"rotation", deg_to_rad(_rotation), 0.65)
	move_and_slide()
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("in_lshift"):
		print("Shift pressed")
		if not isPreHyperSpace:
			isPreHyperSpace = true
			print(isPreHyperSpace)
		else:
			isPreHyperSpace = false
			print(isPreHyperSpace)
	if camTween:
		camTween.kill()
	else: 
		camTween.tween_property(self,"rotation", deg_to_rad(_rotation), 0.9)
	if Input.is_action_pressed("in_d"):
		_rotation += 2.5
	if Input.is_action_pressed("in_a"):
		_rotation -= 2.5
