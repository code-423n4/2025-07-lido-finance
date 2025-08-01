// SPDX-FileCopyrightText: 2025 Lido <info@lido.fi>
// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.24;

import { GIndex } from "../../src/lib/GIndex.sol";

// Check using `yarn run gindex`
library GIndices {
    GIndex constant FIRST_WITHDRAWAL_DENEB =
        GIndex.wrap(
            0x0000000000000000000000000000000000000000000000000000000000e1c004
        );
    GIndex constant FIRST_VALIDATOR_DENEB =
        GIndex.wrap(
            0x0000000000000000000000000000000000000000000000000056000000000028
        );
    GIndex constant FIRST_HISTORICAL_SUMMARY_DENEB =
        GIndex.wrap(
            0x0000000000000000000000000000000000000000000000000000007600000018
        );
    GIndex constant FIRST_BLOCK_ROOT_IN_SUMMARY_DENEB =
        GIndex.wrap(
            0x000000000000000000000000000000000000000000000000000000000040000d
        );

    GIndex constant FIRST_WITHDRAWAL_ELECTRA =
        GIndex.wrap(
            0x000000000000000000000000000000000000000000000000000000000161c004
        );
    GIndex constant FIRST_VALIDATOR_ELECTRA =
        GIndex.wrap(
            0x0000000000000000000000000000000000000000000000000096000000000028
        );
    GIndex constant FIRST_HISTORICAL_SUMMARY_ELECTRA =
        GIndex.wrap(
            0x000000000000000000000000000000000000000000000000000000b600000018
        );
    GIndex constant FIRST_BLOCK_ROOT_IN_SUMMARY_ELECTRA =
        GIndex.wrap(
            0x000000000000000000000000000000000000000000000000000000000040000d
        );
}
