# Getting Started

[Crystal](https://crystal-lang.org/) language bindings for [Nuklear](https://github.com/Immediate-Mode-UI/Nuklear/tree/master)

## Introduction

Nuklear-cr provides a lightweight immediate-mode GUI for use with the following backends:

* SDL3-Renderer
* SDL3-OpenGL3

An immediate-mode GUI means that it does not hold the state of its widgets. Instead, 
you call the functions for the elements you want to draw, and they are drawn every frame.

```crystal
# Outside the render loop
count = 0

# Inside the render loop
nk.window("demo") do
    nk.row
    count += 1 if nk.button("Increase")
    nk.label "Count: " + count.to_s
end
```

nk.button returns true if the button was clicked during the current frame. Since everything is redrawn every frame, 
there is no need to worry about updating the value of a given label instance.

## Installation
TODO
