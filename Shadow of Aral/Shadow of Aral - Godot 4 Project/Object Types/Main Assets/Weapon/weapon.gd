class_name weapon extends Node2D

# Weapon Signals
signal open_fire(muzzle_pos, muzzle_drctn)
signal recoil()     # [Best to Use a Signal Instead of Using get_parent().get_child(4)]
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
var max_recoil: float = 5.0        # Max Recoil
var recoil_increment: float = 0.0  # Increment Recoil

# Weapon Attributes
@onready var timer_fired: Timer = $FiredTimer
@onready var timer_reload: Timer = $ReloadTimer
@onready var wpn_img: Sprite2D = $WeaponImage
@onready var muzzle_markers := $WeaponImage/BulletStartPosition.get_children()
@onready var selected_muzzle := muzzle_markers[randi()%muzzle_markers.size()]

# How to Reference the First Parent this Object is Attached too which is Remote2D [Hardcoded]
@onready var front_arm := get_parent().get_child(4)

# Object Ready
func _ready():
     # Connect the Weapon Signal to a Global Data Bus
     connect("open_fire", EventBus.wpn_fired)
     connect("updt_ammo", EventBus.update_ui)
     # Set Fired Timer and Reload Timer
     timer_fired.wait_time = fire_rate
     timer_reload.wait_time = reload_time

# Weapon Shoot
func shoot(wpn_pointing_direction):
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
          Globals.bullets = ammo_left
               # Restart Timer
          timer_fired.start()
               # Emit the Open Fire Signal
          open_fire.emit(selected_muzzle.global_position, wpn_pointing_direction)
          updt_ammo.emit()
               
# Weapon Reload
func reload():
     reloading = true
     timer_reload.start()

# Weapon Recoil Animation [Hardcoded the Arm Recoil]
func wpn_arm_recoil(wpn_dir):
     var recoil_tween = create_tween()
     var tween_up_time := 0.01
     var tween_down_time := 0.2
     var random_recoil_rotation = randf_range(deg_to_rad(-5), deg_to_rad(0))
     # Start the Weapon Recoil
     recoil_tween.tween_property(wpn_dir, "position", Vector2(-5,5), tween_up_time)
     recoil_tween.tween_property(wpn_dir, "rotation", random_recoil_rotation, tween_up_time)
     # Arm Recoil
     recoil_tween.tween_property(front_arm, "position", front_arm.position + Vector2(-5,0), 0.02)
     recoil_tween.tween_property(front_arm, "position", front_arm.position - Vector2(-5,0), 0.02)
     # Weapon Retrun to Rest 
     recoil_tween.tween_property(wpn_dir, "position", Vector2(0,0), tween_down_time)
     recoil_tween.tween_property(wpn_dir, "rotation", 0, tween_down_time)


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
