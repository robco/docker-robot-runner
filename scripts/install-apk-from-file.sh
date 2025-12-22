#!/bin/sh
# MIT License
#
# Copyright (c) 2025 Róbert Malovec
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#!/bin/sh
set -eu

enable_community_repo() {
  REPO_FILE="/etc/apk/repositories"

  # Already enabled?
  if grep -Eq '^[[:space:]]*[^#].*/community([[:space:]]|$)' "${REPO_FILE}"; then
    return 0
  fi

  # Present but commented out -> uncomment
  if grep -Eq '^[[:space:]]*#.*\/community([[:space:]]|$)' "${REPO_FILE}"; then
    sed -i -E 's/^[[:space:]]*#([[:space:]]*.*\/community([[:space:]]|$))/\1/' "${REPO_FILE}"
    return 0
  fi

  # Missing -> derive from first enabled main repo line
  MAIN_LINE="$(grep -E '^[[:space:]]*[^#].*/main([[:space:]]|$)' "${REPO_FILE}" | head -n1 || true)"
  if [ -n "${MAIN_LINE}" ]; then
    echo "${MAIN_LINE%/main}/community" >> "${REPO_FILE}"
    return 0
  fi

  # Last resort: add official CDN main+community based on installed Alpine major.minor
  VER="$(cut -d. -f1-2 /etc/alpine-release)"
  echo "https://dl-cdn.alpinelinux.org/alpine/v${VER}/main" >> "${REPO_FILE}"
  echo "https://dl-cdn.alpinelinux.org/alpine/v${VER}/community" >> "${REPO_FILE}"
}

APK_FILE="${1:-}"
if [ -z "${APK_FILE}" ]; then
  echo "Usage: install-apk-from-file.sh <path-to-apk.in>" >&2
  exit 2
fi

# Treat missing file as "nothing to install".
if [ ! -f "${APK_FILE}" ]; then
  exit 0
fi

enable_community_repo

APK_PKGS="$(grep -vE '^[[:space:]]*(#|$)' "${APK_FILE}" | xargs || true)"
if [ -n "${APK_PKGS}" ]; then
  apk add --no-cache ${APK_PKGS}
fi
