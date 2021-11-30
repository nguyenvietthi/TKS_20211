# clear all
set nfacs [ gtkwave::getNumFacs ]
set signals [list]
for {set i 0} {$i < $nfacs } {incr i} {
    set facname [ gtkwave::getFacName $i ]
    lappend signals "$facname"
}
gtkwave::deleteSignalsFromList $signals

# add instance port
set ports [list tb_memorywork.clk tb_memorywork.data tb_memorywork.address tb_memorywork.we_p tb_memorywork.we_w tb_memorywork.re_RAM tb_memorywork.nextstep tb_memorywork.dp tb_memorywork.dw tb_memorywork.addrp tb_memorywork.addrw tb_memorywork.step_out tb_memorywork.GO tb_memorywork.in_dense]
gtkwave::addSignalsFromList $ports
