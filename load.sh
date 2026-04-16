# Python tools for BuildBox - load script
# Copyright (C) 2023-2026 Trusted Objects

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# version 2, as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see
# <https://www.gnu.org/licenses/>.

OPTS=

# Are system site packages allowed?
if [ -n "${BB_TARGET_VAR_PYVENV_ALLOW_SYS_SITE_PKG}" ] && [ ${BB_TARGET_VAR_PYVENV_ALLOW_SYS_SITE_PKG} -eq 1 ] ; then
	ALLOW_SYS_PKG=1
	OPTS=--system-site-packages ${OPTS}
else
	ALLOW_SYS_PKG=0
fi

# Is it required to create virtual env?
if [[ ! -f "${BB_TARGET_BUILD_DIR}/pyvenv.cfg" ]] || \
	( [[ "${ALLOW_SYS_PKG}" -eq 1 ]] && [[ ! -f "${BB_TARGET_BUILD_DIR}/pyvenv_allow_sys_site_pkg" ]] ) || \
	( [[ "${ALLOW_SYS_PKG}" -eq 0 ]] && [[ -f "${BB_TARGET_BUILD_DIR}/pyvenv_allow_sys_site_pkg" ]] ); then
	python3 -m venv ${OPTS} ${BB_TARGET_BUILD_DIR}
	if [ ${ALLOW_SYS_PKG} -eq 1 ]; then
		touch ${BB_TARGET_BUILD_DIR}/pyvenv_allow_sys_site_pkg
	else
		rm -f ${BB_TARGET_BUILD_DIR}/pyvenv_allow_sys_site_pkg
	fi
fi

# VIRTUAL_ENV set to target build dir
export VIRTUAL_ENV=${BB_TARGET_BUILD_DIR}
