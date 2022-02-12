--
-- lume
--
-- Copyright (c) 2020 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local lume = {_version = "2.3.0"}

local pairs, ipairs = pairs, ipairs
local type, assert, unpack = type, assert, table.unpack
local tostring, tonumber = tostring, tonumber
local math_floor = math.floor
local math_ceil = math.ceil
local math_atan2 = math.atan
local math_sqrt = math.sqrt
local math_abs = math.abs

local noop = function()
end

local identity = function(x)
  return x
end

local patternescape = function(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
end

local absindex = function(len, i)
  return i < 0 and (len + i + 1) or i
end

local iscallable = function(x)
  if type(x) == "function" then
    return true
  end
  local mt = getmetatable(x)
  return mt and mt.__call ~= nil
end

local getiter = function(x)
  if lume.isarray(x) then
    return ipairs
  elseif type(x) == "table" then
    return pairs
  end
  error("expected table", 3)
end

local iteratee = function(x)
  if x == nil then
    return identity
  end
  if iscallable(x) then
    return x
  end
  if type(x) == "table" then
    return function(z)
      for k, v in pairs(x) do
        if z[k] ~= v then
          return false
        end
      end
      return true
    end
  end
  return function(z)
    return z[x]
  end
end

---- 숫자 `min` 과 `max`  사이에 고정된 숫자 x를 반환합니다.
---@param x number
---@param min number
---@param max number
---@return number
function lume.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

-- 'x'를 가장 가까운 정수로 반올림합니다.
--- - 두 정수의 중간에 있으면 `0` 에서 반올림합니다.
--- - 'increment'인자가 설정되면 숫자가 가장 가까운 소수점으로 반올림됩니다.
-- ```
--  lume.round(2.3)
--      --> 2
--  lume.round(123.4567, .1)
--      --> 123.5
-- ```
---@param x number
---@param increment number
function lume.round(x, increment)
  if increment then
    return lume.round(x / increment) * increment
  end
  return x >= 0 and math_floor(x + .5) or math_ceil(x - .5)
end

-- - `x`가 양수 혹은 0 일경우엔 `1` 을 리턴, 음수일 경우엔 `-1` 을 리턴합니다
---@param x number
function lume.sign(x)
  return x < 0 and -1 or 1
end

-- -  와 b 사이의 선형 보간된 숫자를 반환합니다.
--    - `amount` 는 0 - 1 범위에 있어야 합니다.
--    - `amount` 의 범위를 벗어나면 고정됩니다.
---@param a number
---@param b number
---@param amount '0 ... -1'
---@return number
function lume.lerp(a, b, amount)
  return a + (b - a) * lume.clamp(amount, 0, 1)
end

-- - lume.lerp()와 유사하지만 선형 보간 대신 3차 보간을 사용합니다.
---@param a number
---@param b number
---@param amount '0 ~ -1'
---@return number
function lume.smooth(a, b, amount)
  local t = lume.clamp(amount, 0, 1)
  local m = t * t * (3 - 2 * t)
  return a + (b - a) * m
end

-- -  Ping-pongs the number x between 0 and 1.
---@param x number
function lume.pingpong(x)
  return 1 - math_abs(1 - x % 2)
end

-- -  두 점 사이의 거리를 반환합니다. `squared` 옵션이 참이면 제곱 거리가 반환됩니다. 연산속도가 더 빠릅니다
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param squared boolean
function lume.distance(x1, y1, x2, y2, squared)
  local dx = x1 - x2
  local dy = y1 - y2
  local s = dx * dx + dy * dy
  return squared and s or math_sqrt(s)
end

-- - 두 포인트 사이의 각도를 계산합니다
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
function lume.angle(x1, y1, x2, y2)
  return math_atan2(y2 - y1, x2 - x1)
end

--  - 각도와 크기가 주어지면 벡터를 반환합니다
---@param angle number 각도
---@param magnitude number 크기
---@return number
function lume.vector(angle, magnitude)
  return math.cos(angle) * magnitude, math.sin(angle) * magnitude
end

-- - a 와 b 사이의 난수를 반환합니다
-- - a만 제공되면 0과 a 사이의 숫자가 반환됩니다
-- - 인수가 제공되지 않으면 0과 1 사이의 난수가 반환됩니다
---@param a number
---@param b number
function lume.random(a, b)
  if not a then
    a, b = 0, 1
  end
  if not b then
    b = 0
  end
  return a + math.random() * (b - a)
end

-- - 배열 t에서 임의의 값을 반환합니다. 배열이 비어 있으면 오류가 발생합니다.
-- function lume.randomchoice(t)
--     return t[math.random(#t)]
-- end

-- - override
-- - 배열 t에서 임의의 값을 반환합니다. 배열이 비어 있으면 오류가 발생합니다.
---@param t any[]
function lume.randomchoice(t)
  return t[rand(0, #t)]
end

-- -  가중치는 0 이상이어야 하며 숫자가 클수록 선택될 확률이 높아집니다. 테이블이 비어 있거나 가중치가 0 미만이거나 모든 가중치가 0이면 오류가 발생합니다.
-- ```
-- lume.weightedchoice({ ["cat"] = 10, ["dog"] = 5, ["frog"] = 0 })
--      --> "cat" , "dog", "frog" 중 숫자의 값이 큰 키값이 반환될 확률이 높습니다
-- ```
---@param t table<string , number>
---@return string
function lume.weightedchoice(t)
  local sum = 0
  for _, v in pairs(t) do
    assert(v >= 0, "weight 값이 0보다 작습니다")
    sum = sum + v
  end
  assert(sum ~= 0, "모든 weights가 0입니다")
  -- local rnd = lume.random(sum)
  local rnd = rand(0, sum)
  for k, v in pairs(t) do
    if rnd < v then
      return k
    end
    rnd = rnd - v
  end
end

-- - `x` 가 배열형식이면 `true` 를 반환합니다
---@param x table
---@return boolean
function lume.isarray(x)
  return type(x) == "table" and x[1] ~= nil
end

-- - 주어진 모든 값을 테이블 t의 끝으로 푸시하고 푸시된 값을 반환합니다. Nil 값은 무시됩니다.
---@param t any[]
---@return any[]
function lume.push(t, ...)
  local n = select("#", ...)
  for i = 1, n do
    t[#t + 1] = select(i, ...)
  end
  return ...
end

-- - 테이블 `t` 에 존재하는 경우 값 `x` 의 첫 번째 인스턴스를 제거합니다. `x` 를 반환합니다.
---@param t any[]
---@return any[]
function lume.remove(t, x)
  local iter = getiter(t)
  for i, v in iter(t) do
    if v == x then
      if lume.isarray(t) then
        table.remove(t, i)
        break
      else
        t[i] = nil
        break
      end
    end
  end
  return x
end

-- - 테이블 t의 모든 값을 제거하고 빈 테이블을 반환합니다.
---@param t any[]
---@return any[]
function lume.clear(t)
  local iter = getiter(t)
  for k in iter(t) do
    t[k] = nil
  end
  return t
end

-- -  원본 테이블의 모든 필드를 테이블 t에 복사하고 t를 반환합니다. 키가 여러 테이블에 있는 경우 맨 오른쪽 테이블의 값이 사용됩니다.
--
-- ```
--      local t = { a = 1, b = 2 }
--      lume.extend(t, { b = 4, c = 6 }) --> { a = 1, b = 4, c = 6 }
-- ```
---@param t any[]
function lume.extend(t, ...)
  for i = 1, select("#", ...) do
    local x = select(i, ...)
    if x then
      for k, v in pairs(x) do
        t[k] = v
      end
    end
  end
  return t
end

--  - 배열 `t` 의 뒤섞인 복사본을 반환합니다.
function lume.shuffle(t)
  local rtn = {}
  for i = 1, #t do
    local r = math.random(i)
    if r ~= i then
      rtn[i] = rtn[r]
    end
    rtn[r] = t[i]
  end
  return rtn
end

-- - 모든 항목이 정렬된 배열 `t` 의 복사본을 반환합니다. `comp` 가 함수인 경우 정렬할 때 항목을 비교하는 데 사용됩니다. `comp` 가 문자열이면 항목을 정렬하는 기준으로 사용됩니다.
-- ```
--      lume.sort({ 1, 4, 3, 2, 5 })
--      --> { 1, 2, 3, 4, 5 }
--      lume.sort({ {z=2}, {z=3}, {z=1} }, "z")
--      --> { {z=1}, {z=2}, {z=3} }
--      lume.sort({ 1, 3, 2 }, function(a, b) return a > b end)
--      --> { 3, 2, 1 }
-- ```
---@param t any[]
---@param comp? string | function
function lume.sort(t, comp)
  local rtn = lume.clone(t)
  if comp then
    if type(comp) == "string" then
      table.sort(
        rtn,
        function(a, b)
          return a[comp] < b[comp]
        end
      )
    else
      table.sort(rtn, comp)
    end
  else
    table.sort(rtn)
  end
  return rtn
end

-- - 제공된 반복기를 반복하고 값으로 채워진 배열을 반환합니다.
--
-- ```
--      lume.array(string.gmatch("Hello world", "%a+"))
--      --> {"Hello", "world"}
-- ```
function lume.array(...)
  local t = {}
  for x in ... do
    t[#t + 1] = x
  end
  return t
end

--  - 테이블 `t` 를 반복하고 제공된 추가 인수가 뒤따르는 각 값에 대해 함수 `fn` 을 호출합니다. `fn` 이 문자열이면 각 값에 대해 해당 이름의 메소드가 호출됩니다. 함수는 수정되지 않은 `t` 를 반환합니다.
--
-- ```
--      lume.each({1, 2, 3}, print)
--      -> "1", "2", "3" on separate lines
--      lume.each({a, b, c}, "move", 10, 20)
--      -> Does x:move(10, 20) on each value
-- ```
---@param t any[]
---@return any[] t
function lume.each(t, fn, ...)
  local iter = getiter(t)
  if type(fn) == "string" then
    for _, v in iter(t) do
      v[fn](v, ...)
    end
  else
    for _, v in iter(t) do
      fn(v, ...)
    end
  end
  return t
end

-- - 함수 fn을 테이블 t의 각 값에 적용하고 결과 값과 함께 새 테이블을 반환합니다.
-- ```
--      lume.map({1, 2, 3}, function(x) return x * 2 end)
--      -> {2, 4, 6}
-- ```
function lume.map(t, fn)
  fn = iteratee(fn)
  local iter = getiter(t)
  local rtn = {}
  for k, v in iter(t) do
    rtn[k] = fn(v)
  end
  return rtn
end

-- - `t` 테이블의 모든 값이 참이면 참을 반환합니다. `fn` 함수가 제공되면 각 값에 대해 호출되고 `fn` 에 대한 모든 호출이 `true` 를 반환하면 `true`가 반환됩니다.
-- ```
--      lume.all({1, 2, 1}, function(x) return x == 1 end)
--      -> false
-- ```
function lume.all(t, fn)
  fn = iteratee(fn)
  local iter = getiter(t)
  for _, v in iter(t) do
    if not fn(v) then
      return false
    end
  end
  return true
end

-- - t 테이블의 값 중 하나라도 `true` 면 `true` 를 반환합니다. `fn` 함수가 제공되면 각 값에 대해 호출되고 `fn` 에 대한 호출 중 하나라도 `true` 를 반환하면 `true` 가 반환됩니다.
function lume.any(t, fn)
  fn = iteratee(fn)
  local iter = getiter(t)
  for _, v in iter(t) do
    if fn(v) then
      return true
    end
  end
  return false
end

-- - 배열을 단일 값으로 줄이기 위해 왼쪽에서 오른쪽으로 배열 `t` 의 항목에 누적된 두 인수에 `fn` 을 적용합니다. 첫 번째 값이 지정되면 누산기는 이것으로 초기화되고, 그렇지 않으면 배열의 첫 번째 값이 사용됩니다. 배열이 비어 있고 첫 번째 값이 지정되지 않으면 오류가 발생합니다.
-- ```
--      lume.reduce({1, 2, 3}, function(a, b) return a + b end)
--      -> 6
-- ```
---@param t any[]
---@param fn function
---@return any
function lume.reduce(t, fn, first)
  local started = first ~= nil
  local acc = first
  local iter = getiter(t)
  for _, v in iter(t) do
    if started then
      acc = fn(acc, v)
    else
      acc = v
      started = true
    end
  end
  assert(started, "reduce of an empty table with no first value")
  return acc
end

-- - 모든 중복 값이 ​​제거된 `t` 배열의 복사본을 반환합니다.
---@param t table
function lume.unique(t)
  local rtn = {}
  for k in pairs(lume.invert(t)) do
    rtn[#rtn + 1] = k
  end
  return rtn
end

-- `t` 테이블의 각 값에 대해 `fn`을 호출합니다. `fn` 이 `true` 를 반환한 값만 포함하는 새 테이블을 반환합니다. `Retainkeys` 가 `true` 이면 테이블은 배열로 처리되지 않고 원래 키를 유지합니다.
--- ```
--      lume.filter(
--          {1, 2, 3, 4},
--              function(x) return x % 2 == 0 end
--      )
--      -> Returns {2, 4}
-- ```
---@param t table
---@param fn function
---@param retainkeys? string
function lume.filter(t, fn, retainkeys)
  fn = iteratee(fn)
  local iter = getiter(t)
  local rtn = {}
  if retainkeys then
    for k, v in iter(t) do
      if fn(v) then
        rtn[k] = v
      end
    end
  else
    for _, v in iter(t) do
      if fn(v) then
        rtn[#rtn + 1] = v
      end
    end
  end
  return rtn
end

-- - `lume.filter()` 의 반대: `t` 테이블의 각 값에 대해 `fn` 을 호출합니다. `fn` 이 `false` 를 반환한 값만 있는 새 테이블을 반환합니다. `Retainkeys` 가 `true` 이면 테이블은 배열로 처리되지 않고 원래 키를 유지합니다.
-- ```
--      lume.reject({1, 2, 3, 4}, function(x) return x % 2 == 0 end)
--      --> {1, 3}
-- ```
---@param t table
---@param fn function
---@param retainkeys? boolean
function lume.reject(t, fn, retainkeys)
  fn = iteratee(fn)
  local iter = getiter(t)
  local rtn = {}
  if retainkeys then
    for k, v in iter(t) do
      if not fn(v) then
        rtn[k] = v
      end
    end
  else
    for _, v in iter(t) do
      if not fn(v) then
        rtn[#rtn + 1] = v
      end
    end
  end
  return rtn
end

-- 주어진 모든 테이블이 함께 병합된 새 테이블을 반환합니다. 키가 여러 테이블에 있는 경우 맨 오른쪽 테이블의 값이 사용됩니다.
-- ```
-- lume.merge({a=1, b=2, c=3}, {c=8, d=9})
-- --> {a=1, b=2, c=8, d=9}
-- ```
function lume.merge(...)
  local rtn = {}
  for i = 1, select("#", ...) do
    local t = select(i, ...)
    local iter = getiter(t)
    for k, v in iter(t) do
      rtn[k] = v
    end
  end
  return rtn
end

-- 주어진 모든 배열이 하나로 연결된 새 배열을 반환합니다.
-- ```
-- lume.concat({1, 2}, {3, 4}, {5, 6})
-- --> {1, 2, 3, 4, 5, 6}
-- ```
function lume.concat(...)
  local rtn = {}
  for i = 1, select("#", ...) do
    local t = select(i, ...)
    if t ~= nil then
      local iter = getiter(t)
      for _, v in iter(t) do
        rtn[#rtn + 1] = v
      end
    end
  end
  return rtn
end

-- `t` 에 있는 값의 인덱스/키를 반환합니다. 해당 값이 테이블에 없으면 `nil` 을 반환합니다.
-- ```
--  lume.find({"a", "b", "c"}, "b")
--      --> 2
-- ```
function lume.find(t, value)
  local iter = getiter(t)
  for k, v in iter(t) do
    if v == value then
      return k
    end
  end
  return nil
end

-- `fn` 이 호출될 때 `true` 를 반환하는 테이블 `t` 에 있는 값의 값과 키를 반환합니다. 그러한 값이 없으면 `nil` 을 반환합니다.
-- ```
--  lume.match({1, 5, 8, 7}, function(x) return x % 2 == 0 end)
--      --> 8, 3
-- ```
function lume.match(t, fn)
  fn = iteratee(fn)
  local iter = getiter(t)
  for k, v in iter(t) do
    if fn(v) then
      return v, k
    end
  end
  return nil
end

-- 테이블 `t` 에 있는 값의 수를 계산합니다. `fn` 함수가 제공되면 각 값에 대해 호출되고 `true` 를 반환하는 횟수가 계산됩니다.
-- ```
-- lume.count({a = 2, b = 3, c = 4, d = 5})
--      --> 4
-- lume.count({1, 2, 4, 6}, function(x) return x % 2 == 0 end)
--      --> 3
-- ```
function lume.count(t, fn)
  local count = 0
  local iter = getiter(t)
  if fn then
    fn = iteratee(fn)
    for _, v in iter(t) do
      if fn(v) then
        count = count + 1
      end
    end
  else
    if lume.isarray(t) then
      return #t
    end
    for _ in iter(t) do
      count = count + 1
    end
  end
  return count
end

-- `Lua` 의 `string.sub` 동작을 모방하지만 문자열이 아닌 배열에서 작동합니다. 주어진 슬라이스의 새 배열을 만들고 반환합니다.
-- ```
-- lume.slice({"a", "b", "c", "d", "e"}, 2, 4)
--      --> {"b", "c", "d"}
-- ```
function lume.slice(t, i, j)
  i = i and absindex(#t, i) or 1
  j = j and absindex(#t, j) or #t
  local rtn = {}
  for x = i < 1 and 1 or i, j > #t and #t or j do
    rtn[#rtn + 1] = t[x]
  end
  return rtn
end

-- 배열의 첫 번째 요소를 반환하거나 배열이 비어 있으면 `nil` 을 반환합니다. `n` 이 지정되면 처음 `n` 개 요소의 배열이 반환됩니다.
-- ```
-- lume.first({"a", "b", "c"})
--      --> "a"
-- ```
function lume.first(t, n)
  if not n then
    return t[1]
  end
  return lume.slice(t, 1, n)
end

-- 배열의 마지막 요소를 반환하거나 배열이 비어 있으면 `nil` 을 반환합니다. `n` 이 지정되면 마지막 `n` 개 요소의 배열이 반환됩니다.
-- ```
-- lume.last({"a", "b", "c"})
--      --> "c"
-- ```
function lume.last(t, n)
  if not n then
    return t[#t]
  end
  return lume.slice(t, -n, -1)
end

-- 키가 값이 되고 값이 키로 된 테이블의 복사본을 반환합니다.
-- ```
-- lume.invert({a = "x", b = "y"})
--      --> {x = "a", y = "b"}
-- ```
function lume.invert(t)
  local rtn = {}
  for k, v in pairs(t) do
    rtn[v] = k
  end
  return rtn
end

-- 주어진 키에 대한 값만 포함하도록 필터링된 테이블의 복사본을 반환합니다.
-- ```
-- lume.pick({ a = 1, b = 2, c = 3 }, "a", "c")
--      --> { a = 1, c = 3 }
-- ```
function lume.pick(t, ...)
  local rtn = {}
  for i = 1, select("#", ...) do
    local k = select(i, ...)
    rtn[k] = t[k]
  end
  return rtn
end

-- 테이블의 각 키를 포함하는 배열을 반환합니다.
function lume.keys(t)
  local rtn = {}
  local iter = getiter(t)
  for k in iter(t) do
    rtn[#rtn + 1] = k
  end
  return rtn
end

-- 테이블 `t` 의 얕은 복사본을 반환합니다.
function lume.clone(t)
  local rtn = {}
  for k, v in pairs(t) do
    rtn[k] = v
  end
  return rtn
end

-- `fn` 함수 주위에 래퍼 함수를 ​​만들고 래퍼가 호출될 때마다 지속되는 인수를 `fn` 에 자동으로 삽입합니다. 반환된 함수에 전달된 모든 인수는 `fn` 에 전달된 이미 존재하는 인수 뒤에 삽입됩니다.
-- ```
-- local f = lume.fn(print, "Hello")
-- f("world") --> "Hello world"
-- ```
function lume.fn(fn, ...)
  assert(iscallable(fn), "expected a function as the first argument")
  local args = {...}
  return function(...)
    local a = lume.concat(args, {...})
    return fn(unpack(a))
  end
end

-- 제공된 인수를 사용하는 `fn` 에 래퍼 함수를 ​​반환합니다. 래퍼 함수는 첫 번째 호출에서 `fn` 을 호출하고 후속 호출에서는 아무 작업도 수행하지 않습니다.
-- ```
-- local f = lume.once(print, "Hello")
-- f() --> Prints "Hello"
-- f() --> Does nothing
-- ```
function lume.once(fn, ...)
  local f = lume.fn(fn, ...)
  local done = false
  return function(...)
    if done then
      return
    end
    done = true
    return f(...)
  end
end

local memoize_fnkey = {}
local memoize_nil = {}

-- 주어진 인수 집합에 대한 결과가 캐시되는 `fn` 에 래퍼 함수를 ​​반환합니다. `lume.memoize()` 는 계산 속도가 느린 함수에 사용할 때 유용합니다.
-- ```
-- fib = lume.memoize(function(n) return n < 2 and n or fib(n-1) + fib(n-2) end)
-- ```
function lume.memoize(fn)
  local cache = {}
  return function(...)
    local c = cache
    for i = 1, select("#", ...) do
      local a = select(i, ...) or memoize_nil
      c[a] = c[a] or {}
      c = c[a]
    end
    c[memoize_fnkey] = c[memoize_fnkey] or {fn(...)}
    return unpack(c[memoize_fnkey])
  end
end

-- `lume.combine()` 에 전달된 순서대로 제공된 각 인수를 호출하는 래퍼 함수를 ​​만듭니다. `nil` 인수는 무시됩니다. 래퍼 함수는 호출될 때 각 래핑된 함수에 자체 인수를 전달합니다.
-- ```
-- local f = lume.combine(function(a, b) print(a + b) end,
--                        function(a, b) print(a * b) end)
-- f(3, 4) -- Prints "7" then "12" on a new line
-- ```
function lume.combine(...)
  local n = select("#", ...)
  if n == 0 then
    return noop
  end
  if n == 1 then
    local fn = select(1, ...)
    if not fn then
      return noop
    end
    assert(iscallable(fn), "함수가 아니거나 nil입니다")
    return fn
  end
  local funcs = {}
  for i = 1, n do
    local fn = select(i, ...)
    if fn ~= nil then
      assert(iscallable(fn), "함수가 아니거나 nil입니다")
      funcs[#funcs + 1] = fn
    end
  end
  return function(...)
    for _, f in ipairs(funcs) do
      f(...)
    end
  end
end

-- 제공된 인수를 사용하여 주어진 함수를 호출하고 해당 값을 반환합니다. `fn` 이 `nil` 이면 아무 작업도 수행되지 않고 함수는 `nil` 을 반환합니다.
-- ```
-- lume.call(print, "Hello world")
--      --> "Hello world"
-- ```
function lume.call(fn, ...)
  if fn then
    return fn(...)
  end
end

-- 인수를 함수 `fn` 에 삽입하고 호출합니다. `fn` 함수가 실행되는 데 걸린 시간(초)과 `fn` 의 반환 값을 반환합니다.
-- ```
-- lume.time(function(x) return x end, "hello")
-- --> 0, "hello"
-- ```
function lume.time(fn, ...)
  local start = os.clock()
  local rtn = {fn(...)}
  return (os.clock() - start), unpack(rtn)
end

local lambda_cache = {}

-- 문자열 람다를 가져와서 함수를 반환합니다. `str` 은 쉼표로 구분된 매개변수의 목록이어야 하며, 그 뒤에 `->` 가 오고, 그 뒤에 평가되고 반환될 표현식이 와야 합니다.
-- ```
-- local f = lume.lambda "x,y -> 2*x+y"
-- f(10, 5) --> 25
-- ```
function lume.lambda(str)
  if not lambda_cache[str] then
    local args, body = str:match([[^([%w,_ ]-)%->(.-)$]])
    assert(args and body, "bad string lambda")
    local s = "return function(" .. args .. ")\nreturn " .. body .. "\nend"
    lambda_cache[str] = lume.dostring(s)
  end
  return lambda_cache[str]
end

local serialize

local serialize_map = {
  ["boolean"] = tostring,
  ["nil"] = tostring,
  ["string"] = function(v)
    return string.format("%q", v)
  end,
  ["number"] = function(v)
    if v ~= v then
      return "0/0" --  nan
    elseif v == 1 / 0 then
      return "1/0" --  inf
    elseif v == -1 / 0 then
      return "-1/0"
    end -- -inf
    return tostring(v)
  end,
  ["table"] = function(t, stk)
    stk = stk or {}
    if stk[t] then
      error("circular reference")
    end
    local rtn = {}
    stk[t] = true
    for k, v in pairs(t) do
      rtn[#rtn + 1] = "[" .. serialize(k, stk) .. "]=" .. serialize(v, stk)
    end
    stk[t] = nil
    return "{" .. table.concat(rtn, ",") .. "}"
  end
}

setmetatable(
  serialize_map,
  {
    __index = function(_, k)
      error("unsupported serialize type: " .. k)
    end
  }
)

serialize = function(x, stk)
  return serialize_map[type(x)](x, stk)
end

-- `lume.deserialize()` 를 사용하여 다시 로드할 수 있는 문자열로 인수 `x` 를 직렬화합니다. 부울, 숫자, 테이블 및 문자열만 직렬화할 수 있습니다. 순환 참조는 오류를 발생시킵니다. 모든 중첩 테이블은 고유 테이블로 직렬화됩니다.
-- ```
-- lume.serialize({a = "test", b = {1, 2, 3}, false})
--      --> "{[1]=false,["a"]="test",["b"]={[1]=1,[2]=2,[3]=3,},}"
-- ```
function lume.serialize(x)
  return serialize(x)
end

function lume.deserialize(str)
  return lume.dostring("return " .. str)
end

-- 문자열 `str` 에 있는 단어의 배열을 반환합니다. `sep` 가 제공되면 구분 기호로 사용되며 연속 구분 기호는 함께 그룹화되지 않고 빈 문자열을 구분합니다.
-- ```
-- lume.split("One two three")
--      --> {"One", "two", "three"}
-- lume.split("a,b,,c", ",")
--      --> {"a", "b", "", "c"}
-- ```
function lume.split(str, sep)
  if not sep then
    return lume.array(str:gmatch("([%S]+)"))
  else
    assert(sep ~= "", "empty separator")
    local psep = patternescape(sep)
    return lume.array((str .. sep):gmatch("(.-)(" .. psep .. ")"))
  end
end

-- 문자열 `str` 의 시작과 끝에서 공백을 제거하고 새 문자열을 반환합니다. `chars` 값이 설정되면 `chars` 의 문자는 공백 대신 잘립니다.
function lume.trim(str, chars)
  if not chars then
    return str:match("^[%s]*(.-)[%s]*$")
  end
  chars = patternescape(chars)
  return str:match("^[" .. chars .. "]*(.-)[" .. chars .. "]*$")
end

-- 줄당 문자 수를 제한하기 위해 줄 바꿈된 `str` 을 반환합니다. 기본적으로 제한은 `72` 입니다. `limit` 는 문자열을 전달할 때 한 줄이 너무 긴 경우 `true` 를 반환하는 함수일 수도 있습니다.
-- ```
-- lume.wordwrap("Hello world. This is a short string", 14)
-- -> "Hello world\nThis is a\nshort string"
-- ```
function lume.wordwrap(str, limit)
  limit = limit or 72
  local check
  if type(limit) == "number" then
    check = function(s)
      return #s >= limit
    end
  else
    check = limit
  end
  local rtn = {}
  local line = ""
  for word, spaces in str:gmatch("(%S+)(%s*)") do
    local s = line .. word
    if check(s) then
      table.insert(rtn, line .. "\n")
      line = word
    else
      line = s
    end
    for c in spaces:gmatch(".") do
      if c == "\n" then
        table.insert(rtn, line .. "\n")
        line = ""
      else
        line = line .. c
      end
    end
  end
  table.insert(rtn, line)
  return table.concat(rtn)
end

-- - 형식이 지정된 문자열을 반환합니다. `vars` 테이블의 키 값은 `str` 에서 "{key}" 형식을 사용하여 문자열에 삽입할 수 있습니다. 숫자 키를 사용할 수도 있습니다.
-- ```
-- lume.format("{b} hi {a}", {a = "mark", b = "Oh"})
--      --> "Oh hi mark"
-- lume.format("Hello {1}!", {"world"})
--      --> "Hello world!"
-- ```
function lume.format(str, vars)
  if not vars then
    return str
  end
  local f = function(x)
    return tostring(vars[x] or vars[tonumber(x)] or "{" .. x .. "}")
  end
  return (str:gsub("{(.-)}", f))
end

-- - 현재 파일 이름과 줄 번호를 같이 출력합니다.
-- ```
-- lume.trace("hello", 1234)
--      -> "example.lua:12: hello 1234"
-- ```
function lume.trace(...)
  local info = debug.getinfo(2, "Sl")
  local t = {info.short_src .. ":" .. info.currentline .. ":"}
  for i = 1, select("#", ...) do
    local x = select(i, ...)
    if type(x) == "number" then
      x = string.format("%g", lume.round(x, .01))
    end
    t[#t + 1] = tostring(x)
  end
  print(table.concat(t, " "))
end

-- - `str` 내부의 lua 코드를 실행합니다.
function lume.dostring(str)
  return assert(load(str))()
end

-- - 임의의 UUID 문자열을 생성합니다. [RFC 4122](https://www.ietf.org/rfc/rfc4122.txt)
function lume.uuid()
  local fn = function(x)
    local r = math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef"):sub(r, r)
  end
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

-- - 이미 로드된 모듈을 다시 로드합니다 프로그램을 다시 시작하지 않고도 코드 변경의 효과를 즉시 확인할 수 있습니다. `modname` 은 `require()` 로 모듈을 로드할 때 사용한 것과 같은 문자열이어야 합니다. 오류가 발생하면 전역 환경이 복원되고 nil과 오류 메시지가 반환됩니다.
-- ```
-- lume.hotswap("lume")
--      -> Reloads the lume module
-- assert(lume.hotswap("inexistant_module"))
--      -> Raises an error
-- ```
function lume.hotswap(modname)
  local oldglobal = lume.clone(_G)
  local updated = {}
  local function update(old, new)
    if updated[old] then
      return
    end
    updated[old] = true
    local oldmt, newmt = getmetatable(old), getmetatable(new)
    if oldmt and newmt then
      update(oldmt, newmt)
    end
    for k, v in pairs(new) do
      if type(v) == "table" then
        update(old[k], v)
      else
        old[k] = v
      end
    end
  end
  local err = nil
  local function onerror(e)
    for k in pairs(_G) do
      _G[k] = oldglobal[k]
    end
    err = lume.trim(e)
  end
  local ok, oldmod = pcall(require, modname)
  oldmod = ok and oldmod or nil
  xpcall(
    function()
      package.loaded[modname] = nil
      local newmod = require(modname)
      if type(oldmod) == "table" then
        update(oldmod, newmod)
      end
      for k, v in pairs(oldglobal) do
        if v ~= _G[k] and type(v) == "table" then
          update(v, _G[k])
          _G[k] = v
        end
      end
    end,
    onerror
  )
  package.loaded[modname] = oldmod
  if err then
    return nil, err
  end
  return oldmod
end

local ripairs_iter = function(t, i)
  i = i - 1
  local v = t[i]
  if v ~= nil then
    return i, v
  end
end

-- `ipairs()` 와 동일한 기능을 수행하지만 역순으로 반복합니다.
-- 항목을 건너뛰지 않고 반복 중에 테이블에서 항목을 제거할 수 있습니다.
-- ```
-- for i, v in lume.ripairs({ "a", "b", "c" }) do
--     print(i .. "->" .. v)
-- end
-- Prints "3->c", "2->b" and "1->a" on separate lines
-- ```
function lume.ripairs(t)
  return ripairs_iter, t, (#t + 1)
end

function lume.color(str, mul)
  mul = mul or 1
  local r, g, b, a
  r, g, b = str:match("#(%x%x)(%x%x)(%x%x)")
  if r then
    r = tonumber(r, 16) / 0xff
    g = tonumber(g, 16) / 0xff
    b = tonumber(b, 16) / 0xff
    a = 1
  elseif str:match("rgba?%s*%([%d%s%.,]+%)") then
    local f = str:gmatch("[%d.]+")
    r = (f() or 0) / 0xff
    g = (f() or 0) / 0xff
    b = (f() or 0) / 0xff
    a = f() or 1
  else
    error(("bad color string '%s'"):format(str))
  end
  return r * mul, g * mul, b * mul, a * mul
end

local chain_mt = {}
chain_mt.__index =
  lume.map(
  lume.filter(lume, iscallable, true),
  function(fn)
    return function(self, ...)
      self._value = fn(self._value, ...)
      return self
    end
  end
)
chain_mt.__index.result = function(x)
  return x._value
end

-- lume 함수를 연결시켜주는 래핑된 객체를 반환합니다. 결과 값을 반환하려면 체인의 끝에서 `result()` 함수를 호출해야 합니다.
-- ```
-- lume.chain({1, 2, 3, 4})
--   :filter(function(x) return x % 2 == 0 end)
--   :map(function(x) return -x end)
--   :result()
--      --> { -2, -4 }
-- ```
-- - - -
-- `lume` 모듈이 반환한 테이블은 호출될 때 `lume.chain()`을 호출하는 것과 같은 방식으로 작동합니다.
-- ```
-- lume({1, 2, 3}):each(print)
--      --> Prints 1, 2 then 3 on separate lines
-- ```
-- - - -
-- 여러 `lume` 함수를 사용하면 iteratee 함수 인수 대신 `테이블` , `문자열` , `nil` 을 사용할 수 있습니다.
-- 이 동작을 제공하는 함수는 `map()` , `all()` , `any()` , `filter()` , `reject()` , `match()`  및 `count()` 입니다.
-- ```
-- lume.filter({ true, true, false, true }, nil) -- { true, true, true }
-- ```
function lume.chain(value)
  return setmetatable({_value = value}, chain_mt)
end

setmetatable(
  lume,
  {
    __call = function(_, ...)
      return lume.chain(...)
    end
  }
)

return lume
