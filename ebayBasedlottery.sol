// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;
import eth_utils;

contract AuctionCreator{
    Auction[] public auctions;

    function createAuction() public{
        Auction newAuction = new Auction(msg.sender);
        auctions.push(newAuction);
    }
}


contract Auction {
    address payable public owner;
    uint256 public startBlock;
    uint256 public endBlock;
    string public ipfsHash;

    enum State {
        Started,
        Running,
        Ended,
        Canceled
    }
    State public auctionState;

    uint256 public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint256) public bids;
    uint256 bidIncrement;

    constructor(address eoa) {
        owner = payable(eoa);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 4;
        ipfsHash = "";
        bidIncrement = 1000000000000000000;
    }

    modifier notOwner() {
        require(msg.sender != owner);
        _;
    }
    modifier afterStart() {
        require(block.number >= startBlock);
        _;
    }
    modifier beforEnd() {
        require(block.number <= endBlock);
        _;
    }
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a <= b) {
            return a;
        } else {
            return b;
        }
    }

    function placeBid() public payable notOwner afterStart beforEnd {
        // implicit int variable for validating the start and end the auction
        require(auctionState == State.Running);
        // minimum value for starting the auction is 100 wie;
        require(msg.value >= 100);
        // currentBid are those who start this bid now
        uint256 currentBid = bids[msg.sender] + msg.value;
        // it validate the currentBid is higher then its previous bid
        require(currentBid > highestBindingBid);
        // it will automaticlly define the current bidder as an currentBid that is higher then previous
        bids[msg.sender] = currentBid;
        // if the current bid is lower
        if (currentBid <= bids[highestBidder]) {
            // then new bid then currentbid value is increased by increment value that is 100 wei
            highestBindingBid = min(
                currentBid + bidIncrement,
                bids[highestBidder]
            );
        } else {
            // or else the higher bidder is liable to pay and the
            highestBindingBid = min(
                currentBid,
                bids[highestBidder] + bidIncrement
            );
            highestBidder = payable(msg.sender);
        }
    }

    // Cancelling the auction by its owner
    function cancleAuction() public onlyOwner {
        auctionState = State.Canceled;
    }

    function finalizeAuction() public {
        require(auctionState == State.Canceled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);
        address payable recipient;
        uint256 value;
        if (auctionState == State.Canceled) {
            // Auction is cancelled
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        } else {
            // Auction ended (not canceled)
            if (msg.sender == owner) {
                // this is the owner
                recipient = owner;
                value = highestBindingBid;
            } else {
                // this is the bidder
                if (msg.sender == highestBidder) {
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                } else {
                    // this the neither the owner nor a bidder
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }
        // after finalizing the auction and amount paid to 
        // the recipient then its value must be zero
        bids[recipient] = 0;

        // sends value to recipient
        recipient.transfer(value);
    }
}
