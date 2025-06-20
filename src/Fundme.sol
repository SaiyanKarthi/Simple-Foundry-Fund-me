//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Priceconvertor} from "./PriceConvertor.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/*trying my best to write is code as much as simple as possible. So,people who comes here can read and understand my code
For the people who comes here, I will tell you this the main contract the source code. But for this source code we 
need a pricecovertor so first beofre creating it we need,

 => Priceconvertor => Helperconfi(to get pricefeed address automatically)
 => come here and write or read Fundme this main src code
 => create a script file called DeployFundme.s.sol for automating the lot of stuff
 => create a testfile called fundme.t.sol to test our function whcih is in Fundme.sol.*/

contract Fundme {
    using Priceconvertor for uint256;
    uint256 public constant MINIMUM_USD = 5e18; //5 USD worth of crytpocoin only.
    address public immutable I_owner; //Deployer is the contract owner.
    address[] private s_funders; // private variables are Gas efficient.
    mapping(address => uint256) private amountFunded; //shows How much amount got funded from the address if we give it has input to check
    AggregatorV3Interface private d_priceFeed; //pricefeed address

    constructor(address priceFeedaddress) {
        I_owner = msg.sender; //msg.sender is the deployer of the contract
        d_priceFeed = AggregatorV3Interface(priceFeedaddress); //pricefeed address is passed to the contract
    }

    modifier onlyowner() {
        require(msg.sender == I_owner, "You are not the owner!"); //require is used to check if the sender is the owner of the contract
        _; //this is used to call the function which is using this modifier
    }

    function fundme() public payable {
        require(
            MINIMUM_USD <=
                Priceconvertor.getconvertionrate(msg.value, d_priceFeed),
            "You need to spend more ETH!"
        ); //require is used to check if the amount is less than 5 USD
        /* this above line is simplified version. which explains the MINIMUM_USD (which is in state variable) is = or < to receive funds using
      the Priceconvertor library we are calling the getconvertionrate function to check the amount of ETH sent in USD */

        amountFunded[msg.sender] += msg.value;
        // msg.value is the amount of ETH sent to the contract by the user who use fundme function.

        s_funders.push(msg.sender);
        //msg.sender is the address of the person who is calling the function
    }

    function myfundings() public view returns (uint256) {
        require(
            amountFunded[msg.sender].getconvertionrate(d_priceFeed) >
                5 * MINIMUM_USD,
            "You have not funded enough!"
        ); //this function can only be called if the user has funded cryto worth more than 25 usd cuz of gas fees
        return amountFunded[msg.sender]; //returns the amount funded by the user
    }

    function withdraw() public onlyowner {
        for (uint i = 0; i < s_funders.length; i++) {
            address fund = s_funders[i];
            amountFunded[fund] = 0; //reset the amount funded by the user to 0
        }
        s_funders = new address[](0); //reset the funders array to empty
        (bool successful, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        //transfer the balance of the contract to the owner
        require(successful, "Transfer failed!"); //require is used to check if the transfer was successful
    }

    fallback() external payable {
        fundme();
    } /*if someone sends ETH to the contract without calling the fundme function
         (like if someone directy fund to contract address without using fundme button in frontend), it will call the fundme function*/

    receive() external payable {
        fundme(); //if someone sends ETH or crytpo directly to our contract address without data or usign any function
    }
    /*in simple terms here the differnce between two special functions

receive() = “Just ETH? Sure, I’ll take it.” 

fallback() = “You’re calling something weird? Let me handle that — maybe I’ll take your ETH too.
*/
}
