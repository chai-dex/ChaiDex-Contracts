// SPDX-License-Identifier: MIT
// CHAIDEX Version 1
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
contract LiquidityPoolTron is Ownable,Pausable {


    function unpause() public onlyOwner {
        _unpause();
    }

    function pause() public onlyOwner {
        _pause();
    }
 constructor() {}
    event Stake(string USD, address liquidityProvider, uint256 amount);
    /**
     * Event Unstake
     * Note:
     * is emitted when a liquidity providers takes liquidity from the liquidity pool
     */
    event Unstake(
        string USD,
        address liquidityProvider,
        uint256 amount
    );

    /**
        These are the Stakers
    */
    address[] public stakers;
    /**
     * List of all the USD stable coins we support
     * 0 - USDC
     * 1 - USDT
     * 2 - BUSD
     */
    mapping(uint8 => address) public USDStable;
    mapping(uint8 => string) public names;
    /**
     * This Mapping maps the amount of USD they have staked to the Respective USD LP's
     * user address => Token Index => Staked Amount
     * user1        => USDC        => 10,000
     * user2        => USDT        => 6,000
     * user1        => USDT        => 1,000
     */
    mapping(address => mapping(uint8 => uint256)) public liquidityPool;
    mapping(address => mapping(uint8 => bool)) public unstakedMax;


    /**
     * No of times the same user has staked in the Liquidity Pool
     * 0 - USDC
     * 1 - USDT
     * 2 - BUSD
     * example:
     * user1 => 0(USDC) => 2
     */
    mapping(address => mapping(uint8 => uint256)) public liquidityPoolStakes;

    /**
     * Total Liquidity of the pool
     */
    uint256 public totalLiquidity;
    bool public epochover;
    /**
     * @dev Updates the address of the USD stable coins in the list
     */
function setEpoch(bool _over)public onlyOwner whenNotPaused {
epochover=_over;
}

    function setUSDAddress(
        uint8 _index,
        string memory _name,
        address _USD
    ) public whenNotPaused onlyOwner {
        USDStable[_index] = _USD;
        names[_index] = _name;
    }

    /**
     *
     * @dev See {_stake}
     * NOTE:
     *  Visibility: Public
     */

    function stake(uint8 _usd, uint256 _amount) public {
        _stake(_usd, _amount);
    }

    /**
     *
     * @dev See {_unStake}
     * NOTE:
     *  Visibility: Public
     */

    function unstake(uint8 _usd, uint256 _amount) public {
        _unStake(_usd, _amount);
    }
    function unstakeAll(uint8 _usd) public {
        _unstakeAll(_usd);
    }

    /**
     *
     * @dev Function that lets users stake USD Stable into the Pool
     * @param _usd Index of the USD Stable Coin
     * @param _amount amount of USD to Stake
     * NOTE:
     *  Visibility: Internal
     * TODO:
     *  Define the epochs and reward algorithm along woth 24-36 hur cooldown timelock in immediate iteration
     */
    function _stake(uint8 _usd, uint256 _amount) internal whenNotPaused {
        require(_amount > 0, "Treasury Pool: Amount cannot be Zero");
        if (liquidityPool[msg.sender][_usd] == 0) {
            liquidityPoolStakes[msg.sender][_usd] += 1;
        }
        IERC20(USDStable[_usd]).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        liquidityPool[msg.sender][_usd] += _amount;
        unstakedMax[msg.sender][_usd]=false;
        totalLiquidity += _amount;
        stakers.push(msg.sender);
        emit Stake(names[_usd], msg.sender, _amount);
    }

    /**
     *
     * @dev Function that lets Stakers withdraw USD Stable out of the Pool
     * @param _usd Index of the USD Stable Coin
     * @param _amount amount of USD to Stake
     * NOTE:
     *  Visibility: Internal
     * TODO:
     *  Define the epochs and reward algorithm along woth 24-36 hur cooldown timelock in immediate iteration
     */
    function _unStake(uint8 _usd, uint256 _amount) internal whenNotPaused {
        uint256 balance = liquidityPool[msg.sender][_usd];
        require(
           _amount<= balance *80/100 ,
            "Treasury Pool: Amount is Zero or Greater than Stake"
        );
        require(_amount > 0, "Amount cannot be 0");
         require( !unstakedMax[msg.sender][_usd],"unstake full later first");
         unstakedMax[msg.sender][_usd]=true;
        IERC20(USDStable[_usd]).transfer(msg.sender, _amount);
        liquidityPool[msg.sender][_usd] -= _amount;
        totalLiquidity -= _amount;
        emit Unstake(names[_usd], msg.sender, _amount);
    }
function _unstakeAll(uint8 _usd) internal whenNotPaused {

        uint256 balance = liquidityPool[msg.sender][_usd];

        require (epochover,"yet to unstake");
        require( unstakedMax[msg.sender][_usd],"unstake half first");
        IERC20(USDStable[_usd]).transfer(msg.sender,balance);
        liquidityPool[msg.sender][_usd] -= balance;
        totalLiquidity -= balance;
        liquidityPoolStakes[msg.sender][_usd] -= 1;
}
}