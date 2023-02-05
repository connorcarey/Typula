extends Node

func read(path: String):
	print("bruh")
	var array = []
	var file = File.new()
	var err = file.open(path, File.READ)
	
	if err != OK:
		print("Unable to read...", path)
		return
	
	while !file.eof_reached():
		var line = file.get_line()
		#print(line)
		array.append(line.substr(line.find("\"") + 1, line.find_last("\"") - line.find("\"") - 1))
	
	file.close()
	return array
