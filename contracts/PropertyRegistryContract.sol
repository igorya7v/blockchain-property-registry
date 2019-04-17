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

    mapping(uint => PropertyDetails) public propertiesMap;

    function addProperty(string propertyAddress) public {

        require(msg.sender == contractOwner);

        uint id = properties.length;
        PropertyDetails newProperty = PropertyDetails(id, propertyAddress, 0x0);
        properties.push(newProperty);
        propertiesMap[id] = newProperty;

        emit NewPropertyAdded(id, propertyAddress);
    }

    function setPropertyOwnership(byte32 propertyId, address owner) public {

        require(msg.sender == contractOwner);

        require(propertiesMap[propertyId].owner == 0x0);

        propertiesMap[propertyId].owner = owner;

        emit PropertyOwnershipSet(propertyId, owner);
    }

    function transferPropertyOwnership(byte32 propertyId, address newOwner) public {

        require(propertiesMap[propertyId].owner == msg.sender);

        propertiesMap[propertyId].owner = newOwner;

        emit PropertyOwnershipTransferred(propertyId, msg.sender, newOwner);
    }
 }