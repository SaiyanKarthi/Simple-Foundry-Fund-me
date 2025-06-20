//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Fundme} from "../src/Fundme.sol";
import {Helperconfig} from "../script/HelperConfig.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {MockV3Aggregator} from "../test/Mockv3Aggregator.t.sol";
import {DeployFundme} from "../script/DeployFundme.s.sol";

contract fundmeTest is Test {
    uint256 public constant SEND_VALUE = 5e18;
    Fundme fundme;
    address USER = makeAddr("user");

    function setUp() public {
        Helperconfig helperConfig = new Helperconfig();
        address priceFeed = helperConfig.Network();
        fundme = new Fundme(priceFeed);
    }

    function testMINIMUM_USD() public view {
        console.log("MINIMUM_USD:", fundme.MINIMUM_USD());
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testonwerissneder() public view {
        assertEq(fundme.I_owner(), address(this));
    }
}
