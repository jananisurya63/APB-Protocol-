/*
-----------------------------------------------------------------------------------------------------

Author       :  JANANI.S
E-mail ID    :  jananisurya63@gmail.com
Project      :  APB protocol
Description  :  This file implements the apb write test.
Date         :  10-03-2026.

-----------------------------------------------------------------------------------------------*/
`ifndef _APB_WRITE_TEST
`define _APB_WRITE_TEST

class apb_write_test;
// Handle for environment   
   apb_env env;
// Virtual interface to connect testbench with DUT
   virtual apb_interface vif;

// Constructor
   function new(virtual apb_interface vif);
      this.vif = vif;
   endfunction

   task run();
       env=new(vif);
// Number of transactions to generate
       env.agent_h.gen.count=10;
      env.agent_h.gen.error=0;
// Write transaction      
      env.agent_h.gen.write=1;
      env.run();
   endtask

endclass


`endif
