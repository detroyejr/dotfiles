return {
  'ggml-org/llama.vim',
  init = function()
    vim.g.llama_config = {
      endpoint = "http://localhost:11434/infill",
    }
  end
}
