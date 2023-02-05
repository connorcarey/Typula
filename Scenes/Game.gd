extends Node2D

var Word = preload("res://Scenes/Word.tscn") # Class responsible for displaying words.

onready var word_container = $Words # Contains all the words that are spawned in.
onready var spawn_container = $SpawnContainer # Contains all the spawn points for the words.

onready var spawn_timer = $SpawnTimer # Timer for spawning words.
onready var difficulty_timer = $DifficultyTimer # Timer that measures how fast and complext the words are.
onready var game_timer = $GameTimer # Timer that ends the game after sixty seconds.

onready var typed_count = $UI/VBoxContainer/CenterContainer/TopRow/WordsTypedCountLabel # The label pointing to the amount of sucessful typed words.
onready var difficulty_count = $UI/VBoxContainer/BottomRow/DifficultyCountLabel # The label pointing to the level of difficulty.
onready var game_over_screen = $UI/GameOverScreen # The screen that shows up when the game reaches the end (word reaches the wall).

var curr_word = null # Current word the player is typing.
var curr_index = -1 # The index the player is at when typing the word.

var difficulty = 0 # Difficulty dictates the speed and complexity of a word.
var words_typed = 0 # The amount of words the player has typed in a session.\

# Runs the game.
func _ready():
	$UI/GameOverScreen.hide()
	start_game()

# Gets the next word at the top of the spawn_container hierarchy.
# Basically, the left-most word that contains the initial character inputted is selected.
func get_next_word(letter: String):
	for word in word_container.get_children():
		var prompt = word.get_prompt()
		var next_letter = prompt.substr(0,1)
		if next_letter == letter:
			curr_word = word
			curr_index = 1
			curr_word.set_next_char(1)
			return

# Godot method that is responsible for handling unhandled input specified in project settings.
func _unhandled_input(event: InputEvent):
	if event is InputEventKey and event.is_pressed():
		event = event as InputEventKey
		var letter = PoolByteArray([event.unicode]).get_string_from_utf8()
		
		if curr_word == null: ## If we are not currently targeting a word.
			get_next_word(letter)
		else:
			var prompt = curr_word.get_prompt() # The word that we are trying to spell
			var next_letter = prompt.substr(curr_index, 1) # The letter we need to hit
			if next_letter == letter: # Check if we hit the letter.
				curr_index += 1
				curr_word.set_next_char(curr_index)
				if curr_index == prompt.length(): # Edge case for end of words, target the next word.
					curr_index = -1
					curr_word.queue_free()
					curr_word = null
					words_typed += 1
					typed_count.text = str(words_typed)

# Creates a word everytime the timer runs out.
# The method fires automatically.
func _on_SpawnTimer_timeout():
	create_word()

# Creates a word instance for the player to type.
func create_word():
	var word_instance = Word.instance()
	var spawns = spawn_container.get_children()
	var pos = randi() % spawns.size()
	
	word_instance.global_position = spawns[pos].global_position
	word_container.add_child(word_instance)
	word_instance.set_difficulty(difficulty)

# When the difficulty timer runs out, the difficulty increases.
func _on_DifficultyTimer_timeout():
	difficulty += 1
	GlobalSignals.emit_signal("difficulty_increased", difficulty)
	spawn_timer.wait_time = clamp(spawn_timer.wait_time-0.2, 1, spawn_timer.wait_time)
	difficulty_count.text = str(difficulty)

# When the bats / words hit the left edge of the screen, the game will end.
func _on_EndArea_body_entered(body):
	game_over()

# Completely hides and stops every node in the tree then prompts the retry node.
func game_over():
	game_over_screen.show()
	spawn_timer.stop()
	game_timer.stop()
	difficulty_timer.stop()
	difficulty_count.hide()
	typed_count.hide()
	$UI/VBoxContainer/CenterContainer/TopRow/WordsTypedLabel.hide()
	$UI/VBoxContainer/BottomRow/DifficultyLabel.hide()
	curr_word = null
	curr_index = -1
	for word in word_container.get_children():
		word.queue_free()

# Sets all the values to their initial position then begins the game.
func start_game():
	game_over_screen.hide()
	difficulty = 0
	words_typed = 0
	difficulty_count.text = "0"
	typed_count.text = "0"
	difficulty_count.show()
	typed_count.show()
	$UI/VBoxContainer/CenterContainer/TopRow/WordsTypedLabel.show()
	$UI/VBoxContainer/BottomRow/DifficultyLabel.show()
	spawn_timer.wait_time = 3
	difficulty_timer.wait_time = 15
	game_timer.wait_time = 60
	randomize()
	spawn_timer.start()
	difficulty_timer.start()
	game_timer.start()
	
	create_word()

# Starts the game when the restart button is clicked on the retry page.
func _on_RestartButton_pressed():
	start_game()

# When the timer is through with its 60 seconds it moves on to the next level.
func _on_GameTimer_timeout():
	var level = PlayerVariables.level
	if level == 1:
		get_tree().change_scene("res://Scenes/PassedOne.tscn")
	elif level == 2:
		get_tree().change_scene("res://Scenes/PassedTwo.tscn")
	elif level == 3:
		get_tree().change_scene("res://Scenes/PassedThree.tscn")
	else:
		get_tree().change_scene("res://Scenes/PassedFinal.tscn")
	PlayerVariables.level += 1
	PlayerVariables.total_typed += words_typed

# Button on death screen that leads to main menu.
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
