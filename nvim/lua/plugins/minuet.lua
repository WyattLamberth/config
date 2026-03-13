return {
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        throttle = 200,
        debounce = 150,
        request_timeout = 10,
        context_window = 4096,
        n_completions = 1,
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM",
            stream = false,
            name = "Ollama",
            end_point = "http://localhost:11434/v1/completions",
            -- end_point = "https://maple-fifth-dem-retro.trycloudflare.com/v1/completions",
            model = "qwen2.5-coder:7b",
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<A-y>"] = {
          function(cmp)
            cmp.show({ providers = { "minuet" } })
          end,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            score_offset = 8,
          },
        },
      },
    },
  },
}
