extends CanvasLayer

#C:\Users\John\Desktop\npc\hand\attack
#C:\Users\John\Desktop\output

#@onready var input_dialog = $tabs/ImageConverter/Input/InputDirectoryDialog
#@onready var output_dialog = $tabs/ImageConverter/Output/OutputDirectoryDialog

@onready var i_input_text = $tabs/ImageConverter/Input/i_directory_input
@onready var i_input_accept = $tabs/ImageConverter/Input/i_directory_accept
@onready var i_input_removeall = $tabs/ImageConverter/Input/i_directory_removeall

@onready var o_input_text = $tabs/ImageConverter/Output/o_directory_input
@onready var o_input_accept = $tabs/ImageConverter/Output/o_directory_set
@onready var o_output_label = $tabs/ImageConverter/Output/o_directory_info/o_directory_label

@onready var directory_list = $tabs/ImageConverter/Input/i_directory_list/directory_list_container

@onready var finalize_button = $tabs/ImageConverter/Finalize/finalize_button

var input_directories : Array

func get_window_vec():
	return get_viewport().size

func connect_accept_inputs():
	pass

func is_valid_input(_text : String):
	if _text == "" or _text.is_absolute_path() == false:
		return false
	return true

func add_input_directory():
	var input_text : String = i_input_text.text
	if is_valid_input(input_text) == false:
		print("bad!")
		return
	print("good!")
	directory_list.add_child(DirectoryItem.new(input_text))

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

func connect_buttons():
	i_input_accept.connect("pressed", input_accept_button)
	o_input_accept.connect("pressed", output_accept_button)
	i_input_removeall.connect("pressed", input_remove_button)
	finalize_button.connect("pressed", finalize_pressed)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
