// SPDX-FileCopyrightText: 2025 Lido <info@lido.fi>
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

/*  ────────────────────────────────────────────────────────────────────────────
    MINIMAL HARNESS
    •  We stub every external dependency so **no real libraries must be linked**.
    •  The single invariant always returns true – it only proves that Echidna’s
       plumbing works.  Replace it later with real properties.
    ───────────────────────────────────────────────────────────────────────── */
contract Echidna_Accounting_Invariants {
    /* ---------------------------------------------------------------------- */
    /* Echidna looks for functions that start with `echidna_` and return bool */
    /* ---------------------------------------------------------------------- */
    function echidna_dummy() external pure returns (bool ok) {
        return true;                     // ← always passes
    }
}
