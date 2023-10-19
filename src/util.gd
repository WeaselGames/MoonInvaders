extends Node

func find_fastest_yaw(angle_diff: float) -> float:
	if angle_diff > 0 && angle_diff < PI:
		return 1
	elif angle_diff > 0 && angle_diff > PI:
		return -1
	elif angle_diff < 0 && angle_diff > -PI:
		return -1
	elif angle_diff < 0 && angle_diff < -PI:
		return 1
	else:
		return 0