extends Node

remote var all_graphs = {}
# TODO handle player position in its own graph

func getLocalPlayerNode():
	var player_path = '/root/mainArena/' + str(get_tree().get_network_unique_id())
	return get_node(player_path)

func attachNewGraph(graph_id):
	all_graphs[graph_id] = {}

func removeGraph(graph_id):
	if graph_id in all_graphs:
		all_graphs.erase(graph_id)

func addNode(graph_id, source, dest):
	var plants_graph = all_graphs[graph_id]
	if source in plants_graph:
		plants_graph[source][dest] = dest
	else:
		plants_graph[source] = { dest: dest }

func removeNode(graph_id, node_id):
	var plants_graph = all_graphs[graph_id]
	for id in plants_graph:
		if node_id in plants_graph[id]:
			plants_graph[id].erase(node_id)
	plants_graph.erase(node_id)

func removeIfDetached(graph_id, node_id):
	var plants_graph = all_graphs[graph_id]
	var queue = [node_id]
	var visited = { node_id: true }
 
	while queue:
		var current_id = queue.pop_front()

		var player = getLocalPlayerNode()
		if current_id == player.current_plant:
			return

		for id in plants_graph[current_id]:
			if not id in visited:
				queue.append(plants_graph[current_id][id])
				visited[id] = true

	var node = instance_from_id(node_id)
	node.destroy()

func getNeighborIds(graph_id, node_id):
	if not graph_id in all_graphs:
		return []
	var plants_graph = all_graphs[graph_id]
	return plants_graph[node_id].values() if node_id in plants_graph else []
