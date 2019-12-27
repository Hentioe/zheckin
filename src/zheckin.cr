module Zheckin
  VERSION = "0.1.0"
end

macro matching(value, **pattern)
  %matching = true
  {% for k, v in pattern %}
    {% unless v.class_name.downcase == "var" %}
      if !%matching || {{v}} != {{value}}.{{k.id}}
        %matching = false
      end
    {% end %}
  {% end %}

  if %matching
    {% for k, v in pattern %}
      {% if v.class_name.downcase == "var" %}
        {{v}} = {{value}}.{{k.id}}
      {% end %}
    {% end %}
  end
end

class Person
  property name : String
  property age : Int32
  property nicknames : Array(String)

  def initialize(@name, @age, @nicknames)
  end
end

name : String? = nil
age : Int32? = nil

p1 = Person.new("小明", 18, ["狗子"])
p2 = Person.new("小红", 21, [] of String)

matching(p1, name: name, age: 18, nicknames: ["狗子"])

pp name # => 小明
