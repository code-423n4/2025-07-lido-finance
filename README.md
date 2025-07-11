# Lido Finance audit details
- Total Prize Pool: $103,500 in USDC
  - HM awards: up to $96,000 in USDC
    - If no valid Highs or Mediums are found, the HM pool is $0 
  - QA awards: $4,000 in USDC
  - Judge awards: $3,000 in USDC
  - Scout awards: $500 in USDC
- [Read our guidelines for more details](https://docs.code4rena.com/competitions)
- Starts July 16, 2025 20:00 UTC 
- Ends August 11, 2025 20:00 UTC 

**❗ Important notes for wardens** 
1. A coded, runnable PoC is required for all High/Medium submissions to this audit. 
  - This repo includes a basic template to run the test suite.
  - PoCs must use the test suite provided in this repo (see [PoC.t.sol](https://github.com/code-423n4/2025-07-lido-finance/blob/main/test/PoC.t.sol). Use `just test-poc` to run this test)
  - Your submission will be marked as Insufficient if the POC is not runnable and working with the provided test suite.
  - Exception: PoC is optional (though recommended) for wardens with signal ≥ 0.68.
2. Judging phase risk adjustments (upgrades/downgrades):
  - High- or Medium-risk submissions downgraded by the judge to Low-risk (QA) will be ineligible for awards.
  - Upgrading a Low-risk finding from a QA report to a Medium- or High-risk finding is not supported.
  - As such, wardens are encouraged to select the appropriate risk level carefully during the submission phase.

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2025-07-lido-finance/blob/main/4naly3er-report.md).

_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

- It is assumed that all of the roles in the contracts are assigned correctly concerning the permissions granted;
- It is assumed that ElRewardsStealing penalty is reported timely before Node Operators exit their validators and claim back bond tokens;
- It is assumed that Oracles deliver valid Merkle Trees for rewards distribution and strikes;
- Bond tokens are stored in the form of stETH. Hence, it is assumed that Node Operators accept all of the risks associated with stETH holding;

More on the Known Issues and Security Considerations here - https://hackmd.io/@lido/csm-v2-spec#Security-considerations


# Overview

Lido Community Staking Module (CSM) is a permissionless module allowing community stakers to operate Ethereum validators with lower entry costs. Stakers provide stETH bonds, serving as security collateral, and receive rewards in the form of bond rebase and staking rewards (including execution layer rewards), which are socialized across Lido’s staking modules.

More on CSM in the [docs](https://docs.lido.fi/staking-modules/csm/intro).


## Links

- **Previous audits:**  Audits are in progress, and there are no finalized reports yet
- **Documentation:** https://docs.lido.fi/, https://github.com/lidofinance/lido-improvement-proposals/blob/develop/LIPS/lip-29.md
- **Website:** https://lido.fi/
- **X/Twitter:** https://x.com/lidofinance

---

# Scope

*See [scope.txt](https://github.com/code-423n4/2025-07-lido-finance/blob/main/scope.txt)*

### Files in scope


| File   | Logic Contracts | Interfaces | nSLOC | Purpose | Libraries used |
| ------ | --------------- | ---------- | ----- | -----   | ------------ |
| /src/CSAccounting.sol | 1| **** | 412 | |@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol|
| /src/CSEjector.sol | 1| **** | 175 | |@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol|
| /src/CSExitPenalties.sol | 1| **** | 126 | |@openzeppelin/contracts/utils/math/SafeCast.sol<br>@openzeppelin/contracts/utils/math/Math.sol|
| /src/CSFeeDistributor.sol | 1| **** | 202 | |@openzeppelin/contracts/utils/cryptography/MerkleProof.sol<br>@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol|
| /src/CSFeeOracle.sol | 1| **** | 95 | ||
| /src/CSModule.sol | 1| **** | 1038 | |@openzeppelin/contracts/utils/math/Math.sol<br>@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol|
| /src/CSParametersRegistry.sol | 1| **** | 480 | |@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol<br>@openzeppelin/contracts/utils/math/SafeCast.sol|
| /src/CSStrikes.sol | 1| **** | 180 | |@openzeppelin/contracts/utils/cryptography/MerkleProof.sol<br>@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol<br>@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol|
| /src/CSVerifier.sol | 1| **** | 257 | |@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol|
| /src/PermissionlessGate.sol | 1| **** | 73 | |@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol|
| /src/VettedGate.sol | 1| **** | 249 | |@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol<br>@openzeppelin/contracts/utils/cryptography/MerkleProof.sol|
| /src/VettedGateFactory.sol | 1| **** | 24 | ||
| /src/abstract/AssetRecoverer.sol | 1| **** | 20 | ||
| /src/abstract/CSBondCore.sol | 1| **** | 180 | ||
| /src/abstract/CSBondCurve.sol | 1| **** | 181 | |@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol|
| /src/abstract/CSBondLock.sol | 1| **** | 100 | |@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol<br>@openzeppelin/contracts/utils/math/SafeCast.sol|
| /src/abstract/ExitTypes.sol | 1| **** | 6 | ||
| /src/lib/AssetRecovererLib.sol | 1| 1 | 67 | |@openzeppelin/contracts/token/ERC20/IERC20.sol<br>@openzeppelin/contracts/token/ERC721/IERC721.sol<br>@openzeppelin/contracts/token/ERC1155/IERC1155.sol<br>@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol|
| /src/lib/GIndex.sol | ****| **** | 63 | ||
| /src/lib/NOAddresses.sol | 1| 1 | 161 | ||
| /src/lib/QueueLib.sol | 1| 1 | 143 | ||
| /src/lib/SSZ.sol | 1| **** | 211 | ||
| /src/lib/SigningKeys.sol | 1| **** | 157 | ||
| /src/lib/TransientUintUintMapLib.sol | 1| **** | 47 | ||
| /src/lib/Types.sol | ****| **** | 35 | ||
| /src/lib/UnstructuredStorage.sol | 1| **** | 23 | ||
| /src/lib/ValidatorCountsReport.sol | 1| **** | 20 | ||
| /src/lib/base-oracle/BaseOracle.sol | 1| **** | 273 | |@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol<br>@openzeppelin/contracts/utils/math/SafeCast.sol|
| /src/lib/base-oracle/HashConsensus.sol | 1| **** | 716 | |@openzeppelin/contracts/utils/math/SafeCast.sol<br>@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol|
| /src/lib/base-oracle/interfaces/IConsensusContract.sol | ****| 1 | 3 | ||
| /src/lib/base-oracle/interfaces/IReportAsyncProcessor.sol | ****| 1 | 3 | ||
| /src/lib/proxy/OssifiableProxy.sol | 1| **** | 53 | |@openzeppelin/contracts/utils/StorageSlot.sol<br>@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol<br>@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol|
| /src/lib/utils/PausableUntil.sol | 1| **** | 79 | ||
| /src/lib/utils/Versioned.sol | 1| **** | 44 | ||
| **Totals** | **30** | **5** | **5896** | | |

### Files out of scope

*See [out_of_scope.txt](https://github.com/code-423n4/2025-07-lido-finance/blob/main/out_of_scope.txt)*



# Additional context

## Areas of concern (where to focus for bugs)
- Bond accounting consitency
- No possibility to steal bond funds
- No protocol grieffing


## Main invariants

- Node Operators can not claim more rewards than distributed in the Performance Oracle report
- Node Operators can not delete deposited keys
- Add Keys operation ensures that after the keys addition all of the Node Operator's keys are covered with the bond

More invariants [here](https://github.com/lidofinance/community-staking-module/blob/develop/test/helpers/InvariantAsserts.sol)


## All trusted roles in the protocol

More on roles here - https://hackmd.io/@lido/csm-v2-spec#Roles-to-actors-mapping


| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
| Lido DAO                          | admin functions, smart contract upgrades                |
| CSM Committee multisig                             | EL Rewards Stealing penalty reporting and cancelation, Bond curve set, emergency contracts pause via GateSeal, end referral season in VettedGate   |


## Running tests

- Install [Foundry tools](https://book.getfoundry.sh/getting-started/installation)

- Install [Just](https://github.com/casey/just)

> Some Linux distributions (like Arch Linux) might require additional install of [netcat (nc)](https://en.wikipedia.org/wiki/Netcat). The preferred version is OpenBSD.



```shell
git clone git@github.com:code-423n4/2025-07-lido-finance.git
cd 2025-07-lido-finance
foundryup -v 1.2.1
just deps


# Run unit tests
just test-unit

# Run integration tests

export RPC_URL=<YOUR_ETHEREUM_RPC_URL>
export DEPLOY_CONFIG=./artifacts/mainnet/deploy-mainnet.json
export CHAIN=mainnet
export ARTIFACTS_DIR=./artifacts/local/
# Alternatively, set all envs in the .env file
just test-local

# Run upgrade tests
export RPC_URL=<YOUR_ETHEREUM_RPC_URL>
export DEPLOY_CONFIG=./artifacts/mainnet/deploy-mainnet.json
export CHAIN=mainnet
export ARTIFACTS_DIR=./artifacts/local/
# Alternatively, set all envs in the .env file
just test-upgrade
```

To run code coverage
```bash
just coverage
```

Coverage table:
| File                                  | % Lines            | % Statements       | % Branches       | % Funcs           |
| ------------        | --------            | -------       | --------       | --------           |
| src/CSAccounting.sol                  | 100.00% (213/213)  | 100.00% (193/193)  | 100.00% (19/19)  | 100.00% (52/52)   |
| src/CSEjector.sol                     | 100.00% (70/70)    | 100.00% (75/75)    | 100.00% (12/12)  | 100.00% (10/10)   |
| src/CSExitPenalties.sol               | 100.00% (63/63)    | 100.00% (68/68)    | 100.00% (11/11)  | 100.00% (9/9)     |
| src/CSFeeDistributor.sol              | 100.00% (100/100)  | 100.00% (95/95)    | 100.00% (23/23)  | 100.00% (16/16)   |
| src/CSFeeOracle.sol                   | 100.00% (40/40)    | 100.00% (30/30)    | 100.00% (4/4)    | 100.00% (10/10)   |
| src/CSModule.sol                      | 100.00% (500/500)  | 100.00% (493/493)  | 100.00% (74/74)  | 100.00% (72/72)   |
| src/CSParametersRegistry.sol          | 100.00% (259/259)  | 100.00% (209/209)  | 100.00% (22/22)  | 100.00% (68/68)   |
| src/CSStrikes.sol                     | 100.00% (88/88)    | 100.00% (96/96)    | 100.00% (17/17)  | 100.00% (11/11)   |
| src/CSVerifier.sol                    | 100.00% (97/97)    | 100.00% (115/115)  | 100.00% (16/16)  | 100.00% (11/11)   |
| src/PermissionlessGate.sol            | 100.00% (19/19)    | 100.00% (14/14)    | 100.00% (2/2)    | 100.00% (5/5)     |
| src/VettedGate.sol                    | 100.00% (130/130)  | 100.00% (114/114)  | 100.00% (20/20)  | 100.00% (26/26)   |
| src/VettedGateFactory.sol             | 100.00% (8/8)      | 100.00% (6/6)      | 100.00% (1/1)    | 100.00% (2/2)     |
| src/abstract/AssetRecoverer.sol       | 100.00% (12/12)    | 100.00% (8/8)      | 100.00% (0/0)    | 100.00% (4/4)     |
| src/abstract/CSBondCore.sol           | 100.00% (106/106)  | 100.00% (113/113)  | 100.00% (12/12)  | 100.00% (19/19)   |
| src/abstract/CSBondCurve.sol          | 100.00% (106/106)  | 100.00% (112/112)  | 100.00% (17/17)  | 100.00% (17/17)   |
| src/abstract/CSBondLock.sol           | 100.00% (47/47)    | 100.00% (41/41)    | 100.00% (8/8)    | 100.00% (11/11)   |
| src/lib/AssetRecovererLib.sol         | 100.00% (19/19)    | 100.00% (16/16)    | 100.00% (1/1)    | 100.00% (5/5)     |
| src/lib/NOAddresses.sol               | 100.00% (76/76)    | 100.00% (69/69)    | 100.00% (22/22)  | 100.00% (6/6)     |
| src/lib/QueueLib.sol                  | 100.00% (46/46)    | 100.00% (42/42)    | 100.00% (7/7)    | 100.00% (5/5)     |
| src/lib/SSZ.sol                       | 95.65% (88/92)     | 95.40% (83/87)     | 69.23% (9/13)    | 100.00% (6/6)     |
| src/lib/SigningKeys.sol               | 100.00% (82/82)    | 100.00% (91/91)    | 100.00% (5/5)    | 100.00% (6/6)     |
| src/lib/TransientUintUintMapLib.sol   | 100.00% (24/24)    | 100.00% (21/21)    | 100.00% (0/0)    | 100.00% (6/6)     |
| src/lib/UnstructuredStorage.sol       | 100.00% (8/8)      | 100.00% (4/4)      | 100.00% (0/0)    | 100.00% (4/4)     |
| src/lib/ValidatorCountsReport.sol     | 100.00% (10/10)    | 100.00% (14/14)    | 100.00% (1/1)    | 100.00% (2/2)     |
| src/lib/base-oracle/BaseOracle.sol    | 100.00% (115/115)  | 100.00% (115/115)  | 100.00% (23/23)  | 100.00% (20/20)   |
| src/lib/base-oracle/HashConsensus.sol | 97.15% (341/351)   | 97.76% (349/357)   | 91.80% (56/61)   | 100.00% (56/56)   |
| src/lib/proxy/OssifiableProxy.sol     | 100.00% (27/27)    | 100.00% (23/23)    | 100.00% (2/2)    | 100.00% (10/10)   |
| src/lib/utils/PausableUntil.sol       | 100.00% (43/43)    | 100.00% (34/34)    | 100.00% (10/10)  | 100.00% (10/10)   |
| src/lib/utils/Versioned.sol           | 100.00% (21/21)    | 100.00% (20/20)    | 100.00% (4/4)    | 100.00% (6/6)     |
| Total                                 | 99.49% (2758/2772) | 99.55% (2663/2675) | 97.79% (398/407) | 100.00% (485/485) |


## Miscellaneous
Employees of Lido Finance and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.

