# Makefile for PALASM1-ARCHIVE
# 
# This file is part of PALASM1-ARCHIVE
# 
# PALASM1-ARCHIVE is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# PALASM1-ARCHIVE is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with PALASM1-ARCHIVE.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Andreas Heitmann
# Date: 2025-01-10
#
# PALASM20 Rev 1.6C date 1983-08-16
#
URL = http://www.brouhaha.com/~eric/retrocomputing/mmi/palasm/palasm20.for
SRC = palasm20.for
FFLAGS = -ffixed-form -g -std=legacy
FC = gfortran
NEW_DIR = new
TARGET = PALASM
OBJ = $(patsubst %.FOR, %.o, $(SRC))
ORIG_DIR = orig
ORIG_SRC = $(addprefix $(ORIG_DIR)/, $(SRC))
ORIG_BAK = $(patsubst %, %.orig, $(FILES))
OS := $(shell uname -o)
ifeq ($(OS), Cygwin)
    EXE := .exe
else
    EXE :=
endif

build: $(TARGET)$(EXE)

$(TARGET)$(EXE): $(OBJ)
	$(FC) $^ -o $@

%.o: %.for
	$(FC) -c $(FFLAGS) $< -o $@

$(ORIG_SRC):
	mkdir -p $(ORIG_DIR)
	wget --no-clobber "$(URL)" -O $@
	tr -d '\032\r' <$@ >$@.cropped
	mv $@.cropped $@

$(SRC): $(ORIG_SRC)
	patch -b -s -p0 <palasm.patch
	mv $(ORIG_SRC) .
	for file in $(ORIG_SRC); do \
		mv $$file.orig $$file; \
	done

clean:
	rm -f TAGS *.o *.O *.orig *.bak $(SRC) $(TARGET)$(EXE) $(ZIP) *~
	rm -rf new/ orig/

palasm.patch: $(ORIG_SRC)
	mkdir -p new
	cp $(SRC) $(NEW_DIR)/
	-((head -20 Makefile | sed s/Makefile/patch/) ; diff --strip-trailing-cr --unified $(ORIG_DIR)/ $(NEW_DIR)/) >$@
	(cd $(NEW_DIR) ; rm $(SRC))
	rmdir new
