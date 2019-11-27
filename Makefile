#-
#  ==========================================================================
#  Copyright 1995,2006,2008 Autodesk, Inc. All rights reserved.
# 
#  Use of this software is subject to the terms of the Autodesk
#  license agreement provided at the time of installation or download,
#  or which otherwise accompanies this software in either electronic
#  or hard copy form.
#  ==========================================================================
#+
NAME =	tcSoftIkSolver
MAJOR =		1
MINOR =		0.0
VERSION =	$(MAJOR).$(MINOR)

LIBNAME =	$(NAME).so

C++			= gcc
MAYAVERSION = 2018
# Uncomment the following line on MIPSpro 7.2 compilers to supress
# warnings about declarations in the X header files
# WARNFLAGS	= -woff 3322

# When the following line is present, the linking of plugins will
# occur much faster.  If you link transitively (the default) then
# a number of "ld Warning 85" messages will be printed by ld.
# They are expected, and can be safely ignored.
MAYA_LOCATION = /usr/autodesk/maya
INSTALL_PATH = $(HOME)/maya/$(MAYAVERSION)/plugins
CFLAGS		= -m64 -pthread -pipe -D_BOOL -DLINUX -DREQUIRE_IOSTREAM -Wno-deprecated -fno-gnu-keywords -fPIC -std=gnu++0x
C++FLAGS	= $(CFLAGS) $(WARNFLAGS)
INCLUDES	= -I. -I$(MAYA_LOCATION)/include
LD			= $(C++) -shared $(C++FLAGS)
LIBS		= -L$(MAYA_LOCATION)/lib -lOpenMaya -lOpenMayaAnim -lssl -lcrypto -lpthread -ldl

.SUFFIXES: .cpp .cc .o .so .c

.cc.o:
	$(C++) -c $(INCLUDES) $(C++FLAGS) $<

.cpp.o:
	$(C++) -c $(INCLUDES) $(C++FLAGS) $<

.cc.i:
	$(C++) -E $(INCLUDES) $(C++FLAGS) $*.cc > $*.i

.cc.so:
	-rm -f $@
	$(LD) -o $@ $(INCLUDES) $< $(LIBS)

.cpp.so:
	-rm -f $@
	$(LD) -o $@ $(INCLUDES) $< $(LIBS)

.o.so:
	-rm -f $@
	$(LD) -o $@ $< $(LIBS)

CPP_FILES := $(wildcard *.cpp)
OBJS = $(notdir $(CPP_FILES:.cpp=.o))

all: $(LIBNAME)
	@echo "Done"
	mv $(LIBNAME) $(INSTALL_PATH)

$(LIBNAME): $(OBJS)
	-rm -f $@
	$(LD) -o $@ $(OBJS) $(LIBS) 

depend:
	makedepend $(INCLUDES) -I/usr/include/CC *.cc

clean:
	-rm -f *.o *.so

Clean:
	-rm -f *.o *.so *.bak
	
install:	all 
	mv $(LIBNAME) $(INSTALL_PATH)



