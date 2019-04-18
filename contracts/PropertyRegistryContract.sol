pragma solidity ^0.5.0;

/**
* PropertyRegistryContract is a contract for managing records of Real Estate Properties, Owners
* and transfers of the Ownership.
*/
contract PropertyRegistryContract {

    /**
    * Event for new property added logging.
    *
    * @param id                 The id of the new property.
    * @param propertyAddress    The address of the new property.
    */
    event NewPropertyAdded(uint indexed id, string indexed propertyAddress);

    /**
    * Event for property ownership set logging.
    *
    * @param propertyId     The id of the property.
    * @param owner          The address of the set owner.
    */
    event PropertyOwnershipSet(uint indexed propertyId, address indexed owner);

    /**
    * Event for property ownership transferred logging.
    *
    * @param propertyId     The id of the property.
    * @param previousOwner  The previous owner of the property.
    * @param newOwner       The new owner of the property.
    */
    event PropertyOwnershipTransferred(
        uint indexed propertyId,
        address indexed previousOwner,
        address indexed newOwner);

    /**
    * The Property Details structure: every Property is composed of:
    * - Property id
    * - Property address
    * - Property owner
    */
    struct PropertyDetails {
        uint id;
        string propertyAddress;
        address owner;
    }

    /**
    * Address of the contract owner.
    */
    address public contractOwner;

    /**
    * Properties Map.
    * The key or id of the property is it's index in the properties array.
    */
    PropertyDetails[] public properties;

    /**
    * Constructor of the Property Registry Contract.
    * Sets the original owner of the contract to the sender account.
    */
    constructor() public {
        contractOwner = msg.sender;
    }

    /**
    * Adds a new property to the registry.
    *
    * @param propertyAddress    The address of the property.
    */
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

    /**
    * Sets the initial property ownership.
    *
    * @param propertyId     The id of the property.
    * @param owner          The address of the owner to set.
    */
    function setPropertyOwnership(uint propertyId, address owner) public {

        // This function can ONLY be used by the owner of the contract.
        require(msg.sender == contractOwner);

        // This function can be called ONLY if the property hasn't had an owner yet.
        require(properties[propertyId].owner == address(0));

        // Set the initial property owner.
        properties[propertyId].owner = owner;

        // Emit the property ownership set event for logging.
        emit PropertyOwnershipSet(propertyId, owner);
    }

    /**
    * Allows the current property owner to transfer ownership to a new owner.
    *
    * @param propertyId     The id of the property to transfer.
    * @param newOwner       The address to transfer ownership to.
    */
    function transferPropertyOwnership(uint propertyId, address newOwner) public {

        // This function can ONLY be used by the current property owner.
        require(properties[propertyId].owner == msg.sender);

        // Set the new owner.
        properties[propertyId].owner = newOwner;

        // Emmit the property ownership transferred event for logging.
        emit PropertyOwnershipTransferred(propertyId, msg.sender, newOwner);
    }
}