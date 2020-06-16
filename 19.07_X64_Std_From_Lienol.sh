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
#添加固件版本描述。
rm -Rf package/default-settings/files/zzz-default-settings
rm -Rf package/lean/luci-app-ssr-plus
#rm -Rf package/OpenAppFilter
cp -Rf ../diy-lienol/* ./
sed -i 's/OpenWrt/LedeWrt /g' package/default-settings/files/zzz-default-settings
#添加luci版本。
sed -i 's/"18.06 Lienol"/"openwrt-19.07 branch "/g' feeds/luci/luci.mk
# 关闭禁止解析IPv6 DNS 记录
sed -i '/option filter_aaaa 1/d' package/network/services/dnsmasq/files/dhcp.conf
#添加img编译时间前缀。
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(shell date +%Y%m%d)-LEDE-1907-/g' include/image.mk
#选择编译内核。
#sed -i 's/4.19/4.14/g' target/linux/x86/Makefile
#修改网络连接数
#sed -i 's/net.netfilter.nf_conntrack_max=65535/net.netfilter.nf_conntrack_max=105535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#添加自定义插件1。
git clone https://github.com/vernesong/OpenClash.git package/luci-app-openclash
#git clone https://github.com/rufengsuixing/luci-app-adguardhome.git  package/luci-app-adguardhome
git clone https://github.com/ledewrt/luci-app-eqos.git  package/luci-app-eqos
git clone https://github.com/jefferymvp/luci-app-koolproxyR.git  package/luci-app-koolproxyR
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
#git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone https://github.com/fw876/helloworld.git package/luci-app-ssr-plus
#克隆opentomato主题并改标题
svn co https://github.com/solidus1983/luci-theme-opentomato/trunk/luci/themes/luci-theme-opentomato package/luci-theme-opentomato
sed -i 's/<img width="150" alt="Openwrt" src="<%=media%>/icons/logo.svg">/<a class="brand" href="#"><%="LEDE"%>/g' package/luci-theme-opentomato/luasrc/view/themes/opentomato/header.htm
cd package
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-passwall
cd -
./scripts/feeds update -a
./scripts/feeds install -a
