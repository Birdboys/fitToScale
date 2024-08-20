extends RigidBody2D

@onready var playerSprite := $playerSprite
@onready var mountainRay := $mountainRay
@onready var playerAnim := $playerAnim
@export var hand : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand.pull_force.connect(pulled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if mountainRay.is_colliding():
		playerAnim.play("kick")
	else:
		playerAnim.play("RESET")

func summonHand():
	hand.global_position = global_position
	
func pulled(force, delta):
	apply_central_force(force * delta)
