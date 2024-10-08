class_name Character_Body extends Node

# Character Body Properties
@export var character_texture: Texture
var stock_grip_pos: Vector2 = Vector2.ZERO

# Character Body Attributes
@onready var path_to_wpn: Node2D = $Torso/Weapon
@onready var front_arm: Node2D = $Torso/FrontArm
@onready var back_arm: Node2D = $BackArm
@onready var hand_pos: Vector2 = back_arm.position

# Front Arm Pointing Toward Mouse
var wpn_pointing_direction: Vector2 = Vector2.ZERO

# Weapon Properties
var current_recoil: float = 0.0    # Current Recoil
var max_recoil: float = 10.0       # Max Recoil
var recoil_increment: float = 0.0  # Increment Recoil

func update_animation(animation_name):
     $AnimationPlayer.play(animation_name)

func update_facing_direction(direction):
     if direction.x > 0:
          $".".scale = Vector2(1, 1)
     elif direction.x < 0:
          $".".scale = Vector2(-1, 1)

# Received from Character a Command to use Equipped Weapon
func player_wpn_action(action):
     # Front Arm Pointing Direction
     wpn_pointing_direction = Vector2(cos(front_arm.rotation), sin(front_arm.rotation))*($".".scale)
     
     # If Player is Shooting the Weapon
     if action == "shoot":
          if path_to_wpn.has_method("shoot"):
               path_to_wpn.shoot(wpn_pointing_direction)
     # If Player is NOT Shooting the Weapon
     elif action == "stop shoot":
          if path_to_wpn.has_method("stop_shoot"):
               path_to_wpn.stop_shoot()
     # If Player is Reloading the Weapon
     elif action == "reload":
          $AnimationArms.play("Reload")
          # Check that the Weapon Has Method Shoot
          if path_to_wpn.has_method("reload"):
               # Call the Reload Method
               path_to_wpn.reload()
#               $Torso/Magazine.z_index = -1

# Arm Recoil Animation
func arm_recoil():
     var recoil_tween = create_tween()
#     var tween_up_time := 0.1
#     var tween_down_time := 0.2
     recoil_tween.tween_property(front_arm, "position", front_arm.position + Vector2(-5,0), 0.02)
     recoil_tween.tween_property(front_arm, "position", front_arm.position - Vector2(-5,0), 0.02)

# On Animation Finished
#func _on_animation_arms_animation_finished(anim_name):
#     if anim_name == "Reload":
#          $Torso/Magazine.z_index = 0
