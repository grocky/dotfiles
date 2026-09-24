return {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("xcodebuild").setup({
            -- Optional: Set the default build configuration (default: "Debug")
            default_build_configuration = "Debug",
            -- Optional: Set the default build scheme (default: nil)
            default_build_scheme = nil,
            -- Optional: Set the default build target (default: nil)
            default_build_target = nil,
            -- Optional: Set the default build destination (default: nil)
            default_build_destination = nil,
        })
    end
}
