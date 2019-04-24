pragma solidity ^0.5.0;

contract PropertyRegistryContract {

    event NewPropertyAdded(uint indexed id, string indexed propertyAddress);

    event PropertyOwnershipSet(uint indexed propertyId, address indexed owner);

    event PropertyOwnershipTransferred(
        uint indexed propertyId,
        address indexed previousOwner,
        address indexed newOwner);


    struct PropertyDetails {
        uint propertyId;
        string propertyAddress;
        address propertyOwner;
    }


    address public contractOwner;

    PropertyDetails[] public properties;


    constructor() public {
        contractOwner = msg.sender;
    }


    function addProperty(string memory propertyAddress) public {

        // This function can ONLY be used by the owner of the contract.
        require(msg.sender == contractOwner);

        // Assign the property id as an index in the array of properties for easy mapping.
        uint id = properties.length;

        // Initialise a new Property instance.
        PropertyDetails memory newProperty = PropertyDetails(id, propertyAddress, address(0));

        // Add the new property to the array of properties.
        properties.push(newProperty);

        // Emmit the new property added event for logging.
        emit NewPropertyAdded(id, propertyAddress);
    }


    function setPropertyInitialOwnership(uint propertyId, address owner) public {

        // This function can ONLY be used by the owner of the contract.
        require(msg.sender == contractOwner);

        // This function can be called ONLY if the property hasn't had an owner yet.
        require(properties[propertyId].owner == address(0));

        // Set the initial property owner.
        properties[propertyId].owner = owner;

        // Emit the property ownership set event for logging.
        emit PropertyOwnershipSet(propertyId, owner);
    }


    function transferPropertyOwnership(uint propertyId, address newOwner) public {

        // This function can ONLY be used by the current property owner.
        require(properties[propertyId].owner == msg.sender);

        // Set the new owner.
        properties[propertyId].owner = newOwner;

        // Emmit the property ownership transferred event for logging.
        emit PropertyOwnershipTransferred(propertyId, msg.sender, newOwner);
    }
}
