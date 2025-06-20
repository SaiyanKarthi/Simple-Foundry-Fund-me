//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {Fundme} from "../src/Fundme.sol";
import {Helperconfig} from "./HelperConfig.s.sol";

contract DeployFundme is Script {
    function run() external returns (Fundme, Helperconfig) {
        Helperconfig helperConfig = new Helperconfig();
        address priceFeed = helperConfig.Network();
        vm.startBroadcast();
        Fundme fundme = new Fundme(priceFeed);
        vm.stopBroadcast();
        console.log("Fundme deployed to: ", address(fundme));
        return (fundme, helperConfig);
    }
}
