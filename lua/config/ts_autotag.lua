-- nvim-ts-autotag: type <div> and the closing </div> appears automatically;
-- rename either the opening or closing tag and the other side follows.
-- Treesitter-based, so it uses the same jsx/tsx parsers already installed
-- in config.treesitter -- nothing else to wire up.
require("nvim-ts-autotag").setup()
