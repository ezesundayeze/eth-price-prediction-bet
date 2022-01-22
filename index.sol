// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./chainlink-price-aggregator.sol";

contract Prediction {
    mapping(address => uint256) public participants;
    mapping(address => uint256) public winners;
    mapping(address => int256) public predictions;
    uint256 public totalPredictionAmount;
    uint256 public totalParticipants;
    address public owner;
    uint256 public startTime;
    uint256 public endTime;
    int256 public openingValue;
    int256 public closingValue;
    string public coin;
    int256 public predictionAmount;
    AggregatorV3Interface internal priceFeed;

    constructor() {
        owner = msg.sender;
        coin = "ETH/USD";
        priceFeed = AggregatorV3Interface(
            0x9326BFA02ADD2366b30bacB125260Af641031331
        );
    }

    event DepositEvent(uint256 _amount, address _participant);

    receive() external payable {
        emit DepositEvent(msg.value, msg.sender);
    }

    // @dev: This function is used to set a participant's price  prediction and to make the default contribution by all participants.
    function predict(int256 _price) external payable {
        if (block.timestamp > endTime) {
            revert("Prediction closed");
        }

        if (int256(msg.value) == predictionAmount) {
            revert("Invalid prediction amount");
        }

        participants[msg.sender] = msg.value;
        predictions[msg.sender] = _price;
        totalPredictionAmount = totalPredictionAmount + msg.value;
        totalParticipants++;
    }
    // Start a new prediction circle
    function startPredictionCircle(int256 _predictionAmount) public {
        startTime = block.timestamp;
        predictionAmount = _predictionAmount;
        totalPredictionAmount = 0;
        totalParticipants = 0;
        openingValue = getLatestPrice();
    }
    // end the prediction circle
    function endPredictionCirle() public {
        closingValue = getLatestPrice();
        endTime = block.timestamp;
    }

    // a Participant can withdraw his deposit and profit if the prediction is in their advantage
    function checkStatusAndWithdraw(address payable _participant)
        public
        payable
    {
        if (block.timestamp < endTime) {
            revert("prediction is not closed yet");
        }
        require(
            int256(participants[_participant]) != (predictionAmount),
            "Not allowed"
        );
        if (closingValue >= predictions[_participant]) {
            // transfer equal amount of totalPredictionAmount to all winners
            uint256 winningAmount = totalPredictionAmount / totalParticipants;
            _participant.transfer(winningAmount);
        }
    }
    // @dev: This function is used to get the latest price from the offchain price feed
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
