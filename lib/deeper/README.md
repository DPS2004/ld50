```
██████╗ ███████╗███████╗██████╗ ███████╗██████╗
██╔══██╗██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗
██║  ██║█████╗  █████╗  ██████╔╝█████╗  ██████╔╝
██║  ██║██╔══╝  ██╔══╝  ██╔═══╝ ██╔══╝  ██║██╚╗
██████╔╝███████╗███████╗██║     ███████╗██║╗██║
╚═════╝ ╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝ ╚═╝
```

**deeper** is a modification of deep that allows for multiple queues.

# Usage
Place `deeper.lua` inside your project and require it:

```lua
deeper = require "deeper"
```

### Making a new queue
```lua
newqueue = deeper.init()
```
### Queue actions
```lua
newqueue.queue(3, print, "wound!")
newqueue.queue(1, print, "It's just")
newqueue.queue(2, print, "a flesh")
```

### Execute
```lua
newqueue.execute()
```
Prints:
```
It's just
a flesh
wound!
```

# Documentation

### `deeper.init()`
Returns a queue.
```lua
newqueue = deeper.init()
```
### `[queue].queue(i, fun, ...)`
Queues a function for execution at index `i`

```lua
[queue].queue(100, print, "Hello")
-- or
[queue].queue(100, function() print("Hello") end)
```

Arguments:
* `i` `(number)` - The index of the action. Can be negative or positive.
* `fun` `(function)` - An anonymous or named function
* `...` `(*)` - The arguments of the passed named function

Usage:

* With anonymous functions: 
	```lua
	[queue].queue(30, function() hit(iron, 100) end)
	```

* With named functions: 
	```lua
	[queue].queue(30, hit, iron, 100)
	```

* With multiple functions:
	```lua
	[queue].queue(30, function()
	  hit(iron, 100)
	  strike(steel, 200)
	end)
	```
---

### `[queue].execute()`
Executes all of the queued actions

```lua
-- Will execute the actions in random order
[queue].queue(math.random(10), print, "'Tis")
[queue].queue(math.random(10), print, "but")
[queue].queue(math.random(10), print, "a")
[queue].queue(math.random(10), print, "scratch!")

[queue].execute()
```

# Examples
Deeper can do anything that deep can do, so please view the page for deep for examples.

