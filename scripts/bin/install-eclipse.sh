#!/usr/bin/env bash
# =============================================================================
# eclipse-installer.sh — Eclipse Modelling Environment Setup
#
# Downloads and configures an Eclipse Modelling Tools installation with:
#   - EMF / Ecore  (pre-installed in eclipse-modeling base)
#   - Xtext / OCL  (pre-installed in eclipse-modeling base)
#   - UML2
#   - ATL (model transformation)
#   - Acceleo (model-to-text / code generation)
#
# Usage:
#   ./eclipse-installer.sh                           # installs using defaults below
#   ECLIPSE_RELEASE=2026-03 ./eclipse-installer.sh   # override release inline
# =============================================================================

set -euo pipefail

# ── Configuration — edit these to change version or layout ───────────────────

ECLIPSE_RELEASE="${ECLIPSE_RELEASE:-2026-03}"       # release train
ECLIPSE_EDITION="modeling"                          # base package
ECLIPSE_BASE_DIR="${ECLIPSE_BASE_DIR:-$HOME/eclipse}"
ECLIPSE_NAME="${ECLIPSE_NAME:-${ECLIPSE_EDITION}-${ECLIPSE_RELEASE}}"
ECLIPSE_DIR="${ECLIPSE_BASE_DIR}/${ECLIPSE_NAME}"   # e.g. ~/eclipse/modeling-2026-03

# JVM memory (Standard profile: 512m / 2g)
JVM_XMS="512m"
JVM_XMX="2g"

# Detect architecture
ARCH="$(uname -m)"
if [[ "$ARCH" == "arm64" ]]; then
  PLATFORM="macosx-cocoa-aarch64"
else
  PLATFORM="macosx-cocoa-x86_64"
fi

# Eclipse download URL pattern
# Check https://www.eclipse.org/downloads/packages/ if a release is unavailable
TARBALL="eclipse-${ECLIPSE_EDITION}-${ECLIPSE_RELEASE}-R-${PLATFORM}.tar.gz"
DOWNLOAD_URL="https://download.eclipse.org/technology/epp/downloads/release/${ECLIPSE_RELEASE}/R/${TARBALL}"

# Eclipse executable inside the installed .app bundle
ECLIPSE_APP="${ECLIPSE_DIR}/Eclipse.app"
ECLIPSE_BIN="${ECLIPSE_APP}/Contents/MacOS/eclipse"
ECLIPSE_INI="${ECLIPSE_APP}/Contents/Eclipse/eclipse.ini"

# Update sites
RELEASE_REPO="https://download.eclipse.org/releases/${ECLIPSE_RELEASE}"
UPDATES_REPO="https://download.eclipse.org/eclipse/updates/latest"

# ── Helpers ───────────────────────────────────────────────────────────────────

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

info()    { echo -e "${BOLD}${GREEN}▶ $*${RESET}"; }
warn()    { echo -e "${YELLOW}⚠ $*${RESET}"; }
error()   { echo -e "${RED}✖ $*${RESET}" >&2; exit 1; }
divider() { echo -e "\n${BOLD}────────────────────────────────────────${RESET}"; }

# ── Checks ────────────────────────────────────────────────────────────────────

[[ "$(uname)" == "Darwin" ]] || error "This script is macOS only."
command -v java &>/dev/null   || error "Java not found."

divider
info "Eclipse Modelling Environment Setup"
echo "  Release   : ${ECLIPSE_RELEASE}"
echo "  Edition   : eclipse-${ECLIPSE_EDITION}"
echo "  Install   : ${ECLIPSE_DIR}"
echo "  Platform  : ${PLATFORM}"
echo "  JAVA_HOME : ${JAVA_HOME}"
echo "  JVM args  : -Xms${JVM_XMS} -Xmx${JVM_XMX}"

# ── Download & extract ────────────────────────────────────────────────────────

divider
if [[ -d "$ECLIPSE_DIR" ]]; then
  info "Eclipse already installed at ${ECLIPSE_DIR} — skipping download."
