extends Area2D

@export var speed: int = 2000
var direction: Vector2 = Vector2.ZERO

func _process(delta):
     position += direction*speed*delta
