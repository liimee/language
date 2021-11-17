# import "std.nop"
# func main() -> null {
# std.print("HEY")
# }

require './run'

$funcs = {}

def parseImports(str)
  ar = str.strip.scan(/import \"([^\"]*)\"/)
  return ar
end

def parseFunctions(str)
  ar = str.strip.scan(/func (\w*)\(([^\)]*)\) \{([^\}]*)\}/m)
  ar.map! { |item| item.map! { |a| a.strip } }
  ar.each do |a|
    $funcs[a[0]] = Function.new(a[1], a[2])
  end
end

def parseFuncCalls(str)
  ar = str.strip.scan(/(\w*)\(([^\)]*)\)/)
  return ar
end

def resolveArgs(str, args, g)
  e = args.strip.split(/\,/)
  f = {}
  #puts args
  e.each_with_index do |a, b|
    f["@"+a] = g[b]
  end
  return f
  #puts f
end

def parseThing(str)
  ar = str.strip.scan(/\"(?!\\)([^\"(?!\\)]*)\"(?!\\)/)
  return ar[0]
end

class Function
  def initialize(a, b)
    @args, @func = a, b
  end

  def run()
    e = parseFuncCalls(@func)
    e.each { |a|
      dd = a[1].split(/("[^"]*")|\,/)
      s = resolveArgs(@func, @args, dd)
      if a[0] == 'eval'
        eval(a[1][1...-1])
      else
        $funcs[a[0]].run()
      end
    }
  end
end

def main(str)
  imp = parseImports(str)
  imp = import(imp)
  imp.each do |a|
    parseFunctions a
  end
  fun = parseFunctions(str)
end

main('
  import "test.nop"

  func main() {
    puts()
  }
')
$funcs["main"].run
