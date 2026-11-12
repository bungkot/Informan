---
name: Review
description: "Review current changes for correctness and regressions using the Reviewer custom agent."
agent: Reviewer
---
Review the current working changes against the project instructions. Report
only actionable findings, ordered by severity, with file, problem, and suggested
fix. Do not edit files. Additional scope: ${input:scope:Optional scope or constraints}
