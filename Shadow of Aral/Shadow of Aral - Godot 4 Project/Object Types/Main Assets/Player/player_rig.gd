extends Node2D

# Player Body Properties
var stock_grip_pos: Vector2 = Vector2.ZERO

# Player Body Attributes
@onready var path_to_wpn: Node2D = $Torso/Weapon
#@onready var grip_path = path_to_wpn.get_child(2)
@onready var front_arm: Node2D = $Torso/FrontArm
@onready var back_arm: Node2D = $Torso/BackArm
@onready var hand_pos: Vector2 = back_arm.position

# Front Arm Pointing Toward Mouse
var wpn_pointing_direction: Vector2 = Vector2.ZERO

# Weapon Properties
var current_recoil: float = 0.0    # Current Recoil
var max_recoil: float = 10.0       # Max Recoil
var recoil_increment: float = 0.0  # Increment Recoil

     
func _process(_delta):
     # Set rotation of the arms to mouse position
     front_arm.look_at(get_global_mouse_position())
#     pass
     
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
     wpn_pointing_direction = Vector2(cos(front_arm.rotation), sin(front_arm.rotation))*($".".scale)
     
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

# Arm Recoil Animation
#func wpn_arm_recoil(wpn_dir):
#     var tween = create_tween()
#     var tween_up_time := 0.1
#     var tween_down_time := 0.2
#     var random_recoil_rotation = randf_range(deg_to_rad(max_recoil), deg_to_rad(5))
#     tween.tween_property(front_arm, "rotation", wpn_dir, 0.1)

# On Animation Finished
func _on_animation_arms_animation_finished(anim_name):
     if anim_name == "Reload":
          $Torso/Magazine.z_index = 1

