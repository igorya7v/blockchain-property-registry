pragma solidity ^0.4.0;

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

    modifier isContractOwner() {
        require(msg.sender == contractOwner);
        _;
    }

    modifier isNewProperty(uint propertyId) {
        require(propertiesMap[propertyId].owner == 0x0);
        _;
    }

    modifier isPropertyOwner(uint propertyId, address owner) {
        require(propertiesMap[propertyId].owner == owner);
        _;
    }

    function addProperty(string propertyAddress) public isContractOwner {

        uint id = properties.length;
        PropertyDetails newProperty = PropertyDetails(id, propertyAddress, 0x0);
        properties.push(newProperty);
        propertiesMap[id] = newProperty;

        emit NewPropertyAdded(id, propertyAddress);
    }

    function setPropertyOwnership(
        byte32 propertyId,
        address owner
    ) public isContractOwner isNewProperty(propertyId) {

        propertiesMap[propertyId].owner = owner;

        emit PropertyOwnershipSet(propertyId, owner);
    }

    function transferPropertyOwnership(
        byte32 propertyId,
        address newOwner
    ) public isPropertyOwner(propertyId, msg.sender) {

        propertiesMap[propertyId].owner = newOwner;

        emit PropertyOwnershipTransferred(propertyId, msg.sender, newOwner);
    }
 }