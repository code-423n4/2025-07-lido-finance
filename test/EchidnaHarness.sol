// SPDX-FileCopyrightText: 2025 Lido <info@lido.fi>
// SPDX-License-Identifier: GPL‑3.0
pragma solidity 0.8.24;

import "../src/CSAccounting.sol";

/**
 * Minimal Echidna harness for the Community‑Staking‑Module (CSM‑v2).
 *
 * • Deploys a fresh `CSAccounting` with harmless stub dependencies so the
 *   constructor cannot revert.
 * • Contains a single always‑true invariant (`echidna_dummy`) that proves the
 *   Foundry → Echidna pipeline works.  Replace it with real invariants later.
 */
contract Echidna_Accounting_Invariants {
    CSAccounting public acc;

    constructor() payable {
        DummyLocator locator = new DummyLocator();

        acc = new CSAccounting(
            address(locator),                                        // LidoLocator
            address(0x0000000000000000000000000000000000000001),     // stub Staking‑Module
            address(0x0000000000000000000000000000000000000002),     // stub Fee‑Distributor
            1 days,                                                 // min bond‑lock
            30 days                                                 // max bond‑lock
        );
    }

    /// -----------------------------------------------------------------------
    ///  Replace this with real invariants once the scaffold is confirmed
    /// -----------------------------------------------------------------------
    function echidna_dummy() external pure returns (bool) {
        return true;
    }
}

/**
 * Very small stub that satisfies the methods `CSAccounting` expects from
 * the real LidoLocator.  Each returns a distinct inert address.
 */
contract DummyLocator {
    function lido()            external pure returns (address) { return address(0x0000000000000000000000000000000000000100); }
    function stakingRouter()   external pure returns (address) { return address(0x0000000000000000000000000000000000000200); }
    function withdrawalQueue() external pure returns (address) { return address(0x0000000000000000000000000000000000000300); }
    function burner()          external pure returns (address) { return address(0x0000000000000000000000000000000000000400); }
    function wstETH()          external pure returns (address) { return address(0x0000000000000000000000000000000000000500); }
    function elRewardsVault()  external pure returns (address) { return address(0x0000000000000000000000000000000000000600); }
}
