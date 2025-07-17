// SPDX-FileCopyrightText: 2025 Lido <info@lido.fi>
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import "../src/CSAccounting.sol";

/* ---------- dummy locator ------------------------------------------------- *
 * Exposes just the getters that CSAccounting‘s constructor calls.  Each
 * returns a perfectly‑formed 40‑hex‑digit address so the compiler is happy.  */
contract DummyLocator {
    function lido()            external pure returns (address) { return address(0x1111111111111111111111111111111111111111); }
    function stakingRouter()   external pure returns (address) { return address(0x2222222222222222222222222222222222222222); }
    function withdrawalQueue() external pure returns (address) { return address(0x3333333333333333333333333333333333333333); }
    function burner()          external pure returns (address) { return address(0x4444444444444444444444444444444444444444); }
    function wstETH()          external pure returns (address) { return address(0x5555555555555555555555555555555555555555); }
    function elRewardsVault()  external pure returns (address) { return address(0x6666666666666666666666666666666666666666); }
}

/* ---------- Echidna harness ------------------------------------------------ */
contract Echidna_Accounting_Invariants {
    CSAccounting public acc;

    constructor() {
        DummyLocator locator = new DummyLocator();

        acc = new CSAccounting(
            address(locator),                                 // LidoLocator
            address(0x7777777777777777777777777777777777777777), // stub Module
            address(0x8888888888888888888888888888888888888888), // stub FeeDistributor
            1 days,                                           // min bond‑lock
            30 days                                           // max bond‑lock
        );
    }

    /* trivial invariant — replace with real ones later */
    function echidna_dummy() external view returns (bool ok) {
        ok = address(acc) != address(0);
    }
}
