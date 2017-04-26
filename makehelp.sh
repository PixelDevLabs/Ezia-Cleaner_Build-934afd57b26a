#!/bin/bash
# POSTAL Make Helper
# Copyright 2017 Declan Hoare
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as published by
# the Free Software Foundation
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#
# Helper script for make to find NFD.

# Find the directory for NFD's Makefile on this target.
nfdSrcDir()
{
	echo "NFD/build/gmake_${1%%_*}"
}

# Format the target for NFD.
nfdTarget()
{
	MODE="release"
	for argument in "$@"
	do
		if [ "$argument" = "debug" ]
		then
			MODE="debug"
		fi
	done
	ARCHITECTURE="${1#*_}"
	if [ "$ARCHITECTURE" = "x86_64" ]
	then
		ARCHITECTURE="x64"
	fi
	echo "${MODE}_${ARCHITECTURE}"
}

# Find the NFD library location on this target.
nfdFileName()
{
	TARGET=$(nfdTarget $*)
	MODE="${TARGET%_*}"
	MODE="$(printf '%b' '\'$(( $(printf '%o' "'${MODE:0:1}") - 40 )))${MODE:1}"
	if [ "$MODE" = "Debug" ]
	then
		FILENAME="libnfd_d.a"
	else
		FILENAME="libnfd.a"
	fi
	ARCHITECTURE="${TARGET#*_}"
	echo "NFD/build/lib/${MODE}/${ARCHITECTURE}/${FILENAME}"
}

eval "$*"
