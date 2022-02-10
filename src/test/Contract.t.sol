// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Vm} from "forge-std/Vm.sol";

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
}

contract ContractTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    Utilities internal utils;
    address payable[] internal users;

    function setUp() public {
        utils = new Utilities();
        users = utils.createUsers(2);
    }

    function testExample() public {
        address payable alice = users[0];
        vm.label(alice, "Alice");
        console.log("alice's address", alice);
        address payable bob = users[1];
        vm.label(bob, "Bob");
        vm.prank(alice);
        (bool sent, ) = bob.call{value: 10 ether}("");
        assertTrue(sent);
        assertGt(bob.balance, alice.balance);
    }

    function testTokenFakeMint() public {
        address payable alice = users[0];
        vm.label(alice, "Alice");
        utils.writeTokenBalance(alice, DAI, 1_000_000_000 * 1e18);
        uint256 fakeBalance = IERC20(DAI).balanceOf(alice);
        console.log("alice's dai balance", fakeBalance);
        assertEq(fakeBalance, 1_000_000_000 * 1e18);
    }
}
