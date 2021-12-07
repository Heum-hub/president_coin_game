// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./ERC20.sol";
// import "./SafeMath.sol";

contract Politics {

    // using SafeMath for uint256;

    IERC20 public token1;
    IERC20 public token2;

    address private owner;

    event MintEvent(address indexed from, uint256 value);
    event RefundEvent(address indexed to, uint256 value);

    // 명코인, 열코인 발행
    constructor() {
        token1 = new ERC20("MYUNG", "JMT");
        token2 = new ERC20("YEOL", "SYT");
        owner = msg.sender;
    }

    // 송금한 BNB 수량만큼 명/열 코인 발행
    function mint1() payable public {
  
        uint256 amountToBuy = msg.value;
        require(amountToBuy >= 10**16, "BNB amount must be >=0.01");
        token1.mint(msg.sender, amountToBuy * 100);
        
        emit MintEvent(msg.sender, amountToBuy * 100);
    }

    function mint2() payable public {
        
        uint256 amountToBuy = msg.value;
        require(amountToBuy >= 10**16, "BNB amount must be >=0.01");
        token2.mint(msg.sender, amountToBuy * 100);
        
        emit MintEvent(msg.sender, amountToBuy * 100);
    }

    // 발행한 명/열 코인을 클레이로 반환해줌(수수료 1.8% 제외)
    function refund1(uint256 amountToRefund) public {
        
        require(amountToRefund >= 10**18, "JMT amount must be >=1");
        uint256 allowance = token1.allowance(msg.sender, address(this));
        require(allowance >= amountToRefund, "Check the token allowance");
        token1.transferFrom(msg.sender, address(this), amountToRefund);
        payable(msg.sender).transfer(amountToRefund * 982 / 100000);
        
        emit RefundEvent(msg.sender, amountToRefund * 982 / 100000);
    }

    function refund2(uint256 amountToRefund) public {
        
        require(amountToRefund >= 10**18, "SYT amount must be >=1");
        uint256 allowance = token2.allowance(msg.sender, address(this));
        require(allowance >= amountToRefund, "Check the token allowance");
        token2.transferFrom(msg.sender, address(this), amountToRefund);
        payable(msg.sender).transfer(amountToRefund * 982 / 100000);
        
        emit RefundEvent(msg.sender, amountToRefund * 982 / 100000);
    }

    // 각 코인의 발행량에서 컨트랙트로 환불된 코인 제외
    function token1_Balance() public view returns (uint256 _token1_Balance) {

        _token1_Balance = token1.totalSupply() - (token1.balanceOf(address(this)));

        return _token1_Balance;

    }
    
    function token2_Balance() public view returns (uint256 _token2_Balance) {

        _token2_Balance = token2.totalSupply() - (token2.balanceOf(address(this)));

        return _token2_Balance;

    }

    // 2022년 4월 1일에 실행할 메소드(수수료 및 명/열 코인 판매 수익 수취)
    function getRevenue() public {
        
        require(block.timestamp >= 1648738800);
        require(msg.sender == owner);

        payable(owner).transfer(address(this).balance);
    
    }


}