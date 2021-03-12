class_name Envelope

var attack = 0.5 # how many seconds until max_level is reached
var release = 0.5 # how many seconds until 0 is reached
var max_level = 1.0 # the maximum value the envelope will return
#var stage_duration = 0.0 # how long the envelope has been in the current stage (attack/sustain/release)
var attack_gain
var release_gain
var level = 0.0
var stage = Stage.IDLE
enum Stage {IDLE, ATTACK, SUSTAIN, RELEASE}

func _init(attack_time = 0.5, release_time = 0.5):
	self.attack = attack_time
	self.release = release_time
	if attack <= 0.0:
		attack_gain = max_level
	else:
		attack_gain = max_level / attack
	if release <= 0.0:
		release_gain = -max_level
	else:
		release_gain = -max_level / release

func start_sending():
	stage = Stage.ATTACK

func stop_sending():
	stage = Stage.RELEASE

# returns a value between 0 and 1
func get_level(delta):
	if stage == Stage.ATTACK:
		level += attack_gain
		if level >= max_level:
			level = max_level
			stage = Stage.SUSTAIN
	elif stage == Stage.RELEASE:
		level += release_gain
		if level <= 0.0:
			level = 0.0
			stage = Stage.IDLE
	return level

func has_level():
	return stage != Stage.IDLE
