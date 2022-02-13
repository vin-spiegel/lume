# Lume

네코랜드 개발을 위한 유틸 함수 모음집


## 사용방법

```lua
lume = require "lume"
```


## 지원 함수 목록

#### lume.clamp(x, min, max)

  숫자 `min` 과 `max`  사이에 고정된 숫자 x를 반환합니다.

#### lume.round(x [, increment])
`x` 를 가장 가까운 정수로 반올림합니다.
두 정수의 중간에 있으면 `0` 에서 반올림합니다.
`increment` 인자가 설정되면 숫자가 가장 가까운 소수점으로 반올림됩니다.

```lua
lume.round(2.3) -- Returns 2
lume.round(123.4567, .1) -- Returns 123.5
```

#### lume.sign(x)
`x`가 양수 혹은 0 일경우엔 `1` 을 리턴, 음수일 경우엔 `-1` 을 리턴합니다


#### lume.lerp(a, b, amount)
`a` 와 `b` 사이의 선형 보간된 수를 반환합니다.
`amount` 는 0 - 1 범위에 있어야 합니다.
`amount` 의 범위를 벗어나면 고정됩니다.
```lua
lume.lerp(100, 200, .5) -- Returns 150
```

#### lume.smooth(a, b, amount)
`lume.lerp()` 와 유사하지만 선형 보간 대신 3차 보간된 수를 반환합니다

#### lume.pingpong(x)
`x` 를 기준으로 0과 1 사이의 수를 리턴합니다

#### lume.distance(x1, y1, x2, y2 [, squared])
두 점 사이의 거리를 반환합니다. `squared` 옵션이 `true` 이면 제곱 거리가 반환됩니다. 연산속도가 더 빠릅니다

#### lume.angle(x1, y1, x2, y2)
두 포인트 사이의 각도를 계산합니다

#### lume.vector(angle, magnitude)
각도와 크기가 주어지면 벡터를 반환합니다

```lua
local x, y = lume.vector(0, 10) -- Returns 10, 0
```

#### lume.random([a [, b]])
`a` 와 `b` 사이의 난수를 반환합니다
`a` 만 제공되면 `0` 과 `a` 사이의 숫자가 반환됩니다
인수가 제공되지 않으면 `0`과 `1` 사이의 난수가 반환됩니다

#### lume.randomchoice(t)
배열 `t`에서 임의의 값을 반환합니다. 배열이 비어 있으면 오류를 발생시킵니다

```lua
lume.randomchoice({true, false}) -- Returns either true or false
```

#### lume.weightedchoice(t)
가중치 랜덤입니다. 가중치는 `0` 이상이어야 하며 숫자가 클수록 선택될 확률이 높아집니다. 테이블이 비어 있거나 가중치가 `0` 미만이거나 모든 가중치가 `0` 이면 오류가 발생합니다.
```lua
lume.weightedchoice({ ["cat"] = 10, ["dog"] = 5, ["frog"] = 0 })
-- Returns either "cat" or "dog" with "cat" being twice as likely to be chosen.
```

#### lume.isarray(x)
`x` 가 배열형식이면 `true` 를 반환합니다


#### lume.push(t, ...)
주어진 모든 값을 테이블 `t` 의 끝으로 푸시하고 푸시된 값을 반환합니다. `nil` 값은 무시됩니다.

```lua
local t = { 1, 2, 3 }
lume.push(t, 4, 5) -- `t` becomes { 1, 2, 3, 4, 5 }
```

#### lume.remove(t, x)
테이블 `t` 에 존재하는 경우 값 `x` 의 첫 번째 인스턴스를 제거합니다. `x` 를 반환합니다.

```lua
local t = { 1, 2, 3 }
lume.remove(t, 2) -- `t` becomes { 1, 3 }
```

#### lume.clear(t)
테이블 `t` 의 모든 값을 제거하고 빈 테이블을 반환합니다.

```lua
local t = { 1, 2, 3 }
lume.clear(t) -- `t` becomes {}
```

