# Package

version       = "0.1.0"
author        = "djazz"
description   = "Nim bindings for libmpv"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 1.0.0"
requires "nimterop >= 0.5.7"

task examples, "Build examples":
  exec "nim c examples/simple.nim"