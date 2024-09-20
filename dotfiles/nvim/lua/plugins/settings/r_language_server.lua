local util = require 'lspconfig.util'
return {
  root_dir = function(fname)
    return util.find_git_ancestor(fname) or
    util.root_pattern("DESCRIPTION", "NAMESPACE", ".Rbuildignore", ".RProj", ".Rproj", ".rproj")(fname) or
    vim.loop.os_homedir()
  end,
}
