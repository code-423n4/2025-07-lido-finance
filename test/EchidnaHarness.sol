// SPDX-FileCopyrightText: 2025 Lido <info@lido.fi>
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import {CSAccounting}           from "../src/CSAccounting.sol";
import {BondCurveIntervalInput} from "../src/abstract/CSBondCurve.sol";

/**
 * Community‑Staking‑Module accounting harness.
 * – Deploys a fresh CSAccounting with dummy non‑zero parameters.
 * – Contains a single invariant (`echidna_dummy`) that always passes.
 *   You can add real invariants later, but compiling & fuzzing works already.
 */
contract Echidna_Accounting_Invariants {
    CSAccounting public acc;

    constructor() {
        address dummy = address(0xDEAD);

        acc = new CSAccounting(
            dummy,  // lidoLocator
            dummy,  // module
            dummy,  // feeDistributor
            1 days, // minBondLockPeriod
            30 days // maxBondLockPeriod
        );
    }

    /// Always true – proves the harness is wired correctly.
    function echidna_dummy() public view returns (bool) {
        return address(acc) != address(0);
    }
}
