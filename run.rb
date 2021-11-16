def import(t)
  d = []
  t.each do |e|
    d.push(File.read('./'+e.join))
  end
  return d
end
