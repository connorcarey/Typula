extends Node2D

# Dracula theme colors.
export (Color) var WHITE = Color("#f8f8f2")
export (Color) var CYAN = Color("#8be9fd")
export (Color) var GREEN = Color("#50fa7b")
export (Color) var ORANGE = Color("#ffb86c")
export (Color) var PINK = Color("#ff79c6")
export (Color) var PURPLE = Color("#bd93f9")
export (Color) var RED = Color("#ff5555")
export (Color) var YELLOW = Color("#f1fa8c")

export (float) var speed = 1 # Speed at which the words are moving toward the left.

onready var prompt = $RichTextLabel # Node responsible for housing the text.
onready var text = prompt.text # Text itself ^

var difficulty = 1
var multiplier


# Once ready, set the prompt to a random english word.
func _ready():
	GlobalSignals.connect("difficulty_increased", self, "increase_difficulty")
	var level = PlayerVariables.level
	if level == 1:
		text = English200.get_prompt()
		speed = 1
	elif level == 2:
		text = English2k.get_prompt()
		speed = 1.5
	elif level == 3:
		text = English25k.get_prompt()
		speed = 2
	else:
		text = English450k.get_prompt()
		speed = 2.5
		
	prompt.parse_bbcode("[center]" + text + "[/center]")

# When the difficulty increases, the words get more complex and faster.
func increase_difficulty(new_difficulty: int):
	difficulty = new_difficulty
	speed = clamp(speed + (new_difficulty * 0.125), speed, 5)

# Setter method for setting the difficulty of the game.
func set_difficulty(difficulty: int):
	increase_difficulty(difficulty)


# Slide the sprite toward the left of the screen.
func _physics_process(delta):
	global_position.x -= speed

# Getter method for the prompt's text.
func get_prompt():
	return text

# Set the color of the text as the player progresses / types the word.
func set_next_char(index: int):
	var cyan = get_bbcode_color_tag(CYAN) + text.substr(index, 1) + "[/color]"
	var purple = get_bbcode_color_tag(PURPLE) + text.substr(0, index) + "[/color]"
	var white = ""
	if index != text.length():
		white = get_bbcode_color_tag(WHITE) + text.substr(index + 1, text.length() - index + 1) + "[/color]"
	prompt.parse_bbcode("[center]" + purple + cyan + white + "[/center]")

# Helper method for surrounding the text in bb color preset.
func get_bbcode_color_tag(color : Color):
	return "[color=#" + color.to_html(false) + "]"
