local M = {}

function M.build()
    local dockerfile = vim.fn.input("Dockerfile path (default: Dockerfile): ", "Dockerfile")
    if dockerfile == "" then
        dockerfile = "Dockerfile"
    end
    local image_name = vim.fn.input("Image name: ")
    if image_name == "" then
        return
    end
    require("FTerm").scratch({
        cmd = { "docker", "build", "-f", dockerfile, "-t", image_name, "." },
        hl = "Normal,FloatBorder:FzfLuaBorder",
        border = "rounded",
    })
end

function M.run()
    local image_name = vim.fn.input("Image name: ")
    if image_name == "" then
        return
    end
    require("FTerm").scratch({
        cmd = { "docker", "run", "-it", image_name },
        hl = "Normal,FloatBorder:FzfLuaBorder",
        border = "rounded",
    })
end

function M.logs()
    local container = vim.fn.input("Container name/id: ")
    if container == "" then
        return
    end
    require("FTerm").scratch({
        cmd = { "docker", "logs", "-f", container },
        hl = "Normal,FloatBorder:FzfLuaBorder",
        border = "rounded",
    })
end

function M.ps()
    require("FTerm").scratch({
        cmd = { "docker", "ps", "-a" },
        hl = "Normal,FloatBorder:FzfLuaBorder",
        border = "rounded",
    })
end

function M.exec()
    local container = vim.fn.input("Container name/id: ")
    if container == "" then
        return
    end
    local cmd = vim.fn.input("Command to run: ")
    if cmd == "" then
        return
    end
    require("FTerm").scratch({
        cmd = { "docker", "exec", "-it", container, "sh", "-c", cmd },
        hl = "Normal,FloatBorder:FzfLuaBorder",
        border = "rounded",
    })
end

return M
