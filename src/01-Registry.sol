// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

/**
 * @title A name registry smart contract
 * @author catellaTech
 * @notice You can use this contract to register and release names. A name once
 * registered cannot be claimed by another until released.
 */
contract Registry {
    /// @notice mapping from names to users
    mapping(string name => address userAdd) users;

    /// @notice Event to emit when an user is registred sucessfully
    event Registered(address indexed to, string name);
    /// @notice Event to emit when an user is released sucessfully
    event Released(address indexed from, string name);

    /// @notice Function to registry a name
    /// @param name that the user want to registry
    function register(string calldata name) external {
        require(users[name] == address(0), "Already registered!");
        users[name] = msg.sender;
        emit Registered(msg.sender, name);
    }

    /// @notice Function to release a name
    /// @param name that the user want to release
    function release(string calldata name) external {
        require(users[name] == msg.sender, "You haven't registered this");
        delete users[name];
        emit Released(msg.sender, name);
    }
}
