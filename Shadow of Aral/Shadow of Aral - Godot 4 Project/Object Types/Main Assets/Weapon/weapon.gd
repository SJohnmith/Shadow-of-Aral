class_name weapon extends Node2D

# Weapon Signals
signal open_fire(muzzle_pos, muzzle_drctn)
signal updt_ammo()

# Weapon Properties
var wpn_name: String = "AK-47"     # Object Name
var wpn_type: String = "Multi"     # Single or Multi Shot Gun
var wpn_damage: float = 10.0       # Bullet Damage
var fire_rate: float = 0.1         # Seconds per Bullet
var reload_time: float = 2.0       # Reload Animation
var reload_bullets: int = 30       # How Many Bullets to Add
var ammo_capacity: int = 30        # Limit on Bullets to Add
var ammo_left: int = 30            # Current Bullet Count
var fire_range: float = 500.0      # Bullet Travel Range
var fired: bool = false            # Gun Has Been Fired
var reloading: bool = false        # Gun Is Reloading

var current_recoil: float = 0.0    # Current Recoil
var max_recoil: float = 10.0       # Max Recoil
var recoil_increment: float = 0.0  # Increment Recoil

# Weapon Attributes
var fcn_shoot_called: bool = false
@onready var timer_fired: Timer = $FiredTimer
@onready var timer_reload: Timer = $ReloadTimer
@onready var wpn_img: Sprite2D = $WeaponImage
@onready var muzzle_markers := $WeaponImage/BulletStartPosition.get_children()
@onready var selected_muzzle := muzzle_markers[randi()%muzzle_markers.size()]

# Parent Attributes
@onready var front_arm := get_parent().get_parent()

# Object Ready
func _ready():
     # Connect the Weapon Signal to a Global Data Bus
     connect("open_fire", EventBus.wpn_fired)
     connect("updt_ammo", EventBus.update_ui)
     # Set Fired Timer and Reload Timer
     timer_fired.wait_time = fire_rate
     timer_reload.wait_time = reload_time

func _process(_delta):
#     print(fcn_shoot_called)
     # This Will Work Good for Player But Not for General Purpose Use
#     if not Input.is_action_pressed("Left Click"):
     # Works but there has to be a better way of doing this
     # If Weapon is Not being Fired Return Recoil to Zero
     if not fcn_shoot_called:
          recoil_increment = max_recoil * 0.1
          current_recoil = clamp(current_recoil - recoil_increment, 0.0, max_recoil)
     
func stop_shoot():
     fcn_shoot_called = false
     
# Weapon Shoot
func shoot(wpn_pointing_direction):
     fcn_shoot_called = true
     
     # Select a Random Muzzle Object
     selected_muzzle = muzzle_markers[randi()%muzzle_markers.size()]
     # Check Not Gun Fired, Has Ammo, and Not Reloading
     if !fired and ammo_left > 0 and !reloading:
          # Gun Fired
          fired = true
          # Gun Recoil
          wpn_arm_recoil(wpn_img)
          # Subtract Ammo
          ammo_left -= 1
          Globals.bullets = ammo_left   # [Hardcoded and Not Unique to Player when Enemy Uses Should Create a Conflict]
          # Restart Timer
          timer_fired.start()
          # Emit the Open Fire Signal
          open_fire.emit(selected_muzzle.global_position, recoil(wpn_pointing_direction))
          updt_ammo.emit()
               
# Weapon Reload
func reload():
     if !reloading:
          reloading = true
          timer_reload.start()

# Weapon Recoil Bullets
func recoil(wpn_pointing_direction):
     recoil_increment = max_recoil * 0.1
     current_recoil = clamp(current_recoil + recoil_increment, 0, max_recoil)
     
     var recoil_deg_max = current_recoil * 0.5
     var recoil_rad_act = deg_to_rad(randf_range(-recoil_deg_max, recoil_deg_max))
     var act_bullet_dir = wpn_pointing_direction.rotated(recoil_rad_act)
     
     return act_bullet_dir

# Weapon Recoil Animation [Hardcoded the Arm Recoil]
func wpn_arm_recoil(wpn_dir):
     var recoil_tween := create_tween()
     var tween_up_time := 0.01
     var tween_down_time := 0.2
     var random_recoil_rotation = randf_range(deg_to_rad(-5), deg_to_rad(0))
     # Start the Weapon Recoil
     recoil_tween.tween_property(wpn_dir, "position", Vector2(-5,5), tween_up_time)
     recoil_tween.tween_property(wpn_dir, "rotation", random_recoil_rotation, tween_up_time)
     
     # Weapon Retrun to Rest 
     recoil_tween.tween_property(wpn_dir, "position", Vector2(0,0), tween_down_time)
     recoil_tween.tween_property(wpn_dir, "rotation", 0, tween_down_time)
#     if recoil_tween:
#          recoil_tween.kill()
     # Arm Recoil
     if front_arm.has_method("arm_recoil"):
          front_arm.arm_recoil()

# On Fired Timer Timeout
func _on_fired_timer_timeout():
     # Enable Shoot
     fired = false  

# On Reload Timer Timeout
func _on_reload_timer_timeout():
     # Reload Finished
     reloading = false
     # Reload the Weapon
     ammo_left = ammo_capacity
     Globals.bullets = ammo_left

     updt_ammo.emit()
