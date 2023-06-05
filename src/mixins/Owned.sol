// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @notice Simple single owner authorization mixin
/// @author This is slightly modified Solmate verison
/// (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
abstract contract Owned {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event OwnershipTransferred(address indexed user, address indexed newOwner);

    /*//////////////////////////////////////////////////////////////
                            OWNERSHIP STORAGE
    //////////////////////////////////////////////////////////////*/

    address internal _owner;

    modifier onlyOwner() virtual {
        require(msg.sender == _owner, "UNAUTHORIZED");

        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address owner_) {
        _owner = owner_;

        emit OwnershipTransferred(address(0), owner_);
    }

    /*//////////////////////////////////////////////////////////////
                             OWNERSHIP LOGIC
    //////////////////////////////////////////////////////////////*/

    function transferOwnership(address newOwner) public virtual onlyOwner {
        _owner = newOwner;

        emit OwnershipTransferred(msg.sender, newOwner);
    }

    /*//////////////////////////////////////////////////////////////
                             OWNER GETTER
    //////////////////////////////////////////////////////////////*/
    function owner() public view virtual returns (address) {
        return _owner;
    }
}
