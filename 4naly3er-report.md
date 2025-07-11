# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Use ERC721A instead ERC721 | 1 |
| [GAS-2](#GAS-2) | Don't use `_msgSender()` if not supporting EIP-2771 | 4 |
| [GAS-3](#GAS-3) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 15 |
| [GAS-4](#GAS-4) | Using bools for storage incurs overhead | 6 |
| [GAS-5](#GAS-5) | Cache array length outside of loop | 14 |
| [GAS-6](#GAS-6) | For Operations that will not overflow, you could use unchecked | 375 |
| [GAS-7](#GAS-7) | Avoid contract existence checks by using low level calls | 1 |
| [GAS-8](#GAS-8) | Functions guaranteed to revert when called by normal users can be marked `payable` | 31 |
| [GAS-9](#GAS-9) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 3 |
| [GAS-10](#GAS-10) | Using `private` rather than `public` for constants, saves gas | 45 |
| [GAS-11](#GAS-11) | Use shift right/left instead of division/multiplication if possible | 6 |
| [GAS-12](#GAS-12) | `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas | 2 |
| [GAS-13](#GAS-13) | Increments/decrements can be unchecked in for-loops | 21 |
| [GAS-14](#GAS-14) | Use != 0 instead of > 0 for unsigned integer comparison | 15 |
### <a name="GAS-1"></a>[GAS-1] Use ERC721A instead ERC721
ERC721A standard, ERC721A is an improvement standard for ERC721 tokens. It was proposed by the Azuki team and used for developing their NFT collection. Compared with ERC721, ERC721A is a more gas-efficient standard to mint a lot of of NFTs simultaneously. It allows developers to mint multiple NFTs at the same gas price. This has been a great improvement due to Ethereum's sky-rocketing gas fee.

    Reference: https://nextrope.com/erc721-vs-erc721a-2/

*Instances (1)*:
```solidity
File: ./src/lib/AssetRecovererLib.sol

6: import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/AssetRecovererLib.sol)

### <a name="GAS-2"></a>[GAS-2] Don't use `_msgSender()` if not supporting EIP-2771
Use `msg.sender` if the code does not implement [EIP-2771 trusted forwarder](https://eips.ethereum.org/EIPS/eip-2771) support

*Instances (4)*:
```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

445:         if (_msgSender() != CONSENSUS_CONTRACT_POSITION.getStorageAddress()) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

963:         uint256 memberIndex = _getMemberIndex(_msgSender());

1056:         emit ReportReceived(slot, _msgSender(), report);

1107:                 _msgSender()

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

### <a name="GAS-3"></a>[GAS-3] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)
This saves **16 gas per instance.**

*Instances (15)*:
```solidity
File: ./src/CSFeeDistributor.sol

141:             distributedShares[nodeOperatorId] += sharesToDistribute;

185:                 totalClaimableShares += distributed;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSModule.sol

771:                     penaltySum += exitPenaltyInfo.delayPenalty.value;

777:                     penaltySum += exitPenaltyInfo.strikesPenalty.value;

797:                     penaltySum += DEPOSIT_SIZE - withdrawalInfo.amount;

947:                     loadedKeysCount += keysCount;

981:             _totalDepositedValidators += uint64(depositsCount);

1039:                     removed += removedPerQueue;

1051:                 totalVisited += visitedPerQueue;

1530:         no.enqueuedCount += count;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSStrikes.sol

237:             strikes += keyStrikes.data[i];

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/VettedGate.sol

390:             _referralCounts[_seasonedAddress(referrer, season)] += 1;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/abstract/CSBondCore.sol

125:             $.bondShares[nodeOperatorId] += shares;

126:             $.totalBondShares += shares;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCore.sol)

```solidity
File: ./src/abstract/CSBondLock.sol

91:             amount += lock.amount;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondLock.sol)

### <a name="GAS-4"></a>[GAS-4] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (6)*:
```solidity
File: ./src/CSModule.sol

92:     bool internal _publicRelease;

97:     mapping(uint256 noKeyIndexPacked => bool) private _isValidatorWithdrawn;

99:     mapping(uint256 noKeyIndexPacked => bool) private _isValidatorSlashed;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/VettedGate.sol

47:     mapping(address => bool) internal _consumedAddresses;

53:     bool public isReferralProgramSeasonActive;

66:     mapping(bytes32 => bool) internal _consumedReferrers;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

### <a name="GAS-5"></a>[GAS-5] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (14)*:
```solidity
File: ./src/CSAccounting.sol

120:         for (uint256 i = 1; i < bondCurvesInputs.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

151:         for (uint256 i = 0; i < keyIndices.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSModule.sol

681:         for (uint256 i; i < nodeOperatorIds.length; ++i) {

724:         for (uint256 i; i < withdrawalsInfo.length; ++i) {

1288:         for (uint256 i = 0; i < nodeOperatorIds.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

285:         for (uint256 i = 0; i < data.length; ++i) {

311:         for (uint256 i = 0; i < data.length; ++i) {

780:         for (uint256 i = 1; i < intervals.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

149:         for (uint256 i; i < pubkeys.length; ++i) {

166:         for (uint256 i; i < keyStrikesList.length; ++i) {

189:         for (uint256 i; i < leaves.length; i++) {

236:         for (uint256 i; i < keyStrikes.data.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

236:         for (uint256 i = 1; i < intervals.length; ++i) {

280:         for (uint256 i = 1; i < intervals.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

### <a name="GAS-6"></a>[GAS-6] For Operations that will not overflow, you could use unchecked

*Instances (375)*:
```solidity
File: ./src/CSAccounting.sol

5: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

7: import { CSBondCore } from "./abstract/CSBondCore.sol";

8: import { CSBondCurve } from "./abstract/CSBondCurve.sol";

9: import { CSBondLock } from "./abstract/CSBondLock.sol";

10: import { AssetRecoverer } from "./abstract/AssetRecoverer.sol";

12: import { PausableUntil } from "./lib/utils/PausableUntil.sol";

13: import { AssetRecovererLib } from "./lib/AssetRecovererLib.sol";

15: import { IStakingModule } from "./interfaces/IStakingModule.sol";

16: import { ICSModule, NodeOperatorManagementProperties } from "./interfaces/ICSModule.sol";

17: import { ICSAccounting } from "./interfaces/ICSAccounting.sol";

18: import { ICSFeeDistributor } from "./interfaces/ICSFeeDistributor.sol";

109:         assembly ("memory-safe") {

120:         for (uint256 i = 1; i < bondCurvesInputs.length; ++i) {

387:         uint256 shares = LIDO.sharesOf(address(this)) - totalBondShares();

475:         current = current + feesToDistribute;

477:         return current > required ? current - required : 0;

506:             return totalRequired > current ? totalRequired - current : 0;

574:                     ? currentShares - requiredShares

588:             nonWithdrawnKeys + additionalKeys,

595:         return requiredBondForKeys + actualLockedBond;

624:                 currentBond -= lockedBond;

630:                 currentBond + 10 wei,

635:                     ? nonWithdrawnKeys - bondedKeys

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

6: import { AccessControlEnumerable } from "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";

8: import { AssetRecoverer } from "./abstract/AssetRecoverer.sol";

9: import { ExitTypes } from "./abstract/ExitTypes.sol";

11: import { PausableUntil } from "./lib/utils/PausableUntil.sol";

12: import { SigningKeys } from "./lib/SigningKeys.sol";

14: import { ICSEjector } from "./interfaces/ICSEjector.sol";

15: import { ICSModule } from "./interfaces/ICSModule.sol";

16: import { ITriggerableWithdrawalsGateway, ValidatorData } from "./interfaces/ITriggerableWithdrawalsGateway.sol";

86:             uint256 maxKeyIndex = startFrom + keysCount;

97:             for (uint256 i = startFrom; i < maxKeyIndex; ++i) {

110:         for (uint256 i; i < keysCount; ++i) {

113:                 let keyLen := mload(pubkey) // PUBKEY_LENGTH

114:                 let offset := mul(keyLen, i) // PUBKEY_LENGTH * i

115:                 let keyPos := add(add(pubkeys, 0x20), offset) // pubkeys[offset]

116:                 mcopy(add(pubkey, 0x20), keyPos, keyLen) // pubkey = pubkeys[offset:offset+PUBKEY_LENGTH]

151:         for (uint256 i = 0; i < keyIndices.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSExitPenalties.sol

6: import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";

7: import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

9: import { ExitTypes } from "./abstract/ExitTypes.sol";

11: import { ICSAccounting } from "./interfaces/ICSAccounting.sol";

12: import { ICSExitPenalties, MarkedUint248, ExitPenaltyInfo } from "./interfaces/ICSExitPenalties.sol";

13: import { ICSModule } from "./interfaces/ICSModule.sol";

14: import { ICSParametersRegistry } from "./interfaces/ICSParametersRegistry.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSExitPenalties.sol)

```solidity
File: ./src/CSFeeDistributor.sol

6: import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

7: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

8: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

10: import { AssetRecoverer } from "./abstract/AssetRecoverer.sol";

12: import { AssetRecovererLib } from "./lib/AssetRecovererLib.sol";

14: import { ICSFeeDistributor } from "./interfaces/ICSFeeDistributor.sol";

15: import { IStETH } from "./interfaces/IStETH.sol";

140:             totalClaimableShares -= sharesToDistribute;

141:             distributedShares[nodeOperatorId] += sharesToDistribute;

158:             totalClaimableShares + distributed + rebate >

185:                 totalClaimableShares += distributed;

229:             ++distributionDataHistoryCount;

249:         return STETH.sharesOf(address(this)) - totalClaimableShares;

287:             sharesToDistribute = cumulativeFeeShares - _distributedShares;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSFeeOracle.sol

6: import { AssetRecoverer } from "./abstract/AssetRecoverer.sol";

8: import { PausableUntil } from "./lib/utils/PausableUntil.sol";

9: import { BaseOracle } from "./lib/base-oracle/BaseOracle.sol";

11: import { ICSFeeDistributor } from "./interfaces/ICSFeeDistributor.sol";

12: import { ICSStrikes } from "./interfaces/ICSStrikes.sol";

13: import { ICSFeeOracle } from "./interfaces/ICSFeeOracle.sol";

84:         assembly ("memory-safe") {

121:         ConsensusReport memory /* report */,

122:         uint256 /* prevSubmittedRefSlot */,

123:         uint256 /* prevProcessingRefSlot */

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeOracle.sol)

```solidity
File: ./src/CSModule.sol

6: import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

7: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

8: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

10: import { AssetRecoverer } from "./abstract/AssetRecoverer.sol";

12: import { IStakingModule } from "./interfaces/IStakingModule.sol";

13: import { ILidoLocator } from "./interfaces/ILidoLocator.sol";

14: import { IStETH } from "./interfaces/IStETH.sol";

15: import { ICSParametersRegistry } from "./interfaces/ICSParametersRegistry.sol";

16: import { ICSAccounting } from "./interfaces/ICSAccounting.sol";

17: import { ICSExitPenalties } from "./interfaces/ICSExitPenalties.sol";

18: import { ICSModule, NodeOperator, NodeOperatorManagementProperties, ValidatorWithdrawalInfo } from "./interfaces/ICSModule.sol";

19: import { ExitPenaltyInfo } from "./interfaces/ICSExitPenalties.sol";

21: import { PausableUntil } from "./lib/utils/PausableUntil.sol";

22: import { QueueLib, Batch } from "./lib/QueueLib.sol";

23: import { ValidatorCountsReport } from "./lib/ValidatorCountsReport.sol";

24: import { NOAddresses } from "./lib/NOAddresses.sol";

25: import { TransientUintUintMap, TransientUintUintMapLib } from "./lib/TransientUintUintMapLib.sol";

26: import { SigningKeys } from "./lib/SigningKeys.sol";

159:         assembly ("memory-safe") {

209:             ++_nodeOperatorsCount;

393:         for (uint256 i = 0; i < operatorsInReport; ++i) {

487:         for (uint256 i = 0; i < operatorsInReport; ++i) {

556:         ) * keysCount;

612:         uint32 toMigrate = uint32(Math.min(enqueued, maxDeposits - deposited));

645:         accounting().lockBondETH(nodeOperatorId, amount + additionalFine);

681:         for (uint256 i; i < nodeOperatorIds.length; ++i) {

724:         for (uint256 i; i < withdrawalsInfo.length; ++i) {

746:                 ++no.totalWithdrawnKeys;

771:                     penaltySum += exitPenaltyInfo.delayPenalty.value;

777:                     penaltySum += exitPenaltyInfo.strikesPenalty.value;

797:                     penaltySum += DEPOSIT_SIZE - withdrawalInfo.amount;

834:         uint256 /* proofSlotTimestamp */,

867:         bytes calldata /* depositCalldata */

893:                 ++priority;

916:                         no.enqueuedCount -= uint32(keysInBatch);

923:                         no.enqueuedCount -= uint32(keysCount);

926:                         item = item.setKeys(keysInBatch - keysCount);

947:                     loadedKeysCount += keysCount;

949:                     uint32 totalDepositedKeys = no.totalDepositedKeys +

961:                     uint32 newCount = no.depositableValidatorsCount -

966:                     depositsLeft -= keysCount;

980:             _depositableValidatorsCount -= uint64(depositsCount);

981:             _totalDepositedValidators += uint64(depositsCount);

1015:                 ++priority;

1037:                         totalVisited +

1039:                     removed += removedPerQueue;

1051:                 totalVisited += visitedPerQueue;

1052:                 maxItems -= visitedPerQueue;

1144:             return no.totalAddedKeys - no.totalWithdrawnKeys;

1177:         uint256 totalNonDepositedKeys = no.totalAddedKeys -

1188:                     no.totalAddedKeys -

1189:                         no.totalWithdrawnKeys -

1198:                     no.totalAddedKeys -

1199:                     no.totalWithdrawnKeys -

1284:         uint256 idsCount = limit < nodeOperatorsCount - offset

1286:             : nodeOperatorsCount - offset;

1288:         for (uint256 i = 0; i < nodeOperatorIds.length; ++i) {

1289:             nodeOperatorIds[i] = offset + i;

1296:         uint256 /* proofSlotTimestamp */,

1327:             emit NonceChanged(++_nonce);

1348:                 totalAddedKeys + keysCount - no.totalWithdrawnKeys > keysLimit

1364:                 uint32 totalVettedKeys = no.totalVettedKeys + uint32(keysCount);

1412:                 (_totalExitedValidators - totalExitedKeys) +

1431:         uint256 newCount = no.totalVettedKeys - totalDepositedKeys;

1437:             uint256 nonDeposited = no.totalAddedKeys - totalDepositedKeys;

1440:             } else if (unbondedKeys > no.totalAddedKeys - no.totalVettedKeys) {

1441:                 newCount = nonDeposited - unbondedKeys;

1447:                 uint256 nonWithdrawnValidators = totalDepositedKeys -

1451:                         ? no.targetLimit - nonWithdrawnValidators

1463:                     _depositableValidatorsCount -

1464:                     no.depositableValidatorsCount +

1491:             toEnqueue = depositable - enqueued;

1496:                 uint32 depositedAndQueued = no.totalDepositedKeys + enqueued;

1498:                     uint32 priorityDepositsLeft = maxDeposits -

1505:                     toEnqueue -= count;

1530:         no.enqueuedCount += count;

1618:             startIndex + keysCount >

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

6: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

7: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

8: import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";

10: import { ICSParametersRegistry } from "./interfaces/ICSParametersRegistry.sol";

85:         QUEUE_LEGACY_PRIORITY = queueLowestPriority - 1;

285:         for (uint256 i = 0; i < data.length; ++i) {

311:         for (uint256 i = 0; i < data.length; ++i) {

780:         for (uint256 i = 1; i < intervals.length; ++i) {

783:                     intervals[i].minKeyNumber <= intervals[i - 1].minKeyNumber

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

6: import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

7: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

8: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

10: import { ICSModule } from "./interfaces/ICSModule.sol";

11: import { ICSAccounting } from "./interfaces/ICSAccounting.sol";

12: import { ICSExitPenalties } from "./interfaces/ICSExitPenalties.sol";

13: import { ICSParametersRegistry } from "./interfaces/ICSParametersRegistry.sol";

14: import { ICSEjector } from "./interfaces/ICSEjector.sol";

15: import { ICSStrikes } from "./interfaces/ICSStrikes.sol";

149:         for (uint256 i; i < pubkeys.length; ++i) {

165:         uint256 valuePerKey = msg.value / keyStrikesList.length;

166:         for (uint256 i; i < keyStrikesList.length; ++i) {

189:         for (uint256 i; i < leaves.length; i++) {

236:         for (uint256 i; i < keyStrikes.data.length; ++i) {

237:             strikes += keyStrikes.data[i];

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/CSVerifier.sol

6: import { AccessControlEnumerable } from "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";

8: import { BeaconBlockHeader, Slot, Validator, Withdrawal } from "./lib/Types.sol";

9: import { PausableUntil } from "./lib/utils/PausableUntil.sol";

10: import { GIndex } from "./lib/GIndex.sol";

11: import { SSZ } from "./lib/SSZ.sol";

13: import { ICSVerifier } from "./interfaces/ICSVerifier.sol";

14: import { ICSModule, ValidatorWithdrawalInfo } from "./interfaces/ICSModule.sol";

25:     return uint256(amount) * 1 gwei;

386:         uint256 targetSlotShifted = targetSlot.unwrap() - CAPELLA_SLOT.unwrap();

387:         uint256 summaryIndex = targetSlotShifted / SLOTS_PER_HISTORICAL_ROOT;

394:         gI = gI.shr(summaryIndex); // historicalSummaries[summaryIndex]

399:         ); // historicalSummaries[summaryIndex].blockRoots[0]

400:         gI = gI.shr(rootIndex); // historicalSummaries[summaryIndex].blockRoots[rootIndex]

406:         return slot.unwrap() / SLOTS_PER_EPOCH;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

```solidity
File: ./src/PermissionlessGate.sol

6: import { AccessControlEnumerable } from "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";

8: import { AssetRecoverer } from "./abstract/AssetRecoverer.sol";

10: import { ICSAccounting } from "./interfaces/ICSAccounting.sol";

11: import { ICSModule, NodeOperatorManagementProperties } from "./interfaces/ICSModule.sol";

12: import { IPermissionlessGate } from "./interfaces/IPermissionlessGate.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/PermissionlessGate.sol)

```solidity
File: ./src/VettedGate.sol

6: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

7: import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

9: import { AssetRecoverer } from "./abstract/AssetRecoverer.sol";

11: import { PausableUntil } from "./lib/utils/PausableUntil.sol";

13: import { ICSAccounting } from "./interfaces/ICSAccounting.sol";

14: import { ICSModule, NodeOperatorManagementProperties } from "./interfaces/ICSModule.sol";

15: import { IVettedGate } from "./interfaces/IVettedGate.sol";

131:         season = referralProgramSeasonNumber + 1;

390:             _referralCounts[_seasonedAddress(referrer, season)] += 1;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/VettedGateFactory.sol

6: import { VettedGate } from "./VettedGate.sol";

8: import { OssifiableProxy } from "./lib/proxy/OssifiableProxy.sol";

10: import { IVettedGateFactory } from "./interfaces/IVettedGateFactory.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGateFactory.sol)

```solidity
File: ./src/abstract/AssetRecoverer.sol

6: import { AssetRecovererLib } from "../lib/AssetRecovererLib.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/AssetRecoverer.sol)

```solidity
File: ./src/abstract/CSBondCore.sol

6: import { ILidoLocator } from "../interfaces/ILidoLocator.sol";

7: import { ILido } from "../interfaces/ILido.sol";

8: import { IBurner } from "../interfaces/IBurner.sol";

9: import { IWstETH } from "../interfaces/IWstETH.sol";

10: import { IWithdrawalQueue } from "../interfaces/IWithdrawalQueue.sol";

11: import { ICSBondCore } from "../interfaces/ICSBondCore.sol";

114:         _increaseBond(nodeOperatorId, sharesAfter - sharesBefore);

125:             $.bondShares[nodeOperatorId] += shares;

126:             $.totalBondShares += shares;

153:         _unsafeReduceBond(nodeOperatorId, sharesBefore - sharesAfter);

194:         _unsafeReduceBond(nodeOperatorId, sharesBefore - sharesAfter);

274:         $.bondShares[nodeOperatorId] -= shares;

275:         $.totalBondShares -= shares;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCore.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

6: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

8: import { ICSBondCurve } from "../interfaces/ICSBondCurve.sol";

119:             if (curveId > $.bondCurves.length - 1) {

138:             if (curveId > $.bondCurves.length - 1) {

157:             uint256 high = intervals.length - 1;

159:                 uint256 mid = (low + high + 1) / 2;

161:                     high = mid - 1;

168:                 interval.minBond +

169:                 (keys - interval.minKeysCount) *

187:             uint256 high = intervals.length - 1;

189:                 uint256 mid = (low + high + 1) / 2;

191:                     high = mid - 1;

207:             if (low < intervals.length - 1) {

208:                 interval = intervals[low + 1];

209:                 if (amount > interval.minBond - interval.trend) {

210:                     return interval.minKeysCount - 1;

215:                 interval.minKeysCount +

216:                 (amount - interval.minBond) /

236:         for (uint256 i = 1; i < intervals.length; ++i) {

242:                 intervals[i].trend +

243:                 prev.minBond +

244:                 (intervals[i].minKeysCount - prev.minKeysCount - 1) *

254:             if (curveId > $.bondCurves.length - 1) {

280:         for (uint256 i = 1; i < intervals.length; ++i) {

283:                     intervals[i].minKeysCount <= intervals[i - 1].minKeysCount

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/abstract/CSBondLock.sol

6: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

7: import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";

9: import { ICSBondLock } from "../interfaces/ICSBondLock.sol";

91:             amount += lock.amount;

97:                 until: block.timestamp + $.bondLockPeriod

114:                 locked - amount,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondLock.sol)

```solidity
File: ./src/abstract/ExitTypes.sol

6: import { IExitTypes } from "../interfaces/IExitTypes.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/ExitTypes.sol)

```solidity
File: ./src/lib/AssetRecovererLib.sol

5: import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

6: import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

7: import { IERC1155 } from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

8: import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

9: import { ILido } from "../interfaces/ILido.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/AssetRecovererLib.sol)

```solidity
File: ./src/lib/GIndex.sol

49:     if ((i % w) + n >= w) {

53:     return pack(i + n, pow(self));

65:     return pack(i - n, pow(self));

76:     if (lhsMSbIndex + 1 + rhsMSbIndex > 248) {

90:     assembly ("memory-safe") {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/GIndex.sol)

```solidity
File: ./src/lib/NOAddresses.sol

5: import { NodeOperator, ICSModule } from "../interfaces/ICSModule.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/NOAddresses.sol)

```solidity
File: ./src/lib/QueueLib.sol

5: import { NodeOperator } from "../interfaces/ICSModule.sol";

6: import { TransientUintUintMap } from "./TransientUintUintMapLib.sol";

54:         ) // self.keys = keysCount

69:         ) // self.next = next

85:         item := shl(128, keysCount) // `keysCount` in [64:127]

86:         item := or(item, shl(192, nodeOperatorId)) // `nodeOperatorId` in [0:63]

149:             visited++;

167:                 no.enqueuedCount -= uint32(item.keys());

171:                     ++removed;

201:             ) // item.next = self.tail + 1;

206:             ++self.tail;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/QueueLib.sol)

```solidity
File: ./src/lib/SSZ.sol

6: import { BeaconBlockHeader, Withdrawal, Validator } from "./Types.sol";

7: import { GIndex } from "./GIndex.sol";

30:         assembly ("memory-safe") {

91:         assembly ("memory-safe") {

120:         assembly ("memory-safe") {

185:         assembly ("memory-safe") {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SSZ.sol)

```solidity
File: ./src/lib/SigningKeys.sol

7: import { IStakingModule } from "../interfaces/IStakingModule.sol";

38:         if (keysCount == 0 || startIndex + keysCount > type(uint32).max) {

43:                 pubkeys.length != keysCount * PUBKEY_LENGTH ||

44:                 signatures.length != keysCount * SIGNATURE_LENGTH

60:                 let _ofs := add(pubkeys.offset, mul(i, 48)) // PUBKEY_LENGTH = 48

61:                 let _part1 := calldataload(_ofs) // bytes 0..31

62:                 let _part2 := calldataload(add(_ofs, 0x10)) // bytes 16..47

64:                 mstore(add(tmpKey, 0x30), _part2) // store 2nd part first

65:                 mstore(add(tmpKey, 0x20), _part1) // store 1st part with overwrite bytes 16-31

74:                 sstore(curOffset, mload(add(tmpKey, 0x20))) // store bytes 0..31

75:                 sstore(add(curOffset, 1), shl(128, mload(add(tmpKey, 0x30)))) // store bytes 32..47

77:                 let _ofs := add(signatures.offset, mul(i, 96)) // SIGNATURE_LENGTH = 96

103:             startIndex + keysCount > totalKeysCount ||

115:             for (uint256 i = startIndex + keysCount; i > startIndex; ) {

118:                     i - 1

125:                     ) // bytes 16..47

126:                     mstore(add(tmpKey, 0x20), sload(curOffset)) // bytes 0..31

131:                         totalKeysCount - 1

180:                 startIndex + i

184:                 let _ofs := add(add(pubkeys, 0x20), mul(add(bufOffset, i), 48)) // PUBKEY_LENGTH = 48

185:                 mstore(add(_ofs, 0x10), shr(128, sload(add(curOffset, 1)))) // bytes 16..47

186:                 mstore(_ofs, sload(curOffset)) // bytes 0..31

188:                 _ofs := add(add(signatures, 0x20), mul(add(bufOffset, i), 96)) // SIGNATURE_LENGTH = 96

204:         pubkeys = new bytes(keysCount * PUBKEY_LENGTH);

208:                 startIndex + i

212:                 let offset := add(add(pubkeys, 0x20), mul(i, 48)) // PUBKEY_LENGTH = 48

213:                 mstore(add(offset, 0x10), shr(128, sload(add(curOffset, 1)))) // bytes 16..47

214:                 mstore(offset, sload(curOffset)) // bytes 0..31

224:             new bytes(count * PUBKEY_LENGTH),

225:             new bytes(count * SIGNATURE_LENGTH)

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SigningKeys.sol)

```solidity
File: ./src/lib/TransientUintUintMapLib.sol

17:         assembly ("memory-safe") {

32:         assembly ("memory-safe") {

46:         assembly ("memory-safe") {

56:         assembly ("memory-safe") {

64:         assembly ("memory-safe") {

75:         assembly ("memory-safe") {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/TransientUintUintMapLib.sol)

```solidity
File: ./src/lib/ValidatorCountsReport.sol

14:             counts.length / 16 != ids.length / 8 ||

21:         return ids.length / 8;

30:         assembly ("memory-safe") {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/ValidatorCountsReport.sol)

```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

5: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

6: import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";

8: import { UnstructuredStorage } from "../UnstructuredStorage.sol";

9: import { Versioned } from "../utils/Versioned.sol";

11: import { IReportAsyncProcessor } from "./interfaces/IReportAsyncProcessor.sol";

12: import { IConsensusContract } from "./interfaces/IConsensusContract.sol";

331:     ) internal virtual {} // solhint-disable-line no-empty-blocks

451:         return block.timestamp; // solhint-disable-line not-rely-on-time

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

5: import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";

6: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

8: import { IReportAsyncProcessor } from "./interfaces/IReportAsyncProcessor.sol";

9: import { IConsensusContract } from "./interfaces/IConsensusContract.sol";

413:                 _isFastLaneMember(index1b - 1, _getCurrentFrame().index);

548:         for (uint256 i = 0; i < variantsLength; ++i) {

597:                 --index;

598:             } // convert to 0-based

617:                     slot > frame.refSlot + _frameConfig.fastLaneLengthSlots;

656:         if (fastLaneLengthSlots > epochsPerFrame * SLOTS_PER_EPOCH) {

702:         uint256 nextFrameStartSlot = frameStartSlot +

703:             config.epochsPerFrame *

709:                 refSlot: uint64(frameStartSlot - 1),

711:                     nextFrameStartSlot - 1 - DEADLINE_SLOT_OFFSET

731:         return config.initialEpoch + frameIndex * config.epochsPerFrame;

742:         return (epoch - config.initialEpoch) / config.epochsPerFrame;

749:         return GENESIS_TIME + slot * SECONDS_PER_SLOT;

755:         return (timestamp - GENESIS_TIME) / SECONDS_PER_SLOT;

760:         return slot / SLOTS_PER_EPOCH;

773:         return epoch * SLOTS_PER_EPOCH;

777:         return block.timestamp; // solhint-disable-line not-rely-on-time

794:             return uint256(index1b - 1);

820:         uint256 newTotalMembers = _memberStates.length - 1;

829:             _memberIndices1b[addrToMove] = index + 1;

848:                 --_reportVariants[memberState.lastReportVariantIndex].support;

858:             fastLaneLengthSlots > frameConfig.epochsPerFrame * SLOTS_PER_EPOCH

880:             pastEndIndex = startIndex + quorum;

901:                     flPastRight - 1,

930:         addresses = new address[](right - left);

933:         for (uint256 i = left; i < right; ++i) {

936:             uint256 k = i - left;

988:             currentSlot <= frame.refSlot + config.fastLaneLengthSlots &&

1022:             ++varIndex;

1031:                 uint256 support = --_reportVariants[prevVarIndex].support;

1032:                 if (support == _quorum - 1) {

1041:             support = ++_reportVariants[varIndex].support;

1048:             _reportVariantsLength = ++variantsLength;

1094:         if (quorum <= totalMembers / 2) {

1095:             revert QuorumTooSmall(totalMembers / 2 + 1, quorum);

1166:             return (ZERO_HASH, -1, 0);

1170:         variantIndex = -1;

1174:         for (uint256 i = 0; i < variantsLength; ++i) {

1257:     return (x + n - a) % n <= (b - a) % n;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

```solidity
File: ./src/lib/proxy/OssifiableProxy.sol

6: import { StorageSlot } from "@openzeppelin/contracts/utils/StorageSlot.sol";

7: import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

8: import { ERC1967Utils } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/proxy/OssifiableProxy.sol)

```solidity
File: ./src/lib/utils/PausableUntil.sol

5: import { UnstructuredStorage } from "../UnstructuredStorage.sol";

69:             resumeSince = block.timestamp + duration;

82:             resumeSince = pauseUntilInclusive + 1;

94:             emit Paused(resumeSince - block.timestamp);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/PausableUntil.sol)

```solidity
File: ./src/lib/utils/Versioned.sol

5: import { UnstructuredStorage } from "../UnstructuredStorage.sol";

53:         if (newVersion != getContractVersion() + 1) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/Versioned.sol)

### <a name="GAS-7"></a>[GAS-7] Avoid contract existence checks by using low level calls
Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (1)*:
```solidity
File: ./src/lib/AssetRecovererLib.sol

98:         uint256 amount = IERC1155(token).balanceOf(address(this), tokenId);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/AssetRecovererLib.sol)

### <a name="GAS-8"></a>[GAS-8] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (31)*:
```solidity
File: ./src/CSAccounting.sol

126:     function resume() external onlyRole(RESUME_ROLE) {

131:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

640:     function _onlyRecoverer() internal view override {

644:     function _onlyExistingNodeOperator(uint256 nodeOperatorId) internal view {

655:     function _onlyNodeOperatorManagerOrRewardAddresses(

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

65:     function resume() external onlyRole(RESUME_ROLE) {

70:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

238:     function _onlyNodeOperatorOwner(uint256 nodeOperatorId) internal view {

248:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSFeeDistributor.sol

311:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSFeeOracle.sol

93:     function resume() external onlyRole(RESUME_ROLE) {

98:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

151:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeOracle.sol)

```solidity
File: ./src/CSModule.sol

167:     function resume() external onlyRole(RESUME_ROLE) {

172:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

1590:     function _onlyNodeOperatorManager(

1604:     function _onlyExistingNodeOperator(uint256 nodeOperatorId) internal view {

1612:     function _onlyValidIndexRange(

1625:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSVerifier.sol

157:     function resume() external onlyRole(RESUME_ROLE) {

162:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

```solidity
File: ./src/PermissionlessGate.sol

117:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/PermissionlessGate.sol)

```solidity
File: ./src/VettedGate.sol

103:     function resume() external onlyRole(RESUME_ROLE) {

108:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

402:     function _onlyNodeOperatorOwner(uint256 nodeOperatorId) internal view {

412:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/abstract/AssetRecoverer.sol

50:     function _onlyRecoverer() internal view virtual;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/AssetRecoverer.sol)

```solidity
File: ./src/abstract/CSBondLock.sol

127:     function __CSBondLock_init(uint256 period) internal onlyInitializing {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondLock.sol)

```solidity
File: ./src/lib/proxy/OssifiableProxy.sol

56:     function proxy__ossify() external onlyAdmin {

66:     function proxy__changeAdmin(address newAdmin_) external onlyAdmin {

73:     function proxy__upgradeTo(address newImplementation_) external onlyAdmin {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/proxy/OssifiableProxy.sol)

### <a name="GAS-9"></a>[GAS-9] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)
Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (3)*:
```solidity
File: ./src/CSEjector.sol

151:         for (uint256 i = 0; i < keyIndices.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSStrikes.sol

189:         for (uint256 i; i < leaves.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/lib/QueueLib.sol

149:             visited++;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/QueueLib.sol)

### <a name="GAS-10"></a>[GAS-10] Using `private` rather than `public` for constants, saves gas
If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (45)*:
```solidity
File: ./src/CSAccounting.sol

32:     bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

33:     bytes32 public constant RESUME_ROLE = keccak256("RESUME_ROLE");

34:     bytes32 public constant MANAGE_BOND_CURVES_ROLE =

36:     bytes32 public constant SET_BOND_CURVE_ROLE =

38:     bytes32 public constant RECOVERER_ROLE = keccak256("RECOVERER_ROLE");

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

25:     bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

26:     bytes32 public constant RESUME_ROLE = keccak256("RESUME_ROLE");

27:     bytes32 public constant RECOVERER_ROLE = keccak256("RECOVERER_ROLE");

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSFeeDistributor.sol

24:     bytes32 public constant RECOVERER_ROLE = keccak256("RECOVERER_ROLE");

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSFeeOracle.sol

24:     bytes32 public constant SUBMIT_DATA_ROLE = keccak256("SUBMIT_DATA_ROLE");

27:     bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

30:     bytes32 public constant RESUME_ROLE = keccak256("RESUME_ROLE");

33:     bytes32 public constant RECOVERER_ROLE = keccak256("RECOVERER_ROLE");

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeOracle.sol)

```solidity
File: ./src/CSModule.sol

37:     bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

38:     bytes32 public constant RESUME_ROLE = keccak256("RESUME_ROLE");

39:     bytes32 public constant STAKING_ROUTER_ROLE =

41:     bytes32 public constant REPORT_EL_REWARDS_STEALING_PENALTY_ROLE =

43:     bytes32 public constant SETTLE_EL_REWARDS_STEALING_PENALTY_ROLE =

45:     bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

46:     bytes32 public constant RECOVERER_ROLE = keccak256("RECOVERER_ROLE");

47:     bytes32 public constant CREATE_NODE_OPERATOR_ROLE =

50:     uint256 public constant DEPOSIT_SIZE = 32 ether;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSVerifier.sol

35:     bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

36:     bytes32 public constant RESUME_ROLE = keccak256("RESUME_ROLE");

39:     address public constant BEACON_ROOTS =

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

```solidity
File: ./src/PermissionlessGate.sol

21:     bytes32 public constant RECOVERER_ROLE = keccak256("RECOVERER_ROLE");

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/PermissionlessGate.sol)

```solidity
File: ./src/VettedGate.sol

23:     bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

24:     bytes32 public constant RESUME_ROLE = keccak256("RESUME_ROLE");

25:     bytes32 public constant RECOVERER_ROLE = keccak256("RECOVERER_ROLE");

26:     bytes32 public constant SET_TREE_ROLE = keccak256("SET_TREE_ROLE");

27:     bytes32 public constant START_REFERRAL_SEASON_ROLE =

29:     bytes32 public constant END_REFERRAL_SEASON_ROLE =

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

42:     uint256 public constant MIN_CURVE_LENGTH = 1;

43:     uint256 public constant DEFAULT_BOND_CURVE_ID = 0;

44:     uint256 public constant MAX_CURVE_LENGTH = 100;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/abstract/ExitTypes.sol

9:     uint8 public constant VOLUNTARY_EXIT_TYPE_ID = 0;

10:     uint8 public constant STRIKES_EXIT_TYPE_ID = 1;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/ExitTypes.sol)

```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

31:     bytes32 public constant MANAGE_CONSENSUS_CONTRACT_ROLE =

36:     bytes32 public constant MANAGE_CONSENSUS_VERSION_ROLE =

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

84:     bytes32 public constant MANAGE_MEMBERS_AND_QUORUM_ROLE =

90:     bytes32 public constant DISABLE_CONSENSUS_ROLE =

95:     bytes32 public constant MANAGE_FRAME_CONFIG_ROLE =

100:     bytes32 public constant MANAGE_FAST_LANE_CONFIG_ROLE =

105:     bytes32 public constant MANAGE_REPORT_PROCESSOR_ROLE =

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

```solidity
File: ./src/lib/utils/PausableUntil.sol

14:     uint256 public constant PAUSE_INFINITELY = type(uint256).max;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/PausableUntil.sol)

### <a name="GAS-11"></a>[GAS-11] Use shift right/left instead of division/multiplication if possible
While the `DIV` / `MUL` opcode uses 5 gas, the `SHR` / `SHL` opcode only uses 3 gas. Furthermore, beware that Solidity's division operation also includes a division-by-0 prevention which is bypassed using shifting. Eventually, overflow checks are never performed for shift operations as they are done for arithmetic operations. Instead, the result is always truncated, so the calculation can be unchecked in Solidity version `0.8+`
- Use `>> 1` instead of `/ 2`
- Use `>> 2` instead of `/ 4`
- Use `<< 3` instead of `* 8`
- ...
- Use `>> 5` instead of `/ 2^5 == / 32`
- Use `<< 6` instead of `* 2^6 == * 64`

TL;DR:
- Shifting left by N is like multiplying by 2^N (Each bits to the left is an increased power of 2)
- Shifting right by N is like dividing by 2^N (Each bits to the right is a decreased power of 2)

*Saves around 2 gas + 20 for unchecked per instance*

*Instances (6)*:
```solidity
File: ./src/abstract/CSBondCurve.sol

159:                 uint256 mid = (low + high + 1) / 2;

189:                 uint256 mid = (low + high + 1) / 2;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/lib/ValidatorCountsReport.sol

14:             counts.length / 16 != ids.length / 8 ||

21:         return ids.length / 8;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/ValidatorCountsReport.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

1094:         if (quorum <= totalMembers / 2) {

1095:             revert QuorumTooSmall(totalMembers / 2 + 1, quorum);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

### <a name="GAS-12"></a>[GAS-12] `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas
https://soliditydeveloper.com/bitmaps

https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/BitMaps.sol

- [BitMaps.sol#L5-L16](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/BitMaps.sol#L5-L16):

```solidity
/**
 * @dev Library for managing uint256 to bool mapping in a compact and efficient way, provided the keys are sequential.
 * Largely inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
 *
 * BitMaps pack 256 booleans across each bit of a single 256-bit slot of `uint256` type.
 * Hence booleans corresponding to 256 _sequential_ indices would only consume a single slot,
 * unlike the regular `bool` which would consume an entire slot for a single value.
 *
 * This results in gas savings in two ways:
 *
 * - Setting a zero value to non-zero only once every 256 times
 * - Accessing the same warm slot for every 256 _sequential_ indices
 */
```

*Instances (2)*:
```solidity
File: ./src/CSModule.sol

97:     mapping(uint256 noKeyIndexPacked => bool) private _isValidatorWithdrawn;

99:     mapping(uint256 noKeyIndexPacked => bool) private _isValidatorSlashed;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

### <a name="GAS-13"></a>[GAS-13] Increments/decrements can be unchecked in for-loops
In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (21)*:
```solidity
File: ./src/CSAccounting.sol

120:         for (uint256 i = 1; i < bondCurvesInputs.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

97:             for (uint256 i = startFrom; i < maxKeyIndex; ++i) {

110:         for (uint256 i; i < keysCount; ++i) {

151:         for (uint256 i = 0; i < keyIndices.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSModule.sol

393:         for (uint256 i = 0; i < operatorsInReport; ++i) {

487:         for (uint256 i = 0; i < operatorsInReport; ++i) {

681:         for (uint256 i; i < nodeOperatorIds.length; ++i) {

724:         for (uint256 i; i < withdrawalsInfo.length; ++i) {

1288:         for (uint256 i = 0; i < nodeOperatorIds.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

285:         for (uint256 i = 0; i < data.length; ++i) {

311:         for (uint256 i = 0; i < data.length; ++i) {

780:         for (uint256 i = 1; i < intervals.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

149:         for (uint256 i; i < pubkeys.length; ++i) {

166:         for (uint256 i; i < keyStrikesList.length; ++i) {

189:         for (uint256 i; i < leaves.length; i++) {

236:         for (uint256 i; i < keyStrikes.data.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

236:         for (uint256 i = 1; i < intervals.length; ++i) {

280:         for (uint256 i = 1; i < intervals.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

548:         for (uint256 i = 0; i < variantsLength; ++i) {

933:         for (uint256 i = left; i < right; ++i) {

1174:         for (uint256 i = 0; i < variantsLength; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

### <a name="GAS-14"></a>[GAS-14] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (15)*:
```solidity
File: ./src/CSAccounting.sol

339:         if (lockedAmount > 0) {

528:             permit.value > 0 &&

548:             permit.value > 0 &&

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSFeeDistributor.sol

164:         if (distributed == 0 && rebate > 0) {

168:         if (distributed > 0) {

200:         if (rebate > 0) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSModule.sol

800:             if (penaltySum > 0) {

1025:             if (removedPerQueue > 0) {

1445:         if (no.targetLimitMode > 0 && newCount > 0) {

1514:         if (toEnqueue > 0) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

282:         if (intervals.length > 0) {

308:         if (intervals.length > 0) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

144:         if (msg.value % keyStrikesList.length > 0) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

412:                 index1b > 0 &&

838:         if (memberState.lastReportRefSlot > 0) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | `require()` should be used instead of `assert()` | 2 |
| [NC-2](#NC-2) | Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked` | 1 |
| [NC-3](#NC-3) | `constant`s should be defined rather than using magic numbers | 43 |
| [NC-4](#NC-4) | Control structures do not follow the Solidity Style Guide | 86 |
| [NC-5](#NC-5) | Dangerous `while(true)` loop | 2 |
| [NC-6](#NC-6) | Functions should not be longer than 50 lines | 170 |
| [NC-7](#NC-7) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 24 |
| [NC-8](#NC-8) | Consider using named mappings | 17 |
| [NC-9](#NC-9) | `address`s shouldn't be hard-coded | 1 |
| [NC-10](#NC-10) | Take advantage of Custom Error's return value property | 237 |
| [NC-11](#NC-11) | Use Underscores for Number Literals (add an underscore every 3 digits) | 1 |
| [NC-12](#NC-12) | Constants should be defined rather than using magic numbers | 8 |
| [NC-13](#NC-13) | Variables need not be initialized to zero | 16 |
### <a name="NC-1"></a>[NC-1] `require()` should be used instead of `assert()`
Prior to solidity version 0.8.0, hitting an assert consumes the **remainder of the transaction's available gas** rather than returning it, as `require()`/`revert()` do. `assert()` should be avoided even past solidity version 0.8.0 as its [documentation](https://docs.soliditylang.org/en/v0.8.14/control-structures.html#panic-via-assert-and-error-via-require) states that "The assert function creates an error of type Panic(uint256). ... Properly functioning code should never create a Panic, not even on invalid external input. If this happens, then there is a bug in your contract which you should fix. Additionally, a require statement (or a custom error) are more friendly in terms of understanding what happened."

*Instances (2)*:
```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

822:         assert(index <= newTotalMembers);

1027:             assert(prevVarIndex < variantsLength);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

### <a name="NC-2"></a>[NC-2] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`
Solidity version 0.8.4 introduces `bytes.concat()` (vs `abi.encodePacked(<bytes>,<bytes>)`)

Solidity version 0.8.12 introduces `string.concat()` (vs `abi.encodePacked(<str>,<str>), which catches concatenation errors (in the event of a `bytes` data mixed in the concatenation)`)

*Instances (1)*:
```solidity
File: ./src/lib/SigningKeys.sol

236:                 keccak256(abi.encodePacked(position, nodeOperatorId, keyIndex))

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SigningKeys.sol)

### <a name="NC-3"></a>[NC-3] `constant`s should be defined rather than using magic numbers
Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (43)*:
```solidity
File: ./src/CSAccounting.sol

630:                 currentBond + 10 wei,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSModule.sol

1634:         return (nodeOperatorId << 128) | keyIndex;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSVerifier.sol

323:         if (!witness.slashed && gweiToWei(witness.amount) < 8 ether) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

159:                 uint256 mid = (low + high + 1) / 2;

189:                 uint256 mid = (low + high + 1) / 2;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/lib/GIndex.sol

21:     return GIndex.wrap(bytes32((gI << 8) | p));

33:     return uint256(unwrap(self)) >> 8;

76:     if (lhsMSbIndex + 1 + rhsMSbIndex > 248) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/GIndex.sol)

```solidity
File: ./src/lib/SSZ.sol

32:             let count := 8

95:             mcopy(0x00, add(offset, 32), 48)

97:             mcopy(48, 0x60, 16)

122:             let count := 8

279:                 8) |

282:                 8);

286:                 16) |

289:                 16);

293:                 32) |

296:                 32);

300:                 64) |

303:                 64);

304:         v = (v >> 128) | (v << 128);

309:         return bytes32(v ? 1 << 248 : 0);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SSZ.sol)

```solidity
File: ./src/lib/SigningKeys.sol

60:                 let _ofs := add(pubkeys.offset, mul(i, 48)) // PUBKEY_LENGTH = 48

77:                 let _ofs := add(signatures.offset, mul(i, 96)) // SIGNATURE_LENGTH = 96

78:                 sstore(add(curOffset, 2), calldataload(_ofs))

79:                 sstore(add(curOffset, 3), calldataload(add(_ofs, 0x20)))

80:                 sstore(add(curOffset, 4), calldataload(add(_ofs, 0x40)))

134:                     for (j = 0; j < 5; ) {

144:                 for (j = 0; j < 5; ) {

184:                 let _ofs := add(add(pubkeys, 0x20), mul(add(bufOffset, i), 48)) // PUBKEY_LENGTH = 48

188:                 _ofs := add(add(signatures, 0x20), mul(add(bufOffset, i), 96)) // SIGNATURE_LENGTH = 96

189:                 mstore(_ofs, sload(add(curOffset, 2)))

190:                 mstore(add(_ofs, 0x20), sload(add(curOffset, 3)))

191:                 mstore(add(_ofs, 0x40), sload(add(curOffset, 4)))

212:                 let offset := add(add(pubkeys, 0x20), mul(i, 48)) // PUBKEY_LENGTH = 48

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SigningKeys.sol)

```solidity
File: ./src/lib/ValidatorCountsReport.sol

14:             counts.length / 16 != ids.length / 8 ||

15:             ids.length % 8 != 0 ||

16:             counts.length % 16 != 0

21:         return ids.length / 8;

31:             nodeOperatorId := shr(192, calldataload(add(ids.offset, mul(offset, 8))))

32:             keysCount := shr(128, calldataload(add(counts.offset, mul(offset, 16))))

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/ValidatorCountsReport.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

1094:         if (quorum <= totalMembers / 2) {

1095:             revert QuorumTooSmall(totalMembers / 2 + 1, quorum);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

### <a name="NC-4"></a>[NC-4] Control structures do not follow the Solidity Style Guide
See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (86)*:
```solidity
File: ./src/CSAccounting.sol

196:         _unwrapStETHPermitIfRequired(from, permit);

207:         _unwrapStETHPermitIfRequired(msg.sender, permit);

219:         _unwrapWstETHPermitIfRequired(from, permit);

230:         _unwrapWstETHPermitIfRequired(msg.sender, permit);

523:     function _unwrapStETHPermitIfRequired(

527:         if (

543:     function _unwrapWstETHPermitIfRequired(

547:         if (

645:         if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

87:             if (

194:         if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSFeeDistributor.sol

157:         if (

271:         bool isValid = MerkleProof.verifyCalldata(

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSFeeOracle.sol

142:         if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeOracle.sol)

```solidity
File: ./src/CSModule.sol

45:     bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

236:         if (

451:             incrementNonceIfUpdated: false

522:                 incrementNonceIfUpdated: false

573:             incrementNonceIfUpdated: false

582:             incrementNonceIfUpdated: true

656:             incrementNonceIfUpdated: true

673:             incrementNonceIfUpdated: true

694:                     incrementNonceIfUpdated: true

714:             incrementNonceIfUpdated: true

785:             if (

810:                 incrementNonceIfUpdated: false

1180:         if (

1347:             if (

1384:             incrementNonceIfUpdated: false

1426:         bool incrementNonceIfUpdated

1617:         if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

106:         _setDefaultStrikesParams(data.strikesLifetime, data.strikesThreshold);

163:         uint256 lifetime,

166:         _setDefaultStrikesParams(lifetime, threshold);

328:         uint256 lifetime,

331:         _validateStrikesParams(lifetime, threshold);

333:             lifetime.toUint32(),

336:         emit StrikesParamsSet(curveId, lifetime, threshold);

531:                 defaultStrikesParams.lifetime,

535:         return (params.lifetime, params.threshold);

561:         if (

660:         uint256 lifetime,

663:         _validateStrikesParams(lifetime, threshold);

665:             lifetime: lifetime.toUint32(),

668:         emit DefaultStrikesParamsSet(lifetime, threshold);

730:         if (

742:         uint256 lifetime,

782:                 if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

182:     function verifyProof(

194:             MerkleProof.multiProofVerifyCalldata(

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/CSVerifier.sol

13: import { ICSVerifier } from "./interfaces/ICSVerifier.sol";

133:         GI_FIRST_WITHDRAWAL_PREV = gindices.gIFirstWithdrawalPrev;

134:         GI_FIRST_WITHDRAWAL_CURR = gindices.gIFirstWithdrawalCurr;

136:         GI_FIRST_VALIDATOR_PREV = gindices.gIFirstValidatorPrev;

137:         GI_FIRST_VALIDATOR_CURR = gindices.gIFirstValidatorCurr;

140:             .gIFirstHistoricalSummaryPrev;

142:             .gIFirstHistoricalSummaryCurr;

145:             .gIFirstBlockRootInSummaryPrev;

147:             .gIFirstBlockRootInSummaryCurr;

386:         uint256 targetSlotShifted = targetSlot.unwrap() - CAPELLA_SLOT.unwrap();

387:         uint256 summaryIndex = targetSlotShifted / SLOTS_PER_HISTORICAL_ROOT;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

```solidity
File: ./src/VettedGate.sol

146:         if (

330:     function verifyProof(

334:         return MerkleProof.verifyCalldata(proof, treeRoot, hashLeaf(member));

385:         if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/VettedGateFactory.sol

8: import { OssifiableProxy } from "./lib/proxy/OssifiableProxy.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGateFactory.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

265:         if (

282:                 if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/lib/SSZ.sol

177:     function verifyProof(

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SSZ.sol)

```solidity
File: ./src/lib/SigningKeys.sol

42:             if (

101:         if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SigningKeys.sol)

```solidity
File: ./src/lib/ValidatorCountsReport.sol

13:         if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/ValidatorCountsReport.sol)

```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

213:         if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

666:         if (

842:             if (

857:         if (

987:         if (

1071:         if (

1125:         if (

1212:         if (

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

```solidity
File: ./src/lib/proxy/OssifiableProxy.sol

13:     event ProxyOssified();

16:     error ProxyIsOssified();

23:             revert ProxyIsOssified();

60:         emit ProxyOssified();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/proxy/OssifiableProxy.sol)

```solidity
File: ./src/lib/utils/Versioned.sol

19:     uint256 internal constant PETRIFIED_VERSION_MARK = type(uint256).max;

30:         CONTRACT_VERSION_POSITION.setStorageUint256(PETRIFIED_VERSION_MARK);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/Versioned.sol)

### <a name="NC-5"></a>[NC-5] Dangerous `while(true)` loop
Consider using for-loops to avoid all risks of an infinite-loop situation

*Instances (2)*:
```solidity
File: ./src/CSModule.sol

885:         while (true) {

1008:         while (true) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

### <a name="NC-6"></a>[NC-6] Functions should not be longer than 50 lines
Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability 

*Instances (170)*:
```solidity
File: ./src/CSAccounting.sol

126:     function resume() external onlyRole(RESUME_ROLE) {

131:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

183:     function depositETH(uint256 nodeOperatorId) external payable whenResumed {

375:     function recoverERC20(address token, uint256 amount) external override {

397:     function getInitializedVersion() external view returns (uint64) {

482:     function feeDistributor() external view returns (ICSFeeDistributor) {

640:     function _onlyRecoverer() internal view override {

644:     function _onlyExistingNodeOperator(uint256 nodeOperatorId) internal view {

655:     function _onlyNodeOperatorManagerOrRewardAddresses(

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

65:     function resume() external onlyRole(RESUME_ROLE) {

70:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

238:     function _onlyNodeOperatorOwner(uint256 nodeOperatorId) internal view {

248:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSFeeDistributor.sol

234:     function recoverERC20(address token, uint256 amount) external override {

243:     function getInitializedVersion() external view returns (uint64) {

248:     function pendingSharesToDistribute() external view returns (uint256) {

302:     function _setRebateRecipient(address _rebateRecipient) internal {

311:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSFeeOracle.sol

80:     function finalizeUpgradeV2(uint256 consensusVersion) external {

93:     function resume() external onlyRole(RESUME_ROLE) {

98:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

129:     function _handleConsensusReportData(ReportData calldata data) internal {

141:     function _checkMsgSenderIsAllowedToSubmitData() internal view {

151:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeOracle.sol)

```solidity
File: ./src/CSModule.sol

143:     function initialize(address admin) external reinitializer(2) {

158:     function finalizeUpgradeV2() external reinitializer(2) {

167:     function resume() external onlyRole(RESUME_ROLE) {

172:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

356:     function resetNodeOperatorManagerAddress(uint256 nodeOperatorId) external {

459:     function onExitedAndStuckValidatorsCountsUpdated() external {

579:     function updateDepositableValidatorsCount(uint256 nodeOperatorId) external {

587:     function migrateToPriorityQueue(uint256 nodeOperatorId) external {

1058:     function getInitializedVersion() external view returns (uint64) {

1087:     function getType() external view returns (bytes32) {

1253:     function getNonce() external view returns (uint256) {

1258:     function getNodeOperatorsCount() external view returns (uint256) {

1263:     function getActiveNodeOperatorsCount() external view returns (uint256) {

1321:     function accounting() public view returns (ICSAccounting) {

1331:     function _addKeysAndUpdateDepositableValidatorsCount(

1477:     function _enqueueNodeOperatorKeys(uint256 nodeOperatorId) internal {

1536:     function _recordOperatorCreator(uint256 nodeOperatorId) internal {

1544:     function _forgetOperatorCreator(uint256 nodeOperatorId) internal {

1604:     function _onlyExistingNodeOperator(uint256 nodeOperatorId) internal view {

1625:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

134:     function setDefaultElRewardsStealingAdditionalFine(

622:     function getInitializedVersion() external view returns (uint64) {

626:     function _setDefaultKeyRemovalCharge(uint256 keyRemovalCharge) internal {

631:     function _setDefaultElRewardsStealingAdditionalFine(uint256 fine) internal {

636:     function _setDefaultKeysLimit(uint256 limit) internal {

641:     function _setDefaultRewardShare(uint256 share) internal {

650:     function _setDefaultPerformanceLeeway(uint256 leeway) internal {

671:     function _setDefaultBadPerformancePenalty(uint256 penalty) internal {

710:     function _setDefaultAllowedExitDelay(uint256 delay) internal {

716:     function _setDefaultExitDelayPenalty(uint256 penalty) internal {

721:     function _setDefaultMaxWithdrawalRequestFee(uint256 fee) internal {

750:     function _validateAllowedExitDelay(uint256 delay) internal pure {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

73:     function initialize(address admin, address _ejector) external initializer {

177:     function getInitializedVersion() external view returns (uint64) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/CSVerifier.sol

18: function amountWei(Withdrawal memory withdrawal) pure returns (uint256) {

24: function gweiToWei(uint64 amount) pure returns (uint256) {

157:     function resume() external onlyRole(RESUME_ROLE) {

162:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

404:     function _computeEpochAtSlot(Slot slot) internal view returns (uint256) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

```solidity
File: ./src/PermissionlessGate.sol

117:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/PermissionlessGate.sol)

```solidity
File: ./src/VettedGate.sol

103:     function resume() external onlyRole(RESUME_ROLE) {

108:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

315:     function getInitializedVersion() external view returns (uint64) {

320:     function isReferrerConsumed(address referrer) external view returns (bool) {

325:     function isConsumed(address member) public view returns (bool) {

338:     function hashLeaf(address member) public pure returns (bytes32) {

342:     function _consume(bytes32[] calldata proof) internal {

402:     function _onlyNodeOperatorOwner(uint256 nodeOperatorId) internal view {

412:     function _onlyRecoverer() internal view override {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/abstract/AssetRecoverer.sol

25:     function recoverERC20(address token, uint256 amount) external virtual {

34:     function recoverERC721(address token, uint256 tokenId) external {

43:     function recoverERC1155(address token, uint256 tokenId) external {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/AssetRecoverer.sol)

```solidity
File: ./src/abstract/CSBondCore.sol

55:     function totalBondShares() public view returns (uint256) {

67:     function getBond(uint256 nodeOperatorId) public view returns (uint256) {

72:     function _depositETH(address from, uint256 nodeOperatorId) internal {

118:     function _increaseBond(uint256 nodeOperatorId, uint256 shares) internal {

202:     function _burn(uint256 nodeOperatorId, uint256 amount) internal {

254:     function _sharesByEth(uint256 ethAmount) internal view returns (uint256) {

263:     function _ethByShares(uint256 shares) internal view returns (uint256) {

272:     function _unsafeReduceBond(uint256 nodeOperatorId, uint256 shares) private {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCore.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

47:     function getCurvesCount() external view returns (uint256) {

135:     function _setBondCurve(uint256 nodeOperatorId, uint256 curveId) internal {

222:     function _getLegacyBondCurvesLength() internal view returns (uint256) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/abstract/CSBondLock.sol

62:     function getBondLockPeriod() external view returns (uint256) {

84:     function _lock(uint256 nodeOperatorId, uint256 amount) internal {

103:     function _reduceAmount(uint256 nodeOperatorId, uint256 amount) internal {

121:     function _remove(uint256 nodeOperatorId) internal {

127:     function __CSBondLock_init(uint256 period) internal onlyInitializing {

132:     function _setBondLockPeriod(uint256 period) internal {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondLock.sol)

```solidity
File: ./src/lib/AssetRecovererLib.sol

63:     function recoverERC20(address token, uint256 amount) external {

75:     function recoverStETHShares(address lido, uint256 shares) external {

86:     function recoverERC721(address token, uint256 tokenId) external {

97:     function recoverERC1155(address token, uint256 tokenId) external {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/AssetRecovererLib.sol)

```solidity
File: ./src/lib/GIndex.sol

15: function pack(uint256 gI, uint8 p) pure returns (GIndex) {

24: function unwrap(GIndex self) pure returns (bytes32) {

28: function isRoot(GIndex self) pure returns (bool) {

32: function index(GIndex self) pure returns (uint256) {

36: function width(GIndex self) pure returns (uint256) {

45: function shr(GIndex self, uint256 n) pure returns (GIndex) {

57: function shl(GIndex self, uint256 n) pure returns (GIndex) {

69: function concat(GIndex lhs, GIndex rhs) pure returns (GIndex) {

89: function fls(uint256 x) pure returns (uint256 r) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/GIndex.sol)

```solidity
File: ./src/lib/QueueLib.sol

21: function unwrap(Batch self) pure returns (uint256) {

25: function noId(Batch self) pure returns (uint64 n) {

31: function keys(Batch self) pure returns (uint64 n) {

38: function next(Batch self) pure returns (uint128 n) {

46: function setKeys(Batch self, uint256 keysCount) pure returns (Batch) {

61: function setNext(Batch self, uint128 nextIndex) pure returns (Batch) {

210:     function dequeue(Queue storage self) internal returns (Batch item) {

220:     function peek(Queue storage self) internal view returns (Batch) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/QueueLib.sol)

```solidity
File: ./src/lib/SSZ.sol

275:     function toLittleEndian(uint256 v) internal pure returns (bytes32) {

308:     function toLittleEndian(bool v) internal pure returns (bytes32) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SSZ.sol)

```solidity
File: ./src/lib/TransientUintUintMapLib.sol

11:     function create() internal returns (TransientUintUintMap self) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/TransientUintUintMapLib.sol)

```solidity
File: ./src/lib/Types.sol

9: function unwrap(Slot slot) pure returns (uint64) {

13: function gt(Slot lhs, Slot rhs) pure returns (bool) {

17: function lt(Slot lhs, Slot rhs) pure returns (bool) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/Types.sol)

```solidity
File: ./src/lib/UnstructuredStorage.sol

11:     function setStorageAddress(bytes32 position, address data) internal {

17:     function setStorageUint256(bytes32 position, uint256 data) internal {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/UnstructuredStorage.sol)

```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

117:     function getConsensusContract() external view returns (address) {

137:     function getConsensusVersion() external view returns (uint256) {

254:     function discardConsensusReport(uint256 refSlot) external {

279:     function getLastProcessingRefSlot() external view returns (uint256) {

307:     function _isConsensusMember(address addr) internal view returns (bool) {

368:     function _startProcessing() internal returns (uint256) {

388:     function _checkProcessingDeadline(uint256 deadlineTime) internal view {

398:     function _setConsensusVersion(uint256 version) internal {

444:     function _checkSenderIsConsensusContract() internal view {

450:     function _getTime() internal view virtual returns (uint256) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

317:     function getInitialRefSlot() external view returns (uint256) {

376:     function getIsMember(address addr) external view returns (bool) {

408:     function getIsFastLaneMember(address addr) external view returns (bool) {

475:     function getQuorum() external view returns (uint256) {

495:     function getReportProcessor() external view returns (address) {

678:     function _getCurrentFrame() internal view returns (ConsensusFrame memory) {

682:     function _getInitialFrame() internal view returns (ConsensusFrame memory) {

758:     function _computeEpochAtSlot(uint256 slot) internal view returns (uint256) {

776:     function _getTime() internal view virtual returns (uint256) {

784:     function _isMember(address addr) internal view returns (bool) {

788:     function _getMemberIndex(address addr) internal view returns (uint256) {

798:     function _addMember(address addr, uint256 quorum) internal {

818:     function _removeMember(address addr, uint256 quorum) internal {

855:     function _setFastLaneLengthSlots(uint256 fastLaneLengthSlots) internal {

1082:     function _consensusNotReached(ConsensusFrame memory frame) internal {

1118:     function _checkConsensus(uint256 quorum) internal {

1191:     function _setReportProcessor(address newProcessor) internal {

1224:     function _getLastProcessingRefSlot() internal view returns (uint256) {

1240:     function _cancelReportProcessing(ConsensusFrame memory frame) internal {

1246:     function _getConsensusVersion() internal view returns (uint256) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

```solidity
File: ./src/lib/base-oracle/interfaces/IConsensusContract.sol

6:     function getIsMember(address addr) external view returns (bool);

22:     function getInitialRefSlot() external view returns (uint256);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/interfaces/IConsensusContract.sol)

```solidity
File: ./src/lib/base-oracle/interfaces/IReportAsyncProcessor.sol

49:     function discardConsensusReport(uint256 refSlot) external;

55:     function getLastProcessingRefSlot() external view returns (uint256);

65:     function getConsensusVersion() external view returns (uint256);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/interfaces/IReportAsyncProcessor.sol)

```solidity
File: ./src/lib/proxy/OssifiableProxy.sol

66:     function proxy__changeAdmin(address newAdmin_) external onlyAdmin {

73:     function proxy__upgradeTo(address newImplementation_) external onlyAdmin {

91:     function proxy__getAdmin() external view returns (address) {

97:     function proxy__getImplementation() external view returns (address) {

103:     function proxy__getIsOssified() external view returns (bool) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/proxy/OssifiableProxy.sol)

```solidity
File: ./src/lib/utils/PausableUntil.sol

42:     function getResumeSinceTimestamp() external view returns (uint256) {

74:     function _pauseUntil(uint256 pauseUntilInclusive) internal {

89:     function _setPausedState(uint256 resumeSince) internal {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/PausableUntil.sol)

```solidity
File: ./src/lib/utils/Versioned.sol

34:     function getContractVersion() public view returns (uint256) {

39:     function _initializeContractVersionTo(uint256 version) internal {

52:     function _updateContractVersion(uint256 newVersion) internal {

60:     function _checkContractVersion(uint256 version) internal view {

67:     function _setContractVersion(uint256 version) private {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/Versioned.sol)

### <a name="NC-7"></a>[NC-7] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor
If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (24)*:
```solidity
File: ./src/CSAccounting.sol

48:         if (msg.sender != address(MODULE)) {

207:         _unwrapStETHPermitIfRequired(msg.sender, permit);

230:         _unwrapWstETHPermitIfRequired(msg.sender, permit);

662:         if (no.managerAddress == msg.sender || no.rewardAddress == msg.sender) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

34:         if (msg.sender != STRIKES) {

243:         if (owner != msg.sender) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSExitPenalties.sol

27:         if (msg.sender != address(MODULE)) {

35:         if (msg.sender != STRIKES) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSExitPenalties.sol)

```solidity
File: ./src/CSFeeDistributor.sol

57:         if (msg.sender != ACCOUNTING) {

65:         if (msg.sender != ORACLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSModule.sol

1579:         if (who == msg.sender) {

1584:             if (_getOperatorCreator(nodeOperatorId) != msg.sender) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSStrikes.sol

38:         if (msg.sender != ORACLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/VettedGate.sol

265:         if (!verifyProof(msg.sender, proof)) {

343:         if (isConsumed(msg.sender)) {

347:         if (!verifyProof(msg.sender, proof)) {

407:         if (owner != msg.sender) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/lib/NOAddresses.sol

56:         if (no.managerAddress != msg.sender) {

90:         if (no.proposedManagerAddress != msg.sender) {

118:         if (no.rewardAddress != msg.sender) {

152:         if (no.proposedRewardAddress != msg.sender) {

183:         if (no.rewardAddress != msg.sender) {

227:         if (no.managerAddress != msg.sender) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/NOAddresses.sol)

```solidity
File: ./src/lib/proxy/OssifiableProxy.sol

25:         if (admin != msg.sender) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/proxy/OssifiableProxy.sol)

### <a name="NC-8"></a>[NC-8] Consider using named mappings
Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (17)*:
```solidity
File: ./src/CSModule.sol

95:     mapping(uint256 => NodeOperator) private _nodeOperators;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

71:     mapping(uint256 => uint256) internal _allowedExitDelay;

74:     mapping(uint256 => MarkedUint248) internal _exitDelayPenalties;

77:     mapping(uint256 => MarkedUint248) internal _maxWithdrawalRequestFees;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/VettedGate.sol

47:     mapping(address => bool) internal _consumedAddresses;

64:     mapping(bytes32 => uint256) internal _referralCounts;

66:     mapping(bytes32 => bool) internal _consumedReferrers;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/lib/NOAddresses.sol

47:         mapping(uint256 => NodeOperator) storage nodeOperators,

82:         mapping(uint256 => NodeOperator) storage nodeOperators,

109:         mapping(uint256 => NodeOperator) storage nodeOperators,

144:         mapping(uint256 => NodeOperator) storage nodeOperators,

171:         mapping(uint256 => NodeOperator) storage nodeOperators,

211:         mapping(uint256 => NodeOperator) storage nodeOperators,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/NOAddresses.sol)

```solidity
File: ./src/lib/QueueLib.sol

106:         mapping(uint128 => Batch) queue;

115:         mapping(uint256 => NodeOperator) storage nodeOperators,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/QueueLib.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

134:     mapping(address => uint256) internal _memberIndices1b;

144:     mapping(uint256 => ReportVariant) internal _reportVariants;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

### <a name="NC-9"></a>[NC-9] `address`s shouldn't be hard-coded
It is often better to declare `address`es as `immutable`, and assign them via constructor arguments. This allows the code to remain the same across deployments on different networks, and avoids recompilation when addresses need to change.

*Instances (1)*:
```solidity
File: ./src/CSVerifier.sol

40:         0x000F3df6D732807Ef1319fB7B8bB8522d0Beac02;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

### <a name="NC-10"></a>[NC-10] Take advantage of Custom Error's return value property
An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (237)*:
```solidity
File: ./src/CSAccounting.sol

49:             revert SenderIsNotModule();

67:             revert ZeroModuleAddress();

70:             revert ZeroFeeDistributorAddress();

94:             revert ZeroAdminAddress();

115:             revert InvalidBondCurvesLength();

325:             revert ElRewardsVaultReceiveFailed();

378:             revert NotAllowedToRecover();

652:         revert NodeOperatorDoesNotExist();

659:             revert NodeOperatorDoesNotExist();

666:         revert SenderIsNotEligible();

673:             revert ZeroChargePenaltyRecipientAddress();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

35:             revert SenderIsNotStrikes();

48:             revert ZeroModuleAddress();

51:             revert ZeroStrikesAddress();

54:             revert ZeroAdminAddress();

91:                 revert SigningKeysInvalidOffset();

99:                     revert AlreadyWithdrawn();

155:                 revert SigningKeysInvalidOffset();

162:                 revert AlreadyWithdrawn();

197:             revert SigningKeysInvalidOffset();

204:             revert AlreadyWithdrawn();

241:             revert NodeOperatorDoesNotExist();

244:             revert SenderIsNotEligible();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSExitPenalties.sol

28:             revert SenderIsNotModule();

36:             revert SenderIsNotStrikes();

44:             revert ZeroModuleAddress();

47:             revert ZeroParametersRegistryAddress();

50:             revert ZeroStrikesAddress();

71:             revert ValidatorExitDelayNotApplicable();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSExitPenalties.sol)

```solidity
File: ./src/CSFeeDistributor.sol

58:             revert SenderIsNotAccounting();

66:             revert SenderIsNotOracle();

74:             revert ZeroAccountingAddress();

77:             revert ZeroOracleAddress();

81:             revert ZeroStEthAddress();

96:             revert ZeroAdminAddress();

136:             revert NotEnoughShares();

161:             revert InvalidShares();

165:             revert InvalidReportData();

170:                 revert InvalidTreeCid();

173:                 revert InvalidTreeCid();

177:                 revert InvalidTreeRoot();

180:                 revert InvalidTreeRoot();

208:             revert InvalidLogCID();

211:             revert InvalidLogCID();

237:             revert NotAllowedToRecover();

268:             revert InvalidProof();

277:             revert InvalidProof();

283:             revert FeeSharesDecrease();

304:             revert ZeroRebateRecipientAddress();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSFeeOracle.sol

52:             revert ZeroFeeDistributorAddress();

55:             revert ZeroStrikesAddress();

69:             revert ZeroAdminAddress();

148:         revert SenderNotAllowed();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeOracle.sol)

```solidity
File: ./src/CSModule.sol

114:             revert ZeroLocatorAddress();

118:             revert ZeroParametersRegistryAddress();

122:             revert ZeroAccountingAddress();

126:             revert ZeroExitPenaltiesAddress();

145:             revert ZeroAdminAddress();

188:             revert ZeroSenderAddress();

240:             revert InvalidAmount();

418:             revert InvalidInput();

421:             revert InvalidInput();

502:                 revert InvalidVetKeysPointer();

506:                 revert InvalidVetKeysPointer();

539:             revert SigningKeysInvalidOffset();

591:             revert PriorityQueueAlreadyUsed();

599:             revert NotEligibleForPriorityQueue();

604:             revert NoQueuedKeysToMigrate();

609:             revert PriorityQueueMaxDepositsUsed();

640:             revert InvalidAmount();

733:                 revert SigningKeysInvalidOffset();

975:             revert NotEnoughKeys();

1350:                 revert KeysLimitExceeded();

1403:             revert ExitedKeysHigherThanTotalDeposited();

1406:             revert ExitedKeysDecrease();

1585:                 revert CannotAddKeys();

1596:             revert NodeOperatorDoesNotExist();

1600:             revert SenderIsNotEligible();

1609:         revert NodeOperatorDoesNotExist();

1621:             revert SigningKeysInvalidOffset();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

81:             revert ZeroQueueLowestPriority();

96:             revert ZeroAdminAddress();

643:             revert InvalidRewardShareData();

652:             revert InvalidPerformanceLeewayData();

734:             revert QueueCannotBeUsed();

737:             revert ZeroMaxDeposits();

746:             revert InvalidStrikesParams();

752:             revert InvalidAllowedExitDelay();

762:             revert InvalidPerformanceCoefficients();

770:             revert InvalidKeyNumberValueIntervals();

773:             revert InvalidKeyNumberValueIntervals();

777:             revert InvalidKeyNumberValueIntervals();

785:                     revert InvalidKeyNumberValueIntervals();

788:                     revert InvalidKeyNumberValueIntervals();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

39:             revert SenderIsNotOracle();

52:             revert ZeroModuleAddress();

55:             revert ZeroOracleAddress();

58:             revert ZeroExitPenaltiesAddress();

61:             revert ZeroParametersRegistryAddress();

75:             revert ZeroAdminAddress();

100:             revert InvalidReportData();

116:             revert InvalidReportData();

137:             revert EmptyKeyStrikesList();

141:             revert ZeroMsgValue();

145:             revert ValueNotEvenlyDivisible();

158:             revert InvalidProof();

223:             revert ZeroEjectorAddress();

244:             revert NotEnoughStrikesToEject();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/CSVerifier.sol

100:             revert ZeroWithdrawalAddress();

104:             revert ZeroModuleAddress();

108:             revert ZeroAdminAddress();

112:             revert InvalidChainConfig();

116:             revert InvalidChainConfig();

120:             revert InvalidPivotSlot();

124:             revert InvalidCapellaSlot();

182:                 revert InvalidBlockHeader();

231:                 revert InvalidBlockHeader();

276:             revert RootNotFound();

294:             revert InvalidWithdrawalAddress();

298:             revert ValidatorNotWithdrawn();

324:             revert PartialWithdrawal();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

```solidity
File: ./src/PermissionlessGate.sol

32:             revert ZeroModuleAddress();

35:             revert ZeroAdminAddress();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/PermissionlessGate.sol)

```solidity
File: ./src/VettedGate.sol

70:             revert ZeroModuleAddress();

88:             revert InvalidCurveId();

95:             revert ZeroAdminAddress();

118:             revert ReferralProgramIsActive();

121:             revert InvalidCurveId();

124:             revert InvalidReferralsThreshold();

149:             revert ReferralProgramIsNotActive();

266:             revert InvalidProof();

270:             revert ReferralProgramIsNotActive();

277:             revert NotEnoughReferrals();

281:             revert AlreadyConsumed();

344:             revert AlreadyConsumed();

348:             revert InvalidProof();

361:             revert InvalidTreeRoot();

364:             revert InvalidTreeRoot();

368:             revert InvalidTreeCid();

371:             revert InvalidTreeCid();

405:             revert NodeOperatorDoesNotExist();

408:             revert NotAllowedToClaim();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/VettedGateFactory.sol

17:             revert ZeroImplementationAddress();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGateFactory.sol)

```solidity
File: ./src/abstract/CSBondCore.sol

46:             revert ZeroLocatorAddress();

143:             revert NothingToClaim();

168:             revert NothingToClaim();

188:             revert NothingToClaim();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCore.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

94:             revert InvalidInitializationCurveId();

120:                 revert InvalidBondCurveId();

139:                 revert InvalidBondCurveId();

255:                 revert InvalidBondCurveId();

269:             revert InvalidBondCurveLength();

273:             revert InvalidBondCurveValues();

277:             revert InvalidBondCurveValues();

285:                     revert InvalidBondCurveValues();

288:                     revert InvalidBondCurveValues();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/abstract/CSBondLock.sol

51:             revert InvalidBondLockPeriod();

55:             revert InvalidBondLockPeriod();

87:             revert InvalidBondLockAmount();

105:             revert InvalidBondLockAmount();

109:             revert InvalidBondLockAmount();

134:             revert InvalidBondLockPeriod();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondLock.sol)

```solidity
File: ./src/lib/AssetRecovererLib.sol

51:             revert IAssetRecovererLib.FailedToSendEther();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/AssetRecovererLib.sol)

```solidity
File: ./src/lib/GIndex.sol

17:         revert IndexOutOfRange();

50:         revert IndexOutOfRange();

62:         revert IndexOutOfRange();

77:         revert IndexOutOfRange();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/GIndex.sol)

```solidity
File: ./src/lib/NOAddresses.sol

53:             revert ICSModule.NodeOperatorDoesNotExist();

57:             revert INOAddresses.SenderIsNotManagerAddress();

61:             revert INOAddresses.SameAddress();

65:             revert INOAddresses.AlreadyProposed();

87:             revert ICSModule.NodeOperatorDoesNotExist();

91:             revert INOAddresses.SenderIsNotProposedAddress();

115:             revert ICSModule.NodeOperatorDoesNotExist();

119:             revert INOAddresses.SenderIsNotRewardAddress();

123:             revert INOAddresses.SameAddress();

127:             revert INOAddresses.AlreadyProposed();

149:             revert ICSModule.NodeOperatorDoesNotExist();

153:             revert INOAddresses.SenderIsNotProposedAddress();

176:             revert ICSModule.NodeOperatorDoesNotExist();

180:             revert INOAddresses.MethodCallIsNotAllowed();

184:             revert INOAddresses.SenderIsNotRewardAddress();

188:             revert INOAddresses.SameAddress();

216:             revert INOAddresses.ZeroRewardAddress();

220:             revert ICSModule.NodeOperatorDoesNotExist();

224:             revert INOAddresses.MethodCallIsNotAllowed();

228:             revert INOAddresses.SenderIsNotManagerAddress();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/NOAddresses.sol)

```solidity
File: ./src/lib/QueueLib.sol

133:             revert IQueueLib.QueueLookupNoLimit();

214:             revert IQueueLib.QueueIsEmpty();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/QueueLib.sol)

```solidity
File: ./src/lib/SigningKeys.sol

39:             revert InvalidKeysCount();

46:                 revert InvalidLength();

69:                 revert EmptyKey();

106:             revert InvalidKeysCount();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SigningKeys.sol)

```solidity
File: ./src/lib/ValidatorCountsReport.sol

18:             revert InvalidReportData();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/ValidatorCountsReport.sol)

```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

108:             revert SecondsPerSlotCannotBeZero();

221:             revert HashCannotBeZero();

268:             revert RefSlotAlreadyProcessing();

371:             revert NoConsensusReportToProcess();

379:             revert RefSlotAlreadyProcessing();

401:             revert VersionCannotBeSame();

405:             revert VersionCannotBeZero();

417:             revert AddressCannotBeZero();

422:             revert AddressCannotBeSame();

429:             revert UnexpectedChainConfig();

446:             revert SenderIsNotTheConsensusContract();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

221:             revert InvalidChainConfig();

225:             revert InvalidChainConfig();

233:             revert AdminCannotBeZero();

237:             revert ReportProcessorCannotBeZero();

331:             revert InitialEpochAlreadyArrived();

342:             revert InitialEpochRefSlotCannotBeEarlierThanProcessingSlot();

653:             revert EpochsPerFrameCannotBeZero();

657:             revert FastLanePeriodCannotBeLongerThanFrame();

740:             revert InitialEpochIsYetToArrive();

791:             revert NonMember();

800:             revert DuplicateMember();

804:             revert AddressCannotBeZero();

860:             revert FastLanePeriodCannotBeLongerThanFrame();

952:             revert InvalidSlot();

956:             revert NumericOverflow();

960:             revert EmptyReport();

980:             revert InvalidSlot();

984:             revert StaleReport();

991:             revert NonFastLaneMemberCannotReportWithinFastLaneInterval();

998:                 revert ConsensusReportAlreadyProcessing();

1029:                 revert DuplicateReport();

1194:             revert ReportProcessorCannotBeZero();

1198:             revert NewProcessorCannotBeTheSame();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

```solidity
File: ./src/lib/proxy/OssifiableProxy.sol

23:             revert ProxyIsOssified();

26:             revert NotAdmin();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/proxy/OssifiableProxy.sol)

```solidity
File: ./src/lib/utils/PausableUntil.sol

62:             revert ZeroPauseDuration();

77:             revert PauseUntilMustBeInFuture();

100:             revert PausedExpected();

106:             revert ResumedExpected();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/PausableUntil.sol)

```solidity
File: ./src/lib/utils/Versioned.sol

41:             revert InvalidContractVersion();

45:             revert NonZeroContractVersionOnInit();

54:             revert InvalidContractVersionIncrement();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/Versioned.sol)

### <a name="NC-11"></a>[NC-11] Use Underscores for Number Literals (add an underscore every 3 digits)

*Instances (1)*:
```solidity
File: ./src/CSParametersRegistry.sol

24:     uint256 internal constant MAX_BP = 10000;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

### <a name="NC-12"></a>[NC-12] Constants should be defined rather than using magic numbers

*Instances (8)*:
```solidity
File: ./src/lib/QueueLib.sol

27:         n := shr(192, self)

33:         n := shl(64, self)

34:         n := shr(192, n)

86:         item := or(item, shl(192, nodeOperatorId)) // `nodeOperatorId` in [0:63]

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/QueueLib.sol)

```solidity
File: ./src/lib/SSZ.sol

97:             mcopy(48, 0x60, 16)

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SSZ.sol)

```solidity
File: ./src/lib/SigningKeys.sol

52:         bytes memory tmpKey = new bytes(48);

112:         bytes memory tmpKey = new bytes(48);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/SigningKeys.sol)

```solidity
File: ./src/lib/ValidatorCountsReport.sol

31:             nodeOperatorId := shr(192, calldataload(add(ids.offset, mul(offset, 8))))

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/ValidatorCountsReport.sol)

### <a name="NC-13"></a>[NC-13] Variables need not be initialized to zero
The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (16)*:
```solidity
File: ./src/CSEjector.sol

151:         for (uint256 i = 0; i < keyIndices.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSModule.sol

393:         for (uint256 i = 0; i < operatorsInReport; ++i) {

487:         for (uint256 i = 0; i < operatorsInReport; ++i) {

879:         uint256 loadedKeysCount = 0;

883:         uint256 priority = 0;

1004:         uint256 totalVisited = 0;

1006:         uint256 priority = 0;

1288:         for (uint256 i = 0; i < nodeOperatorIds.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

285:         for (uint256 i = 0; i < data.length; ++i) {

311:         for (uint256 i = 0; i < data.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

235:         uint256 strikes = 0;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

156:             uint256 low = 0;

186:             uint256 low = 0;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

548:         for (uint256 i = 0; i < variantsLength; ++i) {

1015:         uint64 varIndex = 0;

1174:         for (uint256 i = 0; i < variantsLength; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | `approve()`/`safeApprove()` may revert if the current approval is not zero | 4 |
| [L-2](#L-2) | Division by zero not prevented | 2 |
| [L-3](#L-3) | External call recipient may consume all transaction gas | 2 |
| [L-4](#L-4) | Fallback lacking `payable` | 1 |
| [L-5](#L-5) | Initializers could be front-run | 28 |
| [L-6](#L-6) | Signature use at deadlines should be allowed | 3 |
| [L-7](#L-7) | Loss of precision | 4 |
| [L-8](#L-8) | Sweeping may break accounting if tokens with multiple addresses are used | 13 |
| [L-9](#L-9) | Unsafe ERC20 operation(s) | 6 |
| [L-10](#L-10) | Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions | 22 |
| [L-11](#L-11) | Upgradeable contract not initialized | 70 |
### <a name="L-1"></a>[L-1] `approve()`/`safeApprove()` may revert if the current approval is not zero
- Some tokens (like the *very popular* USDT) do not work when changing the allowance from an existing non-zero allowance value (it will revert if the current approval is not zero to protect against front-running changes of approvals). These tokens must first be approved for zero and then the actual allowance can be approved.
- Furthermore, OZ's implementation of safeApprove would throw an error if an approve is attempted from a non-zero value (`"SafeERC20: approve from non-zero to non-zero allowance"`)

Set the allowance to zero immediately before each of the existing allowance calls

*Instances (4)*:
```solidity
File: ./src/CSAccounting.sol

101:         LIDO.approve(address(WSTETH), type(uint256).max);

102:         LIDO.approve(address(WITHDRAWAL_QUEUE), type(uint256).max);

103:         LIDO.approve(LIDO_LOCATOR.burner(), type(uint256).max);

393:         LIDO.approve(LIDO_LOCATOR.burner(), type(uint256).max);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

### <a name="L-2"></a>[L-2] Division by zero not prevented
The divisions below take an input parameter which does not have any zero-value checks, which may lead to the functions reverting when zero is passed.

*Instances (2)*:
```solidity
File: ./src/CSStrikes.sol

165:         uint256 valuePerKey = msg.value / keyStrikesList.length;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

742:         return (epoch - config.initialEpoch) / config.epochsPerFrame;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

### <a name="L-3"></a>[L-3] External call recipient may consume all transaction gas
There is no limit specified on the amount of gas used, so the recipient can use up all of the transaction's gas, causing it to revert. Use `addr.call{gas: <amount>}("")` or [this](https://github.com/nomad-xyz/ExcessivelySafeCall) library instead.

*Instances (2)*:
```solidity
File: ./src/CSAccounting.sol

321:         (bool success, ) = LIDO_LOCATOR.elRewardsVault().call{

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/lib/AssetRecovererLib.sol

49:         (bool success, ) = msg.sender.call{ value: amount }("");

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/AssetRecovererLib.sol)

### <a name="L-4"></a>[L-4] Fallback lacking `payable`

*Instances (1)*:
```solidity
File: ./src/lib/proxy/OssifiableProxy.sol

50:         _fallback();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/proxy/OssifiableProxy.sol)

### <a name="L-5"></a>[L-5] Initializers could be front-run
Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (28)*:
```solidity
File: ./src/CSAccounting.sol

83:     function initialize(

88:     ) external reinitializer(2) {

89:         __AccessControlEnumerable_init();

90:         __CSBondCurve_init(bondCurve);

91:         __CSBondLock_init(bondLockPeriod);

108:     ) external reinitializer(2) {

119:         __CSBondCurve_init(bondCurvesInputs[0]);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSFeeDistributor.sol

91:     function initialize(

94:     ) external reinitializer(2) {

101:         __AccessControlEnumerable_init();

108:     ) external reinitializer(2) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSFeeOracle.sol

63:     function initialize(

74:         BaseOracle._initialize(consensusContract, consensusVersion, 0);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeOracle.sol)

```solidity
File: ./src/CSModule.sol

143:     function initialize(address admin) external reinitializer(2) {

148:         __AccessControlEnumerable_init();

158:     function finalizeUpgradeV2() external reinitializer(2) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

91:     function initialize(

94:     ) external initializer {

121:         __AccessControlEnumerable_init();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

73:     function initialize(address admin, address _ejector) external initializer {

80:         __AccessControlEnumerable_init();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/VettedGate.sol

79:     function initialize(

84:     ) external initializer {

85:         __AccessControlEnumerable_init();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/VettedGateFactory.sol

38:         VettedGate(instance).initialize(curveId, treeRoot, treeCid, admin);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGateFactory.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

89:     function __CSBondCurve_init(

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/abstract/CSBondLock.sol

127:     function __CSBondLock_init(uint256 period) internal onlyInitializing {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondLock.sol)

```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

290:     function _initialize(

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

### <a name="L-6"></a>[L-6] Signature use at deadlines should be allowed
According to [EIP-2612](https://github.com/ethereum/EIPs/blob/71dc97318013bf2ac572ab63fab530ac9ef419ca/EIPS/eip-2612.md?plain=1#L58), signatures used on exactly the deadline timestamp are supposed to be allowed. While the signature may or may not be used for the exact EIP-2612 use case (transfer approvals), for consistency's sake, all deadlines should follow this semantic. If the timestamp is an expiration rather than a deadline, consider whether it makes more sense to include the expiration timestamp as a valid timestamp, as is done for deadlines.

*Instances (3)*:
```solidity
File: ./src/abstract/CSBondLock.sol

80:         return bondLock.until > block.timestamp ? bondLock.amount : 0;

90:         if (lock.until > block.timestamp) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondLock.sol)

```solidity
File: ./src/lib/utils/PausableUntil.sol

76:         if (pauseUntilInclusive < block.timestamp) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/PausableUntil.sol)

### <a name="L-7"></a>[L-7] Loss of precision
Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator

*Instances (4)*:
```solidity
File: ./src/CSVerifier.sol

387:         uint256 summaryIndex = targetSlotShifted / SLOTS_PER_HISTORICAL_ROOT;

406:         return slot.unwrap() / SLOTS_PER_EPOCH;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

755:         return (timestamp - GENESIS_TIME) / SECONDS_PER_SLOT;

760:         return slot / SLOTS_PER_EPOCH;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

### <a name="L-8"></a>[L-8] Sweeping may break accounting if tokens with multiple addresses are used
There have been [cases](https://blog.openzeppelin.com/compound-tusd-integration-issue-retrospective/) in the past where a token mistakenly had two addresses that could control its balance, and transfers using one address impacted the balance of the other. To protect against this potential scenario, sweep functions should ensure that the balance of the non-sweepable token does not change after the transfer of the swept tokens.

*Instances (13)*:
```solidity
File: ./src/CSAccounting.sol

375:     function recoverERC20(address token, uint256 amount) external override {

380:         AssetRecovererLib.recoverERC20(token, amount);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSFeeDistributor.sol

234:     function recoverERC20(address token, uint256 amount) external override {

239:         AssetRecovererLib.recoverERC20(token, amount);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/abstract/AssetRecoverer.sol

25:     function recoverERC20(address token, uint256 amount) external virtual {

27:         AssetRecovererLib.recoverERC20(token, amount);

34:     function recoverERC721(address token, uint256 tokenId) external {

36:         AssetRecovererLib.recoverERC721(token, tokenId);

43:     function recoverERC1155(address token, uint256 tokenId) external {

45:         AssetRecovererLib.recoverERC1155(token, tokenId);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/AssetRecoverer.sol)

```solidity
File: ./src/lib/AssetRecovererLib.sol

63:     function recoverERC20(address token, uint256 amount) external {

86:     function recoverERC721(address token, uint256 tokenId) external {

97:     function recoverERC1155(address token, uint256 tokenId) external {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/AssetRecovererLib.sol)

### <a name="L-9"></a>[L-9] Unsafe ERC20 operation(s)

*Instances (6)*:
```solidity
File: ./src/CSAccounting.sol

101:         LIDO.approve(address(WSTETH), type(uint256).max);

102:         LIDO.approve(address(WITHDRAWAL_QUEUE), type(uint256).max);

103:         LIDO.approve(LIDO_LOCATOR.burner(), type(uint256).max);

393:         LIDO.approve(LIDO_LOCATOR.burner(), type(uint256).max);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/abstract/CSBondCore.sol

110:         WSTETH.transferFrom(from, address(this), amount);

195:         WSTETH.transfer(to, wstETHAmount);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCore.sol)

### <a name="L-10"></a>[L-10] Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions
See [this](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps) link for a description of this storage variable. While some contracts may not currently be sub-classed, adding the variable now protects against forgetting to add it in the future.

*Instances (22)*:
```solidity
File: ./src/CSAccounting.sol

5: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

29:     AccessControlEnumerableUpgradeable,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSFeeDistributor.sol

7: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

8: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

21:     AccessControlEnumerableUpgradeable,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSModule.sol

7: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

8: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

31:     AccessControlEnumerableUpgradeable,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

6: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

7: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

18:     AccessControlEnumerableUpgradeable

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

7: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

8: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

21:     AccessControlEnumerableUpgradeable

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/VettedGate.sol

6: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

19:     AccessControlEnumerableUpgradeable,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

6: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/abstract/CSBondLock.sol

6: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondLock.sol)

```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

5: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

17:     AccessControlEnumerableUpgradeable,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

6: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

31:     AccessControlEnumerableUpgradeable

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

### <a name="L-11"></a>[L-11] Upgradeable contract not initialized
Upgradeable contracts are initialized via an initializer function rather than by a constructor. Leaving such a contract uninitialized may lead to it being taken over by a malicious user

*Instances (70)*:
```solidity
File: ./src/CSAccounting.sol

5: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

29:     AccessControlEnumerableUpgradeable,

76:         _disableInitializers();

83:     function initialize(

88:     ) external reinitializer(2) {

89:         __AccessControlEnumerable_init();

90:         __CSBondCurve_init(bondCurve);

91:         __CSBondLock_init(bondLockPeriod);

108:     ) external reinitializer(2) {

119:         __CSBondCurve_init(bondCurvesInputs[0]);

397:     function getInitializedVersion() external view returns (uint64) {

398:         return _getInitializedVersion();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSFeeDistributor.sol

7: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

8: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

21:     AccessControlEnumerableUpgradeable,

88:         _disableInitializers();

91:     function initialize(

94:     ) external reinitializer(2) {

101:         __AccessControlEnumerable_init();

108:     ) external reinitializer(2) {

243:     function getInitializedVersion() external view returns (uint64) {

244:         return _getInitializedVersion();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSFeeOracle.sol

63:     function initialize(

74:         BaseOracle._initialize(consensusContract, consensusVersion, 0);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeOracle.sol)

```solidity
File: ./src/CSModule.sol

7: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

8: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

31:     AccessControlEnumerableUpgradeable,

139:         _disableInitializers();

143:     function initialize(address admin) external reinitializer(2) {

148:         __AccessControlEnumerable_init();

158:     function finalizeUpgradeV2() external reinitializer(2) {

1058:     function getInitializedVersion() external view returns (uint64) {

1059:         return _getInitializedVersion();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

6: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

7: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

18:     AccessControlEnumerableUpgradeable

87:         _disableInitializers();

91:     function initialize(

94:     ) external initializer {

121:         __AccessControlEnumerable_init();

622:     function getInitializedVersion() external view returns (uint64) {

623:         return _getInitializedVersion();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

7: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

8: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

21:     AccessControlEnumerableUpgradeable

70:         _disableInitializers();

73:     function initialize(address admin, address _ejector) external initializer {

80:         __AccessControlEnumerable_init();

177:     function getInitializedVersion() external view returns (uint64) {

178:         return _getInitializedVersion();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/VettedGate.sol

6: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

19:     AccessControlEnumerableUpgradeable,

76:         _disableInitializers();

79:     function initialize(

84:     ) external initializer {

85:         __AccessControlEnumerable_init();

315:     function getInitializedVersion() external view returns (uint64) {

316:         return _getInitializedVersion();

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/VettedGateFactory.sol

38:         VettedGate(instance).initialize(curveId, treeRoot, treeCid, admin);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGateFactory.sol)

```solidity
File: ./src/abstract/CSBondCurve.sol

6: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

89:     function __CSBondCurve_init(

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondCurve.sol)

```solidity
File: ./src/abstract/CSBondLock.sol

6: import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

127:     function __CSBondLock_init(uint256 period) internal onlyInitializing {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/abstract/CSBondLock.sol)

```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

5: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

17:     AccessControlEnumerableUpgradeable,

290:     function _initialize(

295:         _initializeContractVersionTo(1);

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

6: import { AccessControlEnumerableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";

31:     AccessControlEnumerableUpgradeable

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)

```solidity
File: ./src/lib/utils/Versioned.sol

39:     function _initializeContractVersionTo(uint256 version) internal {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/utils/Versioned.sol)


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 86 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (86)*:
```solidity
File: ./src/CSAccounting.sol

126:     function resume() external onlyRole(RESUME_ROLE) {

131:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

138:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

145:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

152:     ) external onlyRole(MANAGE_BOND_CURVES_ROLE) returns (uint256 id) {

160:     ) external onlyRole(MANAGE_BOND_CURVES_ROLE) {

168:     ) external onlyRole(SET_BOND_CURVE_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSAccounting.sol)

```solidity
File: ./src/CSEjector.sol

6: import { AccessControlEnumerable } from "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";

21:     AccessControlEnumerable,

65:     function resume() external onlyRole(RESUME_ROLE) {

70:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSEjector.sol)

```solidity
File: ./src/CSFeeDistributor.sol

115:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeDistributor.sol)

```solidity
File: ./src/CSFeeOracle.sol

93:     function resume() external onlyRole(RESUME_ROLE) {

98:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSFeeOracle.sol)

```solidity
File: ./src/CSModule.sol

167:     function resume() external onlyRole(RESUME_ROLE) {

172:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

183:         onlyRole(CREATE_NODE_OPERATOR_ROLE)

379:     ) external onlyRole(STAKING_ROUTER_ROLE) {

387:     ) external onlyRole(STAKING_ROUTER_ROLE) {

416:     ) external onlyRole(STAKING_ROUTER_ROLE) {

468:     ) external onlyRole(STAKING_ROUTER_ROLE) {

481:     ) external onlyRole(STAKING_ROUTER_ROLE) {

637:     ) external onlyRole(REPORT_EL_REWARDS_STEALING_PENALTY_ROLE) {

664:     ) external onlyRole(REPORT_EL_REWARDS_STEALING_PENALTY_ROLE) {

680:     ) external onlyRole(SETTLE_EL_REWARDS_STEALING_PENALTY_ROLE) {

721:     ) external onlyRole(VERIFIER_ROLE) {

826:         onlyRole(STAKING_ROUTER_ROLE)

837:     ) external onlyRole(STAKING_ROUTER_ROLE) {

852:     ) external onlyRole(STAKING_ROUTER_ROLE) {

870:         onlyRole(STAKING_ROUTER_ROLE)

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSModule.sol)

```solidity
File: ./src/CSParametersRegistry.sol

129:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

136:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

143:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

150:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

157:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

165:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

172:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

181:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

193:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

200:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

207:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

214:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

222:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

233:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

242:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

253:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

262:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

270:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

279:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

294:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

303:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

320:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

330:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

342:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

351:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

362:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

373:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

395:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

405:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

417:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

426:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

435:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

444:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

452:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

461:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

472:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSParametersRegistry.sol)

```solidity
File: ./src/CSStrikes.sol

87:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSStrikes.sol)

```solidity
File: ./src/CSVerifier.sol

6: import { AccessControlEnumerable } from "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";

28: contract CSVerifier is ICSVerifier, AccessControlEnumerable, PausableUntil {

157:     function resume() external onlyRole(RESUME_ROLE) {

162:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/CSVerifier.sol)

```solidity
File: ./src/PermissionlessGate.sol

6: import { AccessControlEnumerable } from "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";

18:     AccessControlEnumerable,

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/PermissionlessGate.sol)

```solidity
File: ./src/VettedGate.sol

103:     function resume() external onlyRole(RESUME_ROLE) {

108:     function pauseFor(uint256 duration) external onlyRole(PAUSE_ROLE) {

116:     ) external onlyRole(START_REFERRAL_SEASON_ROLE) returns (uint256 season) {

144:         onlyRole(END_REFERRAL_SEASON_ROLE)

295:     ) external onlyRole(SET_TREE_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/VettedGate.sol)

```solidity
File: ./src/lib/base-oracle/BaseOracle.sol

125:     ) external onlyRole(MANAGE_CONSENSUS_CONTRACT_ROLE) {

145:     ) external onlyRole(MANAGE_CONSENSUS_VERSION_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/BaseOracle.sol)

```solidity
File: ./src/lib/base-oracle/HashConsensus.sol

327:     ) external onlyRole(DEFAULT_ADMIN_ROLE) {

354:     ) external onlyRole(MANAGE_FRAME_CONFIG_ROLE) {

457:     ) external onlyRole(MANAGE_FAST_LANE_CONFIG_ROLE) {

464:     ) external onlyRole(MANAGE_MEMBERS_AND_QUORUM_ROLE) {

471:     ) external onlyRole(MANAGE_MEMBERS_AND_QUORUM_ROLE) {

501:     ) external onlyRole(MANAGE_REPORT_PROCESSOR_ROLE) {

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/base-oracle/HashConsensus.sol)


## High Issues


| |Issue|Instances|
|-|:-|:-:|
| [H-1](#H-1) | Incorrect comparison implementation | 1 |
### <a name="H-1"></a>[H-1] Incorrect comparison implementation

#### Impact:
Use `require` or `if` to compare values. Otherwise comparison will be ignored.

*Instances (1)*:
```solidity
File: ./src/lib/Types.sol

21: using { unwrap, lt as <, gt as > } for Slot global;

```
[Link to code](https://github.com/code-423n4/2025-07-lido-finance/blob/main/./src/lib/Types.sol)

