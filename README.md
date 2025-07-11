# ✨ So you want to run an audit

This `README.md` contains a set of checklists for our audit collaboration. This is your audit repo, which is used for scoping your audit and for providing information to wardens

Some of the checklists in this doc are for our scouts and some of them are for **you as the audit sponsor (⭐️)**.

---

# Repo setup

## ⭐️ Sponsor: Add code to this repo

- [ ] Create a PR to this repo with the below changes:
- [ ] Confirm that this repo is a self-contained repository with working commands that will build (at least) all in-scope contracts, and commands that will run tests producing gas reports for the relevant contracts.
- [ ] Please have final versions of contracts and documentation added/updated in this repo **no less than 48 business hours prior to audit start time.**
- [ ] Be prepared for a 🚨code freeze🚨 for the duration of the audit — important because it establishes a level playing field. We want to ensure everyone's looking at the same code, no matter when they look during the audit. (Note: this includes your own repo, since a PR can leak alpha to our wardens!)

## ⭐️ Sponsor: Repo checklist

- [ ] Modify the [Overview](#overview) section of this `README.md` file. Describe how your code is supposed to work with links to any relevant documentation and any other criteria/details that the auditors should keep in mind when reviewing. (Here are two well-constructed examples: [Ajna Protocol](https://github.com/code-423n4/2023-05-ajna) and [Maia DAO Ecosystem](https://github.com/code-423n4/2023-05-maia))
- [ ] Optional: pre-record a high-level overview of your protocol (not just specific smart contract functions). This saves wardens a lot of time wading through documentation.
- [ ] Review and confirm the details created by the Scout (technical reviewer) who was assigned to your contest. *Note: any files not listed as "in scope" will be considered out of scope for the purposes of judging, even if the file will be part of the deployed contracts.*  

---

# Lido Finance audit details
- Total Prize Pool: $103500 in USDC
  - HM awards: up to XXX XXX USDC (Notion: HM (main) pool)
    - If no valid Highs or Mediums are found, the HM pool is $0 
  - QA awards: $4000 in USDC
  - Judge awards: $3000 in USDC
  - Scout awards: $500 in USDC
  - (this line can be removed if there is no mitigation) Mitigation Review: XXX XXX USDC
- [Read our guidelines for more details](https://docs.code4rena.com/competitions)
- Starts XXX XXX XX 20:00 UTC (ex. `Starts March 22, 2023 20:00 UTC`)
- Ends XXX XXX XX 20:00 UTC (ex. `Ends March 30, 2023 20:00 UTC`)

**❗ Important notes for wardens** 
## 🐺 C4 staff: delete the PoC requirement section if not applicable - i.e. for non-Solidity/EVM audits.
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
## 🐺 C4: Begin Gist paste here (and delete this line)





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

