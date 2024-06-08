extends Node2D

class_name Weapon

signal open_fire(muzzle_pos, muzzle_drctn)

var can_shoot: bool = true

func _ready():
     # Connect the Weapon Signal to a Global Data Bus
     connect("open_fire", EventBus.send_signal_to_parent)

func shoot(wpn_pointing_direction):
     # Get Muzzle Objects
     var muzzle_markers = $BulletStartPosition.get_children()
     # Select a Random Muzzle Object
     var selected_muzzle = muzzle_markers[randi()%muzzle_markers.size()]
     
     # Disable Shoot
     can_shoot = false
     # Restart Timer
     $ShootTimer.start()
     
     # Emit the Open Fire Signal [Figure This Part Out]
     open_fire.emit(selected_muzzle.global_position, wpn_pointing_direction)
     print("Yes")
     
# On Shoot Timer Timeout
func _on_shoot_timer_timeout():
     # Enable Shoot
     can_shoot = true
