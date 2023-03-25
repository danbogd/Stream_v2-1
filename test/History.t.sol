// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {History} from "../src/History.sol";
import {MyStream} from "../src/Stream.sol";
import {Exploit} from "../src/Hacker.sol";
//import {ERC20Mock} from "../src/ERC20Mock.sol";

contract HistoryTest is Test {
    History public contract_history;
    MyStream public contract_stream;
    Exploit public exploit;
    //ERC20Mock public USDT;


    address payable public sender = payable(vm.addr(1));
    address payable public bob = payable(vm.addr(4));
    address payable public recipient = payable(vm.addr(2));
    address payable public hacker = payable(vm.addr(3));
    address payable public shareHolder = payable(vm.addr(5));
     
        

    function setUp() public {
        contract_history = new History();
        contract_stream = new MyStream(address(contract_history), 1);
        exploit = new Exploit();
        
        contract_history.changeStreamContract(address(contract_stream));
        
      
    }
 // Test create stream, storage stream data to the history
    function testcreateStream() public{
        
        vm.warp(10);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         vm.deal(sender, 5.35 ether);

         vm.prank(sender);
         
        
        //console.log(address(sender).balance);
        uint id = contract_stream.createStream{value: 5.35 ether}(5e18, recipient, start, stop, 0, 3, "Hi!" );
        
                
         uint deposit = contract_history.getHistoryStream(id).deposit;
         assertEq(deposit, 5e18);
         //console.log("Deposit",deposit);

         assertEq(address(sender).balance, 15e16);
         assertEq(address(sender).balance, 15e16);

        // Check -wrire to history contract

        // Time check

         uint64 startTime = contract_history.getHistoryStream(id).startTime;
         uint64 stopTime = contract_history.getHistoryStream(id).stopTime;
         uint64 blockTime = contract_history.getHistoryStream(id).blockTime;
         uint64 cancelTime = contract_history.getHistoryStream(id).cancelTime;
         console.log(startTime,  stopTime );
         console.log("blockTime", blockTime, "cancelTime", cancelTime);

        // Check other sream parameters

        //  uint recipientAmountOnCancel  = contract_history.getHistoryStream(id).recipientAmountOnCancel;
        //  uint8 whoCancel = contract_history.getHistoryStream(id).whoCancel;
        //  address sender2 = contract_history.getHistoryStream(id).sender;
        //  uint32 numberOfWithdraws = contract_history.getHistoryStream(id).numberOfWithdraws;
        //  address recipient2 = contract_history.getHistoryStream(id).recipient;
        //  uint8 status = contract_history.getHistoryStream(id).status;
        //  string memory purpose = contract_history.getHistoryStream(id).purpose;

        
         
        //  console.log("Amount after Cancel", recipientAmountOnCancel);
        //  console.log("whoCancel", whoCancel);
        //  console.log( sender2, recipient2);
        //  console.log ("Number of Withdraws", numberOfWithdraws);
        //  console.log ("status", status);
        //  console.log ("text", purpose );
   
        
        //Check charge fee

        
        //if (5 ether <= deposit <= 20 ether) -> fee 700

        uint256 feeAmount = contract_stream.feeCharge(deposit);// 35e16 (350000000000000000)
        //console.log("Fee amount", contract_stream.feeCharge(deposit));
        uint256 getFeeRate = contract_stream.calculateFee(deposit);
        uint256 calculateFeeAmount = deposit * getFeeRate / 10000;
        assertEq(feeAmount, calculateFeeAmount); 

        //console.log("Our rewards",contract_stream.contractFeeBalance());
        assertEq(contract_stream.contractFeeBalance(), 5e16); 

    }

    

    // Test for add fees after several stream

   function testSeveralCreateStreambyOneUser() public{
        
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         vm.deal(sender, 10.7 ether);
         

        vm.prank(sender);
        
        
        //console.log(address(sender).balance);
        uint id = contract_stream.createStream{value: 5.35 ether}(5e18, recipient, start, stop, 0, 3, "Hi 1!" );
        assertEq(id, 1);

        vm.prank(sender);

        vm.warp(2);
        
        uint id2 = contract_stream.createStream{value: 5.35 ether}(5e18, recipient, 3, 100, 0, 3, "Hi 1!" );
        assertEq(id2, 2);
        
        //console.log("Our rewards",contract_stream.contractFeeBalance());
        assertEq(contract_stream.contractFeeBalance(), 100000000000000000); // 1e17
        
   }

   function testSeveralCreateStreambySeveralUsersWithDiffAmount() public{
        
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         vm.deal(sender, 5.35 ether);
         vm.deal(bob, 5.35 ether);

         vm.prank(sender);
        
        
        
        contract_stream.createStream{value: 5.35 ether}(5e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
       vm.prank(bob);
         contract_stream.createStream{value: 5.35 ether}(5e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        
        //console.log("Our rewards",contract_stream.contractFeeBalance());
        assertEq(contract_stream.contractFeeBalance(), 100000000000000000); // 1e17
        
  }

  function testSeveralCreateStreambySeveralUsersWithAmount50() public{
        
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         vm.deal(sender, 50.5 ether);
         vm.deal(bob, 50.5 ether);

         vm.prank(sender);
        
        
        
        contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
       vm.prank(bob);
         contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        
        //console.log("Our rewards",contract_stream.contractFeeBalance());
        assertEq(contract_stream.contractFeeBalance(), 400000000000000000); //4e17 - 0.4 ether
        
  }

  function testSeveralCreateStreambySeveralUsersWithAmount30() public{
        
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         vm.deal(sender, 30.6 ether);
         vm.deal(bob, 30.6 ether);

         vm.prank(sender);
        
        
        
        contract_stream.createStream{value: 30.6 ether}(30e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
       vm.prank(bob);
         contract_stream.createStream{value: 30.6 ether}(30e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        
        //console.log("Our rewards",contract_stream.contractFeeBalance());
        assertEq(contract_stream.contractFeeBalance(), 600000000000000000); //6e17 - 0.6 ether
        
  }

  function testSeveralCreateStreambySeveralUsersWithAmount5and50() public{
        
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         vm.deal(sender, 5.35 ether);
         vm.deal(bob, 50.5 ether);

         vm.prank(sender);
        
        
        
        contract_stream.createStream{value: 5.35 ether}(5e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
       vm.prank(bob);
         contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        
        //console.log("Our rewards",contract_stream.contractFeeBalance());
        assertEq(contract_stream.contractFeeBalance(), 250000000000000000); //25e16 - 0.6 ether //0.05 + (0.5 - 0,3)


            
    }

    function testWithDrawFee() public{
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         
        vm.deal(bob, 50.5 ether);

               
        vm.prank(bob);
         contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
    
         //console.log("Our rewards",contract_stream.contractFeeBalance());
        uint256 BalanceBefore = address(shareHolder).balance;
        assertEq(BalanceBefore, 0);

        vm.stopPrank();

        uint256 feeAm = contract_stream.contractFeeBalance();
         
        contract_stream.withdrawFeeForHolders( feeAm, address(shareHolder));
         uint256 BalanceAfter = address(shareHolder).balance;
         //console.log(BalanceAfter);
        assertEq(feeAm, BalanceAfter);

    }

    function testFailWithDrawFee() public{
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         
        vm.deal(bob, 50.5 ether);

               
        vm.prank(bob);
         contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
    
             

        uint256 feeAm = contract_stream.contractFeeBalance();

        vm.prank(bob);
        contract_stream.withdrawFeeForHolders( feeAm, address(shareHolder));
        

    }

     function testFailCreateSreamWrongDeposit() public{
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         
        vm.deal(bob, 50.5 ether);

               
        vm.prank(bob);
        contract_stream.createStream{value: 50 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
    
             
    }

    function testFailCreateSreamZeroDeposit() public{
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         
        vm.deal(bob, 50.5 ether);

               
        vm.prank(bob);
         contract_stream.createStream{value: 50.5 ether}(0, recipient, start, stop, 0, 3, "Hi 1!" );
    
             
    }

    function testFailCreateSreamWihOutFee() public{
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         
        vm.deal(bob, 50.5 ether);

               
        vm.prank(bob);
         contract_stream.createStream{value: 50.0 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
    
             
    }

    function testFailCreateSreamWithLittleFee() public{
        vm.warp(1);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         
        vm.deal(bob, 50.5 ether);

               
        vm.prank(bob);
         contract_stream.createStream{value: 50.3 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
    
             
    }

    function testCreateSreamWrongStartTime() public{// before timestamp
        vm.warp(5);
        
        uint64 start = 3;
        uint64 stop = uint64(block.timestamp) + 100;
         
        vm.deal(bob, 50.5 ether);

               
        vm.prank(bob);
        vm.expectRevert(bytes("startTime before block.timestamp"));
        contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
             
    }

       //////////////////////////// CANCEL TESTS ///////////////////////////////////////

    function testCancelSream() public{// before timestamp
        vm.warp(2);
        
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
         
        vm.deal(sender, 50.5 ether);

               
        vm.prank(sender);
        
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(sender);
        contract_stream.cancelStream(id);
        uint8 status2 = contract_history.getHistoryStream(id).status;
        
        assertEq(status2, 1);
        uint256 status3 = contract_history.getHistoryStream(id).recipientAmountOnCancel;
        console.log("Amount after Cancel", status3 );// 26 960784313725490197
    }

    function testFailCancelStreamByHaker() public{// before timestamp
        vm.warp(2);
        
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;

         
        vm.deal(sender, 50.5 ether);

               
        vm.prank(sender);
        
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(hacker);
        contract_stream.cancelStream(id);
        uint8 status2 = contract_history.getHistoryStream(id).status;
        
        assertEq(status2, 0);
        
    }

   // Test cancel stream by sender, who Cancel = 3
        function testCancelStreamByRecipient() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(recipient);    
            
        bool success = contract_stream.cancelStream(id);
        assertEq(success, true);
            
        }


        
        /*
        sender при 2 не может
        recipient при 1 не может
        при 3 могут все
        при нуле никто не может
        */

    function testFailCancelStreamByRecipientOnWhoCancel1() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 1, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(recipient);    
            
        contract_stream.cancelStream(id);
       
            
    }

    function testCancelStreamBySenderOnWhoCancel1() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 1, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(sender);    
            
        bool success = contract_stream.cancelStream(id);
        assertEq(success, true);
       
            
    }

    function testFailCancelStreamBySenderOnWhoCancel2() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 2, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(sender);    
            
        contract_stream.cancelStream(id);
       
            
    }

    function testCancelStreamByRecipientOnWhoCancel2() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 2, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(recipient);    
            
        bool success = contract_stream.cancelStream(id);
        assertEq(success, true);
       
            
    }

     function testFailCancelStreamByRecipientOnWhoCancel2() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 2, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(sender);    
            
        contract_stream.cancelStream(id);
       
            
    }

    function testFailCancelStreamByRecipientOnWhoCancel0() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 0, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(recipient);    
            
        contract_stream.cancelStream(id);
       
            
    }

    function testFailCancelStreamBySenderOnWhoCancel0() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 0, "Hi 1!" );
        
        vm.warp(50);
        vm.prank(sender);    
            
        contract_stream.cancelStream(id);
       
            
    }

    function testFailCancelStreamBySenderAfterStream() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        vm.warp(106);
        vm.prank(sender);    
            
        contract_stream.cancelStream(id);
       
            
    }

    function testFailCancelStreamByRecipientAfterStream() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        vm.warp(106);
        vm.prank(recipient);    
            
        contract_stream.cancelStream(id);
       
            
    }

    function testCancelStreamByRecipientBeforeStream() public{

        vm.warp(2);
        uint64 start = uint64(block.timestamp) + 1;
        uint64 stop = uint64(block.timestamp) + 103;
        vm.deal(sender, 50.5 ether);
        vm.prank(sender);
        uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
        
        vm.warp(1);
        vm.prank(recipient); 
        vm.expectRevert(bytes("stream not started"));   
           
        contract_stream.cancelStream(id);
       
            
    }

    



    // //////////////////////////// WITHDRAW TESTS ///////////////////////////////////////



         // Test withdraw after the stream by recipient
        function testWithdrawAfterStream() public {
            vm.warp(2);
            uint64 start = uint64(block.timestamp) + 1;
            uint64 stop = uint64(block.timestamp) + 103;
            vm.deal(sender, 50.5 ether);
            vm.deal(address(this), 10 ether);
            vm.prank(sender);
            uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );

            vm.warp(109);
            uint balanceBefore = address(recipient).balance;
            console.log("Bef", balanceBefore / 1 gwei);
            console.log("Sender", address(sender).balance / 1 gwei);
            
            vm.prank(recipient);

             vm.warp(112);

            bool success = contract_stream.withdrawFromStream(id, 50e18);
            assertEq(success, true);
            uint balanceAfter = address(recipient).balance;
            console.log("Aft",balanceAfter / 1 gwei);
            
            
            uint32 numberOfWithdraws = contract_history.getHistoryStream(id).numberOfWithdraws;
            //console.log(numberOfWithdraws);
            assertEq(numberOfWithdraws, 1);
            uint256 feeAm = contract_stream.contractFeeBalance();
            console.log("Fee", feeAm / 1 gwei);
            assertEq(balanceAfter, 50e18 + balanceBefore);
            // 1 gwei == 1e9
     
         }

          // Test several withdraws after the stream by recipient
        function testWithdrawAfterStream2Time() public {
                                     
            
            vm.warp(2);
            uint64 start = uint64(block.timestamp) + 1;
            uint64 stop = uint64(block.timestamp) + 103;
            vm.deal(sender, 50.5 ether);
            //vm.deal(address(this), 10 ether);
            vm.prank(sender);
            uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
             vm.warp(112);
            uint balanceBefore = address(recipient).balance;
            vm.prank(recipient);
            bool success = contract_stream.withdrawFromStream(id, 25e18);
            assertEq(success, true);
            
            vm.warp(113);

            vm.prank(recipient);

            bool success2 = contract_stream.withdrawFromStream(id, 25e18);
            assertEq(success2, true);

            uint balanceAfter = address(recipient).balance;
               
            uint32 numberOfWithdraws = contract_history.getHistoryStream(id).numberOfWithdraws;
            
            assertEq(numberOfWithdraws, 2);
            
            assertEq(balanceAfter, 50e18 + balanceBefore);
            // 1 gwei == 1e9
     
         }

           
        // Test withdraw duaring the stream by haker
        function testwithdrawStreamByHakerDuaringStream() public {
                                            
            vm.warp(2);
            uint64 start = uint64(block.timestamp) + 1;
            uint64 stop = uint64(block.timestamp) + 103;
            vm.deal(sender, 50.5 ether);
            //vm.deal(address(this), 10 ether);
            vm.prank(sender);
            uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
            vm.warp(100);

            vm.prank(hacker);
            vm.expectRevert(bytes("caller is not the recipient"));
            contract_stream.withdrawFromStream(id, 25e18);
            
            
        } 
        
        // Test withdraw before the stream by haker
        function testwithdrawStreamByHakerBeforeStream() public {
                                            
            vm.warp(2);
            uint64 start = uint64(block.timestamp) + 1;
            uint64 stop = uint64(block.timestamp) + 103;
            vm.deal(sender, 50.5 ether);
            //vm.deal(address(this), 10 ether);
            vm.prank(sender);
            uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
            vm.warp(2);

            vm.prank(hacker);
            vm.expectRevert(bytes("caller is not the recipient"));
            contract_stream.withdrawFromStream(id, 25e18);
            
            
        } 

      
      // Test withdraw duaring the stream by haker
        function testwithdrawStreamBySenderAfterStream() public {
                                            
            vm.warp(2);
            uint64 start = uint64(block.timestamp) + 1;
            uint64 stop = uint64(block.timestamp) + 103;
            vm.deal(sender, 50.5 ether);
            
            vm.prank(sender);
            uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
            
            vm.warp(110);
            vm.prank(sender);
            vm.expectRevert(bytes("caller is not the recipient"));
            contract_stream.withdrawFromStream(id, 25e18);
                    
        } 

    

        function testWithdrawWrongInputId() public {
            vm.warp(2);
            uint64 start = uint64(block.timestamp) + 1;
            uint64 stop = uint64(block.timestamp) + 103;
            vm.deal(sender, 50.5 ether);
            
            vm.prank(sender);
            uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );
            console.log(id);
            vm.warp(110);
                        
            vm.startPrank(recipient);
            vm.expectRevert(bytes("stream does not exist"));
            contract_stream.withdrawFromStream(5, 25e18);//input wrong id = 5 
            
       }

           
        function testWithdrawWrongInputZeroAmount() public {
            vm.warp(2);
            uint64 start = uint64(block.timestamp) + 1;
            uint64 stop = uint64(block.timestamp) + 103;
            vm.deal(sender, 50.5 ether);
            
            vm.prank(sender);
            uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" ); 

            vm.warp(120);
                            
            vm.startPrank(recipient);
            vm.expectRevert(bytes("amount is zero"));
            contract_stream.withdrawFromStream(id, 0);//input 0 amount 
                
        }
        // wrong amount (input amount > stream deposit)
        function testWithdrawWrongInputLargeAmount() public {
                vm.warp(2);
                uint64 start = uint64(block.timestamp) + 1;
                uint64 stop = uint64(block.timestamp) + 103;
                vm.deal(sender, 50.5 ether);
                
                vm.prank(sender);
                uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );  

                vm.warp(120);
                            
                vm.startPrank(recipient);
                vm.expectRevert(bytes("amount exceeds the available balance"));
                contract_stream.withdrawFromStream(id, 51e18);//input amount > stream deposit
                
        }

        // can not withdraw 0 amount before start date of the stream which created

        function testWithdrawBeforeStreamStart() public {
                vm.warp(2);
                uint64 start = uint64(block.timestamp) + 1;
                uint64 stop = uint64(block.timestamp) + 103;
                vm.deal(sender, 50.5 ether);
                
                vm.prank(sender);
                uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" );

                vm.warp(1);
                            
                vm.startPrank(recipient);
                vm.expectRevert(bytes("amount is zero"));
                contract_stream.withdrawFromStream(id, 0);
                
        }

        // can not withdraw before start date of the stream which created

        function testWithdrawBeforeStreamStartWithAmount() public {
                vm.warp(5);
                uint64 start = uint64(block.timestamp) + 2;
                uint64 stop = uint64(block.timestamp) + 100;
                
                vm.deal(sender, 50.5 ether);

                vm.prank(sender);
                
                uint256 id = contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" ); 

                vm.warp(2);
                            
                vm.startPrank(recipient);
                vm.expectRevert(bytes("stream not started"));
                contract_stream.withdrawFromStream(id, 1);
                console.log("GAS", tx.gasprice);
        }

    
    // Fuzz testing
    function testFuzz_StreamStartWithAmount(uint256 deposit) public {

                vm.assume(deposit >= 5e18);
                vm.assume(deposit <= 100000000e18);
                vm.warp(5);
                
                uint64 start = uint64(block.timestamp) + 2;
                uint64 stop = uint64(block.timestamp) + 100;

                vm.startPrank(sender);
                uint256 fee = contract_stream.feeCharge(deposit);
                uint256 amount = deposit + fee;
                vm.deal(sender, amount);          
                
                contract_stream.createStream{value: amount}(deposit, recipient, start, stop, 0, 3, "Hi 1!" ); 

                
        }

        function testFuzz_StreamStartWithAmountAndTime(uint256 startBlock) public {

                
                vm.assume(startBlock >= block.timestamp);
                vm.assume(startBlock <= block.timestamp + 10000000);

                vm.warp(startBlock);
                
                uint64 start = uint64(block.timestamp) + 2;
                uint64 stop = uint64(block.timestamp) + 100;
                

                vm.startPrank(sender);
                
                vm.deal(sender, 5.35 ether);          
                
                contract_stream.createStream{value: 5.35 ether}(5 ether, recipient, start, stop, 0, 3, "Hi 1!" ); 

                
        }
    
     function testStreamOnAdminPause() public {
                vm.warp(5);
                contract_stream.pause();
                
                uint64 start = uint64(block.timestamp) + 2;
                uint64 stop = uint64(block.timestamp) + 100;
                vm.deal(sender, 50.5 ether);

                vm.prank(sender);
                vm.expectRevert(bytes("Pausable: paused"));
          
                contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" ); 
              
    }

    function testStreamOnAdminUnPause() public {
                vm.warp(5);
                contract_stream.pause();
                vm.warp(7);
                contract_stream.unpause();
                
                uint64 start = uint64(block.timestamp) + 2;
                uint64 stop = uint64(block.timestamp) + 100;
                vm.deal(sender, 50.5 ether);
                vm.prank(sender);
                          
                contract_stream.createStream{value: 50.5 ether}(50e18, recipient, start, stop, 0, 3, "Hi 1!" ); 
              
    }

    function testStreamOnPauseByHacker() public {
                vm.warp(5);
                vm.prank(hacker);
                vm.expectRevert(bytes("Ownable: caller is not the owner"));
                contract_stream.pause();
           
    }

    function testStreamOnUnPauseByHacker() public {
                vm.warp(5);
                contract_stream.pause();
                vm.warp(7);
                vm.prank(hacker);
                vm.expectRevert(bytes("Ownable: caller is not the owner"));
                contract_stream.unpause();
    }

    function testcreateStreamWhereStartTimeIsZero() public{
        vm.warp(22);
        
        uint64 start = 0;
        uint64 stop = uint64(block.timestamp) + 10;

         vm.deal(sender, 5.35 ether);

         vm.prank(sender);
             
        uint256 id = contract_stream.createStream{value: 5.35 ether}(5e18, recipient, start, stop, 0, 3, "Hi!" );
        uint sTime = contract_history.getHistoryStream(id).startTime;
        assertEq(sTime, 22);

    }

    function testCreateStreamByExploit() public{
        vm.warp(22);
        
        uint64 start = 0;
        uint64 stop = uint64(block.timestamp) + 10;

         vm.deal(address(exploit), 5.35 ether);

        vm.prank(address(exploit));
        vm.expectRevert(bytes("No contracts"));
        contract_stream.createStream{value: 5.35 ether}(5e18, recipient, start, stop, 0, 3, "Hi!" );

    }

    function testCreateStreamUnder5Matic() public{
        
        vm.warp(10);
        
        uint64 start = uint64(block.timestamp) + 2;
        uint64 stop = uint64(block.timestamp) + 10;

         vm.deal(sender, 2.14 ether);

         vm.prank(sender);
        vm.expectRevert(bytes(""));
        contract_stream.createStream{value: 2.14 ether}(2e18, recipient, start, stop, 0, 3, "Hi!" );
    }      

   // Test admin functions

   function testSetNewFee() public{
        vm.warp(10);
        uint256 x = 1000;
        uint256 y = 500;
        uint256 z = 100;
        contract_stream.changeFeeParameters(x,y,z);
        uint256 fee1 = contract_stream.calculateFee(5e18);
        assertEq(fee1, x);
        uint256 fee2 = contract_stream.calculateFee(21e18);
        assertEq(fee2, y);
        uint256 fee3 = contract_stream.calculateFee(50e18);
        assertEq(fee3, z);

   }

   function testSetNewFeeByHacker() public{
        vm.warp(10);
        vm.prank(hacker);
        uint256 x = 1000;
        uint256 y = 500;
        uint256 z = 100;
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        contract_stream.changeFeeParameters(x,y,z);
        

   }

   function testSetNewLargeFeeX() public{
        vm.warp(10);
        uint256 x = 3000;
        uint256 y = 500;
        uint256 z = 100;
        vm.expectRevert(bytes("x very large"));
        contract_stream.changeFeeParameters(x,y,z);
        uint256 fee1 = contract_stream.calculateFee(5e18);
        assertEq(fee1, 700);
   } 

   function testSetNewLargeFeeY() public{
        vm.warp(10);
        uint256 x = 1000;
        uint256 y = 15000;
        uint256 z = 100;
        vm.expectRevert(bytes("y very large"));
        contract_stream.changeFeeParameters(x,y,z);
        uint256 fee2 = contract_stream.calculateFee(21e18);
        assertEq(fee2, 200);
   }     

   function testSetNewLargeFeeZ() public{
        vm.warp(10);
        uint256 x = 1000;
        uint256 y = 500;
        uint256 z = 10000;
        vm.expectRevert(bytes("z very large"));
        contract_stream.changeFeeParameters(x,y,z);
        uint256 fee3 = contract_stream.calculateFee(50e18);
        assertEq(fee3, 100);
   }                      

/*
    function testSetNewZeroFeeX() public{
        vm.warp(10);
        uint256 x = 0;
        uint256 y = 0;
        uint256 z = 0;
        vm.expectRevert(bytes("Zero parameter"));
        contract_stream.changeFeeParameters(x,y,z);
        uint256 fee1 = contract_stream.calculateFee(5e18);
        assertEq(fee1, 700);
   }     

    function testTransferOwnership() public{
            vm.warp(10);
        contract_stream.transferOwnership(address(bob));
        address newOwner = contract_stream.owner();
        assertEq(address(bob), newOwner);

    }   
*/    
}