#### lume.extend(t, ...)
원본 테이블의 모든 필드를 테이블 `t`에 복사하고 `t`를 반환합니다. 키가 여러 테이블에 있는 경우 맨 오른쪽 테이블의 값이 사용됩니다.

```lua
local t = { a = 1, b = 2 }
lume.extend(t, { b = 4, c = 6 }) -- `t` becomes { a = 1, b = 4, c = 6 }
```

#### lume.shuffle(t)
배열 `t` 의 뒤섞인 복사본을 반환합니다.

#### lume.sort(t [, comp])
모든 항목이 정렬된 배열 `t` 의 복사본을 반환합니다. `comp` 가 함수인 경우 정렬할 때 항목을 비교하는 데 사용됩니다. `comp` 가 문자열이면 항목을 정렬하는 기준으로 사용됩니다.

```lua
lume.sort({ 1, 4, 3, 2, 5 }) -- Returns { 1, 2, 3, 4, 5 }
lume.sort({ {z=2}, {z=3}, {z=1} }, "z") -- Returns { {z=1}, {z=2}, {z=3} }
lume.sort({ 1, 3, 2 }, function(a, b) return a > b end) -- Returns { 3, 2, 1 }
```

#### lume.array(...)
제공된 인수의 값으로 채워진 배열을 반환합니다.

```lua
lume.array(string.gmatch("Hello world", "%a+")) -- Returns {"Hello", "world"}
```

#### lume.each(t, fn, ...)
테이블 `t` 를 반복하고 제공된 추가 인수가 뒤따르는 각 값에 대해 함수 `fn` 을 호출합니다. `fn` 이 문자열이면 각 값에 대해 해당 이름의 메소드가 호출됩니다. 함수는 수정되지 않은 `t` 를 반환합니다.

```lua
lume.each({1, 2, 3}, print) -- Prints "1", "2", "3" on separate lines
lume.each({a, b, c}, "move", 10, 20) -- Does x:move(10, 20) on each value
```

#### lume.map(t, fn)
함수 `fn`을 테이블 `t`의 각 값에 적용하고 결과 값과 함께 새 테이블을 반환합니다.

```lua
lume.map({1, 2, 3}, function(x) return x * 2 end) -- Returns {2, 4, 6}
```

#### lume.all(t [, fn])
`t` 테이블의 모든 값이 참이면 참을 반환합니다. `fn` 함수가 제공되면 각 값에 대해 호출되고 `fn` 에 대한 모든 호출이 `true` 를 반환하면 `true`가 반환됩니다.

```lua
lume.all({1, 2, 1}, function(x) return x == 1 end) -- Returns false
```

#### lume.any(t [, fn])
`t` 테이블의 값 중 하나라도 `true` 면 `true` 를 반환합니다. `fn` 함수가 제공되면 각 값에 대해 호출되고 `fn` 에 대한 호출 중 하나라도 `true` 를 반환하면 `true` 가 반환됩니다.

```lua
lume.any({1, 2, 1}, function(x) return x == 1 end) -- Returns true
```

#### lume.reduce(t, fn [, first])
배열을 단일 값으로 줄이기 위해 제공된 테이블에 `fn` 을 적용합니다.함수에 해당하는 값이 지정되면 해당 값으로 초기화되고, 그렇지 않으면 배열의 첫 번째 값이 사용됩니다. 배열이 비어 있거나 첫 번째 값이 지정되지 않으면 오류가 발생합니다.

```lua
lume.reduce({1, 2, 3}, function(a, b) return a + b end) -- Returns 6
```

#### lume.unique(t)
모든 중복 값이 ​​제거된 `t` 배열의 복사본을 반환합니다.
```lua
lume.unique({2, 1, 2, "cat", "cat"}) -- Returns {1, 2, "cat"}
```

#### lume.filter(t, fn [, retainkeys])
`t` 테이블의 각 값에 대해 `fn`을 호출합니다. `fn` 이 `true` 를 반환한 값만 포함하는 새 테이블을 반환합니다. `Retainkeys` 가 `true` 이면 테이블은 배열로 처리되지 않고 원래 키를 유지합니다.

```lua
lume.filter({1, 2, 3, 4}, function(x) return x % 2 == 0 end) -- Returns {2, 4}
```

