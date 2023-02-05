extends Node

var words = null

var special_chars = [
	".",
	"!",
	"?"
]


func get_prompt():
	if words == null:
		words = FileReader.read("res://Misc/Languages/25k.txt")

	var word_index = randi() % words.size()
	var punc_index = randi() % special_chars.size()
	
	var word = words[word_index].substr(0,1).to_upper() + words[word_index].substr(1)
	var punc = special_chars[punc_index]
	
	return word + punc
