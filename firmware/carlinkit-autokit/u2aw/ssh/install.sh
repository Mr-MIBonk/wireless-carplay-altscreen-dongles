#!/bin/sh
# 040: installs libcl.so with a boot count. Expects /tmp/libcl.so.
# The boot script always removes /etc/ld.so.preload first and re-creates it while /etc/cl/arm counts down; 60 s into a healthy boot the count returns to 8.
# The library runs from /tmp, which is empty after power off, and ld.so skips a missing preload file. So a bad library
# lasts until the next power cycle, and after 8 such boots the hook stays off. Re-arm with: echo 8 > /etc/cl/arm
ROOT=${ROOT:-}
S=$ROOT/script/start_main_service.sh
MARK='# cl-040'
set -e
test -e "$ROOT/tmp/libcl.so"
mkdir -p "$ROOT/etc/cl"
if grep -q "$MARK" "$S"; then
    cp "$ROOT/etc/cl/start_main_service.sh.orig" "$S"
fi
if grep -q "$MARK" "$S"; then
    echo "no clean copy of the boot script"; exit 1
else
    cp "$S" "$ROOT/etc/cl/start_main_service.sh.orig"
    N=$(grep -n '^runMainProcess() {' "$S" | head -1 | cut -d: -f1)
    test -n "$N"
    head -n $((N - 1)) "$S" > "$S.new"
    cat >> "$S.new" <<'EOF'
# cl-040
rm -f /etc/ld.so.preload
if [ -e /etc/cl/arm ]; then
	n=$(cat /etc/cl/arm)
	if [ "$n" -gt 1 ] 2>/dev/null; then echo $((n - 1)) > /etc/cl/arm; else rm -f /etc/cl/arm; fi
	sync
	mkdir -p /tmp/cl
	cp /etc/cl/libcl.so /tmp/cl/libcl.so && echo /tmp/cl/libcl.so > /etc/ld.so.preload
	sync
	# a healthy boot refills the count; with a library that kills programs sleep itself fails and the count runs out
	(sleep 60 && pidof fakeiOSDevice > /dev/null && echo 8 > /etc/cl/arm && sync) &
fi
# cl-040 end

EOF
    tail -n +"$N" "$S" >> "$S.new"
    sh -n "$S.new"
    chmod --reference="$S" "$S.new" 2>/dev/null || chmod 750 "$S.new"
    mv "$S.new" "$S"
fi
cp "$ROOT/tmp/libcl.so" "$ROOT/etc/cl/libcl.so"
echo "${ARM_BOOTS:-8}" > "$ROOT/etc/cl/arm"
sync
echo "armed for the next ${ARM_BOOTS:-8} boots"
md5sum "$ROOT/etc/cl/libcl.so"
ls -la "$ROOT/etc/cl"
sed -n '/# cl-040$/,/# cl-040 end/p' "$S"
df "$ROOT/" | tail -1
