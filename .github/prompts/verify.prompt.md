---
name: Verify
description: "Run the project's TypeScript typecheck and build, then fix issues caused by the current changes."
agent: agent
---
Run `npm run typecheck` and `npm run build`. If either command fails, inspect the
relevant source before making a focused fix, then rerun the failing command.
Report the commands run and their results. Do not suppress or work around
unrelated failures. Additional scope: ${input:scope:Optional scope or constraints}
