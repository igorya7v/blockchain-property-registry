pragma solidity ^0.5.0;

contract PropertyRegistryContract {

    event NewPropertyAdded(uint id, string propertyAddress);

    event PropertyOwnershipSet(uint propertyId, address owner);

    event PropertyOwnershipTransferred(uint propertyId, address previousOwner, address newOwner);

    struct PropertyDetails {
        uint id;
        string propertyAddress;
        address owner;
    }

    address public contractOwner;

    PropertyDetails[] public properties;

    constructor() public {
        contractOwner = msg.sender;
    }

    function addProperty(string memory propertyAddress) public {

        require(msg.sender == contractOwner);

        uint id = properties.length;
        PropertyDetails memory newProperty = PropertyDetails(id, propertyAddress, address(0));
        properties.push(newProperty);

        emit NewPropertyAdded(id, propertyAddress);
    }

    function setPropertyOwnership(uint propertyId, address owner) public {

        require(msg.sender == contractOwner);

        require(properties[propertyId].owner == address(0));

        properties[propertyId].owner = owner;

        emit PropertyOwnershipSet(propertyId, owner);
    }

    function transferPropertyOwnership(uint propertyId, address newOwner) public {

        require(properties[propertyId].owner == msg.sender);

        properties[propertyId].owner = newOwner;

        emit PropertyOwnershipTransferred(propertyId, msg.sender, newOwner);
    }
}