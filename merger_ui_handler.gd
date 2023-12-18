extends Object

var main_ui : CanvasLayer

var i_input_text
var i_input_accept
var i_input_removeall
var o_input_text
var o_input_accept
var o_output_label
var directory_list
var finalize_button
var use_folder_checkbox
var resize_checkbox
var resize_text
var resize_value

var input_directories : Array

func get_nodes():
	i_input_text = main_ui.get_node("tabs/ImageConverter/Input/i_directory_input")
	i_input_accept = main_ui.get_node("tabs/ImageConverter/Input/i_directory_accept")
	i_input_removeall = main_ui.get_node("tabs/ImageConverter/Input/i_directory_removeall")

	o_input_text = main_ui.get_node("tabs/ImageConverter/Output/o_directory_input")
	o_input_accept = main_ui.get_node("tabs/ImageConverter/Output/o_directory_set")
	o_output_label = main_ui.get_node("tabs/ImageConverter/Output/o_directory_info/o_directory_label")

	directory_list = main_ui.get_node("tabs/ImageConverter/Input/i_directory_list/directory_list_container")

	finalize_button = main_ui.get_node("tabs/ImageConverter/Finalize/finalize_button")

	use_folder_checkbox = main_ui.get_node("tabs/ImageConverter/Settings/folder_name")

	resize_checkbox = main_ui.get_node("tabs/ImageConverter/Settings/Resize/size_checkbox")
	resize_text = main_ui.get_node("tabs/ImageConverter/Settings/Resize/size_input")
	resize_value = main_ui.get_node("tabs/ImageConverter/Settings/Resize/size_value")

func connect_accept_inputs():
	pass

func is_valid_input(_text : String):
	if _text == "" or _text.is_absolute_path() == false:
		return false
	return true

func add_input_directory():
	var input_text : String = i_input_text.text
	var lines : Array = input_text.split("\n", false)
	print(lines)
#	return
	for line in lines:
		if is_valid_input(line) == false:
			print("bad!")
			return
		print("good!")
		directory_list.add_child(DirectoryItem.new(line))

func set_output_directory():
	var input_text : String = o_input_text.text
	if is_valid_input(input_text) == false:
		print("bad!")
		return
	print("good!")
	o_output_label.text = input_text
	
func remove_all_input_directories():
	for dir in get_input_directories():
		dir.queue_free()

func get_input_directories_string():
	var directories : Array = []
	for dir in get_input_directories():
		directories.append(dir.get_directory())
	return directories

func get_input_directories():
	return directory_list.get_children()

func get_output_directory():
	return o_output_label.text

func input_remove_button():
	remove_all_input_directories()

func input_accept_button():
	add_input_directory()

func output_accept_button():
	set_output_directory()

func finalize_pressed():
	print("finalize pressed!")
	ImageUtil.handle_image_merging(get_input_directories_string(), get_output_directory())

func set_size_checkmark(state):
	print("use resize toggled: %s" % state)
	ImageUtil.use_resize = state

func set_folder_name_checkmark(state):
	print("use folder toggled: %s" % state)
	ImageUtil.use_folder_name = state

func set_resize_input(text : String):
	var num = text.to_int()
	if num < 1 or num > 100 or num == 0:
		print("invalid resize scale")
		return
	resize_value.text = "Current Size Ratio: %s%%" % text
	ImageUtil.resize_ratio = num * 0.01

func connect_buttons():
	i_input_accept.connect("pressed", input_accept_button)
	o_input_accept.connect("pressed", output_accept_button)
	i_input_removeall.connect("pressed", input_remove_button)
	finalize_button.connect("pressed", finalize_pressed)

	use_folder_checkbox.connect("toggled", set_folder_name_checkmark)
	resize_checkbox.connect("toggled", set_size_checkmark)
	resize_text.connect("text_submitted", set_resize_input)

# Called when the node enters the scene tree for the first time.
func initialize(_main_ui : Node):
	self.main_ui = _main_ui
	get_nodes()
	connect_buttons()
	return self
