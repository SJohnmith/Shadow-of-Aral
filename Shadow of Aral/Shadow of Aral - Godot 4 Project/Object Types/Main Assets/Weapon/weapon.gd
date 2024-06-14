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

# Weapon Attributes
@onready var timer_fired: Timer = $FiredTimer
@onready var timer_reload: Timer = $ReloadTimer
var muzzle_markers
var selected_muzzle

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
     # Get Muzzle Objects
     muzzle_markers = $BulletStartPosition.get_children()
     # Select a Random Muzzle Object
     selected_muzzle = muzzle_markers[randi()%muzzle_markers.size()]
     
     # Check Not Gun Fired, Has Ammo, and Not Reloading
     if !fired and ammo_left > 0 and !reloading:
          # Gun Fired
          fired = true
          # Subtract Ammo
          ammo_left -= 1
          Globals.bullets = ammo_left
          # Restart Timer
          timer_fired.start()
          # Emit the Open Fire Signal [Figure This Part Out]
          open_fire.emit(selected_muzzle.global_position, wpn_pointing_direction)
          updt_ammo.emit()
          
# Weapon Reload
func reload():
     reloading = true
     timer_reload.start()
     
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
