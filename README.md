# cosmos-sdk-codeql

Most of this repository is based on [this](https://github.com/crypto-com/cosmos-sdk-codeql) repository. This repository mainly contains updated and one additional query. The updates primarily consist of improvements to the precision, significantly reducing false positives in many projects. 

## Usage

Using the CodeQL CLI, you can download the query pack using:
```codeql pack download jaspersurmont/cosmos-sdk-codeql```

and afterwards use it to analyze a database:
```codeql database analyze <database> jaspersurmont/cosmos-sdk-cdoeql:<path>```

- `<database>`: The CodeQL database of the project you wish to analyze
- `<path>`: An optional path to a specific query

For more information, visit the [CodeQL documentation](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/publishing-and-using-codeql-packs#running-codeql-pack-download-scopepack)