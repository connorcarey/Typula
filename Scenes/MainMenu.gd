extends Control


func _ready():
	$Information.hide()


func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_LeaderboardButton_pressed():
	pass # Replace with function body.


func _on_HTPButton_pressed():
	$Information.show()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_Button_pressed():
	$Information.hide()


func _on_Multiplayer_pressed():
	pass # Replace with function body.
