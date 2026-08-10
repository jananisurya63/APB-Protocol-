/*
-----------------------------------------------------------------------------------------------------

Author       :  JANANI.S
E-mail ID    :  jananisurya63@gmail.com
Project      :  APB Protocol
Description  :  APB is a simple,low power AMBA bus protocol from ARM Holdings used to connect low
                speed peripherals like UART and GPIO.
Date         :  04-03-2026.

--------------------------------------------------------------------------------------------------*/                                                                          
`ifndef _APB_INTERFACE
`define _APB_INTERFACE

interface apb_interface(input logic pclk, input logic presetn);

   //Global Signal
   
 //  logic pclk;
 //  logic presetn;

   //Control Signal

   logic pready;
   logic penable;
   logic psel;

   // Sideband Signal

   logic[31:0]paddr;
   logic[31:0]pwdata;
   logic[31:0]prdata;
   logic pwrite;

   //These signals can be used in future

   logic pstrb;
   logic pprot;
   logic pslverr;
   logic pauser;
   logic pwuser;
   logic pruser;
   logic pbuser;
   logic pwakeup;

   //Clocking Block
   
   clocking master_cb @(posedge pclk);

      default input #2 output #3;
      input pready,prdata,pslverr;
      output psel,penable,paddr,pwrite,pwdata;

   endclocking:master_cb

   clocking monitor_cb @(posedge pclk);

      default input #2 output #3;
      input pready,prdata,pslverr, psel,penable,paddr,pwrite,pwdata,presetn;

   endclocking:monitor_cb
   //Modport Block

   modport slave_mp(
      input psel,penable,paddr,pwrite,pwdata,
      output pready,prdata,pslverr);
  
   property reset_check;
      @(posedge pclk)(!presetn)|->(!psel&&!penable);
   endproperty;
   presetn_check:assert property(reset_check);

   property sel_penable;
      @(posedge pclk)disable iff(!presetn)$rose(penable)|->$past(psel);
   endproperty;
   psel_penable:assert property(sel_penable);

   property addr_stable;
      @(posedge pclk)disable iff(!presetn)
      (penable&&!pready)|=>$stable(paddr);
   endproperty;
   paddr_stable:assert property(addr_stable);

   property write_stable;
      @(posedge pclk)disable iff(!presetn)
      (penable&&!pready)|=>$stable(pwrite);
   endproperty;
   pwrite_stable:assert property(write_stable);

   property wdata_stable;
      @(posedge pclk)disable iff(!presetn)
      (penable&&!pready)|=>$stable(pwdata);
   endproperty;
   pwdata_stable:assert property(wdata_stable);

   property read_check;
      @(posedge pclk)disable iff(!presetn)
      (psel&&penable)|->pready;
   endproperty;
   pread_check:assert property(read_check);

   property slverr_check;
      @(posedge pclk)disable iff(!presetn)
      (psel&&penable&&pready)|->pslverr;
   endproperty;
   pslverr_check:assert property(slverr_check);

   property ready_wait;
      @(posedge pclk)disable iff(!presetn)
      $rose(psel)|=>(penable##[1:5]pready);
   endproperty;
   pready_wait:assert property(ready_wait);

endinterface:apb_interface

`endif


   

