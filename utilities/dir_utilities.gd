class_name DirUtilities



static func get_files_by_extension(base_dir_name, extension, recursive=false):
	var files = []
	var base_dir = DirAccess.open(base_dir_name)
	for file in base_dir.get_files():
		if file.ends_with(".tscn"):
			files.append(base_dir_name + file)
	if recursive:
		for sub_dir in base_dir.get_directories():
			files.append_array(get_files_by_extension(base_dir_name + sub_dir + "/", extension))
	return files
