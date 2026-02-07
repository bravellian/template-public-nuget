# Bravellian Public .NET Library Template

This repository is a **template** for public NuGet libraries.

## Layout

- `src/` - packable libraries
- `tests/` - unit tests
- `assets/` - package assets (for example `nuget_logo.png`)
- `*.slnx` - solution (use this for restore/build/test/pack)

## Build and Test

```bash
dotnet restore Bravellian.Template.slnx
dotnet build Bravellian.Template.slnx -c Release
dotnet test Bravellian.Template.slnx -c Release
```

## Pack (local)

```powershell
pwsh -File scripts/pack.ps1
```

Packages are written to `./artifacts/packages` (`.nupkg` + `.snupkg`).

## Publish (NuGet.org)

1. Set repository secret `NUGET_API_KEY`.
2. Create and push a tag like `v1.2.3`.
3. The `Release (NuGet)` workflow restores/builds/tests, packs, and pushes packages.

## Public Repo Defaults Included

- `LICENSE` (Apache-2.0)
- `NOTICE` / `NOTICE.md`
- `CONTRIBUTING.md`
- `CODE_OF_CONDUCT.md`
- `AGENTS.md`

## Template Self-Test

```powershell
pwsh -File scripts/self-test-template.ps1
```
