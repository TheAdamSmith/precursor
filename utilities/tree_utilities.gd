class_name TreeUtilities


static func get_character_body_2d_parent(child):
	var curr_node = child
	while curr_node:
		if curr_node is CharacterBody2D:
			return curr_node
		curr_node = curr_node.get_parent()
	return curr_node


static func get_all_children(node : Node):
	var arr = [node]
	for child in node.get_children():
		arr.append_array(get_all_children(child))
	return arr


static func reparent_bullets(old_parent : Node, new_parent : Node):
	for child in get_all_children(old_parent):
		if child is Bullet:
			child.reparent(new_parent, true)
