/*-----------------------------------------------------------------------------------------------------

       Author       :  JANANI.S
       E-mail ID    :  jananisurya63@gmail.com
       Description  : APB transaction is a class that defines the packet                                  or data structure containing APB bus signals like 
                      address,data and write/read control used for 
                      communication between generator and driver in the
                      verification environment.                    
       Date         :  04-03-2026.

--------------------------------------------------------------------------------------------------*/ 
`ifndef _APB_TOP
`define _APB_TOP


//`include "apb_interface.sv"
//`include "apb_slave_design.sv"
//`include "apb_transaction.sv"
//`include "apb_generator.sv"
//`include "apb_driver.sv"
//`include "apb_monitor.sv"
//`include "apb_env.sv"
//`include "apb_test.sv"
//`include "apb_read_test.sv"
//`include "apb_write_test.sv"
//`include "apb_rw_test.sv"

import apb_test_package::*;

module apb_top();
reg pclk,presetn;

apb_interface intf_h(pclk,presetn);
apb_test test;
apb_write_test wtest_h;
apb_slave inst(intf_h);
always #5 pclk = ~pclk;

initial begin
   pclk=0;
   presetn=1;
   #3 presetn=0;
   #50 presetn=1;
   #100 presetn=0;
   #20 presetn=1;
   #500 $finish;
end

initial begin
   test=new(intf_h);
   test.run();
end

endmodule

`endif
