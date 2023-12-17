class_name DirectoryItem extends HBoxContainer

signal remove_clicked(self_ref : Node)
var label
var remove_button

func _init(_text : String):
	label = Label.new()
	label.text = _text
	remove_button = Button.new()
	remove_button.text = "Remove Directory"
	self.size_flags_horizontal
	self.add_child(label)
	self.add_child(remove_button)
	remove_button.connect("pressed", _on_remove_clicked)
#	print("elephant")

func get_directory() -> String:
	return label.text

func _on_remove_clicked():
	print("el")
	emit_signal("remove_clicked", self)
	self.get_parent().remove_child(self)
	self.queue_free()
	pass
