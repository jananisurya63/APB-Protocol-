/*---------------------------------------------------------------------------------------------------

Author       : JANANI.S
E-mail ID    : jananisurya63@gmail.com
Project      : APB Protocol
Description  : APB Monitor is a verification component that passively observes APB bus signals,
               captures transactions, and sends them to the scoreboard and coverage for checking
               and analysis.
Date         : 09-03-2026.

---------------------------------------------------------------------------------------------------*/

`ifndef _APB_MONITOR
`define _APB_MONITOR



class apb_monitor;
// Virtual interface handle
   virtual apb_interface vif;
// Mailbox for monitor-scoreboard   
   mailbox mon_sb;
// Handle for transaction   
   apb_transaction packet;
// Counter for wait states   
   int wait_count;

// Constructor   
   function new(virtual apb_interface vif,mailbox mon_sb);
// Creating memory for transaction object      
      packet=new();
// Assign interface handle      
      this.vif=vif;
// Assign monitor-scoreboard mailbox      
      this.mon_sb=mon_sb;
// Creating memory for coverage group      
      apb_cg=new();
   endfunction

   task run();
      forever begin
// Check for valid APB transfer         
         if(vif.monitor_cb.psel && vif.monitor_cb.penable && vif.monitor_cb.pready)begin

            @(vif.monitor_cb);
// Wait until slave is ready
         while(!vif.monitor_cb.pready)begin
// Increment wait counter            
            wait_count++;
            @(vif.monitor_cb);
         end
// Clear wait state count
         wait_count=0;


// Capture APB address from interface and store it in transaction
            packet.paddr <= vif.monitor_cb.paddr;
// Capture write data from interface and store it in transaction            
            packet.pwdata <= vif.monitor_cb.pwdata;
// Capture read/write control from interface and store it in transaction            
            packet.pwrite <= vif.monitor_cb.pwrite;
// Capture read data from interface and store it in transaction            
            packet.prdata <= vif.monitor_cb.prdata;
// Capture slave error status from interface and store it in transaction            
            packet.pslverr <= vif.monitor_cb.pslverr;
// Sample functional coverage
            apb_cg.sample();
// Send transaction to scoreboard            
            mon_sb.put(packet);
            packet.display("mon");
            @(vif.monitor_cb);
         end
         else
            @(vif.monitor_cb);
      end
   endtask
// Functional coverage for APB transaction
   covergroup apb_cg;
// Coverage for APB address      
      PADDR:coverpoint packet.paddr {bins low_addr={[13:15]};
                                  bins mid_addr={[16:127]};
                                  bins high_addr={[128:255]};
                                 }
// Coverage for write data
      PWDATA:coverpoint packet.pwdata {bins zero={0};
                                   bins max={32'hFFFF_FFFF};
                                   bins others=default;}
// Coverage for read/write operation
      PWRITE:coverpoint packet.pwrite {bins read={0};
                                   bins write={1};}
// Coverage for penable signal
     PENABLE:coverpoint packet.penable {bins setup={0};
                                   bins enable={1};}
// Coverage for pready signal
     PREADY:coverpoint packet.pready {bins ready={1};
                                  bins waitstate={0};}
// Coverage for slave error response
     PSLVERR:coverpoint packet.pslverr {bins no_error={0};
                                   bins error={1};}
// Cross Coverage                                   
      cross_1:cross PADDR,PWDATA;
      cross_2:cross PWDATA,PWRITE;
      cross_3:cross PWRITE,PENABLE;
      cross_4:cross PENABLE,PREADY;
      cross_5:cross PREADY,PSLVERR;
   endgroup

       
endclass


`endif
