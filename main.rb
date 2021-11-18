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

def parseThing(str, l)
  ar = str.strip.scan(/(\$\w*)/)
  ar.each do |f|
    if $vars[f[0][1..-1]][:l] <= l
      str.gsub!(f[0], $vars[f[0][1..-1]][:val])
    end
  end
  #          (^|[^\\])
  str.gsub!(/\\/, "")
  return str
end

class Function
  def initialize(a, b)
    @args, @func = a, b
  end

  def run(args)
    $s+=1
    l = $s
    s = args.split(/(.*)[|[^\\]]\,(.*)/)
    s.shift
    resolveArgs(@args, s, l)
    ss = parseThing(@func, l)
    parseFuncCalls(ss).each do |s|
      if s[1] == 'eval'
        eval(s[2][1...-1])
      else
        $funcs[s[1]].run(s[2][1...-1])
      end
    end
    $vars.reject! do |_, s| s[:l] == l end
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

  func main(aaa,bbb) {
    puts("$aaa: $bbb", d)
    puts("test", d)
  }
')

$funcs["main"].run('aaaaaaaaaaaaa\,bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb,ccc')
