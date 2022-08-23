# fancytoc.sile

[![license](https://img.shields.io/github/license/Omikhleia/fancytoc.sile)](LICENSE)
[![Luacheck](https://img.shields.io/github/workflow/status/Omikhleia/fancytoc.sile/Luacheck?label=Luacheck&logo=Lua)](https://github.com/Omikhleia/fancytoc.sile/actions?workflow=Luacheck)
[![Luarocks](https://img.shields.io/luarocks/v/Omikhleia/fancytoc.sile?label=Luarocks&logo=Lua)](https://luarocks.org/modules/Omikhleia/fancytoc.sile)

This package for the [SILE](https://github.com/sile-typesetter/sile) typesetting
system provides an altenative way to output a table of contents, with two levels
only being used, but with nice curly braces.

![fancytoc](fancytoc.png "Fancy table of contents example")

## Installation

This package requires SILE v0.14 or upper.

Installation relies on the **luarocks** package manager.

To install the latest development version, you may use the provided “rockspec”:

```
luarocks --lua-version 5.4 install --server=https://luarocks.org/dev fancytoc.sile
```

(Adapt to your version of Lua, if need be, and refer to the SILE manual for more
detailed 3rd-party package installation information.)
