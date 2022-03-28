// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

//create a contract that show ownership
contract owned {
    address  public owner;
    
    constructor(){
        owner = msg.sender;
        
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "I am the owner");
        _;
    }
    
    //This function enable transfer on ownership of the token 
    function transferOwnership (address newOwner) internal onlyOwner{
        owner = newOwner;
    }
   
}


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
 
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}



contract Alleviate is owned {
  // wallet address
  address public wallet = 0x0;
    using SafeMath for uint256;
    //This is the token name
    string public name = "Alleviate Coin";
    //This is the token symbol
    string public symbol = "ALC";
    //This is the token decimals
    uint public decimals = 18;
    //This is the token total supply
    uint256 public totalSupply;
    //This is the token balance of the owner
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) internal allowed;
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    
 constructor(uint256 _initialSupply) public{
   // add the initial supply to the total supply
    totalSupply = _initialSupply *10**decimals;
    balances[msg.sender] = totalSupply;
    emit Transfer(address(0),msg.sender, totalSupply);
  }
  // This is the function that transfer the token to the owner
  function transfer(address to, uint256 value) public {
    require(balances[msg.sender] >= value, "Insufficient balance");
    tax();
    balances[msg.sender] -= value;
    balances[to] += value;
    emit Transfer(msg.sender, to, value);
  }
  
  // This is the function that return the balance of the owner
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  // This is the function that allow the owner to approve the transfer of the token to the other address
  function approve(address _spender, uint256 _value) public {
    require(balances[msg.sender] >= _value, "Insufficient balance");
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
  }
  //This is the function allow other address to transfer the token 
  function transferFrom(address _from, address _to, uint256 _value) public {
    require(allowed[_from][msg.sender] >= _value, "Insufficient allowance");
    balances[_from] -= _value;
    balances[_to] += _value;
    allowed[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
  }

  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  // This is the function that burn the token
  function burn(uint256 _value) internal onlyOwner {
    require(balances[msg.sender] >= _value, "Insufficient balance");
    balances[msg.sender] -= _value;
    emit Transfer(msg.sender, address(0), _value);
  }

  // This is the function that mint the token
  function mint(address _to, uint256 _value) internal onlyOwner {
    balances[_to] += _value;
    emit Transfer(address(0), _to, _value);
  }
  // how add tax to the token on every transfer and transfer to the owner
  function tax(uint256 _value) internal onlyOwner {
    balances[msg.sender] -= _value;
    // send the tax to the owner
    balances[wallet] += _value;
    emit Transfer(msg.sender, address(0), _value);
  } 
  
}
