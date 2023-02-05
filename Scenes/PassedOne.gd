extends Control


func _ready():
	pass


func _on_MainMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_NextLevelButton_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")
