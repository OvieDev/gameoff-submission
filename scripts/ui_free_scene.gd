extends Control
class_name UIFreeScene

func _ready():
	if get_tree().get_root().has_node("/root/Gui"):
		get_tree().get_root().call_deferred("remove_child",get_tree().get_root().get_node("/root/PauseMenu"))
		get_tree().get_root().call_deferred("remove_child", get_tree().get_root().get_node("/root/Gui"))
	
