/*---------------------------------------------------------------------------------------------------

Author       : JANANI.S
E-mail ID    : jananisurya63@gmail.com
Project      : APB protocol
Description  : APB agent is a container component that encapsulates the APB driver,sequencer
               and monitor and manages all APB protocol activities.
Date         : 09-03-2026.

---------------------------------------------------------------------------------------------------*/ 

 
`ifndef _APB_AGENT
`define _APB_AGENT


class apb_agent;
// Handle for generator,driver and monitor
   apb_generator gen;
   apb_driver drv;
   apb_monitor mon;
// Mailbox for generator to driver   
   mailbox gen_drv;
// Mailbox for monitor to scoreboard   
   mailbox mon_sb;
// Virtual interface handle   
   virtual apb_interface vif;
// Constructor   
   function new(virtual apb_interface vif,mailbox mon_sb);
// Assign interface handle      
      this.vif=vif;
// Assign monitor-scoreboard mailbox      
      this.mon_sb=mon_sb;
// Create generator-driver mailbox     
      gen_drv=new();
// Create monitor-scoreboard mailbox     
      mon_sb=new();
// Create generator component
      gen=new(gen_drv);
// Create driver component      
      drv=new(gen_drv,vif);
// Create monitor component      
      mon=new(vif,mon_sb);
   endfunction
// Run generator and driver
   task run();
      fork
         gen.run();
         drv.run();
         mon.run();
      join
   endtask

endclass


`endif
