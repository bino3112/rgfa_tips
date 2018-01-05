require "rgfa"
require "rgfatools"

#single pit node and single father
gfa1 = RGFA.new
lines = ["H\tVN:Z:1.0", 
		 "S\t1\tAAA", 
		 "S\t2\tACG", 
		 "S\t3\tCAT",
		 "S\t4\tTTT",
		 "S\t5\tGAC", 
		 "L\t1\t+\t2\t+\t0M",
		 "L\t2\t+\t3\t+\t0M", 
		 "L\t3\t+\t4\t+\t0M",
		 "L\t4\t+\t5\t+\t0M"]
lines.each {|l| gfa1 << l}

#multiple pit nodes and single father
gfa2 = RGFA.new
lines = ["H\tVN:Z:1.0", 
		 "S\t1\tAAA", 
		 "S\t2\tACG", 
		 "S\t3\tCAT",
		 "S\t4\tTTT",
		 "S\t5\tGAC", 
		 "L\t1\t+\t2\t+\t0M",
		 "L\t2\t+\t3\t+\t0M", 
		 "L\t3\t+\t4\t+\t0M",
		 "L\t3\t+\t5\t+\t0M"]
lines.each {|l| gfa2 << l}

#multiple pit nodes and multiple father
gfa3 = RGFA.new
lines = ["H\tVN:Z:1.0", 
		 "S\t1\tAAA", 
		 "S\t2\tACG", 
		 "S\t3\tCAT",
		 "S\t4\tTTT",
		 "S\t5\tGAC",
		 "S\t6\tACT", 
		 "L\t1\t+\t3\t+\t0M",
		 "L\t2\t+\t3\t+\t0M", 
		 "L\t3\t+\t4\t+\t0M",
		 "L\t3\t+\t5\t+\t0M",
		 "L\t5\t+\t6\t+\t0M"]
lines.each {|l| gfa3 << l}


def tips(graph)
	# Initialize variables
	g_links = Array.new
	g_segments = Array.new
	g_pits = Array.new
	g_fathers = Array.new
	final = Array.new


	g_links = graph.links	
	
	# Find pits of graph
	g_links.each do |l|
		pit = true
		g_links.each do |m|
			if l.to_name == m.from_name || (l.to_name == m.to_name && l != m)
				pit = false
			end
		end
		if pit ==  true
			g_pits << l.to_name
		end
	end

	# Find fathers of graph
	g_links.each do |l|
		father = true
		g_links.each do |m|
			if l.from_name == m.to_name
			father = false
			end
		end
		if father == true
			g_fathers << l.from_name
		end
	end
	g_fathers = g_fathers.uniq

	# Method to find the route for the pit nodes 
	def routes(links, fathers, nodo, route_length)
			node_recursive = nodo
			entred = false
			links.each do |n|	
				for i in 0..fathers.length do
					if fathers[i] == n.from_name && nodo == n.to_name
						return route_length += 1
					end
				end	
				if nodo == n.to_name
					links.each do |c|
						if n.from_name == c.to_name  && entred == true
							return route_length += 1
						end
						if n.from_name == c.to_name && entred == false
							entred = true
							node_recursive = c.to_name
						end
					end
				end
			end
			route_length += 1
			routes(links, fathers, node_recursive, route_length)
	end

	# Call the method for every pit
	for i in 0..g_pits.length-1 do 
		final << [g_pits[i].to_s + ", " + routes(g_links, g_fathers, g_pits[i], 0).to_s]
	end
	puts "Pit node, route length :"
	puts final
	return final
end

	


tips(gfa1)
tips(gfa2)
tips(gfa3)