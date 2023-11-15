// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import {Registry} from "../src/01-Registry.sol";

/* 
1. We create two users.
2. We create the events.
3. We test the Register function.
4. We test the release function.
5. We test the expectRevert and expectEmit.
*/
contract RegistryTest is Test {
    Registry public registryContract;

    address public userOne = makeAddr("userOne");
    address public userTwo = makeAddr("userTwo");

    /// @notice Event to emit when an user is registred sucessfully
    event Registered(address indexed to, string name);
    /// @notice Event to emit when an user is released sucessfully
    event Released(address indexed from, string name);

    function setUp() public {
        registryContract = new Registry();
    }

    function testRegister() public {
        vm.expectEmit(false, false, true, true);
        // We emit the event we expect to see.
        emit Registered(userOne, "catellaTech");
        // We perform the call.
        vm.startPrank(userOne);
        registryContract.register("catellaTech");
        vm.stopPrank();

        // Expect revert with the follow msg "Already registered!" when another user try to register the same name
        vm.expectRevert(bytes("Already registered!"));
        vm.startPrank(userTwo);
        registryContract.register("catellaTech");
        vm.stopPrank();
    }

    function testRelease() public {
        testRegister();
        vm.startPrank(userOne);
        vm.expectEmit(false, false, false, true);
        // We emit the event we expect to see.
        emit Released(userOne, "catellaTech");
        registryContract.release("catellaTech");
        vm.stopPrank();
    }
}
