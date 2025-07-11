// SPDX-FileCopyrightText: 2025 Lido <info@lido.fi>
// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.24;

import "forge-std/Test.sol";

import { DeploymentFixtures } from "./helpers/Fixtures.sol";
import { DeployParams } from "./../script/DeployBase.s.sol";

import { Utilities } from "./helpers/Utilities.sol";

// based on test/fork/deployment/PostDeployment.t.sol
// run `just test-poc` to run the tests here

contract DeploymentBaseTest_PoC is Test, Utilities, DeploymentFixtures {
    DeployParams internal deployParams;
    uint256 adminsCount;

    function setUp() public {
        Env memory env = envVars();
        vm.createSelectFork(env.RPC_URL);
        initializeFromDeployment();
        deployParams = parseDeployParams(env.DEPLOY_CONFIG);
        adminsCount = block.chainid == 1 ? 1 : 2;
    }

    function test_PoC() public view {
    // add here the test scenario, e.g.:
        // (uint256 strikesLifetime, uint256 strikesThreshold) = parametersRegistry
        //     .defaultStrikesParams();
        // assertEq(strikesLifetime, deployParams.defaultStrikesLifetimeFrames);
        // assertEq(strikesThreshold, deployParams.defaultStrikesThreshold);
    }

}