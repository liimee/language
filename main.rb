# import "std.nop"
# func main() -> null {
# std.print("HEY")
# }

$funcs = []
$imports = []

def parseImports(str)
  ar = str.strip.scan(/import \"([^\"]*)\"/)
  $imports = ar
end

def parseFunctions(str)
  ar = str.strip.split(/func (\w*)\(([^\)]*)\) \-\> (\w*) \{([^\}]*)\}/m)
  ar.map! { |item| item.strip }
  ar.each_slice(4) do |a, b, c, d|
    $funcs.push(Function.new(a, b, c, d))
  end
end

class Function
  def initialize(a, b, c, d)
    @name, @args, @returns, @func = a, b, c, d
  end
end

def main(str)
  imp = parseImports(str)
  fun = parseFunctions(str)
  puts $imports
end

main('
  import "std"
  import "ddd"

  func main() -> null {
    std.puts("hey")
  }
')