#### lume.reject(t, fn [, retainkeys])
`lume.filter()` 의 반대: `t` 테이블의 각 값에 대해 `fn` 을 호출합니다. `fn` 이 `false` 를 반환한 값만 있는 새 테이블을 반환합니다. `Retainkeys` 가 `true` 이면 테이블은 배열로 처리되지 않고 원래 키를 유지합니다.

```lua
lume.reject({1, 2, 3, 4}, function(x) return x % 2 == 0 end) -- Returns {1, 3}
```

#### lume.merge(...)
주어진 모든 테이블이 함께 병합된 새 테이블을 반환합니다. 키가 여러 테이블에 있는 경우 맨 오른쪽 테이블의 값이 사용됩니다.

```lua
lume.merge({a=1, b=2, c=3}, {c=8, d=9}) -- Returns {a=1, b=2, c=8, d=9}
```

#### lume.concat(...)
주어진 모든 배열이 하나로 연결된 새 배열을 반환합니다.

```lua
lume.concat({1, 2}, {3, 4}, {5, 6}) -- Returns {1, 2, 3, 4, 5, 6}
```

#### lume.find(t, value)
`t` 에 있는 값의 인덱스/키를 반환합니다. 해당 값이 테이블에 없으면 `nil` 을 반환합니다.

```lua
lume.find({"a", "b", "c"}, "b") -- Returns 2
```

#### lume.match(t, fn)
`fn` 이 호출될 때 `true` 를 반환하는 테이블 `t` 에 있는 값의 값과 키를 반환합니다. 그러한 값이 없으면 `nil` 을 반환합니다.

```lua
lume.match({1, 5, 8, 7}, function(x) return x % 2 == 0 end) -- Returns 8, 3
```

#### lume.count(t [, fn])
테이블 `t` 에 있는 값의 수를 계산합니다. `fn` 함수가 제공되면 각 값에 대해 호출되고 `true` 를 반환하는 횟수가 계산됩니다.

```lua
lume.count({a = 2, b = 3, c = 4, d = 5}) -- Returns 4
lume.count({1, 2, 4, 6}, function(x) return x % 2 == 0 end) -- Returns 3
```

#### lume.slice(t [, i [, j]])
`Lua` 의 `string.sub` 동작을 모방하지만 문자열이 아닌 배열에서 작동합니다. 주어진 슬라이스의 새 배열을 만들고 반환합니다.

```lua
lume.slice({"a", "b", "c", "d", "e"}, 2, 4) -- Returns {"b", "c", "d"}
```

#### lume.first(t [, n])
배열의 첫 번째 요소를 반환하거나 배열이 비어 있으면 `nil` 을 반환합니다. `n` 이 지정되면 처음 `n` 개 요소의 배열이 반환됩니다.

```lua
lume.first({"a", "b", "c"}) -- Returns "a"
```

#### lume.last(t [, n])
배열의 마지막 요소를 반환하거나 배열이 비어 있으면 `nil` 을 반환합니다. `n` 이 지정되면 마지막 `n` 개 요소의 배열이 반환됩니다.

```lua
lume.last({"a", "b", "c"}) -- Returns "c"
```

#### lume.invert(t)
키가 값이 되고 값이 키로 된 테이블의 복사본을 반환합니다.

```lua
lume.invert({a = "x", b = "y"}) -- returns {x = "a", y = "b"}
```

#### lume.pick(t, ...)
주어진 키에 대한 값만 포함하도록 필터링된 테이블의 복사본을 반환합니다.

```lua
lume.pick({ a = 1, b = 2, c = 3 }, "a", "c") -- Returns { a = 1, c = 3 }
```

#### lume.keys(t)
테이블의 각 키를 포함하는 배열을 반환합니다.


#### lume.clone(t)
테이블 `t` 의 얕은 복사본을 반환합니다.

#### lume.fn(fn, ...)
`fn` 함수 주위에 래퍼 함수를 ​​만들고 래퍼가 호출될 때마다 지속되는 인수를 `fn` 에 자동으로 삽입합니다. 반환된 함수에 전달된 모든 인수는 `fn` 에 전달된 이미 존재하는 인수 뒤에 삽입됩니다.

