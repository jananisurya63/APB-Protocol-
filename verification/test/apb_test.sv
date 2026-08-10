/*-----------------------------------------------------------------------------------------------------
 Author       :  JANANI.S
 E-mail ID    :  jananisurya63@gmail.com
 Project      :  APB protocol
Description   :  APB test is a class that creates the APB environment and starts the verification 
                process by calling the run method of the environment.
Date          :  10-03-2026.

---------------------------------------------------------------------------------------------------*/ 
`ifndef _APB_TEST
`define _APB_TEST

class apb_test;
// Handle for environment   
   apb_env env;
// Virtual interface to connect testbench with DUT
   virtual apb_interface vif;

// Constructor   
   function new(virtual apb_interface vif);
      this.vif=vif;
   endfunction


  task run();
      env=new(vif);
// Number of transactions to generate      
      env.agent_h.gen.count=10;
      env.agent_h.gen.error=0;
      env.run();
   endtask

endclass

`endif
