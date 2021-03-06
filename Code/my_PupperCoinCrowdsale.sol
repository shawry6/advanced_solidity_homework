pragma solidity ^0.5.0;

import "./my_PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate, 
        address payable wallet, 
        PupperCoin token,
        uint goal, 
        uint open,
        uint close
    )

        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)  // rate = 1, wallet = purchaser, token = PupperCoin
        // MintedCrowdsale(rate, wallet, token) // 
        CappedCrowdsale(goal) // goal = 300ETH
        TimedCrowdsale(open, close) // open = now, close = now + 24
        RefundableCrowdsale(goal) // goal = 300ETH
        public
        
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public puppercoin_sale_address;
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name, 
        string memory symbol, 
        address payable wallet
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal (300ETH), and set the open and close times to now and now + 24 weeks.
        PupperCoinSale puppercoin_sale = new PupperCoinSale(1,wallet,token, 300, now, now + 24 weeks); //, goal, open, close);
        puppercoin_sale_address = address(puppercoin_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(puppercoin_sale_address);
        token.renounceMinter();
    }
}
