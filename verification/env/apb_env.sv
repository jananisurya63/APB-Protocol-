/*--------------------------------------------------------------------------------------------------

Author       : JANANI.S
E-mail ID    : jananisurya63@gmail.com
Project      : APB Protocol
Description  : APB environment is a verification component that connects and controls the generator
               and driver to run the APB verification process.
Date         : 09-03-2026.

---------------------------------------------------------------------------------------------------*/
`ifndef _APB_ENV
`define _APB_ENV



class apb_env;
// Mailbox for monitor-scoreboard   
   mailbox mon_sb;
// Handle for scoreboard and agent   
   apb_scoreboard sb;
   apb_agent agent_h;
// Virtual interface handle   
   virtual apb_interface vif;

// Constructor
   function new(virtual apb_interface vif);
// Assign interface handle     
      this.vif=vif;
// Creating memory for mailbox monitor-scoreboard        
      mon_sb=new();
// Creating memory for agent      
      agent_h=new(vif,mon_sb);
// Creating memory for scoreboard        
      sb=new(mon_sb);
   endfunction

   task run();
      fork
// Runs driver+monitor         
         agent_h.run();
// Checks expected vs actual data         
         sb.run();
      join
   endtask

endclass

`endif
