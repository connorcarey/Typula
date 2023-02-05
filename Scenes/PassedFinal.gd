extends Control


onready var total_word_label = $CenterContainer/VBoxContainer/HBoxContainer/TotalWordLabel

func _ready():
	total_word_label.text = str(PlayerVariables.total_typed)


func _on_MainMenu_pressed():
	PlayerVariables.level = 1
	PlayerVariables.total_typed = 0
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
