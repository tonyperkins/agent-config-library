# MCP config examples

Example `.mcp.json` entries. Copy only the servers a given project actually needs into
the project's `.mcp.json`, then fill in the paths and environment variables.

## Servers included

- **filesystem** — gives the agent read/write access to a specific directory.
  Update the path argument to point at your project root.
- **github** — GitHub API access via MCP. Requires a `GITHUB_TOKEN` environment
  variable (set in your shell or `.env`, not in the JSON).

## Notes

- The `${GITHUB_TOKEN}` syntax is a placeholder — the MCP client substitutes
  environment variables at load time. Make sure the variable is set in the
  environment that launches the agent.
- Only enable servers a project actually needs. Each server expands the agent's
  attack surface and token budget.
