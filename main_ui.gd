extends CanvasLayer

var MERGER_HANDLER_CLASS = preload("res://merger_ui_handler.gd")
var MERGER_HANDLER

func init_merger_handler():
	self.MERGER_HANDLER = MERGER_HANDLER_CLASS.new().initialize(self)

func _ready():
	init_merger_handler()
