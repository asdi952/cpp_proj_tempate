root_path = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

#------Paths----------------------------------------
cpp_path = $(root_path)cpp/

header_path = $(root_path)header/

bin_path = $(root_path)bin/

normal_bin_path = $(bin_path)normal/
preHeader_path = $(normal_bin_path)preHeader/
object_path = $(normal_bin_path)objects/
depend_path = $(normal_bin_path)depend/

debug_bin_path = $(bin_path)debug/
d_preHeader_path = $(debug_bin_path)preHeader/
d_object_path = $(debug_bin_path)objects/
d_depend_path = $(debug_bin_path)depend/

lib_path = $(root_path)lib/
include_path = $(root_path)include/

#-----Precompiled Header Files -----------------------------
preHeader_files_raw = aux

#------Library include path ------------------------------------------

#extra_lib_path =

#------Library--Dependecies-------------------------------
lib_depend = -pthread -luajit-5.1

#-----Excutable---------------------------------------------
exec_files_raw = main.exe

#-----------------------------------------------------
cpp_files_raw = $(notdir $(wildcard cpp/*.cpp))
cpp_files = $(addprefix $(cpp_path), $(cpp_files_raw))

header_files_raw = $(notdir $(wildcard header/*.h))
header_files = $(addprefix $(header_path), $(header_files_raw))

accepted_header_files = $(patsubst %.h, %.h.gch, $(filter $(addsuffix .h, $(preHeader_files_raw)), $(header_files_raw)))
preHeader_files = $(addprefix $(preHeader_path), $(accepted_header_files))
d_preHeader_files = $(addprefix $(d_preHeader_path), $(accepted_header_files))

object_files_raw = $(patsubst %.cpp, %.o, $(cpp_files_raw))
object_files = $(addprefix $(object_path), $(object_files_raw))
d_object_files = $(addprefix $(d_object_path), $(object_files_raw))

depend_files_raw = $(patsubst %.cpp, %.d, $(cpp_files_raw))
depend_files = $(addprefix $(depend_path), $(depend_files_raw))
d_depend_files = $(addprefix $(d_depend_path), $(depend_files_raw))

exec_files = $(addprefix $(normal_bin_path), $(exec_files_raw))
d_exec_files = $(addprefix $(debug_bin_path), $(exec_files_raw))

-include $(depend_files)
#--------------------------------------------------------------



run: run_init  $(preHeader_files) $(exec_files) run_again

run_init:
	clear


$(preHeader_path)%.h.gch: $(header_path)%.h

	@echo "--> PreHeader"
	@g++ -std=c++17 $< -o $@

$(exec_files): $(object_files)
	@echo "--> Linking"
	@echo "-std=c++17 -Winline $^ -o $@  -L$(lib_path) $(lib_depend)"
	@g++ -std=c++17 -Winline $^ -o $@   $(lib_depend)

$(object_path)%.o: $(cpp_path)%.cpp
	@echo "--> Objectify"
	@g++ -std=c++17 -Winline -MD -MF $(depend_path)$(*).d -I$(header_path) -c $< -o $@

run_again:

	@echo ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	@echo ---""""""----Program-----""""""------------------
	@echo ----------------------------------------------------------------
	@echo
	@$(exec_files)
	@echo

clean:
	@-rm -f $(exec_files) $(object_path)* $(depend_path)* $(preHeader_path)*

show:
	@echo root_path: $(root_path)
	@echo cpp_path: $(cpp_path)
	@echo header_path: $(header_path)
	@echo bin_path: $(bin_path)
	@echo normal_bin_path:$(normal_bin_path)
	@echo preHeader_path: $(preHeader_path)
	@echo object_path: $(object_path)
	@echo depend_path: $(depend_path)

run_force: clean run

run_debug:

run_debug_again:

clean_debug:

clean_all:
