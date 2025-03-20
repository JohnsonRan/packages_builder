#!/bin/sh

# thanks to nikkinikki-org/OpenWrt-nikki

# include openwrt_release
. /etc/openwrt_release

# get branch/arch
arch="$DISTRIB_ARCH"
branch=
case "$DISTRIB_RELEASE" in
	*"24.10"*)
		branch="openwrt-24.10"
		;;
	"SNAPSHOT")
		branch="SNAPSHOT"
		;;
	*)
		echo "unsupported release: $DISTRIB_RELEASE"
		exit 1
		;;
esac

# feed url
repository_url="https://opkg.ihtw.moe"
feed_url="$repository_url/$branch/$arch/InfinitySubstance"

if [ -x "/bin/opkg" ]; then
	# add key
	echo "add key"
	key_build_pub_file="key-build.pub"
	curl -s -L -o "$key_build_pub_file" "$repository_url/key-build.pub"
	opkg-key add "$key_build_pub_file"
	rm -f "$key_build_pub_file"
	# add feed
	echo "add feed"
	if (grep -q infsubs /etc/opkg/customfeeds.conf); then
		sed -i '/infsubs/d' /etc/opkg/customfeeds.conf
	fi
	echo "src/gz infsubs $feed_url" >> /etc/opkg/customfeeds.conf
	# update feeds
	echo "update feeds"
	opkg update
elif [ -x "/usr/bin/apk" ]; then
	echo "add feed"
	if (grep -q infsubs /etc/apk/repositories.d/customfeeds.list); then
		sed -i '/infsubs/d' /etc/apk/repositories.d/customfeeds.list
	fi
	echo "$feed_url/packages.adb" >> /etc/apk/repositories.d/customfeeds.list
	# update feeds
	echo "update feeds"
	apk update --allow-untrusted
fi

echo "success"