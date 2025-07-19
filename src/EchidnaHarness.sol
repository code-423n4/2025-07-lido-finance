// SPDX-License-Identifier: GPL‑3.0
pragma solidity 0.8.24;

import "./CSAccounting.sol";

/* -------------------------------------------------------------------------- */
/*                             MIN‑STUB LIDO LOCATOR                          */
/*   – deterministic, non‑zero addresses so the CSAccounting ctor never reverts */
contract DummyLocator {
    function lido()            external pure returns (address) { return address(0x00000000000000000000000000000000DeAD0001); }
    function wstETH()          external pure returns (address) { return address(0x00000000000000000000000000000000DeAD0002); }
    function withdrawalQueue() external pure returns (address) { return address(0x00000000000000000000000000000000DeAD0003); }
    function burner()          external pure returns (address) { return address(0x00000000000000000000000000000000DeAD0004); }
    function elRewardsVault()  external pure returns (address) { return address(0x00000000000000000000000000000000DeAD0005); }
}

/* -------------------------------------------------------------------------- */
/*                       SIMPLE HARNESS –  one dummy invariant                */
/* -------------------------------------------------------------------------- */
contract Echidna_Accounting_Invariants {
    CSAccounting public acc;

    constructor() payable {
        acc = new CSAccounting(
            address(new DummyLocator()),
            address(0x0001),
            address(0x0002),
            1 days,
            30 days
        );
    }

    /* always‑true placeholder – replace with real invariants later */
    function echidna_dummy() external view returns (bool) {
        return address(acc) != address(0);
    }
}
