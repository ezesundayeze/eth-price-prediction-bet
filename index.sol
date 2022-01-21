// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./chainlink-price-aggregator.sol";

contract Prediction {
    mapping(address => uint256) public participants;
    mapping(address => uint256) public winners;
    mapping(address => int256) public bids;
    uint256 public totalBidsAmount;
    uint256 public totalParticipants;
    address public owner;
    uint256 public startTime;
    uint256 public endTime;
    int256 public openingValue;
    int256 public closingValue;
    string public coin;
    int256 public bidAmount;
    AggregatorV3Interface internal priceFeed;

    event DepositEvent(uint256 _amount, address _participant);

    constructor(int256 _bidAmount) {
        owner = msg.sender;
        coin = "ETH/USD";
        bidAmount = _bidAmount;
        priceFeed = AggregatorV3Interface(
            0x9326BFA02ADD2366b30bacB125260Af641031331
        );
    }

    receive() external payable {
        emit DepositEvent(msg.value, msg.sender);
    }

    function bid(int256 _price) external payable {
        if (block.timestamp > endTime) {
            revert("Bidding is closed");
        }

        if (int256(msg.value) == bidAmount) {
            revert("Invalid bid");
        }

        participants[msg.sender] = msg.value;
        bids[msg.sender] = _price;
        totalBidsAmount = totalBidsAmount + msg.value;
        totalParticipants++;
    }

    function start() public {
        startTime = block.timestamp;
        openingValue = getLatestPrice();
    }

    function end() public {
        closingValue = getLatestPrice();
        endTime = block.timestamp;
    }

    function checkStatusAndWithdraw(address payable _participant)
        public
        payable
    {
        if (block.timestamp < endTime) {
            revert("Bidding is not closed yet");
        }
        require(
            int256(participants[_participant]) != (bidAmount),
            "Not allowed"
        );
        if (closingValue >=bids[_participant] ) {
            // transfer equal amount of totalBidsamount to all winners
            uint256 winningAmount = totalBidsAmount / totalParticipants;
            _participant.transfer(winningAmount);
        }
    }

    function getLatestPrice() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}
