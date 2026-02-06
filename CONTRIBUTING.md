# Contributing

Thanks for contributing.

## Development

1. Install the .NET SDK version from `global.json`.
2. Restore/build/test:
   - `dotnet restore *.slnx`
   - `dotnet build *.slnx -c Release`
   - `dotnet test *.slnx -c Release`
3. Run local quality checks (optional):
   - `pre-commit run --all-files`

## Pull Requests

1. Keep changes focused and include tests for behavior changes.
2. Ensure CI is green.
3. Update docs/README when public APIs or usage changes.

## Versioning and Releases

- Releases are tag-based (`v*`) and publish NuGet packages from CI.
- For public publishing, configure `NUGET_API_KEY` repository secret.
