#
#

CC = gcc

TARGET = make_string
SRCS = make_string.c
OBJS = make_string.o

CFLAGS = -O2

all : $(TARGET)

${TARGET} : ${OBJS}
	${CC} -o $@ ${OBJS}

make_string.o: $(SRCS) seed.h
	${CC} -c $(CFLAGS) $<

.c.o:
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f ${TARGET} ${OBJS}


