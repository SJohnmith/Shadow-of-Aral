class_name Weapon extends Node2D

# Weapon Signals
signal open_fire(muzzle_pos, muzzle_drctn)

# Weapon Properties
var wpn_name: String = "AK-47"     # Object Name
var wpn_type: String = "Multi"     # Single or Multi Shot Gun
var wpn_damage: float = 10.0       # Bullet Damage
var fire_rate: float = 0.1         # Seconds per Bullet
var reload_time: float = 4.0       # Reload Animation
var reload_bullets: int = 30       # How Much Bullets to Add
var ammo_capacity: int = 30        # Limit on Bullets to Add
var ammo_left: int = 30            # Current Bullet Count
var fire_range: float = 500.0      # Bullet Travel Range
var fired: bool = true             # Gun Has Been Fired
var reloading: bool = true         # Gun Is Reloading

# Object Ready
func _ready():
     # Connect the Weapon Signal to a Global Data Bus
     connect("open_fire", EventBus.send_signal_to_parent)
     
     # Set the Shooter Time to Fire Rate
     $ShootTimer.wait_time = fire_rate

# Weapon Shoot
func shoot(wpn_pointing_direction):
     # Get Muzzle Objects
     var muzzle_markers = $BulletStartPosition.get_children()
     # Select a Random Muzzle Object
     var selected_muzzle = muzzle_markers[randi()%muzzle_markers.size()]
     
     # Check that the Gun Can Shoot
     if fired:
          # Disable Shoot
          fired = false
          # Restart Timer
          $ShootTimer.start()
          # Emit the Open Fire Signal [Figure This Part Out]
          open_fire.emit(selected_muzzle.global_position, wpn_pointing_direction)

# On Shoot Timer Timeout
func _on_shoot_timer_timeout():
     # Enable Shoot
     fired = true
