---
name: dotnet-format-analyzers
description: Define canonical dotnet format and analyzer verification commands, and provide scripts that generate a format/analyzer report. Use when checking formatting or Roslyn analyzers without reformatting everything.
---

# dotnet-format-analyzers

Provide canonical format/analyzer commands and a report-generating script that stays in verify mode.

## Canonical commands
Format verification:
```bash
dotnet format "$(ls *.slnx | head -n1)" --verify-no-changes
```

Analyzer verification:
```bash
dotnet format analyzers "$(ls *.slnx | head -n1)" --verify-no-changes
```

## Report script
Bash:
```bash
bash .codex/skills/dotnet-format-analyzers/scripts/run-format-analyzers.sh
```

PowerShell:
```powershell
pwsh -File .codex/skills/dotnet-format-analyzers/scripts/run-format-analyzers.ps1
```

Outputs:
- `artifacts/codex/format-report.txt`

## Targeted usage (preferred)
Never reformat the world unless explicitly asked. Prefer targeted scopes:
- Solution or project: pass a specific `.slnx` or `.csproj` path
- Files: pass one or more `--include` paths

Examples:
```bash
bash .codex/skills/dotnet-format-analyzers/scripts/run-format-analyzers.sh src/YourLibrary/YourLibrary.csproj
bash .codex/skills/dotnet-format-analyzers/scripts/run-format-analyzers.sh "$(ls *.slnx | head -n1)" --include src/YourLibrary/SomeFile.cs
```

## Notes
- Scripts run in verify mode only.
- The report captures both formatter and analyzer output for CI uploads or local triage.
