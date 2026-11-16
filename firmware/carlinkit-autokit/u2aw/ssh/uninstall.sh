#!/bin/sh
# 040: back to stock boot behaviour.
ROOT=${ROOT:-}
S=$ROOT/script/start_main_service.sh
rm -f "$ROOT/etc/ld.so.preload"
if [ -e "$ROOT/etc/cl/start_main_service.sh.orig" ]; then
    cp "$ROOT/etc/cl/start_main_service.sh.orig" "$S.new" && sh -n "$S.new" && mv "$S.new" "$S"
fi
grep -q 'cl-040' "$S" && echo "WARNING: boot script still patched"
rm -rf "$ROOT/etc/cl"
sync
ls -la "$ROOT/etc/ld.so.preload" "$ROOT/etc/cl" 2>&1
echo done
