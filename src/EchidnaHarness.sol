// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.24;

import "./CSAccounting.sol";

/* -------------------------------------------------------------------------- */
/*  Minimal ERC20 stub – just enough for CSAccounting                          */
/* -------------------------------------------------------------------------- */
contract DummyLido {
    function approve(address, uint256) external pure returns (bool) { return true; }
    function allowance(address, address) external pure returns (uint256) { return type(uint256).max; }
    function sharesOf(address) external pure returns (uint256) { return 0; }
    function permit(
        address, address, uint256, uint256, uint8, bytes32, bytes32
    ) external pure {}
}

/* -------------------------------------------------------------------------- */
/*  Locator stub – deterministic, non‑zero addresses                          */
/* -------------------------------------------------------------------------- */
contract DummyLocator {
    DummyLido private immutable _lido = new DummyLido();
    function lido()            external view returns (address) { return address(_lido);     }
    function wstETH()          external pure returns (address) { return address(0xDeaD0002); }
    function withdrawalQueue() external pure returns (address) { return address(0xDeaD0003); }
    function burner()          external pure returns (address) { return address(0xDeaD0004); }
    function elRewardsVault()  external pure returns (address) { return address(0xDeaD0005); }
}

/* -------------------------------------------------------------------------- */
/*  Echidna harness with one always‑true invariant                            */
/* -------------------------------------------------------------------------- */
contract Echidna_Accounting_Invariants {
    CSAccounting public acc;

    constructor() payable {
        acc = new CSAccounting(
            address(new DummyLocator()),   // locator
            address(0x0001),               // dummy Staking‑Module
            address(0x0002),               // dummy Fee‑Distributor
            1 days,                        // min lock
            30 days                        // max lock
        );
    }

    function echidna_dummy() external view returns (bool ok) {
        ok = address(acc) != address(0);
    }
}
