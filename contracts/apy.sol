// SPDX-License-Identifier: GPL-3.0
// CHAIDEX Version 1

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Apy is Ownable {
      address public CHT;
      address public MP;
      address public RP;
      uint256 public amount1;
      uint256 public amount2;
       constructor(address _CHT, address _MP,address _RP) {
        CHT = _CHT;
        RP=_RP;
        MP=_MP;
    }
       function setAddress(address _CHT) public onlyOwner {
           CHT = _CHT;
    }


    function fees(uint256 _amount) public {
        amount1= 80*_amount/100;
        amount2=20*_amount/100;
        IERC20(CHT).transferFrom(msg.sender,RP,amount1);
        IERC20(CHT).transferFrom(msg.sender, MP, amount2);

    }
}
