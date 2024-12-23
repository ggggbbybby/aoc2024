require 'pry'
example = <<TXT
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
TXT

def parse(list)
  links = list.split("\n").map { |row| row.split("-") }
  nodes = Hash.new { |h, k| h[k] = [] }
  links.each do |a, b|
    nodes[a] << b
    nodes[b] << a
  end

  nodes
end

def triangle?(n1, n2, n3, graph)
  # do these three nodes form a triangle?
  n1_friends = graph[n1]
  n2_friends = graph[n2]
  n1_friends.include?(n2) && n1_friends.include?(n3) && n2_friends.include?(n3)
end

def part1BF(input)
  graph = parse(input)
  
  ts = graph.select { |k, v| k.start_with?('t') }
  
  triangles = Set.new
  ts.each do |t, connections|
    # a node in connections has t in its list
    # we want to find another node in its list that has t in _its_ list
    # t contains x, x contains y, y contains t
    
    connections.each do |x|
      graph[x].select { |y| triangle?(t, x, y, graph) }.each do |y|
        triangles << [t, x, y].sort
      end
    end
  end

  # p triangles
  triangles.length
end

def part1BK(input)
  graph = parse(input)
  cliques = bronKerboschCliques(Set.new, Set.new(graph.keys), Set.new, graph, [])
  
  # this does not give the right answer for the input for some reason
  cliques.flat_map { |c| c.to_a.combination(3).select { |c| c.any? {|v| v.start_with?('t') }} }.uniq.length
end

def bronKerboschCliques(r, p, x, graph, collect)
  if p.empty? && x.empty? && r.length > 2
    collect << r
    return
  end

  p.each do |v|
    neighbors = Set.new(graph[v])
    bronKerboschCliques(r.union(Set.new([v])), p.intersection(neighbors), x.intersection(neighbors), graph, collect)
    p.delete(v)
    x.add(v)
  end

  collect
end

def part2(input)
  graph = parse(input)

  maximal = bronKerboschCliques(Set.new, Set.new(graph.keys), Set.new, graph, []).max_by(&:length)
  maximal.to_a.sort.join(',')
end

puts "Part 1"
p part1BF(example)
p part1BK(example)

challenge = File.read("day23.txt")
p part1BF(challenge)

puts "Part 2"
p part2(example)
p part2(challenge)