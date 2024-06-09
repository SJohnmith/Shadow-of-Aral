extends Area2D

@export var speed: int = 3000
@export var damage: int = 10

var direction: Vector2 = Vector2.ZERO
var emitted_bullet: bool = false

func _ready():
     $SelfDestructTimer.start()

func _process(delta):
     position += direction*speed*delta

# Bullet on Collision
func _on_body_entered(body):
     # Check that the Body has this Method
     if "hit" in body:
          body.hit()
          
     # Destroy Bullet
     queue_free()

# On Bullet Timer
func _on_self_destruct_timer_timeout():
     # Destroy Bullet
     queue_free()
