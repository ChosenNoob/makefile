# Best Makefile EVAH (®Baran Karaaslan)

# Change these variables and make will figure the rest
COMPILER := g++

SOURCE_FILE_EXTENSION := cpp
HEADER_FILE_EXTENSION := h


# maybe useful? pkg-config --cflags --libs glfw3
# i guess it creates the linking flag -lglfw

LINK_FLAGS := -g -lglfw -ldl -lX11 -lpthread -lXrandr -lXi -lGLEW -lGLU -lGL -lglfw -ldl  -lpthread -lXrandr -lXi -lGLEW -lGLU -lGL -lX11 -lXxf86vm -L/user/lib/x86_64-linux-gnu/ -lGLEW -lglfw -lGL -lX11 -lXi -lXrandr -lXxf86vm -lXinerama -lXcursor -lrt -lm -pthread
COMP_FLAGS := -g 

  INPUT_DIRECTORY := inputs
 SOURCE_DIRECTORY := src
INCLUDE_DIRECTORY := include
    PCH_DIRECTORY := pch
 BINARY_DIRECTORY := bin
LIBRARY_DIRECTORY := lib

EXECUTABLE_NAME := rasterizer

DEFAULT_INPUT := 
DEFAULT_OUTPUTS := 

# DEFAULT_INPUT := culling_disabled_inputs/empty_box.xml
# DEFAULT_OUTPUTS := empty_box_1.ppm empty_box_2.ppm empty_box_3.ppm empty_box_4.ppm empty_box_5.ppm empty_box_6.ppm  empty_box_7.ppm  empty_box_8.ppm  empty_box_example.ppm  
# DEFAULT_CORRECT_OUTPUTS := clipping_example/

# Use these rules
all: ${BINARY_DIRECTORY}/${EXECUTABLE_NAME} 
	rm -f ${DEFAULT_OUTPUTS}
clean:
	rm -rf ${BINARY_DIRECTORY}/*
	
gdb:
	gdb ./${BINARY_DIRECTORY}/${EXECUTABLE_NAME}

run:
	./${BINARY_DIRECTORY}/${EXECUTABLE_NAME} 

drun:
	./${BINARY_DIRECTORY}/${EXECUTABLE_NAME} ${DEFAULT_INPUT}
	feh ${DEFAULT_OUTPUTS} &
# 	feh ${DEFAULT_CORRECT_OUTPUTS} &
subl:
	subl .

# the rest 
.PHONY: all clean gdb run drun subl dir 
.PRECIOUS: ${PCH_OBJECTS}

SOURCE_FILES := $(shell find $(SOURCE_DIRECTORY)/  -name '*.${SOURCE_FILE_EXTENSION}')
# cFiles := $(shell find $(SOURCE_DIRECTORY)/  -name '*.c')
HEADER_FILES := $(shell find $(INCLUDE_DIRECTORY)/ -name '*.${HEADER_FILE_EXTENSION}')
   PCH_FILES := $(shell find ${PCH_DIRECTORY}/     -name '*.${HEADER_FILE_EXTENSION}')
   
   PCH_OBJECTS := $(patsubst $(PCH_DIRECTORY)/%.${HEADER_FILE_EXTENSION}, $(BINARY_DIRECTORY)/%.gch, $(PCH_FILES))
SOURCE_OBJECTS := $(patsubst $(SOURCE_DIRECTORY)/%.${SOURCE_FILE_EXTENSION}, $(BINARY_DIRECTORY)/%.o,   $(SOURCE_FILES))
# cObjects := $(patsubst $(SOURCE_DIRECTORY)/%.c, $(BINARY_DIRECTORY)/%.oc,   $(cFiles))

${BINARY_DIRECTORY}/${EXECUTABLE_NAME}: ${SOURCE_OBJECTS} ${PCH_OBJECTS} ${HEADER_FILES}
	@mkdir -p "${@D}"
	${COMPILER} -o ${BINARY_DIRECTORY}/${EXECUTABLE_NAME} ${LINK_FLAGS} ${SOURCE_OBJECTS}

${BINARY_DIRECTORY}/%.o: ${SOURCE_DIRECTORY}/%.${SOURCE_FILE_EXTENSION} ${HEADER_FILES} ${PCH_OBJECTS}
	@mkdir -p "${@D}"
	${COMPILER} -o $@ -c -I ${INCLUDE_DIRECTORY} -I ${PCH_DIRECTORY} -I ${LIBRARY_DIRECTORY} ${COMP_FLAGS} $<

# ${BINARY_DIRECTORY}/%.oc: ${SOURCE_DIRECTORY}/%.c ${HEADER_FILES} ${PCH_OBJECTS}
# 	@mkdir -p "${@D}"
# 	${COMPILER} -o $@ -c -I ${INCLUDE_DIRECTORY} -I ${PCH_DIRECTORY} -I ${LIBRARY_DIRECTORY} ${COMP_FLAGS} $<

${BINARY_DIRECTORY}/%.gch: ${PCH_DIRECTORY}/%.${HEADER_FILE_EXTENSION}
	@mkdir -p "${@D}"
	${COMPILER} -o $@ ${COMP_FLAGS} $< 

dir:
	mkdir -p  ${BINARY_DIRECTORY}
	mkdir -p ${INCLUDE_DIRECTORY}
	mkdir -p  ${SOURCE_DIRECTORY}
	mkdir -p   ${INPUT_DIRECTORY}
	mkdir -p     ${PCH_DIRECTORY}
	mkdir -p ${LIBRARY_DIRECTORY}