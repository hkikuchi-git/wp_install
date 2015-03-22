#

CC = gcc

PRG1 = make_string
PRG2 = make_wp-salt

SRC1 = make_string.c
SRC2 = make_wp-salt.c

OBJ1 = make_string.o
OBJ2 = make_wp-salt.o

# DEFS = -D_USE_RANDOM -DSEED_LEN=64

CFLAGS = -I. -O2 

all : $(PRG1) $(PRG2)

${PRG1} : $(OBJ1)
	${CC} -o $@ ${OBJ1}

${PRG2} : $(OBJ2)
	${CC} -o $@ ${OBJ2}

$(OBJ1): $(SRC1) seed.h
	${CC} $(CFLAGS) $(DEFS) -c $<

$(OBJ2): $(SRC2) seed.h
	${CC} $(CFLAGS) $(DEFS) -c $<

.c.o:
	$(CC) $(CFLAGS) $(DEFS) -c $<

clean:
	rm -f $(PRG1) $(PRG2) $(OBJ1) $(OBJ2)


