extends Node2D

var grip_path = 0
var stock_grip_pos = Vector2.ZERO
var hand_pos = Vector2.ZERO

var stock_grip_ang = 0.0
var hand_ang = 0.0

func _ready():
     grip_path = $Torso/Weapon.get_child(2)
     hand_pos = $Torso/BackArm.position

func _process(_delta):
     # Set rotation of the arms to mouse position
     $Torso/FrontArm.look_at(get_global_mouse_position())
     $Torso/BackArm.look_at(get_global_mouse_position())
     
     # Get Gun Stock Grip Position
     stock_grip_pos = grip_path.get_global_position()
     stock_grip_ang = grip_path.get_global_rotation()
     
     # Get Back Arm Hand Position
     hand_pos = $Torso/BackArm.get_global_position()
     hand_ang = $Torso/BackArm.get_global_rotation()
     
#     print(stock_grip_ang)
     
func update_animation(animation_name):
     $AnimationPlayer.play(animation_name)

func update_walk_direction(direction):
     if direction.x > 0:
          $Torso/BackLeg.flip_h = false
          $Torso/FrontLeg.flip_h = false
     elif direction.x < 0:
          $Torso/BackLeg.flip_h = true
          $Torso/FrontLeg.flip_h = true
          
func update_facing_direction(direction):
     if direction.x > 0:
          $".".scale = Vector2(1, 1)
     elif direction.x < 0:
          $".".scale = Vector2(-1, 1)




