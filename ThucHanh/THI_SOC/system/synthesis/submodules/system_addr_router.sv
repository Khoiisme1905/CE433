// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.0sp1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/03/07 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module system_addr_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 1,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 8 
   )
  (output [81 - 78 : 0] default_destination_id,
   output [9-1 : 0] default_wr_channel,
   output [9-1 : 0] default_rd_channel,
   output [9-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[81 - 78 : 0];

  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1) begin
      assign default_src_channel = '0;
    end
    else begin
      assign default_src_channel = 9'b1 << DEFAULT_CHANNEL;
    end
  end
  endgenerate

  generate begin : default_decode_rw
    if (DEFAULT_RD_CHANNEL == -1) begin
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin
      assign default_wr_channel = 9'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 9'b1 << DEFAULT_RD_CHANNEL;
    end
  end
  endgenerate

endmodule


module system_addr_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [92-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [92-1    : 0] src_data,
    output reg [9-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 52;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 81;
    localparam PKT_DEST_ID_L = 78;
    localparam PKT_PROTECTION_H = 85;
    localparam PKT_PROTECTION_L = 83;
    localparam ST_DATA_W = 92;
    localparam ST_CHANNEL_W = 9;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 55;
    localparam PKT_TRANS_READ  = 56;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h10000 - 64'h8000); 
    localparam PAD1 = log2ceil(64'h11000 - 64'h10800); 
    localparam PAD2 = log2ceil(64'h11080 - 64'h11040); 
    localparam PAD3 = log2ceil(64'h110c0 - 64'h110b0); 
    localparam PAD4 = log2ceil(64'h110d0 - 64'h110c8); 
    localparam PAD5 = log2ceil(64'h110d3 - 64'h110d2); 
    localparam PAD6 = log2ceil(64'h110d4 - 64'h110d3); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h110d4;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;

      wire [PKT_ADDR_W-1 : 0] address = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;

    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [9-1 : 0] default_src_channel;





    system_addr_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x8000 .. 0x10000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 17'h8000   ) begin
            src_channel = 9'b0000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x10800 .. 0x11000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 17'h10800   ) begin
            src_channel = 9'b0000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x11040 .. 0x11080 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 17'h11040   ) begin
            src_channel = 9'b0001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x110b0 .. 0x110c0 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 17'h110b0   ) begin
            src_channel = 9'b0100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x110c8 .. 0x110d0 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 17'h110c8   ) begin
            src_channel = 9'b0000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x110d2 .. 0x110d3 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 17'h110d2   ) begin
            src_channel = 9'b1000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x110d3 .. 0x110d4 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 17'h110d3   ) begin
            src_channel = 9'b0010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


