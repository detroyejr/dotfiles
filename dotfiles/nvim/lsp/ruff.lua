return {
  cmd = { "ruff", "server" },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  init_options = {
    settings = {
      lineLength = 79,
      organizeImports = true
    }
  }
}
