extends RigidBody2D

@onready var bounce_chance := 0.2
@onready var damageHurtbox := $damageHurtbox
@onready var pickupHitbox := $pickupHitbox
@onready var killTimer := $killTimer
@onready var sprite := $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	killTimer.timeout.connect(queue_free)
	damageHurtbox.area_entered.connect(hitClimber)
	toggleHurtbox(false)
	freeze = true
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fall(force):
	freeze = false
	visible = true
	$Line2D.points = [force, Vector2.ZERO]
	apply_central_impulse(force)
	apply_torque_impulse(5000000)
	killTimer.start(10.0)
	
func pickedUp():
	killTimer.stop()
	linear_velocity = Vector2.ZERO
	togglePickup(false)
	freeze = true
	
func thrown(force):
	freeze = false
	toggleHurtbox(true)
	togglePickup(true)
	apply_central_impulse(force)
	killTimer.start(25.0)
	set_collision_mask_value(2, true)
	
func hitClimber(climberArea):
	killTimer.stop()
	climberArea.get_parent().hit()
	if randf() > bounce_chance: #no bounce
		queue_free()
	else:
		killTimer.start(10.0)
		toggleHurtbox(false)
		set_collision_mask_value(2, false)
	
func togglePickup(on: bool):
	pickupHitbox.set_deferred("monitorable", on)
	pickupHitbox.set_deferred("monitoring", on)
	
func toggleHurtbox(on: bool):
	damageHurtbox.set_deferred("monitorable", on)
	damageHurtbox.set_deferred("monitoring", on)
