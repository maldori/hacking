CC = gcc
CFLAGS = -g -O0 -fno-stack-protector -D_FORTIFY_SOURCE=0 -Wno-format-security
LDFLAGS = 

# macOS specific to disable PIE (Position Independent Executable)
ifeq ($(shell uname), Darwin)
    LDFLAGS += -Wl,-no_pie
else
    # Linux flags for executable stack and no PIE
    LDFLAGS += -z execstack -no-pie
endif

# Files requiring pcap
PCAP_SRCS = booksrc/decode_sniff.c booksrc/pcap_sniff.c
PCAP_BINS = $(PCAP_SRCS:.c=)

# Files requiring libnet (these might fail if libnet is not installed)
LIBNET_SRCS = booksrc/rst_hijack.c booksrc/shroud.c booksrc/synflood.c
LIBNET_BINS = $(LIBNET_SRCS:.c=)

# All other C files
ALL_SRCS = $(wildcard booksrc/*.c)
OTHER_SRCS = $(filter-out $(PCAP_SRCS) $(LIBNET_SRCS), $(ALL_SRCS))
OTHER_BINS = $(OTHER_SRCS:.c=)

.PHONY: all clean libnet

all: $(OTHER_BINS) $(PCAP_BINS)

$(OTHER_BINS): %: %.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

$(PCAP_BINS): %: %.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS) -lpcap

# Libnet files are kept separate as they often require manual library installation
libnet: $(LIBNET_BINS)

$(LIBNET_BINS): %: %.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS) -lnet

clean:
	rm -f $(OTHER_BINS) $(PCAP_BINS) $(LIBNET_BINS)
	rm -f booksrc/*.o
