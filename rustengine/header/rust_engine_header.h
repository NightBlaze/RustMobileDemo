#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct RustByteSlice {
  const uint8_t *bytes;
  size_t len;
} RustByteSlice;

struct RustByteSlice *rust_download_image(void);

struct RustByteSlice *rust_download_and_resize_image(unsigned int width, unsigned int height);

struct RustByteSlice *rust_parse_big_json(void);

struct RustByteSlice *rust_parse_small_json(void);

void rust_crash(void);

void rust_destroy_byte_slice(struct RustByteSlice *slice);