```lua
local f = lume.fn(print, "Hello")
f("world") -- Prints "Hello world"
```

#### lume.once(fn, ...)
제공된 인수를 사용하는 `fn` 에 래퍼 함수를 ​​반환합니다. 래퍼 함수는 첫 번째 호출에서 `fn` 을 호출하고 후속 호출에서는 아무 작업도 수행하지 않습니다.

```lua
local f = lume.once(print, "Hello")
f() -- Prints "Hello"
f() -- Does nothing
```

#### lume.memoize(fn)
주어진 인수 집합에 대한 결과가 캐시되는 `fn` 에 래퍼 함수를 ​​반환합니다. `lume.memoize()` 는 계산 속도가 느린 함수에 사용할 때 유용합니다.

```lua
fib = lume.memoize(function(n) return n < 2 and n or fib(n-1) + fib(n-2) end)
```

#### lume.combine(...)
`lume.combine()` 에 전달된 순서대로 제공된 각 인수를 호출하는 래퍼 함수를 ​​만듭니다. `nil` 인수는 무시됩니다. 래퍼 함수는 호출될 때 각 래핑된 함수에 자체 인수를 전달합니다.

```lua
local f = lume.combine(function(a, b) print(a + b) end,
                       function(a, b) print(a * b) end)
f(3, 4) -- Prints "7" then "12" on a new line
```

#### lume.call(fn, ...)
제공된 인수를 사용하여 주어진 함수를 호출하고 해당 값을 반환합니다. `fn` 이 `nil` 이면 아무 작업도 수행되지 않고 함수는 `nil` 을 반환합니다.

```lua
lume.call(print, "Hello world") -- Prints "Hello world"
```

#### lume.time(fn, ...)
인수를 함수 `fn` 에 삽입하고 호출합니다. `fn` 함수가 실행되는 데 걸린 시간(초)과 `fn` 의 반환 값을 반환합니다.

```lua
lume.time(function(x) return x end, "hello") -- Returns 0, "hello"
```

#### lume.lambda(str)
문자열 람다를 가져와서 함수를 반환합니다. `str` 은 쉼표로 구분된 매개변수의 목록이어야 하며, 그 뒤에 `->` 가 오고, 그 뒤에 평가되고 반환될 표현식이 와야 합니다.

```lua
local f = lume.lambda "x,y -> 2*x+y"
f(10, 5) -- Returns 25
```

#### lume.serialize(x)
테이블 `x`를 직렬화 합니다
```lua
lume.serialize({a = "test", b = {1, 2, 3}, false})
-- Returns "{[1]=false,["a"]="test",["b"]={[1]=1,[2]=2,[3]=3,},}"
```

#### lume.deserialize(str)
-- `lume.deserialize()` 를 사용하여 다시 로드할 수 있는 문자열로 인수 `x` 를 직렬화합니다. 부울, 숫자, 테이블 및 문자열만 직렬화할 수 있습니다. 순환 참조는 오류를 발생시킵니다. 모든 중첩 테이블은 고유 테이블로 직렬화됩니다.

```lua
lume.deserialize("{1, 2, 3}") -- Returns {1, 2, 3}
```

#### lume.split(str [, sep])
문자열 `str` 에 있는 단어의 배열을 반환합니다. `sep` 가 제공되면 구분 기호로 사용되며 연속 구분 기호는 함께 그룹화되지 않고 빈 문자열을 구분합니다.

```lua
lume.split("One two three") -- Returns {"One", "two", "three"}
lume.split("a,b,,c", ",") -- Returns {"a", "b", "", "c"}
```

#### lume.trim(str [, chars])
문자열 `str` 의 시작과 끝에서 공백을 제거하고 새 문자열을 반환합니다. `chars` 값이 설정되면 `chars` 의 문자는 공백 대신 잘립니다.

```lua
lume.trim("  Hello  ") -- Returns "Hello"
```

