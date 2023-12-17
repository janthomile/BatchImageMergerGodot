extends Node

var valid_extensions = ["png", "jpg"]

func get_directory(_string : String):
	pass

func is_valid_image(_path : String):
	if _path.is_valid_filename() and valid_extensions.has(_path.get_extension()):
		return true
	return false

func get_valid_dir(_dir : String, _file : String):
	var valid = _dir + "/" + _file
	valid = valid.replace("\\", "/")
#	valid = valid.validate_filename()
	return valid

func get_aggregate_dimensions(images : Array[Image]):
	var dimensions : Vector2i = Vector2i.ZERO
	for image in images:
		var size = image.get_size()
		if size.y > dimensions.y:
			dimensions.y = size.y
		dimensions.x += size.x
	return dimensions

func merge_images(images : Array[Image]) -> Image:
	if images.is_empty() or images.size() < 2:
		return null
	var dimensions : Vector2i = get_aggregate_dimensions(images)
	var base_image : Image = Image.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	var current_offset : Vector2i = Vector2i.ZERO
	base_image.resize(dimensions.x, dimensions.y, 0)
	for i in range(0, images.size()):
		var img = images[i]
		base_image.blend_rect(img, Rect2i(Vector2i.ZERO, img.get_size()), current_offset)
		current_offset.x += img.get_size().x
	return base_image

func save_merged(image : Image, filepath):
	var current_filepath = filepath
	while FileAccess.file_exists(current_filepath + ".png"):
		current_filepath += "-2"
#	if FileAccess.file_exists(filepath):
#		return false
	print("saving merged to: %s" % filepath)
	var save_status = image.save_png(current_filepath + ".png")
	print("saving ended with error code: %s" % save_status)

func handle_image_merging(directories : Array, output : String):
	print("start image merging")
	if directories.is_empty() or output.is_empty() or output.is_absolute_path() == false:
		print("something's wrong...")
		return
	var output_directory = DirAccess.open(output)
	if output_directory == null:
		print("Invalid output directory!")
		return
	print("Valid output directory!")
#	return
	var directory_index : int = 0
	for dir in directories:
		var directory = DirAccess.open(dir)
		if directory == null:
			print("Invalid input directory: %s" % directory)
			continue
		var files = directory.get_files()
		var images : Array[Image] = []
		for file in files:
			var valid_dir = get_valid_dir(dir,file)
			if !is_valid_image(valid_dir.get_file()):
				print("Not valid image: %s" % valid_dir)
				continue
			var image = Image.load_from_file(valid_dir)
			if image == null:
				print("bad image: %s" % valid_dir)
				continue
			images.append(image)
		var new_image = merge_images(images)
		if new_image == null:
			print("Error merging")
			return
		save_merged(new_image, get_valid_dir(output, "merge" + str(directory_index)))
		directory_index += 1
	pass
