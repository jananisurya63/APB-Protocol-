CMD = vcs -full64 -R -sverilog -debug_access+all -f files.f -l apb_debug.log 
COV = -cm line+tgl+assert+branch+cond+fsm
COV_DISPLAY = verdi -cov -covdir simv.vdb
WAVEFORM_VERDI = ./simv -gui
WAVEFORM_DVE = ./simv -gui=dve
CLEAR = rm -rf csrc DVEfiles flex* simv* inter* ucli.key novas* vc_hdrs* tr_db*

DESGIN_PATH = /home/dvft1101/final_project/apb_sv/design/apb_slave_design.sv
TOP_PATH = /home/dvft1101/final_project/apb_sv/verification/tb/apb_top.sv

run :
	${CMD}
wave :
	${WAVEFORM_DVE}
clear :
	${CLEAR}
cov :
	${COV}
cov_display :
	${COV_DISPLAY}
