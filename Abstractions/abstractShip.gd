extends CharacterBody2D

@onready var healthbar = $CanvasLayer/HealthBar
@onready var spicebar = $CanvasLayer/SpiceBar
@onready var spiceTimer = $SpiceTimer
@onready var enginesFX = $TurbineFX

@export var HORIZONTAL_SPEED : float = 200.0
@export var VERTICAL_SPEED : float = 300.0
@export var BACKWARD_SPEED : float = 50.0
@export var rotation_speed : float = TAU * 0.5
@export var PREHYPERSPACE_SPEED : float = VERTICAL_SPEED * 2.5 #mostly Vertical speed times two and a half
@export var healthMax : int = 30
@export var spiceMax : float = 60

var speed = 400
var speedUpgAmount : int = 0
var healthUpgAmount : int = 0
var spiceUpgAmount : int = 0
var spiceCapUpgAmount : int = 0
var _rotation = 0.0
var rotTween = create_tween()
var camTween = create_tween()
var spicebarTween = create_tween()
var isPreHyperSpace : bool = false
var health : int = healthMax
var spice : float = spiceMax

func _ready() -> void:
	_init_health()
	_init_spice()
	rotTween.set_trans(Tween.TRANS_SINE)
	rotTween.set_ease(Tween.EASE_OUT)
	camTween.set_trans(Tween.TRANS_SINE)
	camTween.set_ease(Tween.EASE_OUT)
	spicebarTween.set_ease(Tween.EASE_IN_OUT)
	spicebarTween.set_trans(Tween.TRANS_SINE)
	
func get_input():
	if Input.is_action_just_pressed("in_s"):
		speed = BACKWARD_SPEED + speedUpgAmount*60
	elif Input.is_action_just_pressed("in_w"):
		if isPreHyperSpace:
			speed = PREHYPERSPACE_SPEED + speedUpgAmount*30
		else:
			speed = VERTICAL_SPEED + speedUpgAmount*60
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
			if spice > 5 + (spiceUpgAmount*2):
				isPreHyperSpace = true
				speed = PREHYPERSPACE_SPEED + speedUpgAmount*20
				spiceTimer.start()
				print(isPreHyperSpace)
			else:
				print("NO SPICE")
				
		else:
			isPreHyperSpace = false
			speed = VERTICAL_SPEED + speedUpgAmount*60
			spiceTimer.stop()
			print(isPreHyperSpace)
	if camTween:
		camTween.kill()
	else: 
		camTween.tween_property(self,"rotation", deg_to_rad(_rotation), 0.9)
	if Input.is_action_pressed("in_d"):
		_rotation += 2.5
	if Input.is_action_pressed("in_a"):
		_rotation -= 2.5
	if isPreHyperSpace:
		enginesFX.speed_scale = 3
	else:
		enginesFX.speed_scale = 1
	if spice < 15+floor((spiceCapUpgAmount*1.5*10)) and not isPreHyperSpace:
		if Input.is_action_just_pressed("in_g"):
			spice += 0.5
			_update_spice()
func _init_health() -> void:
	healthbar.max_value = healthMax + healthUpgAmount*20
	healthbar.value = healthMax + healthUpgAmount*20
	health = healthMax + healthUpgAmount*20
	
func _init_spice() -> void:
	spicebar.max_value = spiceMax
	spicebar.value = spiceMax
	spice = spiceMax

func _update_spice() -> void:
	while spicebar.value > spice:
		spicebar.value -= 0.05
		await get_tree().create_timer(0.005).timeout
	while spicebar.value < spice:
		spicebar.value += 0.05
		await get_tree().create_timer(0.005).timeout
#	if spicebarTween:
#		spicebarTween.kill()
#	else:
#		spicebarTween.tween_property(spicebar, "value", spice, 2)

func _on_spice_timer_timeout() -> void:
	spice -= 3+(spiceUpgAmount*2)
	_update_spice()
	print("ate spice")
	if spicebar.value < 3+(spiceUpgAmount*2):
		speed = VERTICAL_SPEED
		isPreHyperSpace = false
		print("engines off")
		spiceTimer.stop()
	else:
		spiceTimer.start()
