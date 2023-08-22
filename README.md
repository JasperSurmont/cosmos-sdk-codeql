# Cosmos-sdk-codeql

This repository contains the code, specifically, an updated query along with an additional query, as mentioned in this paper: 

Jasper Surmont, Weihong Wang and Tom Van Cutsem: **"Static Application Security Testing of Consensus-Critical Code in the Cosmos Network."** - [http://arxiv.org/abs/2308.10613]

Much of the content in this repository is built upon the [crypto-com/cosmos-sdk-codeql](https://github.com/crypto-com/cosmos-sdk-codeql) repository. The updates primarily focus on precision enhancements, substantially reducing false positives across various projects.

## Usage

Using the CodeQL CLI, you can download the query pack using:

```codeql pack download jaspersurmont/cosmos-sdk-codeql```

and afterwards use it to analyze a database:

```codeql database analyze <database> jaspersurmont/cosmos-sdk-codeql:<path>```

- `<database>`: The CodeQL database of the project you wish to analyze
- `<path>`: An optional path to a specific query

For more information, visit the [CodeQL documentation](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/publishing-and-using-codeql-packs#running-codeql-pack-download-scopepack)

## Results

The [results](https://github.com/JasperSurmont/cosmos-sdk-codeql/tree/main/results) directory contains a comparison of this query suite with [crypto-com's suite](https://github.com/crypto-com/cosmos-sdk-codeql) based on the amount of false and true positives tested on 11 Cosmos-based blockchains.
Refer to [rule-statistics.ods](./results/rule-statistics.ods) for the spreadsheet. 

For more details, the results of a specific project are located in an individual directory (like [Gaia](./results/gaia)). Use the [result-types.md](./results/result-types.md) for the explanation.

### Repositories
These are links to the repositories that were used to test the CodeQL queries on.


- [Axelar Core](https://github.com/axelarnetwork/axelar-core)
- [Osmosis](https://github.com/osmosis-labs/osmosis)
- [Gaia](https://github.com/cosmos/gaia)
- [Desmos](https://github.com/desmos-labs/desmos)
- [Dig](https://github.com/notional-labs/dig)
- [Fetch.ai](https://github.com/fetchai/fetchd)
- [Stride](https://github.com/stride-labs/stride)
- [Regen](https://github.com/regen-network/regen-ledger)
- [MediBloc](https://github.com/medibloc/panacea-core)
- [Crypto.org](https://github.com/crypto-org-chain/chain-main)
- [Jackal](https://github.com/JackalLabs/canine-chain)
