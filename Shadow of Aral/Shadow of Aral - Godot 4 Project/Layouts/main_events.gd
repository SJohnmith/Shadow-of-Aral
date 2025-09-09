# Global Event
extends Node2D

# List of Objects to Reference
var bullet_scene: PackedScene = preload("res://Object Types/Main Assets/Bullet/bullet.tscn")
var player_scene: PackedScene = preload("res://Object Types/Main Assets/Player/player.tscn")
var player_exists: bool = true

# Connect
func _ready():
     EventBus.wpn_shoot_bullets.connect(_on_player_open_fire)
     EventBus.ui_update.connect(_update_ui_elements)

# Respawn Player
func _process(_delta):
     if !player_exists:
          print("Run")
          var spwn_player = player_scene.instantiate()
          $".".add_child(spwn_player)
          spwn_player.position = $SpawnPoint.position
          
# Player Fires Spawn Bullets
func _on_player_open_fire(muzzle_pos, muzzle_drctn):
     var bullet_instance = bullet_scene.instantiate() as Area2D
     $Projectiles.add_child(bullet_instance)
     bullet_instance.position = muzzle_pos
     bullet_instance.rotation = muzzle_drctn.angle()
     bullet_instance.direction = muzzle_drctn

# Update UI Elements
func _update_ui_elements():
     # This is Good for Testing
     $UI.update_bullet_text()


