# [g]make USE_xxxx=1
#
# USE_SHARED_CACHE   :   enable/disable a shared session cache (disabled by default)

DESTDIR =
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin
MANDIR  = $(PREFIX)/share/man
# WolfSSL should be built with --enable-lighty and --enable-opensslextra
#LIBSSL = wolfssl
#LIBSSL = mbedtls
BENCHMARK = 1

CFLAGS  = -O2 -g -std=c99 -fno-strict-aliasing -Wall -W -D_GNU_SOURCE -I/usr/local/include 
LDFLAGS = -lev -L/usr/local/lib
OBJS    = stud.o ringbuffer.o configuration.o

ifeq ($(LIBSSL),wolfssl)
LDFLAGS += -lwolfssl -L$(PWD)/../wolfssl/root/lib
CFLAGS += -DOPENSSL_NO_DH -DHAVE_LIGHTY -DOPENSSL_EXTRA -DUSE_WOLFSSL -I$(PWD)/../wolfssl/root/include
else ifeq ($(LIBSSL),mbedtls)
LDFLAGS += -lmbedtls -lmbedx509 -lmbedcrypto -L$(PWD)/../mbedtls/root/lib
CFLAGS += -DOPENSSL_NO_DH -DUSE_MBEDTLS -I$(PWD)/../mbedtls/root/include
else
CFLAGS += -DUSE_OPENSSL
LDFLAGS += -lssl -lcrypto
endif

ifneq ($(BENCHMARK),)
CFLAGS += -DBENCHMARK
endif


all: realall

# Shared cache feature
ifneq ($(USE_SHARED_CACHE),)
CFLAGS += -DUSE_SHARED_CACHE -DUSE_SYSCALL_FUTEX
OBJS   += shctx.o ebtree/libebtree.a
ALL    += ebtree

ebtree/libebtree.a: $(wildcard ebtree/*.c)
	make -C ebtree
ebtree:
	@[ -d ebtree ] || ( \
		echo "*** Download libebtree at http://1wt.eu/tools/ebtree/" ; \
		echo "*** Untar it and make a link named 'ebtree' to point on it"; \
		exit 1 )
endif

# No config file support?
ifneq ($(NO_CONFIG_FILE),)
CFLAGS += -DNO_CONFIG_FILE
endif

ALL += stud
realall: $(ALL)

stud: $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

install: $(ALL)
	install -d $(DESTDIR)$(BINDIR)
	install stud $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(MANDIR)/man8
	install -m 644 stud.8 $(DESTDIR)$(MANDIR)/man8

clean:
	rm -f stud $(OBJS)


.PHONY: all realall
