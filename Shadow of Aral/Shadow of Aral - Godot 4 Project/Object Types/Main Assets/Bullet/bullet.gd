extends Area2D

@export var speed: int = 3000
var direction: Vector2 = Vector2.ZERO

func _process(delta):
     position += direction*speed*delta
