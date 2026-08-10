/*
-----------------------------------------------------------------------------------------------------

Author       :  JANANI.S
E-mail ID    :  jananisurya63@gmail.com
Project      :  APB protocol
Description  :  This file implements the APB read-write test.
Date         :  10-03-2026.

--------------------------------------------------------------------------------------------------*/
`ifndef _APB_RW_TEST
`define _APB_RW_TEST

class apb_rw_test;
// Handle for environment   
   apb_env env;
// Virtual interace to connect testbench with DUR
   virtual apb_interface vif;

// Constructor   
   function new(virtual apb_interface vif);
      this.vif = vif;
   endfunction

   task run();
      env=new(vif);
// Number of transactions to generate      
      env.agent_h.gen.count=10;
      env.run();
   endtask

endclass

`endif
