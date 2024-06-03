extends Node2D

#var bullet_scene: PackedScene = preload("res://Object Types/Main Assets/Bullet/bullet.tscn")

# Called when the node enters the scene tree for the first time
func _ready():
     pass


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
#     $Torso/Head.look_at(get_global_mouse_position())
#     $Torso/FrontArm/Weapon.look_at(get_global_mouse_position())
     $Torso/FrontArm.look_at(get_global_mouse_position())
#     $Torso/BackArm.look_at(get_global_mouse_position())
#     print("Angle = ", $Torso/FrontArm.rotation)
     
func update_animation(animation_name):
     $AnimationPlayer.play(animation_name)

func update_facing_direction(direction):
     if direction.x > 0:
#          $".".scale = Vector2(1, 1)
          $Torso.flip_h = false

     elif direction.x < 0:
#          $".".scale = Vector2(-1, 1)
          $Torso.flip_h = true

          
#func fire():
#     var bullet = bullet_scene.instantiate()
#     bullet.position = $Torso/Weapon.position
#     add_child(bullet)
#     print("fire")
