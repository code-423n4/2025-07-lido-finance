// SPDX-FileCopyrightText: 2025 Lido <info@lido.fi>
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import "../src/CSAccounting.sol";

/**
 * Minimal Echidna harness for the Community‑Staking‑Module (CSM‑v2).
 *
 * • Deploys a fresh CSAccounting with stubbed dependencies so the constructor
 *   cannot revert.
 * • Contains a single always‑true invariant (`echidna_dummy`) so you can verify
 *   your Foundry → Echidna tool‑chain works before writing real properties.
 */
contract Echidna_Accounting_Invariants {
    CSAccounting public acc;

    constructor() payable {
        DummyLocator locator = new DummyLocator();

        acc = new CSAccounting(
            address(locator),                                   // LidoLocator
            address(0x0000000000000000000000000000000000000001), // dummy Staking‑Module
            address(0x0000000000000000000000000000000000000002), // dummy Fee‑Distributor
            1 days,                                             // min‑lock
            30 days                                             // max‑lock
        );
    }

    /// -----------------------------------------------------------------------
    ///  Replace this with **real invariants** once the scaffold is confirmed
    /// -----------------------------------------------------------------------
    function echidna_dummy() external pure returns (bool) {
        return true;
    }
}

/**
 * The real CSAccounting constructor touches LidoLocator.  This stub implements
 * ONLY the getters it calls, each returning an inert address.
 */
contract DummyLocator {
    function lido()            external pure returns (address) { return address(0x0000000000000000000000000000000000000100); }
    function stakingRouter()   external pure returns (address) { return address(0x0000000000000000000000000000000000000200); }
    function withdrawalQueue() external pure returns (address) { return address(0x0000000000000000000000000000000000000300); }
    function burner()          external pure returns (address) { return address(0x0000000000000000000000000000000000000400); }
    // Main‑net wstETH address (40 hex digits, no checksum required)
    function wstETH()          external pure returns (address) { return address(0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0); }
    function elRewardsVault()  external pure returns (address) { return address(0x0000000000000000000000000000000000000500); }
}
