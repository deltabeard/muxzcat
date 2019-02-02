muxzcat: tiny .xz and .lzma decompression filter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
muxzcat is decompression filter for .xz and .lzma compressed files
implemented in C (also works in C++). It's platform independent, but it's
size-optimized for Linux i386. It's self-contained: it uses only the
standard C library.

muxzcat is size-optimized for Linux i386 (also runs on amd64) with `xtiny
gcc': the final statically linked executable is 7376 bytes, and with upxbc
(`upxbc --elftiny -f -o muxzcat.upx muxzcat') it can be compressed to 4678
bytes. (Compare it with xzcat-only busybox on Linux i386, which is >20 KiB.)

See the beginning of muxzcat.c for compilation instructions. After
compiling, run it with any of:

  $ ./muxzcat <input.xz >output.bin
  $ ./muxzcat <input.lzma >output.bin

  Error is indicated as a non-zero exit status.

  It ignores command-line flags, so you can specify e.g. `-cd'.

muzxcat is a drop-in replacement for the following commands:

  $ xz -cd              <input.xz >output.bin
  $ unxz -cd            <input.xz >output.bin
  $ xzcat -cd           <input.xz >output.bin
  $ xzdec -cd           <input.xz >output.bin
  $ busybox xz -cd      <input.xz >output.bin
  $ busybox unxz -cd    <input.xz >output.bin
  $ busybox xzcat -cd   <input.xz >output.bin
  $ xz -cd              <input.lzma >output.bin
  $ unxz -cd            <input.lzma >output.bin
  $ xzcat -cd           <input.lzma >output.bin
  $ lzma -cd            <input.lzma >output.bin
  $ unlzma -cd          <input.lzma >output.bin
  $ lzmadec -cd         <input.lzma >output.bin
  $ busybox lzma -cd    <input.lzma >output.bin
  $ busybox unlzma -cd  <input.lzma >output.bin
  $ busybox lzmadec -cd <input.lzma >output.bin

Limitations of muxzcat:

* It keeps uncompressed data in memory, and it needs 130 KiB of
  memory on top of it: readBuf is about 64 KiB, CLzmaDec.prob is about
  28 KiB, the rest is decompressBuf (containing the entire uncompressed
  data) and a small constant overhead.
* It doesn't support uncompressed data larger than 1610612736 (~1.61 GB).
  FYI linux-4.20.5.tar is about half as much, 854855680 bytes.
* For .xz it supports only LZMA2 (no other filters such as BCJ).
* For .lzma it doesn't work with files with 5 <= lc + lp <= 8.
* It doesn't verify checksums (e.g. CRC-32 or CRC-64).
* It extracts the first stream only, and it ignores the index.
* It doesn't support dictionary sizes larger than 1610612736 bytes (~1.61 GB).
  (This is not a problem in practice, because even the ouput of `xz -9e'
  uses only 64 MiB dictionary size.)

Based on decompression speed measurements of linux-4.20.5.tar.xz,
size-optimized muxzcat (on Linux i386) is about 7% slower than
speed-optimized xzcat (on Linux amd64).

If you need a tiny decompressor for .gz, .zip and Flate compressed
files, see https://github.com/pts/pts-zcat .

If you need a tiny extractor and self-extractor for .7z archives, see
https://github.com/pts/pts-tiny-7z-sfx .

__END__