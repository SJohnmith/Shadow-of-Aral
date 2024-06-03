extends Node2D

# Called when the node enters the scene tree for the first time
func _ready():
     pass


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
#     pass
     $Torso/FrontArm.look_at(get_global_mouse_position())

     
func update_animation(animation_name):
     $AnimationPlayer.play(animation_name)

func update_facing_direction(direction):
     if direction.x > 0:
          $".".scale = Vector2(1, 1)
     elif direction.x < 0:
          $".".scale = Vector2(-1, 1)


