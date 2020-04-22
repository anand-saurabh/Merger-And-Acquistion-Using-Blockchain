pragma solidity ^0.6.0;

contract MandA {

   
    address payable public sellerAddress;

    address public highestReceivedProposalAddress;
    uint public highestProposedValue;
    uint public minimumProposalAmount;
    mapping(address => uint) receivedValuesMap;
    uint public acquisitionEndDate;


    string str;

    bool isSaleActive;
    bool isNegotiationActive;

    event logMinimum(uint);
    event Message(string message);

    constructor () public {
        sellerAddress = msg.sender;
        isSaleActive = false;
        isNegotiationActive = false;
        highestProposedValue = 0;
    }   


    function placeInitialBid() public payable {
        // require aunction end
        require(
            isSaleActive == true,
            "Sale is not active right now"
        );
         require(
            isNegotiationActive == false,
            "Negotation is active. Cannot increase proposed value!"
        );
         require(
            msg.sender != sellerAddress,
            "Seller cannot place values!"
        );
        require(
            (msg.value + receivedValuesMap[msg.sender])/ 10**18 > minimumProposalAmount,
            "Amount cannot be less than or equal to minimum proposed amount"
        );
        //Added Value to map
        receivedValuesMap[msg.sender] += msg.value;
        //Change highest if necessary
        if(receivedValuesMap[msg.sender] > highestProposedValue){
            highestProposedValue = receivedValuesMap[msg.sender];
            highestReceivedProposalAddress = msg.sender;
        }
    }  

    function withdraw() public returns (bool) {
        require(
            msg.sender != highestReceivedProposalAddress,
            "Cannot withdraw as highest paid Value!"
        );
         require(
            msg.sender != sellerAddress,
            "Seller cannot withdraw!"
        );


        uint valueToSendBackToBuyer = receivedValuesMap[msg.sender];
        if (valueToSendBackToBuyer > 0) {

            receivedValuesMap[msg.sender] = 0;
            if (!msg.sender.send(valueToSendBackToBuyer)) {
                receivedValuesMap[msg.sender] = valueToSendBackToBuyer;
                return false;
            }
        }
        return true;
    }

    function closeDeal() public {
        require(
            msg.sender == sellerAddress,
            "Sale can only be ended by Beneficiary"
            );
        require(
            isSaleActive == true,
            "Sale has ended"
            );
            
        isSaleActive = false;
        sellerAddress.transfer(highestProposedValue);
    }

    function setMinimumProposalAmount(uint minValue) public {
   
        require(
            msg.sender == sellerAddress,
            "Sale can only be started by Beneficiary"
            );
        require(
            minValue > 0,
            "Minimum proposed amount cannot be less than or equal to zero."
        );

        minimumProposalAmount = minValue;

    }
    function startSale(uint timeInMins) public {
         require(
            msg.sender == sellerAddress,
            "Sale can only be started by Beneficiary"
            );
        require(
            isSaleActive == false,
            "Sale has already started!"
            );
        isSaleActive = true;
        acquisitionEndDate = now + 60 * timeInMins;
    }


    function startNegotiation() public {
        require(
            msg.sender == sellerAddress,
            "Neogotiation Phase can only be started by Beneficiary"
            );
        require(
            isNegotiationActive == false,
            "Sale has already started!"
            );
        // setting the negotiation time (this can be modififed to any time range)    
        isNegotiationActive = true;
    }

    function negotiateDeal() public payable {
        require(now < acquisitionEndDate,"The negotiation time has expired");
        // require aunction end
        require(
            isSaleActive == true,
            "Sale is not active right now"
        );
        require(
            isNegotiationActive == true,
            "Negotation is not active right now"
        );
         require(
            msg.sender != sellerAddress,
            "Seller cannot place values!"
        );
        require(
            msg.value + receivedValuesMap[msg.sender] > highestProposedValue,
            "Amount should be greater than highes proposed value"
        );
        
        
        //Added Value to map
        receivedValuesMap[msg.sender] += msg.value;
         highestProposedValue = receivedValuesMap[msg.sender];
            highestReceivedProposalAddress = msg.sender;
    }  
}
