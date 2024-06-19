extends Node

signal wpn_shoot_bullets(muzzle_pos, muzzle_drctn)
signal ui_update()


func wpn_fired(muzzle_pos, muzzle_drctn):
	 wpn_shoot_bullets.emit(muzzle_pos, muzzle_drctn)

func update_ui():
	 ui_update.emit()
