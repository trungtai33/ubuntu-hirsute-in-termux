#!/data/data/com.termux/files/usr/bin/bash
directory="ubuntu-hirsute"
if [ -d "$PREFIX/share/$directory" ]; then
printf "\n\e[31mError: distribution Ubuntu Hirsute is already installed.\n\n\e[0m"
exit
fi
printf "\n\e[34m[\e[32m*\e[34m]\e[36m Checking device architecture...\n\e[0m"
case $(uname -m) in
aarch64) arch="arm64" ;;
armv7l|armv8l) arch="armhf" ;;
x86_64) arch="amd64" ;;
*)
printf "\e[34m[\e[32m*\e[34m]\e[31m Unsupported architecture.\n\n\e[0m"
exit ;;
esac
apt update > /dev/null 2>&1
apt install -y proot > /dev/null 2>&1
tarball="rootfs.tar.gz"
printf "\e[34m[\e[32m*\e[34m]\e[36m Downloading Ubuntu Hirsute, please wait...\n\n\e[34m"
curl --fail --retry 5 --location --output "$tarball" \
"https://partner-images.canonical.com/core/hirsute/current/ubuntu-hirsute-core-cloudimg-$arch-root.tar.gz"
mkdir -p "$PREFIX/share/$directory"
printf "\n\e[34m[\e[32m*\e[34m]\e[36m Installing Ubuntu Hirsute, please wait...\n\e[31m"
proot --link2symlink tar -xf "$tarball" --directory="$PREFIX/share/$directory" --exclude='dev'||:
rm -f "$tarball"
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing profile file...\n\e[31m"
cat <<- EOF >> "$PREFIX/share/$directory/etc/profile"
export PULSE_SERVER="127.0.0.1"
export MOZ_FAKE_NO_SANDBOX="1"
EOF
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing resolv.conf file (DNS 1.1.1.1/1.0.0.1)...\n\e[31m"
cat <<- EOF > "$PREFIX/share/$directory/etc/resolv.conf"
nameserver 1.1.1.1
nameserver 1.0.0.1
EOF
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing hosts file...\n\e[31m"
cat <<- EOF > "$PREFIX/share/$directory/etc/hosts"
127.0.0.1 localhost
::1       ip6-localhost ip6-loopback
EOF
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing group file (GIDs)...\n\e[31m"
while read gid; do
cat <<- EOF >> "$PREFIX/share/$directory/etc/group"
root:x:$gid:
EOF
done < <(paste <(id -G | tr ' ' '\n'))
cat <<- EOF > "$PREFIX/share/$directory/proc/.loadavg"
0.35 0.22 0.15 1/573 7767
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.stat"
cpu  165542 13183 24203 611072 152293 2164 191340 8252 0 0 0
cpu0 165542 13183 24203 611072 152293 2164 191340 8252 0 0 0
intr 6151816 155 0 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 0 234902 123428 52401 0 0 172134 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 122 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 146429 228361 164732 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 14082004 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
ctxt 90720146
btime 1631785009
processes 253846
procs_running 2
procs_blocked 0
softirq 1857962 23 2536781 0 1723322 2457784 0 253 0 32144 1839876
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.uptime"
11965.80 11411.22
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.vmstat"
nr_free_pages 705489
nr_alloc_batch 0
nr_inactive_anon 1809
nr_active_anon 61283
nr_inactive_file 69543
nr_active_file 58416
nr_unevictable 64
nr_mlock 64
nr_anon_pages 60894
nr_mapped 99503
nr_file_pages 130218
nr_dirty 9
nr_writeback 0
nr_slab_reclaimable 2283
nr_slab_unreclaimable 3714
nr_page_table_pages 1911
nr_kernel_stack 687
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
nr_vmscan_immediate_reclaim 0
nr_writeback_temp 0
nr_isolated_anon 0
nr_isolated_file 0
nr_shmem 2262
nr_dirtied 3675
nr_written 3665
nr_pages_scanned 0
workingset_refault 1183
workingset_activate 1183
workingset_nodereclaim 0
nr_anon_transparent_hugepages 0
nr_free_cma 0
nr_dirty_threshold 21574
nr_dirty_background_threshold 5393
pgpgin 541367
pgpgout 23248
pswpin 1927
pswpout 2562
pgalloc_dma 182
pgalloc_normal 76067
pgalloc_high 326333
pgalloc_movable 0
pgfree 1108260
pgactivate 53201
pgdeactivate 2592
pgfault 420060
pgmajfault 4323
pgrefill_dma 0
pgrefill_normal 2589
pgrefill_high 0
pgrefill_movable 0
pgsteal_kswapd_dma 0
pgsteal_kswapd_normal 0
pgsteal_kswapd_high 0
pgsteal_kswapd_movable 0
pgsteal_direct_dma 0
pgsteal_direct_normal 1211
pgsteal_direct_high 7987
pgsteal_direct_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_normal 0
pgscan_kswapd_high 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_normal 4172
pgscan_direct_high 25365
pgscan_direct_movable 0
pgscan_direct_throttle 0
pginodesteal 0
slabs_scanned 9728
kswapd_inodesteal 0
kswapd_low_wmark_hit_quickly 0
kswapd_high_wmark_hit_quickly 0
pageoutrun 1
allocstall 189
pgrotated 7
drop_pagecache 0
drop_slab 0
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 64
unevictable_pgs_scanned 0
unevictable_pgs_rescued 0
unevictable_pgs_mlocked 64
unevictable_pgs_munlocked 0
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.model"
$(getprop ro.product.brand) $(getprop ro.product.model)
EOF
cat <<- EOF > "$PREFIX/share/$directory/proc/.version"
Linux version 5.11.0 (termux@ubuntu) (gcc version 4.9 (GCC)) $(uname -v)
EOF
bin="start-ubuntu-hirsute"
printf "\e[34m[\e[32m*\e[34m]\e[36m Writing $bin file...\n\e[0m"
cat <<- EOF > "$PREFIX/bin/$bin"
#!/data/data/com.termux/files/usr/bin/bash
unset LD_PRELOAD
command="proot"
command+=" --kernel-release=5.11.0"
command+=" --link2symlink"
command+=" --kill-on-exit"
command+=" --root-id"
command+=" --rootfs=$PREFIX/share/$directory"
command+=" --cwd=/root"
command+=" --bind=/dev"
command+=" --bind=/dev/urandom:/dev/random"
command+=" --bind=/proc"
command+=" --bind=/proc/self/fd:/dev/fd"
command+=" --bind=/proc/self/fd/0:/dev/stdin"
command+=" --bind=/proc/self/fd/1:/dev/stdout"
commamd+=" --bind=/proc/self/fd/2:/dev/stderr"
command+=" --bind=/sys"
command+=" --bind=/data/data/com.termux"
command+=" --bind=/sdcard"
command+=" --bind=$PREFIX/share/$directory/root:/dev/shm"
if ! cat /proc/loadavg > /dev/null 2>&1; then
command+=" --bind=$PREFIX/share/$directory/proc/.loadavg:/proc/loadavg"
fi
if ! cat /proc/stat > /dev/null 2>&1; then
command+=" --bind=$PREFIX/share/$directory/proc/.stat:/proc/stat"
fi
if ! cat /proc/uptime > /dev/null 2>&1; then
command+=" --bind=$PREFIX/share/$directory/proc/.uptime:/proc/uptime"
fi
if ! cat /proc/vmstat > /dev/null 2>&1; then
command+=" --bind=$PREFIX/share/$directory/proc/.vmstat:/proc/vmstat"
fi
command+=" --bind=$PREFIX/share/$directory/proc/.model:/proc/device-tree/model"
command+=" --bind=$PREFIX/share/$directory/proc/.version:/proc/version"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
command+=" TERM=$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"; [ -z "\$1" ] && exec \$command || \$command -c "\$com"
EOF
termux-fix-shebang "$PREFIX/bin/$bin"
chmod 700 "$PREFIX/bin/$bin"
printf "\e[34m[\e[32m*\e[34m]\e[36m Installed successfully.\n\n\e[0m"
printf "\e[36mNow run \e[32m$bin\e[36m to login.\n\n\e[0m"
