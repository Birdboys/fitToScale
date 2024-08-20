extends RigidBody2D

@onready var playerSprite := $playerSprite
@export var hand : CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand.pull_force.connect(pulled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func summonHand():
	hand.global_position = global_position
	
func pulled(force, delta):
	apply_central_force(force * delta)
