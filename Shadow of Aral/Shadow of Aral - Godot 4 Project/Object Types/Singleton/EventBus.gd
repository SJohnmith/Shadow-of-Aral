extends Node

# Signals to Process
signal wpn_shoot_bullets(muzzle_pos, muzzle_drctn)
signal ui_update()

# Main Events to Handle
func wpn_fired(muzzle_pos, muzzle_drctn):
      wpn_shoot_bullets.emit(muzzle_pos, muzzle_drctn)

# Player UI
func update_ui():
      ui_update.emit()
