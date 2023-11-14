// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import { Registry } from "../src/01-Registry.sol";

/* 
1. We create two users.
2. We create the events.
3. We test the Register function.
4. We test the release function.
5. We test the expectRevert and expectEmit.
*/
contract RegistryTest is Test {
    Registry public registryContract;

    address public  USER_ONE = vm.addr(0x01);
    address public  USER_TWO = vm.addr(0x02);

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
        emit Registered(USER_ONE, "catellaTech");
        // We perform the call.
        vm.startPrank(USER_ONE);
        registryContract.register("catellaTech");
        vm.stopPrank();

        // Expect revert with the follow msg "Already registered!" when another user try to register the same name
        vm.expectRevert(bytes("Already registered!"));
        vm.startPrank(USER_TWO);
        registryContract.register("catellaTech");
        vm.stopPrank();
    }

    function testRelease() public {
        testRegister();
        vm.startPrank(USER_ONE);
        vm.expectEmit(false, false, false, true);
        // We emit the event we expect to see.
        emit Released(USER_ONE, "catellaTech");
        registryContract.release("catellaTech");
        vm.stopPrank();
    }
}
