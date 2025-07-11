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
  - PoCs must use the test suite provided in this repo.
  - Your submission will be marked as Insufficient if the POC is not runnable and working with the provided test suite.
  - Exception: PoC is optional (though recommended) for wardens with signal ≥ 0.68.
1. Judging phase risk adjustments (upgrades/downgrades):
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

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

# Overview

[ ⭐️ SPONSORS: add info here ]

## Links

- **Previous audits:**  Audits are in progress, and there are no finalized reports yet
  - ✅ SCOUTS: If there are multiple report links, please format them in a list.
- **Documentation:** https://docs.lido.fi/, https://github.com/lidofinance/lido-improvement-proposals/blob/develop/LIPS/lip-29.md
- **Website:** https://lido.fi/
- **X/Twitter:** https://x.com/lidofinance

---

# Scope

[ ✅ SCOUTS: add scoping and technical details here ]

### Files in scope
- ✅ This should be completed using the `metrics.md` file
- ✅ Last row of the table should be Total: SLOC
- ✅ SCOUTS: Have the sponsor review and and confirm in text the details in the section titled "Scoping Q amp; A"

*For sponsors that don't use the scoping tool: list all files in scope in the table below (along with hyperlinks) -- and feel free to add notes to emphasize areas of focus.*

| Contract | SLOC | Purpose | Libraries used |  
| ----------- | ----------- | ----------- | ----------- |
| [contracts/folder/sample.sol](https://github.com/code-423n4/repo-name/blob/contracts/folder/sample.sol) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |

### Files out of scope
✅ SCOUTS: List files/directories out of scope

# Additional context

## Areas of concern (where to focus for bugs)
- Bond accounting consitency
- No possibility to steal bond funds
- No protocol grieffing

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Main invariants

- Node Operators can not claim more rewards than distributed in the Performance Oracle report
- Node Operators can not delete deposited keys
- Add Keys operation ensures that after the keys addition all of the Node Operator's keys are covered with the bond

More invariants here - https://github.com/lidofinance/community-staking-module/blob/develop/test/helpers/InvariantAsserts.sol

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## All trusted roles in the protocol

- Lido DAO (admin functions, smart contract upgrades)
- CSM Committee multisig (EL Rewards Stealing penalty reporting and cancelation, Bond curve set, emergency contracts pause via GateSeal, end referral season in VettedGate)

More on roles here - https://hackmd.io/@lido/csm-v2-spec#Roles-to-actors-mapping

✅ SCOUTS: Please format the response above 👆 using the template below👇

| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
| Owner                          | Has superpowers                |
| Administrator                             | Can change fees                       |

✅ SCOUTS: Please format the response above 👆 so its not a wall of text and its readable.

## Running tests

git clone git@github.com:lidofinance/community-staking-module.git
cd community-staking-module
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

✅ SCOUTS: Please format the response above 👆 using the template below👇

```bash
git clone https://github.com/code-423n4/2023-08-arbitrum
git submodule update --init --recursive
cd governance
foundryup
make install
make build
make sc-election-test
```
To run code coverage
```bash
make coverage
```

✅ SCOUTS: Add a screenshot of your terminal showing the test coverage

## Miscellaneous
Employees of Lido Finance and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.


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

| File         |
| ------------ |
| ./script/DeployBase.s.sol |
| ./script/DeployCSVerifierElectra.s.sol |
| ./script/DeployHolesky.s.sol |
| ./script/DeployHoodi.s.sol |
| ./script/DeployImplementationsBase.s.sol |
| ./script/DeployImplementationsHolesky.s.sol |
| ./script/DeployImplementationsHoodi.s.sol |
| ./script/DeployImplementationsMainnet.s.sol |
| ./script/DeployLocalDevNet.s.sol |
| ./script/DeployMainnet.s.sol |
| ./script/constants/GIndices.sol |
| ./script/fork-helpers/Common.sol |
| ./script/fork-helpers/NodeOperators.s.sol |
| ./script/fork-helpers/PauseResume.s.sol |
| ./script/fork-helpers/SimulateVote.s.sol |
| ./script/utils/Common.sol |
| ./script/utils/Dummy.sol |
| ./script/utils/Json.sol |
| ./src/interfaces/IACL.sol |
| ./src/interfaces/IBurner.sol |
| ./src/interfaces/ICSAccounting.sol |
| ./src/interfaces/ICSBondCore.sol |
| ./src/interfaces/ICSBondCurve.sol |
| ./src/interfaces/ICSBondLock.sol |
| ./src/interfaces/ICSEjector.sol |
| ./src/interfaces/ICSExitPenalties.sol |
| ./src/interfaces/ICSFeeDistributor.sol |
| ./src/interfaces/ICSFeeOracle.sol |
| ./src/interfaces/ICSModule.sol |
| ./src/interfaces/ICSParametersRegistry.sol |
| ./src/interfaces/ICSStrikes.sol |
| ./src/interfaces/ICSVerifier.sol |
| ./src/interfaces/IExitTypes.sol |
| ./src/interfaces/IGateSeal.sol |
| ./src/interfaces/IGateSealFactory.sol |
| ./src/interfaces/IKernel.sol |
| ./src/interfaces/ILido.sol |
| ./src/interfaces/ILidoLocator.sol |
| ./src/interfaces/IPermissionlessGate.sol |
| ./src/interfaces/IStETH.sol |
| ./src/interfaces/IStakingModule.sol |
| ./src/interfaces/IStakingRouter.sol |
| ./src/interfaces/ITriggerableWithdrawalsGateway.sol |
| ./src/interfaces/IVEBO.sol |
| ./src/interfaces/IVettedGate.sol |
| ./src/interfaces/IVettedGateFactory.sol |
| ./src/interfaces/IWithdrawalQueue.sol |
| ./src/interfaces/IWithdrawalVault.sol |
| ./src/interfaces/IWstETH.sol |
| ./test/AssetRecoverer.t.sol |
| ./test/BaseOracle.t.sol |
| ./test/CSAccounting.t.sol |
| ./test/CSBondCore.t.sol |
| ./test/CSBondCurve.t.sol |
| ./test/CSBondLock.t.sol |
| ./test/CSEjector.t.sol |
| ./test/CSExitPenalties.t.sol |
| ./test/CSFeeDistributor.t.sol |
| ./test/CSFeeOracle.t.sol |
| ./test/CSModule.t.sol |
| ./test/CSParametersRegistry.t.sol |
| ./test/CSStrikes.t.sol |
| ./test/CSVerifier.t.sol |
| ./test/CSVerifierHistorical.t.sol |
| ./test/CSVerifierHistoricalCrossForks.t.sol |
| ./test/GIndex.t.sol |
| ./test/HashConsensus.t.sol |
| ./test/OssifiableProxy.t.sol |
| ./test/PausableUntil.t.sol |
| ./test/PermissionlessGate.t.sol |
| ./test/QueueLib.t.sol |
| ./test/SSZ.t.sol |
| ./test/SigningKeys.t.sol |
| ./test/TransientUintUintMapLib.t.sol |
| ./test/UnstructuredStorage.t.sol |
| ./test/ValidatorCountsReport.t.sol |
| ./test/Versioned.t.sol |
| ./test/VettedGate.t.sol |
| ./test/VettedGateFactory.t.sol |
| ./test/fork/deployment/PostDeployment.t.sol |
| ./test/fork/integration/ClaimInTokens.t.sol |
| ./test/fork/integration/CreateAndDeposit.sol |
| ./test/fork/integration/Ejection.t.sol |
| ./test/fork/integration/GateSeal.t.sol |
| ./test/fork/integration/Misc.t.sol |
| ./test/fork/integration/NoManagement.t.sol |
| ./test/fork/integration/Oracle.t.sol |
| ./test/fork/integration/Penalty.t.sol |
| ./test/fork/integration/RecoverTokens.t.sol |
| ./test/fork/integration/StakingRouter.t.sol |
| ./test/fork/integration/misc/Invariants.t.sol |
| ./test/fork/integration/misc/ProxyUpgrades.sol |
| ./test/fork/vote-upgrade/V2Upgrade.sol |
| ./test/helpers/ERCTestable.sol |
| ./test/helpers/Fixtures.sol |
| ./test/helpers/InvariantAsserts.sol |
| ./test/helpers/MerkleTree.sol |
| ./test/helpers/MerkleTree.t.sol |
| ./test/helpers/Permit.sol |
| ./test/helpers/Utilities.sol |
| ./test/helpers/mocks/BurnerMock.sol |
| ./test/helpers/mocks/CSAccountingMock.sol |
| ./test/helpers/mocks/CSMMock.sol |
| ./test/helpers/mocks/CSParametersRegistryMock.sol |
| ./test/helpers/mocks/CSStrikesMock.sol |
| ./test/helpers/mocks/ConsensusContractMock.sol |
| ./test/helpers/mocks/DistributorMock.sol |
| ./test/helpers/mocks/EjectorMock.sol |
| ./test/helpers/mocks/ExitPenaltiesMock.sol |
| ./test/helpers/mocks/LidoLocatorMock.sol |
| ./test/helpers/mocks/LidoMock.sol |
| ./test/helpers/mocks/ReportProcessorMock.sol |
| ./test/helpers/mocks/StETHMock.sol |
| ./test/helpers/mocks/Stub.sol |
| ./test/helpers/mocks/TWGMock.sol |
| ./test/helpers/mocks/WithdrawalQueueMock.sol |
| ./test/helpers/mocks/WstETHMock.sol |
| Totals: 117 |

