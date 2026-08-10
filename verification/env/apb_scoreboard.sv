/*---------------------------------------------------------------------------------------------------

Author       : JANANI.S
E-mail ID    : jananisurya63@gmail.com
Project      : APB protocol
Description  : APB agent is a container component that encapsulates the APB driver,sequencer and 
               monitor and manages all APB protocol activities.
Date         : 09-03-2026.

---------------------------------------------------------------------------------------------------*/
`ifndef _APB_SCOREBOARD
`define _APB_SCOREBOARD

class apb_scoreboard;
// Handle for transaction
   apb_transaction packet;
// Mailbox for monitor-scoreboard   
   mailbox mon_sb;
// Stores expected data based on address
  bit[31:0]mem[bit[255:0]];
    
// Constructor
   function new(mailbox mon_sb);
      this.mon_sb=mon_sb;
   endfunction

   task run();
      forever begin
// Creating memory for transaction object         
         packet=new();
// Get transaction from monitor through mailbox         
         mon_sb.get(packet);
         $display("transaction received");
// If slave is detected it shows error
         if(packet.pslverr)begin
            $fatal("slave error -> error%0d",packet.paddr);
            continue;
         end
// Write operation         
         if(packet.pwrite)begin
// Store write data into reference memory            
            mem[packet.paddr]=packet.pwdata;
         end
         else begin
            if(mem.exists(packet.paddr))begin
               $warning("read from uninitialised");
               continue;
            end

// Compare expected value with actual DUT output            
            if(mem[packet.paddr]===packet.paddr)
               $display("Pass");
            else
               $display("Fail");
         end
      end
   endtask
endclass


`endif
