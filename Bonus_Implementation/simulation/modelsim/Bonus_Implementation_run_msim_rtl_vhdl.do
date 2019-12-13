transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/Scheduler.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/Qu.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/TopLevel.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/SixteenBitAdder.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/RF.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/MemoryAccess.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/Memory_Data.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/Memory_asyncread_syncwrite.vhdl.vhd}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/InstructionDecode.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/HazardDetectionUnit.vhd}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/Gates.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/ExecutionTasks.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/Encoder.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/EightBitAdder.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/Decoder.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/BitwiseNand.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/WriteBack (1).vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/RegisterRead.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/InstructionFetch.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/Full_Adder.vhdl}
vcom -93 -work work {/home/titasc/Desktop/Sem5/EE309/Bonus_Implementation3/Bonus_Implementation/ALU.vhdl}

