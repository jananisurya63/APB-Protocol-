
/*---------------------------------------------------------------------------------------------------

Author       : JANANI.S
E-mail ID    : jananisurya63@gmail.com
Project      : APB Protocol
Description  : APB driver is a verification component that receives transactions from generator 
               through a mailbox and drives the corresponding APB signals to the DUT using the
               interface         
Date         : 09-03-2026.

--------------------------------------------------------------------------------------------------*/

`ifndef _APB_DRIVER
`define _APB_DRIVER


class apb_driver;
// Handle for transaction   
   apb_transaction packet;
// Mailbox for generator-driver   
   mailbox gen_drv;
// Temporary Mailbox for storing transactions    
   mailbox temp_str;
// Virtual interface handle   
   virtual apb_interface vif;
// Counter for wait states   
   int wait_count;

// Constructor
   function new(mailbox gen_drv,virtual apb_interface vif);
// Assign generator to driver mailbox      
      this.gen_drv=gen_drv;
// Assign interface handle      
      this.vif=vif;
// Creating memory for transaction object and temporaty mailbox      
      packet=new();
      temp_str=new();
   endfunction

// Reset logic   
    task reset();
      do begin
      $display("Entering reset logic");
// Clear address signal      
      vif.paddr <=0;
// Clear write signal      
      vif.pwrite <=0;
// Clear select signal      
      vif.psel <=0;
// Clear enable signal      
      vif.penable <=0;
      $display("Exiting reset logic");
      @(vif.master_cb);
   end
// Repeat until reset is released   
   while(!vif.presetn||$isunknown(vif.presetn));
  endtask


  
// Driver logic  
   task driver(apb_transaction packet);
     // $display("temp_str value=%0d",temp_str.num());
      @(vif.master_cb);


// SETUP STATE


// Check for active reset
      if(!vif.presetn || $isunknown(vif.presetn))begin
// Execute reset logic         
         reset();
// Exxit driver task         
         return;   
              end
      else begin

           packet.display("Drv");

           //IDLE
   //      @(vif.master_cb);
  //  $display("Entered to IDLE state");
  //  vif.master_cb.psel<=1'b0;
  //  vif.master_cb.penable<=1'b0;

   
       
    $display("Entered to setup state");
// Assert psel to select slave    
    vif.master_cb.psel<=1'b1;
// Deassert penable during setup phase    
    vif.master_cb.penable<=1'b0;
// Drive address onto APB bus    
    vif.paddr<=packet.paddr;
// Drive read/write control signal    
    vif.pwrite<=packet.pwrite;
// Drive write data onto APB bus    
    vif.pwdata<=packet.pwdata;
 end
     @(vif.master_cb);

// ACCESS STATE

// Check reset     
if(!vif.presetn || $isunknown(vif.presetn))begin
        $display("[DRV] Reset after setup state");
// Store current transaction in temporary mailbox for retry after reset        
        temp_str.put(packet);
       // reset();
       return;
    end 
    else begin
       $display("Entered to Access State");
       vif.master_cb.penable<=1'b1;
    end
   
    // RESET DURING ACCESS

// Check reset    
    if(!vif.presetn || $isunknown(vif.presetn))begin
       $display("[DRV] Reset after access state");
// Store current transaction in temporary mailbox for retry after reset       
              temp_str.put(packet);
       return;
    end
    else begin

       @(vif.master_cb);

       // PREADY WAIT

// Initialize wait state counter
       wait_count=0;
    while(!vif.master_cb.pready)begin
    if(!vif.presetn || $isunknown(vif.presetn))begin
       $display("[DRV] Reset after access state");
// Store current transaction in temporary mailbox for retry after reset
       temp_str.put(packet);
       return;
    end
    else begin
       wait_count++;
// Report error if wait states exceed limit       
       if(wait_count>5)
          $error($time,"wait count reached maximum %0d",wait_count);
       @(vif.master_cb);
    end
 end

    $display("PREADY occured at=%0d pready  %0d",wait_count,vif.pready);
// Clear wait counter    
    wait_count=0;
    @(vif.master_cb);
    $display("Transaction completed\n");
// Deassert slave select signal    
    vif.master_cb.psel<=1'b0;
// Deassert enable signal    
    vif.master_cb.penable<=1'b0;
 end
  endtask

   task run();
      forever begin
         @(vif.master_cb);
// Check for active reset         
         if(!vif.presetn||$isunknown(vif.presetn))
// Execute reset logic            
            reset();
         else begin
// Check if retry mailbox is expty            
            if(temp_str.num()==0)begin
// Get new transaction from generator               
            gen_drv.get(packet);
// Drive transaction to DUT            
            driver(packet);
         end
         else begin 
// Retrieve saved transaction after reset            
            temp_str.get(packet);
// Re-drive saved transaction            
            driver(packet);
         end
            end
         end
   endtask

endclass


`endif
