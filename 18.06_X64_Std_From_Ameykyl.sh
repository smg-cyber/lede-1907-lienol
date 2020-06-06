#!/bin/bash
#=================================================
# Description: Build OpenWrt using GitHub Actions 
# Lisence: MIT
# 参考以下资料：
# Frome: https://github.com/garypang13/Actions-OpenWrt
# Frome: https://github.com/P3TERX/Actions-OpenWrt
# Frome: https://github.com/Lienol/openwrt-actions
# Frome: https://github.com/svenstaro/upload-release-action
# By LEDE 2020 https://ledewrt.com
# https://github.com/ledewrt
#=================================================
#添加固件版本描述
rm -Rf package/lean/default-settings/files/zzz-default-settings
rm -Rf package/lean/luci-app-ssr-plus
#rm -Rf package/ctcgfw/open-app-filter
cp -Rf ../diy-lean/* ./
sed -i 's/OpenWrt/LedeWrt Standard/g' package/lean/default-settings/files/zzz-default-settings
rm -Rf package/my/luci-app-koolproxyR
# 修改默认IP为192.168.168.1
#sed -i 's/192.168.1.1/192.168.168.1/g' package/base-files/files/bin/config_generate
#修改主机名
#sed -i 's/'OpenWrt'/'LEDE'/g' package/base-files/files/bin/config_generate
# 关闭禁止解析IPv6 DNS 记录
sed -i '/option filter_aaaa 1/d' package/network/services/dnsmasq/files/dhcp.conf
#使用smartdns是需要将dhcp里的dns缓存设置为0.
sed -i '/option noresolv '1'/a option cachesize '0'' package/network/services/dnsmasq/files/dhcp.conf
#修改默认主题
#sed -i '/lang=zh_cn/i uci set luci.main.mediaurlbase=/luci-static/argon' package/lean/default-settings/files/zzz-default-settings
#删除默认密码
#sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./d' package/lean/default-settings/files/zzz-default-settings
#添加img编译时间前缀。
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(shell date +%Y%m%d)-LEDE-1806-Std-/g' include/image.mk
#选择编译内核。
#sed -i 's/5.4/4.14/g' target/linux/x86/Makefile
#修改网络连接数
#sed -i 's/net.netfilter.nf_conntrack_max=65535/net.netfilter.nf_conntrack_max=105535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#添加自定义插件1
#git clone https://github.com/vernesong/OpenClash.git package/luci-app-openclash
#git clone https://github.com/rufengsuixing/luci-app-adguardhome.git  package/luci-app-adguardhome
git clone https://github.com/ledewrt/luci-app-eqos.git  package/luci-app-eqos
git clone https://github.com/jefferymvp/luci-app-koolproxyR.git  package/luci-app-koolproxyR
#git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
#git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone https://github.com/fw876/helloworld.git package/luci-app-ssr-plus
#git clone -b lede https://github.com/pymumu/luci-app-smartdns  package/luci-app-smartdns
./scripts/feeds update -a
./scripts/feeds install -a
