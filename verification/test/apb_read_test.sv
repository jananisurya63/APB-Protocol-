
/*---------------------------------------------------------------------------------------------------

Author       :  JANANI.S
E-mail ID    :  jananisurya63@gmail.com
Project      :  APB protocol
Description  :  This file implements the APB read test.
Date         :  10-03-2026.

--------------------------------------------------------------------------------------------------*/
`ifndef _APB_READ_TEST
`define _APB_READ_TEST


class apb_read_test;
// Handle for environment   
   apb_env env;
// Virtual interface to connect testbench with dut   
   virtual apb_interface vif;

 // Constructor  
   function new(virtual apb_interface vif);
      this.vif = vif;
   endfunction

   task run();
// Creating memory for environment      
      env=new(vif);
// Number of transactions too generate      
      env.agent_h.gen.count=10;
      env.agent_h.gen.error=0;
// Write disabled,only read transaction      
      env.agent_h.gen.write=0;
      env.run();
   endtask
endclass

`endif
