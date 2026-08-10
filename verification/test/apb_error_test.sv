
/*--------------------------------------------------------------------------------------------------

       Author       :  JANANI.S
       E-mail ID    :  jananisurya63@gmail.com
       Description  :  APB test is a class that creates the APB environment
                       and starts the verification process by calling the
                       run method of the environment.
       Date         :  10-03-2026.

---------------------------------------------------------------------------------------------------*/
`ifndef _APB_ERROR_TEST
`define _APB_ERROR_TEST

class apb_error_test;
   apb_env env;

   virtual apb_interface vif;

   function new(virtual apb_interface vif);
      this.vif = vif;
   endfunction

   task run();
      env=new(vif);
      env.agent_h.gen.error=1;
      env.run();
   endtask
endclass


`endif
