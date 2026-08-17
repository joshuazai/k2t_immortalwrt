#!/bin/bash
# diy-part2.sh - 自定义系统默认配置

# 1. 修改默认管理后台 IP (根据需求修改，如 192.168.1.2 适合作为 AP/旁路由)
sed -i 's/192.168.2.1/192.168.2.2/g' package/base-files/files/bin/config_generate

# 2. 设置主机名
sed -i 's/OpenWrt/K2T-AP/g' package/base-files/files/bin/config_generate

# 3. 设置默认时区为上海 (CST-8)
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/set system.@system\[-1\].timezone='CST-8'/a \\\t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 4. 默认开启 Wi-Fi 并设置功率国家码为 CN
sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/country=US/country=CN/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 5. 优化 zram 大小（默认分配物理内存的 50% 作为压缩内存缓存，降低 64MB 内存压力）
mkdir -p package/base-files/files/etc/uci-defaults
cat << 'EOF' > package/base-files/files/etc/uci-defaults/99-custom-settings
uci set system.@system[0].zram_size_mb='32'
uci commit system
exit 0
EOF
