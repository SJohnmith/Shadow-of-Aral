extends Node2D

# Player Properties
var stock_grip_pos: Vector2 = Vector2.ZERO
var hand_pos: Vector2 = Vector2.ZERO

# Player Attributes
@onready var path_to_wpn: Node2D = $Torso/Weapon
@onready var grip_path = path_to_wpn.get_child(2)
@onready var front_arm: Node2D = $Torso/FrontArm
@onready var back_arm: Node2D = $Torso/BackArm

func _ready():
     hand_pos = back_arm.position

func _process(_delta):
     # Set rotation of the arms to mouse position
     front_arm.look_at(get_global_mouse_position())
     back_arm.look_at(get_global_mouse_position())
     
     
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


# Received from Player a Command to use Equipped Weapon
func player_wpn_action(action):
     # Front Arm Pointing Direction
     var wpn_pointing_direction = Vector2(cos(front_arm.rotation), sin(front_arm.rotation))*($".".scale)
     
     # If Player is Shooting the Weapon
     if action == "shoot":
     # Check that the Weapon Has Method Shoot
          if path_to_wpn.has_method("shoot"):
               # Call the Shoot Method
               path_to_wpn.shoot(wpn_pointing_direction)  
     
     # If Player is Reloading the Weapon
     elif action == "reload":
          $AnimationArms.play("Reload")
     # Check that the Weapon Has Method Shoot
          if path_to_wpn.has_method("reload"):
               # Call the Shoot Method
               path_to_wpn.reload()
               $Torso/Magazine.z_index = -1
