-- tools.php.phpcs
--
-- Registers an nvim-lint linter for PHP using phpcs in a container
-- Streams buffer content via stdin; translates host buffer path to container
-- path for --stdin-path. Parses phpcs JSON output directly
--

--- @class PhpcsSetupOpts
--- @field runtime ComposerServiceDescriptor    Docker compose service
--- @field config_file? string                  Linter config file (default: phpcs.xml.dist)
--- @field events? string[]                     Events to tigger lint on (default: "BufWritePost", "InsertLeave")

local M = {}

local DEFAULT_CONFIG_FILE = "phpcs.xml.dist"
local DEFAULT_TRIGGER_EVENTS = { "BufWritePost", "InsertLeave" }

return M