#### lume.wordwrap(str [, limit])
줄당 문자 수를 제한하기 위해 줄 바꿈된 `str` 을 반환합니다. 기본적으로 제한은 `72` 입니다. `limit` 는 문자열을 전달할 때 한 줄이 너무 긴 경우 `true` 를 반환하는 함수일 수도 있습니다.

```lua
-- Returns "Hello world\nThis is a\nshort string"
lume.wordwrap("Hello world. This is a short string", 14)
```

#### lume.format(str [, vars])
형식이 지정된 문자열을 반환합니다. `vars` 테이블의 키 값은 `str` 에서 "{key}" 형식을 사용하여 문자열에 삽입할 수 있습니다. 숫자 키를 사용할 수도 있습니다.

```lua
lume.format("{b} hi {a}", {a = "mark", b = "Oh"}) -- Returns "Oh hi mark"
lume.format("Hello {1}!", {"world"}) -- Returns "Hello world!"
```

<!-- #### lume.trace(...)
현재 파일 이름과 줄 번호를 같이 출력합니다.

```lua
-- Assuming the file is called "example.lua" and the next line is 12:
lume.trace("hello", 1234) -- Prints "example.lua:12: hello 1234"
``` -->
<!-- 
#### lume.dostring(str)
`str` 내부의 lua 코드를 실행합니다.

```lua
lume.dostring("print('Hello!')") -- Prints "Hello!"
``` -->

#### lume.uuid()
임의의 UUID 문자열을 생성합니다. [RFC 4122](https://www.ietf.org/rfc/rfc4122.txt)


<!-- #### lume.hotswap(modname)
이미 로드된 모듈을 다시 로드합니다 프로그램을 다시 시작하지 않고도 코드 변경의 효과를 즉시 확인할 수 있습니다. `modname` 은 `require()` 로 모듈을 로드할 때 사용한 것과 같은 문자열이어야 합니다. 오류가 발생하면 전역 환경이 복원되고 nil과 오류 메시지가 반환됩니다.

```lua
lume.hotswap("lume") -- Reloads the lume module
assert(lume.hotswap("inexistant_module")) -- Raises an error
``` -->

#### lume.ripairs(t)
`ipairs()` 와 동일한 기능을 수행하지만 역순으로 반복합니다.
항목을 건너뛰지 않고 반복 중에 테이블에서 항목을 제거할 수 있습니다.
```lua
-- Prints "3->c", "2->b" and "1->a" on separate lines
for i, v in lume.ripairs({ "a", "b", "c" }) do
  print(i .. "->" .. v)
end
```

#### lume.color(str [, mul])
rgb컬러를 리턴합니다
```lua
lume.color("#ff0000")               -- Returns 1, 0, 0, 1
lume.color("rgba(255, 0, 255, .5)") -- Returns 1, 0, 1, .5
lume.color("#00ffff", 256)          -- Returns 0, 256, 256, 256
lume.color("rgb(255, 0, 0)", 256)   -- Returns 256, 0, 0, 256
```

#### lume.chain(value)
lume 함수를 연결시켜주는 래핑된 객체를 반환합니다. 결과 값을 반환하려면 체인의 끝에서 `result()` 함수를 호출해야 합니다.

```lua
lume.chain({1, 2, 3, 4})
  :filter(function(x) return x % 2 == 0 end)
  :map(function(x) return -x end)
  :result() -- Returns { -2, -4 }
```

```lua
lume({1, 2, 3}):each(print) -- Prints 1, 2 then 3 on separate lines
```

## 반복자
`map()`, `all()`, `any()`, `filter()`, `reject()`, `match()`, `count()` 함수들은 반복자가 가능합니다

```lua
lume.filter({ true, true, false, true }, nil) -- { true, true, true }
```

``` lua
local t = {{ z = "cat" }, { z = "dog" }, { z = "owl" }}
lume.map(t, "z") -- Returns { "cat", "dog", "owl" }
```

```lua
local t = {
  { age = 10, type = "cat" },
  { age = 8,  type = "dog" },
  { age = 10, type = "owl" },
}
lume.count(t, { age = 10 }) -- returns 2
```


## License

[rxi](https://github.com/rxi/lume/blob/master/LICENSE)
