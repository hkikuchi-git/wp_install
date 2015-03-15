#
#

CC = gcc

TARGET = make_string
OBJS = make_string.o

all : $(TARGET)

${TARGET} : ${OBJS}
	${CC} -o $@ ${OBJS}


make_string.o: make_string.c seed.h
	${CC} -c -O2 $<

.c.o:
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f ${TARGET} ${OBJS}

