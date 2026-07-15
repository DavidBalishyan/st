#!/bin/sh
# Install the build dependencies for st.
#
# Covers a C compiler, make, pkg-config, the X11/Xft/fontconfig/freetype/
# harfbuzz development headers, and tic (ncurses) for the terminfo entry.
# Detects the package manager; run it once before `make`.

set -eu

# Pick sudo only when we are not already root and it exists.
SUDO=''
if [ "$(id -u)" -ne 0 ]; then
	if command -v sudo >/dev/null 2>&1; then
		SUDO='sudo'
	else
		echo "warning: not root and sudo not found; run this as root" >&2
	fi
fi

run() {
	echo "+ $SUDO $*"
	$SUDO "$@"
}

if command -v apt-get >/dev/null 2>&1; then
	# Debian, Ubuntu, and derivatives
	run apt-get update
	run apt-get install -y \
		build-essential pkg-config \
		libx11-dev libxft-dev libfontconfig1-dev libfreetype6-dev \
		libharfbuzz-dev ncurses-bin
elif command -v dnf >/dev/null 2>&1; then
	# Fedora, RHEL, and derivatives
	run dnf install -y \
		gcc make pkgconf-pkg-config \
		libX11-devel libXft-devel fontconfig-devel freetype-devel \
		harfbuzz-devel ncurses
elif command -v pacman >/dev/null 2>&1; then
	# Arch and derivatives (dev headers ship with the base packages)
	run pacman -S --needed --noconfirm \
		base-devel pkgconf \
		libx11 libxft fontconfig freetype2 harfbuzz ncurses
elif command -v zypper >/dev/null 2>&1; then
	# openSUSE
	run zypper install -y \
		gcc make pkg-config \
		libX11-devel libXft-devel fontconfig-devel freetype2-devel \
		harfbuzz-devel ncurses-utils
else
	echo "error: no supported package manager found" >&2
	echo "install these manually: C compiler, make, pkg-config, and the" >&2
	echo "dev headers for X11, Xft, fontconfig, freetype2, harfbuzz, plus tic." >&2
	exit 1
fi

echo
echo "Build dependencies installed. Now run: make"
echo "For the terminal font, install JetBrainsMono Nerd Font (see README)."
