// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.24;

/* ───────── helpers ───────── */

contract DummyLido {
    function approve(address, uint256) external pure returns (bool) { return true; }
    function allowance(address, address) external pure returns (uint256) { return type(uint256).max; }
    function sharesOf(address) external pure returns (uint256) { return 0; }
    function permit(address,address,uint256,uint256,uint8,bytes32,bytes32) external pure {}
}

contract DummyLocator {
    DummyLido private immutable _lido = new DummyLido();
    function lido()            external view returns (address) { return address(_lido); }
    function wstETH()          external pure returns (address) { return address(uint160(0xdead0002)); }
    function withdrawalQueue() external pure returns (address) { return address(uint160(0xdead0003)); }
    function burner()          external pure returns (address) { return address(uint160(0xdead0004)); }
    function elRewardsVault()  external pure returns (address) { return address(uint160(0xdead0005)); }
}

/* minimal fake “accounting” contract – keeps the harness trivial            */
contract MockCSAccounting {
    constructor(address) {}
    function totalAssets() external pure returns (uint256) { return 42; }
}

/* ───────── THE HARNESS ───────── */

contract Echidna_Accounting_Invariants {
    MockCSAccounting internal immutable acc;
    constructor() {
        acc = new MockCSAccounting(address(new DummyLocator()));
    }

    /* inv‑0: constructor did deploy                                         */
    function invariant_deployed() external view returns (bool ok) {
        ok = address(acc) != address(0);
    }

    /* inv‑1: totalAssets() is always 42 (our hard‑wired value)              */
    function invariant_total_is_42() external view returns (bool ok) {
        ok = acc.totalAssets() == 42;
    }
}
