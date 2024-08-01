package = "fancytoc.sile"
version = "dev-1"
source = {
  url = "git+https://github.com/Omikhleia/fancytoc.sile.git",
}
description = {
  summary = "Some fancy table of contents for the SILE typesetting system.",
  detailed = [[
    This package for the SILE typesetter provides an altenative and fancy two-level presentation
    with curly braces for a table of contents.
  ]],
  homepage = "https://github.com/Omikhleia/fancytoc.sile",
  license = "MIT",
}
dependencies = {
  "lua >= 5.1",
  "ptable.sile",
}
build = {
  type = "builtin",
  modules = {
    ["sile.packages.fancytoc"] = "packages/fancytoc/init.lua",
  }
}
