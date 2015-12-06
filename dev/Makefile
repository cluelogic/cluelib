# -*-Makefile-*-
#
# Makefile - Makefile for library development
#

common := $(HOME)/Dropbox/dev/common
include $(common)/common_variables.mk

#-------------------------------------------------------------------------------

src_dir  := ../src
test_dir := ../test
api_dir  := ./api
doc_dir  := ./doc
bin_dir  := ./bin

#-------------------------------------------------------------------------------

stylus_files := $(wildcard $(api_dir)/proj/*.styl)

jade_files := $(wildcard $(doc_dir)/*.jade)
jade_dir   := $(doc_dir)
tag_files  := $(src_dir)/*sv $(src_dir)/*svh $(test_dir)/*sv $(test_dir)/*svh

#modelsim_sv_files  := $(src_dir)/cl_pkg.sv $(test_dir)/test_from_examples.sv $(src_dir)/cl_dpi.cc
modelsim_sv_files   := $(src_dir)/cl_pkg.sv $(test_dir)/test_from_examples.sv 
modelsim_top_module := test_from_examples
modelsim_vlog_opts  := +incdir+$(src_dir)+$(test_dir)

umlgraph_sv_files   := $(src_dir)/*.svh

# src/*.svh -> $(umlgraph_build_dir)/*.java

umlgraph_java_files := $(patsubst %,$(umlgraph_build_dir)/%,$(notdir $(umlgraph_sv_files:.svh=.java)))
umlgraph_java_view_files := ~/documents/build/*_view.java

naturaldocs_src_dir := $(src_dir)
naturaldocs_api_dir := $(api_dir)
naturaldocs_style   := cluelib

cloc_dir := $(src_dir)

# This file requires Questa:
#	 $(src_dir)/cl_random_num.svh

cl_files_to_run := \
	$(src_dir)/cl_bit_stream.svh\
	$(src_dir)/cl_choice.svh\
	$(src_dir)/cl_comma_formatter.svh\
	$(src_dir)/cl_crc.svh\
	$(src_dir)/cl_data_stream.svh\
	$(src_dir)/cl_deque.svh\
	$(src_dir)/cl_dynamic_array.svh\
	$(src_dir)/cl_journal.svh\
	$(src_dir)/cl_kitchen_timer.svh\
	$(src_dir)/cl_network.svh\
	$(src_dir)/cl_packed_array.svh\
	$(src_dir)/cl_pair.svh\
	$(src_dir)/cl_putil.svh\
	$(src_dir)/cl_queue.svh\
	$(src_dir)/cl_set.svh\
	$(src_dir)/cl_set_base.svh\
	$(src_dir)/cl_text.svh\
	$(src_dir)/cl_tuple.svh\
	$(src_dir)/cl_unpacked_array.svh\
	$(src_dir)/cl_util.svh\

cl_files_to_update := \
	$(shell ls ../src/*.sv ../src/*.svh ../src/*.txt ../src/*.cc)\
	$(api_dir)/proj/Menu.txt

all: css api tests modelsim cloc html

revision: $(cl_files_to_update)
	$(bin_dir)/revisionize.sh $(cl_files_to_update)

tests: $(cl_files_to_run)
	$(bin_dir)/testify.sh $(cl_files_to_run) > $(test_dir)/test_from_examples.sv

tex:
	$(common)/../bin/latexmath2png.py --outdir=$(api_dir)/images < $(api_dir)/images/crc.tex
	mv $(api_dir)/images/1.png $(api_dir)/images/crc1.png
	mv $(api_dir)/images/2.png $(api_dir)/images/crc4_itu.png
	mv $(api_dir)/images/3.png $(api_dir)/images/crc5_epc.png
	mv $(api_dir)/images/4.png $(api_dir)/images/crc5_itu.png
	mv $(api_dir)/images/5.png $(api_dir)/images/crc5_usb.png
	mv $(api_dir)/images/6.png $(api_dir)/images/crc6_cdma2000_a.png
	mv $(api_dir)/images/7.png $(api_dir)/images/crc6_cdma2000_b.png
	mv $(api_dir)/images/8.png $(api_dir)/images/crc6_itu.png
	mv $(api_dir)/images/9.png $(api_dir)/images/crc7.png
	mv $(api_dir)/images/10.png $(api_dir)/images/crc7_mvb.png
	mv $(api_dir)/images/11.png $(api_dir)/images/crc8.png
	mv $(api_dir)/images/12.png $(api_dir)/images/crc8_ccitt.png
	mv $(api_dir)/images/13.png $(api_dir)/images/crc8_dallas_maxim.png
	mv $(api_dir)/images/14.png $(api_dir)/images/crc8_sae_j1850.png
	mv $(api_dir)/images/15.png $(api_dir)/images/crc8_wcdma.png
	mv $(api_dir)/images/16.png $(api_dir)/images/crc10.png
	mv $(api_dir)/images/17.png $(api_dir)/images/crc10_cdma2000.png
	mv $(api_dir)/images/18.png $(api_dir)/images/crc11.png
	mv $(api_dir)/images/19.png $(api_dir)/images/crc12.png
	mv $(api_dir)/images/20.png $(api_dir)/images/crc12_cdma2000.png
	mv $(api_dir)/images/21.png $(api_dir)/images/crc13_bbc.png
	mv $(api_dir)/images/22.png $(api_dir)/images/crc15_can.png
	mv $(api_dir)/images/23.png $(api_dir)/images/crc15_mpt1327.png
	mv $(api_dir)/images/24.png $(api_dir)/images/crc16_arinc.png
	mv $(api_dir)/images/25.png $(api_dir)/images/crc16_ccitt.png
	mv $(api_dir)/images/26.png $(api_dir)/images/crc16_cdma2000.png
	mv $(api_dir)/images/27.png $(api_dir)/images/crc16_dect.png
	mv $(api_dir)/images/28.png $(api_dir)/images/crc16_t10_dif.png
	mv $(api_dir)/images/29.png $(api_dir)/images/crc16_dnp.png
	mv $(api_dir)/images/30.png $(api_dir)/images/crc16_ibm.png
	mv $(api_dir)/images/31.png $(api_dir)/images/crc17_can.png
	mv $(api_dir)/images/32.png $(api_dir)/images/crc21_can.png
	mv $(api_dir)/images/33.png $(api_dir)/images/crc24.png
	mv $(api_dir)/images/34.png $(api_dir)/images/crc24_radix_64.png
	mv $(api_dir)/images/35.png $(api_dir)/images/crc30.png
	mv $(api_dir)/images/36.png $(api_dir)/images/crc32.png
	mv $(api_dir)/images/37.png $(api_dir)/images/crc32c.png
	mv $(api_dir)/images/38.png $(api_dir)/images/crc32k.png
	mv $(api_dir)/images/39.png $(api_dir)/images/crc32q.png
	mv $(api_dir)/images/40.png $(api_dir)/images/crc40_gsm.png
	mv $(api_dir)/images/41.png $(api_dir)/images/crc64_ecma.png
	mv $(api_dir)/images/42.png $(api_dir)/images/crc64_iso.png
	$(common)/../bin/latexmath2png.py --outdir=$(api_dir)/images < $(api_dir)/images/scrambler.tex
	mv $(api_dir)/images/1.png $(api_dir)/images/scrambler_2.png
	mv $(api_dir)/images/2.png $(api_dir)/images/scrambler_3.png
	mv $(api_dir)/images/3.png $(api_dir)/images/scrambler_4.png
	mv $(api_dir)/images/4.png $(api_dir)/images/scrambler_5.png
	mv $(api_dir)/images/5.png $(api_dir)/images/scrambler_6.png
	mv $(api_dir)/images/6.png $(api_dir)/images/scrambler_7.png
	mv $(api_dir)/images/7.png $(api_dir)/images/scrambler_8.png
	mv $(api_dir)/images/8.png $(api_dir)/images/scrambler_9.png
	mv $(api_dir)/images/9.png $(api_dir)/images/scrambler_10.png
	mv $(api_dir)/images/10.png $(api_dir)/images/scrambler_11.png
	mv $(api_dir)/images/11.png $(api_dir)/images/scrambler_12.png
	mv $(api_dir)/images/12.png $(api_dir)/images/scrambler_13.png
	mv $(api_dir)/images/13.png $(api_dir)/images/scrambler_14.png
	mv $(api_dir)/images/14.png $(api_dir)/images/scrambler_15.png
	mv $(api_dir)/images/15.png $(api_dir)/images/scrambler_16.png
	mv $(api_dir)/images/16.png $(api_dir)/images/scrambler_17.png
	mv $(api_dir)/images/17.png $(api_dir)/images/scrambler_18.png
	mv $(api_dir)/images/18.png $(api_dir)/images/scrambler_19.png

#-------------------------------------------------------------------------------

include $(common)/common_rules.mk

