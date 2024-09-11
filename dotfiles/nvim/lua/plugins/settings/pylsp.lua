return {
  settings = {
    pylsp = {
      plugins = {
        black = { enable = true },
        flake8 = { enable = false },
        isort = { enable = true },
        pycodestyle = { enable = false },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        ruff = { enabled = true },
      }
    }
  }
}
