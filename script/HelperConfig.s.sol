//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mockv3Aggregator.t.sol";

contract Helperconfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000;

    struct Networkconfig {
        address priceFeed;
    }

    Networkconfig public Network;

    constructor() {
        if (block.chainid == 11155111) {
            Network = getsepoliacongfig();
        } else if (block.chainid == 1) {
            Network = getmainnetconfig();
        } else if (block.chainid == 137) {
            Network = getpolycongfig();
        } else {
            Network = getsepoliacongfig();
        }
    }

    function getsepoliacongfig() public pure returns (Networkconfig memory) {
        Networkconfig memory sepoliaconfig = Networkconfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaconfig;
    }

    function getmainnetconfig() public pure returns (Networkconfig memory) {
        Networkconfig memory getmainnet = Networkconfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return getmainnet;
    }

    function getpolycongfig() public pure returns (Networkconfig memory) {
        Networkconfig memory polycongfig = Networkconfig({priceFeed: 0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6});
        return polycongfig;
    }

    function getanvilconfig() public returns (Networkconfig memory) {
        if (Network.priceFeed != address(0)) {
            return Network;
        }
        vm.startBroadcast();
        MockV3Aggregator mockpricefeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        Networkconfig memory anvilconfig = Networkconfig({priceFeed: address(mockpricefeed)});
        return anvilconfig;
    }
}
