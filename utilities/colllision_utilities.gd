class_name CollisionUtilities

const LEVEL_FLAG  = 0b00000000000000000000000000000001
const PLAYER_FLAG = 0b00000000000000000000000000000010
const ENEMY_FLAG  = 0b00000000000000000000000000000100
const DAMAGE_FLAG = 0b00000000000000000000000000001000
const AOE_FLAG    = 0b00000000000000000000000000010000


static func set_flag(mask, flag):
	return mask | flag


static func clear_flag(mask, flag):
	return mask & ~flag


static func toggle_flag(mask, flag):
	return mask ^ flag
