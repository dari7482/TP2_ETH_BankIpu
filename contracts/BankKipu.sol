//SPDX-License-Identifier: MIT
pragma solidity 0.8.30;



/**
	*@title KipuBank
	*@notice TP2 ETH KIPU.
	
*/
import "@openzeppelin/contracts/utils/Strings.sol";

contract KipuBank{
    /*///////////////////////
					Variables
	///////////////////////*/
    ///@notice Immutable address where the funds will be withdrawn
    uint256 public immutable i_MaxWithdraw; 
    uint256 public immutable i_bankCapGlobalAllowed;
    uint256 public s_totalFounds;
    uint256 public s_numDeposit;
    uint256 public s_numRetire;
    ///@notice mapping to storage the user's desposit 
    mapping(address user => uint256) public s_deposits;
    /*///////////////////////
						Events
	////////////////////////*/
	///@notice event alert new user's deposit
    event Deposit_amountSaved(address user_found, uint256 _amount);
    ///@notice event alert new user's retire in process
    event Retire_InProcess(address user_found, uint256 _amount);
    /*///////////////////////
						Errors
	///////////////////////*/
    error Desposit_amount_error(address user_found,string message);
    error WithdrawAmountError(address sender, string message);
    error withdraw_TrasactationFail(bytes erro);
    error Bank_Capacity_error(uint256 _amount,string unit);
    /// @notice Error triggered when withdrawal exceeds allowed maximum
    error WithdrawLimitError(uint256 amount, string message);


    

    constructor(uint256 _Max_Withdraw,uint256 _bankCapGlobalAllowed){
        i_MaxWithdraw=_Max_Withdraw;
        i_bankCapGlobalAllowed=_bankCapGlobalAllowed; 
        
    }


    /*///////////////////////
					Functions
	///////////////////////*/
    receive() external payable{}
	fallback() external{}

    /// @notice Prevents deposits of zero wei
    modifier ControlZeroAmout(){
         if (msg.value == 0) revert Desposit_amount_error(msg.sender,"Deposit amount must be greater than zero."); 
         _;        
    }
    /// @notice Validates that withdrawal amount is greater than zero
    modifier validWithdrawAmount(uint256 _amount) {
    if (_amount == 0) revert WithdrawAmountError(msg.sender, "Withdrawal amount must be greater than zero.");
    _;
    }
    /// @notice Ensures that the total amount does not exceed the global bank cap
    modifier ControlGlobalBankLimit(){
        if (s_totalFounds+msg.value > i_bankCapGlobalAllowed) revert Bank_Capacity_error(msg.value,"Global deposit limit exceeded!!");      
         _;        
    }
    /// @notice Validates that withdrawal does not exceed the allowed maximum
    modifier withinWithdrawLimit(uint256 _amount) {
    if (_amount > i_MaxWithdraw) 
        revert WithdrawLimitError(_amount, "Withdrawal amount exceeds the allowed maximum limit.");
    if (s_deposits[msg.sender] < _amount) {
        revert WithdrawLimitError(_amount, "Insufficient balance to complete the withdrawal.");
    }
    
    _;
}

    /*@notice deposit function
    @param  amount to be saved by the user*/
   
    function depositAmount() external payable ControlZeroAmout ControlGlobalBankLimit{      
        
        
        s_deposits[msg.sender] += msg.value;
        s_totalFounds+=msg.value;
        s_numDeposit++;
        emit  Deposit_amountSaved(msg.sender,msg.value);
    }

  
    /*
      * @notice Function that allows a user to withdraw funds.
      * @notice The withdrawal amount must be greater than zero and less than the global limit allowed by the bank.
      * @param _amount The amount requested by the user.
      * @dev Only the user's own address can withdraw their funds.

    
    */

    function withdrawAmount(uint256 _amount) external validWithdrawAmount(_amount) withinWithdrawLimit(_amount){       
               

        emit Retire_InProcess(msg.sender, _amount);      
        _transferEth(_amount); 

    }

     /*
      * @notice Proivate Function that allows to transfer ETH to the user 
      * @notice The withdrawal amount must be greater than zero and less than the global limit allowed by the bank.
      * @param _amount The amount requested by the user.
      

    
    */



    function _transferEth(uint256 _amount) private{
         s_deposits[msg.sender] -= _amount;
         s_numRetire++;


		(bool sucesso, bytes memory erro) = msg.sender.call{value: _amount}("");
		if(!sucesso) revert withdraw_TrasactationFail(erro);
       

    } 

     /*
      * @notice external view Function returns user's balance   
          
    */

    function _userBalance() external view returns(uint256 balance){        
        
        balance=s_deposits[msg.sender];         
        

    }

     /*
      * @notice external view Function returns total deposit number and retire
          
    */
    
    function recordMovementTolta() external view returns(uint256 _deposit ,uint256  _extraction){
        _deposit=s_numDeposit;
        _extraction=s_numRetire;



    }






}



