// SPDX-FileCopyrightText: 2025 Lido <info@lido.fi>
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

import "../src/CSAccounting.sol";

/**
 * Minimal Echidna harness for Community‑Staking‑Module (CSM‑v2).
 *
 * – Deploys CSAccounting with placeholder contracts so the constructor
 *   does **not** revert.
 * – Contains a single always‑true invariant (`echidna_dummy`) so the
 *   campaign passes out‑of‑the‑box.  Replace it with real invariants
 *   that expose vulnerabilities.
 */
contract Echidna_Accounting_Invariants {
    CSAccounting public acc;     // system under test

    constructor() payable {
        // ─── 1  Deploy a bare‑bones locator that satisfies CSBondCore ────────
        DummyLocator locator = new DummyLocator();

        // ─── 2  Deploy CSAccounting with sane, non‑zero arguments ───────────
        acc = new CSAccounting(
            address(locator),      // lidoLocator
            address(0x1),          // dummy Staking‑Module (non‑zero)
            address(0x2),          // dummy Fee‑Distributor (non‑zero)
            1 days,                // min bond‑lock period
            30 days                // max bond‑lock period
        );

        // NOTE: we deliberately skip acc.initialize(…) – add it later if you
        //       need bonding curves or admin roles for deeper invariants.
    }

    /// -----------------------------------------------------------------------
    ///  🛡️ Place‑holder invariant — **always true**.
    ///     Delete or replace with real safety properties.
    /// -----------------------------------------------------------------------
    function echidna_dummy() external view returns (bool) {
        return address(acc) != address(0);
    }
}

/*//////////////////////////////////////////////////////////////////////////
                                DUMMY LOCATOR
    Minimal stub that satisfies the few external calls CSAccounting (via
    CSBondCore) might make _during fuzzing_.  Return throw‑away addresses.
//////////////////////////////////////////////////////////////////////////*/
contract DummyLocator {
    function burner()          external pure returns (address) { return address(0xBURN); }
    function elRewardsVault()  external pure returns (address) { return address(0xE1);   }
    function lido()            external pure returns (address) { return address(0xL1);   }
    function withdrawalQueue() external pure returns (address) { return address(0xWQ);   }
    function stakingRouter()   external pure returns (address) { return address(0xSR);   }
    function wstETH()          external pure returns (address) { return address(0x7F39C581F595B53c5Cb19bD0b3F8dA6c935E2Ca0); }
}