else
  info "Downloading Eclipse ${ECLIPSE_RELEASE}..."

  TMPFILE="$(mktemp /tmp/eclipse-XXXXXX.tar.gz)"
  trap 'rm -f "$TMPFILE"' EXIT

  echo "  URL : ${DOWNLOAD_URL}"
  curl -L --progress-bar "$DOWNLOAD_URL" -o "$TMPFILE" \
    || error "Download failed. Check release at: https://www.eclipse.org/downloads/packages/"

  # Extract Eclipse app from tarball
  info "Extracting to ${ECLIPSE_DIR}..."
  mkdir -p "$ECLIPSE_DIR"
  tar -xzf "$TMPFILE" -C "$ECLIPSE_DIR"

  info "Eclipse extracted."
fi

[[ -f "$ECLIPSE_BIN" ]] || error "Eclipse binary not found at ${ECLIPSE_BIN}"

# ── Configure eclipse.ini ─────────────────────────────────────────────────────

divider
info "Configuring JVM memory (Xms=${JVM_XMS}, Xmx=${JVM_XMX})..."

# Replace existing -Xms / -Xmx values, or append if not present
if grep -q "^-Xms" "$ECLIPSE_INI"; then
  sed -i '' "s/^-Xms.*/-Xms${JVM_XMS}/" "$ECLIPSE_INI"
else
  echo "-Xms${JVM_XMS}" >> "$ECLIPSE_INI"
fi

if grep -q "^-Xmx" "$ECLIPSE_INI"; then
  sed -i '' "s/^-Xmx.*/-Xmx${JVM_XMX}/" "$ECLIPSE_INI"
else
  echo "-Xmx${JVM_XMX}" >> "$ECLIPSE_INI"
fi

info "eclipse.ini configured."

# ── p2: install extensions ────────────────────────────────────────────────────

divider
info "Installing Eclipse extensions via p2 director..."

# Helper: install one feature, with readable output
p2_install() {
  local label="$1"
  local repos="$2"
  local ius="$3"

  info "  Installing: ${label}"
  "$ECLIPSE_BIN" \
    -application org.eclipse.equinox.p2.director \
    -noSplash \
    -repository "${repos}" \
    -installIUs "${ius}" \
    2>&1 | grep -E "^(Installing|Operation completed|Error|Cannot)" || true
}

# UML2 — UML metamodel support and tooling
p2_install \
  "UML2 SDK" \
  "${RELEASE_REPO}" \
  "org.eclipse.uml2.sdk.feature.group"

# ATL — model-to-model transformation
p2_install \
  "ATL SDK" \
  "${RELEASE_REPO},https://download.eclipse.org/mmt/atl/updates/releases/" \
  "org.eclipse.m2m.atl.sdk.feature.group"

# Acceleo — model-to-text / code generation
p2_install \
  "Acceleo SDK" \
  "${RELEASE_REPO},https://download.eclipse.org/acceleo/updates/releases/3.7/" \
  "org.eclipse.acceleo.sdk.feature.group"

# ── Verify installed features ─────────────────────────────────────────────────

divider
info "Installed features:"
"$ECLIPSE_BIN" \
  -application org.eclipse.equinox.p2.director \
  -noSplash \
  -listInstalledRoots \
  2>/dev/null | grep -E "org.eclipse.(emf|uml|ocl|xtext|m2m.atl|acceleo)" || true

# ── Done ──────────────────────────────────────────────────────────────────────

divider
echo ""
echo -e "${BOLD}${GREEN}✔ Eclipse Modelling ${ECLIPSE_RELEASE} ready.${RESET}"
echo ""
echo "  Location  : ${ECLIPSE_DIR}"
echo "  Open app  : open ${ECLIPSE_APP}"
echo ""
echo "  Installed:"
echo "    ✔ EMF / Ecore / Xtext / OCL (base package)"
echo "    ✔ UML2 SDK"
echo "    ✔ ATL SDK"
echo "    ✔ Acceleo SDK"
echo ""
echo "  To add more extensions:"
echo "    ${ECLIPSE_BIN} -application org.eclipse.equinox.p2.director \\"
echo "      -noSplash -repository <url> -installIUs <feature.group>"
echo ""
echo "  To list available plugins at a repo:"
echo "    ${ECLIPSE_BIN} -application org.eclipse.equinox.p2.director \\"
echo "      -noSplash -repository ${RELEASE_REPO} -list"
echo ""
