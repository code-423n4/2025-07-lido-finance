// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.24;

import "../src/CSAccounting.sol";

/**
 * Minimal Echidna harness for the Community‑Staking‑Module (CSM‑v2).
 *
 * • Deploys a fresh `CSAccounting` with inert stub contracts so its constructor
 *   cannot revert.
 * • Provides a single always‑true invariant (`echidna_dummy`) that proves the
 *   Foundry → Echidna tool‑chain works.  Replace it with real invariants later.
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

    /* ---------------------------------------------------------------------- */
    /*  Invariants – replace `echidna_dummy` with real ones when ready        */
    /* ---------------------------------------------------------------------- */
    function echidna_dummy() external pure returns (bool) {
        return true;
    }
}

/**
 * The production CSAccounting queries LidoLocator for various component
 * addresses.  This tiny stub satisfies those calls with distinct throw‑away
 * addresses so the constructor cannot revert during fuzzing.
 */
contract DummyLocator {
    function lido()            external pure returns (address) { return address(0x0000000000000000000000000000000000000100); }
    function stakingRouter()   external pure returns (address) { return address(0x0000000000000000000000000000000000000200); }
    function withdrawalQueue() external pure returns (address) { return address(0x0000000000000000000000000000000000000300); }
    function burner()          external pure returns (address) { return address(0x0000000000000000000000000000000000000400); }
    function wstETH()          external pure returns (address) { return address(0x0000000000000000000000000000000000000500); }
    function elRewardsVault()  external pure returns (address) { return address(0x0000000000000000000000000000000000000600); }
}
