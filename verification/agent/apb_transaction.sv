
/*---------------------------------------------------------------------------------------------------
Author       :  JANANI.S
E-mail ID    :  jananisurya63@gmail.com
Project      :  APB protocol
Description  :  APB transaction is a class that defines the packet or data structure containing                      APB bus signals like address,data and write/read control used for communication                      between generator and driver in the verification environment.                    
Date         :  09-03-2026.

---------------------------------------------------------------------------------------------------*/`ifndef _APB_TRANSACTION
`define _APB_TRANSACTION
                                                                          
class apb_transaction;
   
    //Control Signal

   bit pready;
   bit penable;
   bit psel;

   // Sideband Signal

   rand bit[31:0]paddr;
   rand bit[31:0]pwdata;
   rand bit pwrite;
   bit[31:0]prdata;
   bit pslverr;


// Exclude addresses 0,4,8 and 12 from randomization
constraint c2{!(paddr inside {0,4,8,12});}
// Address Range from 0 to 100
   constraint c{paddr inside {[0:100]};}
  
   function void display(string name);

      $display($time,"[%0s] pready=%0d penable=%0d psel=%0d paddr=%0d pwdata=%0d pwrite=%0d prdata=%0d",name,pready,penable,psel,paddr,pwdata,pwrite,prdata);

   endfunction

endclass

`endif
