#

CC = gcc

TARGET = make_string
SRCS = make_string.c
OBJS = make_string.o

# DEFS = -D_USE_RANDOM -DSEED_LEN=64

CFLAGS = -I. -O2 

all : $(TARGET)

${TARGET} : ${OBJS}
	${CC} -o $@ ${OBJS}

make_string.o: $(SRCS) seed.h
	${CC} $(CFLAGS) $(DEFS) -c $<

.c.o:
	$(CC) $(CFLAGS) $(DEFS) -c $<

clean:
	rm -f ${TARGET} ${OBJS}


