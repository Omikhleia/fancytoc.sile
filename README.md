# fancytoc.sile

[![license](https://img.shields.io/github/license/Omikhleia/fancytoc.sile?label=License)](LICENSE)
[![Luacheck](https://img.shields.io/github/actions/workflow/status/Omikhleia/fancytoc.sile/luacheck.yml?branch=main&label=Luacheck&logo=Lua)](https://github.com/Omikhleia/fancytoc.sile/actions?workflow=Luacheck)
[![Luarocks](https://img.shields.io/luarocks/v/Omikhleia/fancytoc.sile?label=Luarocks&logo=Lua)](https://luarocks.org/modules/Omikhleia/fancytoc.sile)

This package for the [SILE](https://github.com/sile-typesetter/sile) typesetting
system provides an alternative way to output a table of contents, with two levels
only being used, but with nice curly braces!

![fancytoc](fancytoc.png "Fancy table of contents example")

The idea for such a table of contents came from a question from Caleb Maclennan
in the SILE github repository, from a book he had seen, and I liked it so much
that I used it in [one of my books](https://sites.google.com/site/dragonbrumeux/contes-et-l%C3%A9gendes-dalmaq)
made with SILE. So here it is, now provided as an standalone package.

If the [resilient](https://luarocks.org/modules/Omikhleia/resilient.sile) collection
is installed too, then the fancy table of contents may be styled with the nice styling
specifications offered there. Otherwise, a default styling is applied (which can be
overidden by redefining some internal commands or hooks, I kept that possibility,
but, hey, you might rather want to give a try to the “resilient” classes and packages
collection.)

## Installation

This package requires SILE v0.14 or upper.

Installation relies on the **luarocks** package manager.

To install the latest development version, you may use the provided “rockspec”:

```
luarocks --lua-version 5.4 install --server=https://luarocks.org/dev fancytoc.sile
```

(Adapt to your version of Lua, if need be, and refer to the SILE manual for more
detailed 3rd-party package installation information.)

## Usage

The in-code package documentation may be useful.
A readable version of the documentation is included in the User Manual for
the [resilient.sile](https://github.com/Omikhleia/resilient.sile) collection
of classes and packages.

## License

All SILE-related code and samples in this repository are released under the MIT License, (c) 2022 Omikhleia.
