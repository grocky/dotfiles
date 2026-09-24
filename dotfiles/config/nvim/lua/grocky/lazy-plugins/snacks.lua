-- Collection of small QoL plugins. Every module is off until enabled here.
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        -- xcodebuild.nvim renders SwiftUI/UIKit previews through this.
        image = { enabled = true },
    },
}
