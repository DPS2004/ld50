local deeper = {
  _VERSION = "deeper v1.0.0",
  _DESCRIPTION = "A modification of deep that allows for multiple queues.",
  _URL = "https://github.com/Nikaoto/deep",
  _LICENSE = [[
  Copyright (c) 2017 Nikoloz Otiashvili
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  the above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  ]] 
}
function deeper.init()
  local deepinst = {

  }

  deepinst.execQueue = {}
  deepinst.maxIndex = 1
  deepinst.minIndex = 1

  -- for compatibility with Lua 5.1/5.2
  deepinst.unpack = rawget(table, "unpack") or unpack

  deepinst.queue = function(i, fun, ...)
    if type(i) ~= "number" then
      print("Error: deep.queue(): passed index is not a number")
      return nil
    end

    if type(fun) ~= "function" then
      print("Error: deep.queue(): passed action is not a function")
      return nil
    end

    i = helpers.round(i,true)
    

    local arg = { ... }

    if i < deepinst.minIndex then
      deepinst.minIndex = i
    elseif i > deepinst.maxIndex then
      deepinst.maxIndex = i
    end
    
    if arg and #arg > 0 then
      local t = function() return fun(deepinst.unpack(arg)) end

      if deepinst.execQueue[i] == nil then
        deepinst.execQueue[i] = { t }
      else
        table.insert(deepinst.execQueue[i], t)
      end
    else
      if deepinst.execQueue[i] == nil then
        deepinst.execQueue[i] = { fun }
      else
        table.insert(deepinst.execQueue[i], fun)
      end
    end
  end

  deepinst.execute = function()
    for i = deepinst.minIndex, deepinst.maxIndex do
      if deepinst.execQueue[i] then
        for _, fun in pairs(deepinst.execQueue[i]) do
          fun()
        end
      end
    end

    deepinst.execQueue = {}
  end

  return deepinst
end
return deeper