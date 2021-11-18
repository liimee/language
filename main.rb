require './run'

$funcs = {}
$vars = {}
$s = 0

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
  ar = str.strip.scan(/(^|[^\\])(\w*)\(([^\)]*)\)/)
  return ar
end

def resolveArgs(args, g, l)
  e = args.strip.split(/\,/)
  e.each_with_index do |a, b|
    $vars[a] = {
      l: l,
      val: g[b]
    }
  end
end

def parseThing(str)
  ar = str.strip.scan(/(\$\w*)/)
  ar.each do |f|
    str.gsub!(f[0], $vars[f[0][1..-1]][:val])
  end
  str.gsub!(/(^|[^\\])\\/, "")
  return str
end

class Function
  def initialize(a, b)
    @args, @func = a, b
  end

  def run(args)
    $s+=1
    l = $s
    s = args.split(/\,/)
    resolveArgs(@args, s, l)
    ss = parseThing(@func)
    puts ss
=begin
    e = parseFuncCalls(@func)
    e.each_with_index { |a, s|
      dd = a[2].split(/\,/)
      resolveArgs(@func, @args, dd, l)
      ss = [];
      dd.each do |x|
        ss.push(parseThing(x))
      end
      case a[1]
      when 'eval'
        eval(ss.join('\n')[1...-1])
        #eval(a[2][1...-1].gsub(/(^|[^\\])\\/, ""))
      when 'var'
        $vars[dd[0]] = {
          val: dd[1],
          l: l
        }
      else
        $funcs[a[1]].run()
      end
      puts $vars
    }
    $vars.reject! do |_, s| s[:l] == l end
=end
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

  func main(aaa) {
    puts("$aaa")
  }
')

$funcs["main"].run('aaaaaaaaaaaaa')
