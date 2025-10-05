//SPDX-License-Identifier: MIT
pragma solidity 0.8.30;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";



/**
	*@title KipuBank
	*@notice TP2 ETH KIPU.
	
*/

contract KipuBank is ReentrancyGuard {
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
    error Desposit_amount_error(address user_found,uint256 user_amount);
    error WithdrawAmountError(address sender,uint256 user_amount);
    error withdraw_TrasactationFail(bytes erro);
    error Bank_Capacity_error(uint256 _amount,uint256 max_allowed);
    /// @notice Error triggered when withdrawal exceeds allowed maximum
    error WithdrawLimitError(uint256 amount,uint256 max_allowed_withdrawl);


    

    constructor(uint256 _Max_Withdraw,uint256 _bankCapGlobalAllowed){
        i_MaxWithdraw=_Max_Withdraw;
        i_bankCapGlobalAllowed=_bankCapGlobalAllowed; 
        
    }


    /*///////////////////////
					Functions
	///////////////////////*/
  
	

    /// @notice Prevents deposits of zero wei
    modifier ControlZeroAmout(){
         if (msg.value == 0) revert Desposit_amount_error(msg.sender,msg.value); 
         _;        
    }
    /// @notice Validates that withdrawal amount is greater than zero
    modifier validWithdrawAmount(uint256 _amount) {
    if (_amount == 0) revert WithdrawAmountError(msg.sender,_amount);
    _;
    }
    /// @notice Ensures that the total amount does not exceed the global bank cap
    modifier ControlGlobalBankLimit(){
        if (s_totalFounds+msg.value > i_bankCapGlobalAllowed) revert Bank_Capacity_error(msg.value,i_bankCapGlobalAllowed);      
         _;        
    }
    /// @notice Validates that withdrawal does not exceed the allowed maximum
    modifier withinWithdrawLimit(uint256 _amount) {
    if (_amount > i_MaxWithdraw) 
        revert WithdrawLimitError(_amount,i_MaxWithdraw);
    if (s_deposits[msg.sender] < _amount) {
        revert WithdrawLimitError(_amount,i_MaxWithdraw);
    }
    
    _;
}

    /*@notice deposit function
    @param  amount to be saved by the user*/
   
    function depositAmount() external payable nonReentrant  ControlZeroAmout ControlGlobalBankLimit{      
        
        
       _processDeposit(msg.sender, msg.value);
       
    }
    
     receive() external payable nonReentrant {
        _processDeposit(msg.sender, msg.value);
    }
    fallback() external payable nonReentrant {
        _processDeposit(msg.sender, msg.value);
    }

    function _processDeposit(address _user, uint256 _amount) private   ControlZeroAmout() ControlGlobalBankLimit() {
     
      emit  Deposit_amountSaved(_user,_amount);
      s_deposits[_user] += _amount;
      s_totalFounds+=_amount;
      s_numDeposit++;
    }

  
    /*
      * @notice Function that allows a user to withdraw funds.
      * @notice The withdrawal amount must be greater than zero and less than the global limit allowed by the bank.
      * @param _amount The amount requested by the user.
      * @dev Only the user's own address can withdraw their funds.

    
    */

    function withdrawAmount(uint256 _amount) external validWithdrawAmount(_amount) withinWithdrawLimit(_amount){     
               

        
        _transferEth(_amount); 
        emit Retire_InProcess(msg.sender, _amount);      

    }

     /*
      * @notice Proivate Function that allows to transfer ETH to the user 
      * @notice The withdrawal amount must be greater than zero and less than the global limit allowed by the bank.
      * @param _amount The amount requested by the user.
      

    
    */



    function _transferEth(uint256 _amount) private{
        


		(bool sucesso, bytes memory erro) = msg.sender.call{value: _amount}("");
		if(!sucesso) revert withdraw_TrasactationFail(erro);
         s_deposits[msg.sender] -= _amount;
         s_numRetire++;
         s_totalFounds=s_totalFounds - _amount;
         
        
       

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



