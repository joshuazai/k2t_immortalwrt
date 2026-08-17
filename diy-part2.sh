#!/bin/bash
# diy-part2.sh

# 1. 彻底解决 wpad 包冲突（从底层默认依赖直接替换为支持完整 kvr 漫游的 wpad-mbedtls）
find target/linux/ -name "Makefile" -exec sed -i 's/wpad-basic-mbedtls/wpad-mbedtls/g' {} +
sed -i 's/wpad-basic-mbedtls/wpad-mbedtls/g' include/target.mk

# 2. 修改默认管理后台 IP（如需主路由模式可改回 192.168.1.1）
sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate

# 3. 修改主机名
sed -i 's/OpenWrt/K2T-AP/g' package/base-files/files/bin/config_generate

# 4. 修改默认时区为上海 (CST-8)
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/set system.@system\[-1\].timezone='CST-8'/a \\\t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 5. 默认开启 Wi-Fi 并设置国家码为 CN
sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/country=US/country=CN/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 6. 预置 32MB zram 压缩内存交换
mkdir -p package/base-files/files/etc/uci-defaults
cat << 'EOF' > package/base-files/files/etc/uci-defaults/99-custom-settings
uci set system.@system[0].zram_size_mb='32'
uci commit system
exit 0
EOF
