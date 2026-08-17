#!/bin/bash
# diy-part2.sh

# 1. 全局替换默认无线组件为完整版 wpad-mbedtls (彻底根治 package_install 冲突)
sed -i 's/wpad-basic-mbedtls/wpad-mbedtls/g' include/target.mk
sed -i 's/wpad-basic-mbedtls/wpad-mbedtls/g' target/linux/ath79/Makefile
find target/linux/ -name "Makefile" -exec sed -i 's/wpad-basic-mbedtls/wpad-mbedtls/g' {} +

# 2. 修改默认管理后台 IP (192.168.2.1，避免与光猫/主路由 1.1 冲突)
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 3. 设置主机名
sed -i 's/OpenWrt/K2T-AP/g' package/base-files/files/bin/config_generate

# 4. 设置默认时区为上海 (CST-8)
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate
sed -i "/set system.@system\[-1\].timezone='CST-8'/a \\\t\tset system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate

# 5. 默认开启 Wi-Fi 并设置国家码为 CN
sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/country=US/country=CN/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 6. 设置 32MB zram 压缩内存交换
mkdir -p package/base-files/files/etc/uci-defaults
cat << 'EOF' > package/base-files/files/etc/uci-defaults/99-custom-settings
uci set system.@system[0].zram_size_mb='32'
uci commit system
exit 0
EOF
