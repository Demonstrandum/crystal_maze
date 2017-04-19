class FHeap
  INFINITY = 1.0 / 0.0
  
  attr_reader :trees, :min_node
  
  def initialize(trees = [])
    @trees = trees
    reset_min_node!
  end
  
  def insert!(value)
    returning(Node.new(value, :root)) do |node|
      merge!(FHeap.new([node]))
    end
  end
  
  def merge!(f_heap)
    trees.concat(f_heap.trees)
    reset_min_node!
  end
  
  def extract_minimum!
    if min_node
      returning(trees.delete(min_node)) do |extracted_node|    
        extracted_node.children.each do |child_node|
          child_node.root = child_node
        end
        trees.concat(extracted_node.children)
        
        begin
          consolidated = consolidate!
        end while consolidated
        
        reset_min_node!
      end
    end
  end
  
  def decrease_value!(node, value)
    raise ArgumentError.new("New value (#{value}) is greater than the existing value (#{node.value}) for that node") if value > node.value
    
    node.value = value
    parent     = node.parent
    
    if node.value < parent.value
      cut!(node)
      cascading_cut!(parent)
    end
    
    @min_node = node if node.value < min_node.value
  end
  
  def delete(node)
    # Note that this modifies the value of the node to be deleted, so anything stored there should be saved in advance.
    decrease_value!(node, -INFINITY)
    extract_minimum!
  end
  
  def to_s
    trees.map(&:to_s)
  end
  
  private
  
  def consolidate!
    returning(false) do
      trees.inject({}) do |hash, root|
        if hash.has_key?(root.degree)
          root = connect!(*(root.value < hash[root.degree].value ? [root, hash.delete(root.degree)] : [hash.delete(root.degree), root]))
          return true
        end

        returning(hash) { hash[root.degree] = root }
      end
    end
  end
  
  def connect!(root, child)
    returning(root) do
      child.root   = root
      child.parent = root
      root.children << trees.delete(child)
    end
  end
  
  def cut!(node)
    parent = node.parent
    
    node.root   = node
    node.parent = node
    node.marked = false
    
    trees << parent.children.delete(node)
  end
  
  def cascading_cut!(node)
    unless node.root?
      if node.marked
        parent = node.parent
        cut!(node)
        cascading_cut!(parent)
      else
        node.marked = true
      end
    end
  end
  
  def reset_min_node!
    @min_node = trees.min { |a, b| a.value <=> b.value }
  end
end