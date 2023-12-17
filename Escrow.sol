pragma solidity ^0.8.0;

contract Escrow {
    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, REFUNDED }
    State public currentState;

    address public buyer;
    address payable public seller;

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this method");
        _;
    }

    constructor(address _buyer, address payable _seller) {
        buyer = _buyer;
        seller = _seller;
    }

    function deposit() onlyBuyer external payable {
        require(currentState == State.AWAITING_PAYMENT, "Already paid");
        currentState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery() onlyBuyer external {
        require(currentState == State.AWAITING_DELIVERY, "Cannot confirm delivery");
        seller.transfer(address(this).balance);
        currentState = State.COMPLETE;
    }

    function refundBuyer() onlyBuyer external {
        require(currentState == State.AWAITING_DELIVERY, "Cannot refund");
        payable(msg.sender).transfer(address(this).balance);
        currentState = State.REFUNDED;
    }
}
