
/*---------------------------------------------------------------------------------------------------

Author       : JANANI.S
E-mail ID    : jananisurya63@gmail.com
Project      : APB protocol
Description  : APB generator is a verification component that creates randomized APB
                      transactions and sends them to driver through a mailbox for driving to the DUT.
Date         : 09-03-2026.

---------------------------------------------------------------------------------------------------*/

`ifndef _APB_GENERATOR
`define _APB_GENERATOR


class apb_generator;
// Handle for transaction   
   apb_transaction packet;
// Mailbox for generator-driver   
   mailbox gen_drv;
// Number of transactions to generate   
   int count;
// Write transaction control   
   bit write;
// Error transaction control   
   bit error;
// Mode Selection   
   bit mode;


// Constructor
   function new(mailbox gen_drv);
      this.gen_drv=gen_drv;
   endfunction



   task run();
// Generate specified number of transactions      
      repeat(count)begin
// Creating memory for transaction         
         packet=new();
// Generate write transaction         
         if(write && !error)begin
            packet.randomize()with{pwrite == 1;};
// Send transaction to driver            
            gen_drv.put(packet);
         end
// Generate read transaction
         if(!write && !error)begin
            packet.randomize()with{pwrite == 0;};
// Send transaction to driver            
            gen_drv.put(packet);
         end

         else
// Generate error transaction            
            if(error)begin
               packet.randomize()with{paddr ==32'hffff_ffff;};
// send transaction to driver               
               gen_drv.put(packet);
            end
            else begin
// Randomize all               
               packet.randomize();
// Send transaction to driver               
               gen_drv.put(packet);
            end
// Display generated transaction            
            packet.display("Gen");
         end
      endtask
   endclass


`endif
