--
-- Fancy table of contents.
-- 2022, Didier Willis
-- License: MIT
-- Only processes 2 levels, e.g. parts (level 0) and chapters (level 1)
-- and display them as some braced content.
--
local base = require("packages.base")

local package = pl.class(base)
package._name = "fancytoc"

function package:_init (options)
  base._init(self, options)

  self.class:loadPackage("framebox")
  self.class:loadPackage("parbox")
  self.class:loadPackage("leaders")
  pcall(function () return self.class:loadPackage("resilient.styles") end) -- Optional
  self:registerStyles()
end

local function linkWrapper (dest, func)
  if dest and SILE.Commands["pdf:link"] then
    SILE.call("pdf:link", { dest = dest }, func)
  else
    func()
  end
end

local function getMinLevel (toc)
  local min = function (a, b) return a.level <= b.level and a or b end
  local smallest = pl.tablex.reduce(min, toc)
  return smallest.level
end

local function cancelFragile(func)
    -- Temporarilly kill footnotes and labels (fragile)
    local oldFt = SILE.Commands["footnote"]
    SILE.Commands["footnote"] = function () end
    local oldLbl = SILE.Commands["label"]
    SILE.Commands["label"] = function () end

    func()

    SILE.Commands["footnote"] = oldFt
    SILE.Commands["label"] = oldLbl
end

function package:hasStyles ()
  return self.class.packages["resilient.styles"]
end

function package:findToc (packages)
  if self._toc then return self._toc end -- memoized

  for packname, pack in pairs(packages) do
    if pack.readToc then
      SU.debug("fancytoc", "Found loadToc method in "..packname)
      self._toc = self.class.packages[packname]:readToc()
      return self._toc
    end
  end
  SU.error("Package fancytoc needs a table of contents, but it does not seem a package exposing one is loaded.")
end

function package:registerCommands ()
  self:registerCommand("fancytableofcontents", function (options, _)
    local linking = SU.boolean(options.linking, true)

    local toc = self:findToc(self.class.packages)
    if toc == false then
      SILE.call("tableofcontents:notocmessage")
      return
    end

    local start = SU.cast("integer", options.start or getMinLevel(toc))

    local root = {}
    for i = 1, #toc do
      local item = toc[i]
      local level = item.level
      if level == start then
        root[#root + 1] = { item = item, children = {} }
      elseif level == start + 1 then
        local current = root[#root]
        if current then
          current.children[#current.children +1] = item
        end
      end
    end

    SILE.settings:temporarily(function()
      SILE.settings:set("current.parindent", SILE.nodefactory.glue())
      SILE.settings:set("document.parindent", SILE.nodefactory.glue())

      cancelFragile(function ()
        -- Quick and dirty for now...
        -- TODO: We have the link only on pages, but would want it eventually on titles
        -- too, but this requires multi-line link support.
        for _, v in ipairs(root) do
          SILE.call("medskip")
          if #v.children > 0 then
            SILE.call("parbox", { valign = "middle", width = "20%lw" }, function ()
              SILE.call("raggedright", {}, function ()
                SILE.call("fancytoc:level1", { style = "fancytoc-level1" }, v.item.label)
              end)
            end)
            SILE.call("hfill")
            SILE.call("bracebox", { bracewidth = "0.8em"}, function()
              SILE.call("parbox", { valign = "middle", width = "75%lw" }, function ()
                SILE.settings:set("document.parindent", SILE.length())
                for _, c in ipairs(v.children) do
                  SILE.call("parbox", { valign = "top", strut = "rule", minimize = true, width = "80%lw" }, function ()
                    SILE.settings:set("document.lskip", SILE.length("1em"))
                    SILE.settings:set("document.rskip", SILE.nodefactory.hfillglue())
                    SILE.settings:set("document.parindent", SILE.length("-0.5em"))
                    SILE.call("fancytoc:level2", { style = "fancytoc-level2" }, c.label)
                  end)
                  SILE.call("dotfill")
                  linkWrapper(linking and c.link, function ()
                    SILE.call("fancytoc:pageno", { style = "fancytoc-pageno" }, { c.pageno })
                  end)
                  SILE.call("par")
                end
              end)
            end)
          else
            SILE.call("parbox", { valign = "top", width = "20%lw" }, function ()
              SILE.call("raggedright", {}, function ()
                SILE.call("fancytoc:level1", { style = "fancytoc-level1" }, v.item.label)
              end)
            end)
            SILE.call("dotfill")
            linkWrapper(linking and v.item.link, function ()
                SILE.call("fancytoc:pageno", { style = "fancytoc-pageno" }, { v.item.pageno })
            end)
          end
          SILE.call("par")
        end
      end)
    end)
  end, "Output a fancy table of contents.")

  self:registerCommand("fancytoc:level1", function (options, content)
    if self:hasStyles() then
      SILE.call("style:apply", { name = options.style }, content)
    else
      SILE.call("font", { features = "+smcp" }, content)
    end
  end)

  self:registerCommand("fancytoc:level2", function (options, content)
    if self:hasStyles() then
      SILE.call("style:apply", { name = options.style }, content)
    else
      SILE.process(content)
    end
  end)

  self:registerCommand("fancytoc:pageno", function (options, content)
    if self:hasStyles() then
      SILE.call("style:apply", { name = options.style }, content)
    else
      SILE.call("font", { features = "+onum" }, content)
    end
  end)
end

function package:registerStyles ()
  local styles = self:hasStyles()
  SU.debug("fancytoc", "Package fancytoc has styles: "..(styles and "Yes" or "No"))
  if not styles then return end

  styles:defineStyle("fancytoc-base", {}, {})
  styles:defineStyle("fancytoc-pageno", { inherit = "fancytoc-base" }, { font = { features = "+onum" } })
  styles:defineStyle("fancytoc-level1", { inherit = "fancytoc-base" }, { font = { features = "+smcp" } })
  styles:defineStyle("fancytoc-level2", { inherit = "fancytoc-base" }, {})
end

package.documentation = [[\begin{document}
This package defines a \autodoc:command{\fancytableofcontents}
command\footnote{As opposed to its earlier experimental implementation,
it does not any longer redefine the \autodoc:command[check=false]{\tableofcontents}
command, so the latter remains available.}; which processes only two levels of
a table of contents (by default, starting at the smallest available level).
They are displayed in a sort of fancy table of contents, side by side, with a
curly brace introducing the second level items for a given first level entry.

The default starting level may be overriden with \autodoc:parameter{start=<level>},
so you may actually use it for two other consecutive levels of your choice.

If the \autodoc:package{pdf} package is loaded before using sectioning commands,
entries in the table of contents will be active links to the relevant sections.
To disable the latter behavior, pass \autodoc:parameter{linking=false} to
the \autodoc:command{\fancytableofcontents} command.

If the \autodoc:package{resilient.styles} optional package is available,
the elements are styled with \code{fancytoc-level1}, \code{fancytoc-level2}
and \code{fancytoc-pageno} (all deriving, by default, from a common
\code{fancytoc-base} style). Otherwise, a default styling is applied.

The package does \em{not} create a table of contents. It rather assumes
some adequate package was loaded for that purpose, exposing a \code{readToc}
method to retrieve the table of contents. If none is found, an error is emitted.
\end{document}]]

return package
