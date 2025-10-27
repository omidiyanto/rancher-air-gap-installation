#!/bin/bash
list="rancher-images.txt"
source_registry=""
target_registry=""

# === Spinner Function ===
spinner_run() {
  local pid="$1"
  local msg="$2"
  local spinner=(⠋ ⠙ ⠸ ⠴ ⠦ ⠇)
  local i=0

  while kill -0 "$pid" 2>/dev/null; do
    printf "\r%s %s" "${spinner[$i]}" "$msg"
    sleep 0.1
    i=$(( (i + 1) % ${#spinner[@]} ))
  done

  wait "$pid"
  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    echo -e "\r✅ $msg"
  else
    echo -e "\r❌ $msg (exit code $exit_code)"
  fi
}

usage () {
    echo "USAGE: $0 [--image-list rancher-images.txt] [-s|--source-registry registry:port] [-r|--registry target-registry]"
    echo ""
    echo "  -l, --image-list       Path ke file daftar image (default: rancher-images.txt)"
    echo "  -s, --source-registry  Registry sumber untuk pull image (misal: docker.io atau registry.remote.local)"
    echo "  -r, --registry         Registry tujuan untuk push image (misal: registry.omidiyanto.local)"
    echo "  -h, --help             Tampilkan bantuan"
}

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -l|--image-list)
        list="$2"
        shift; shift
        ;;
        -s|--source-registry)
        source_registry="$2"
        shift; shift
        ;;
        -r|--registry)
        target_registry="$2"
        shift; shift
        ;;
        -h|--help)
        usage
        exit 0
        ;;
        *)
        usage
        exit 1
        ;;
    esac
done

if [[ -z "$target_registry" ]]; then
    echo "❌ Error: registry tujuan (--registry) wajib diisi."
    usage
    exit 1
fi

source_registry="${source_registry%/}"
target_registry="${target_registry%/}"

echo "📋 Menggunakan daftar image dari: ${list}"
echo "📦 Source registry: ${source_registry:-<default>}"
echo "🎯 Target registry: ${target_registry}"
echo

while IFS= read -r image; do
    [ -z "$image" ] && continue

    src_image="${image}"
    [[ -n "$source_registry" ]] && src_image="${source_registry}/${image}"
    dest_image="${target_registry}/${image}"

    echo "────────────────────────────────────────────"
    echo "▶️  Processing: ${image}"
    echo "   Source: ${src_image}"
    echo "   Target: ${dest_image}"

    # 1. Pull dari source registry (dengan spinner)
    (
      docker pull "${src_image}" > /dev/null 2>&1
    ) &
    spinner_run $! "Pulling ${src_image}"

    if ! docker inspect "${src_image}" > /dev/null 2>&1; then
        echo "❌ Gagal pull ${src_image}, skip..."
        continue
    fi

    # 2. Tag ke target registry
    docker tag "${src_image}" "${dest_image}"
    echo "🏷️  Tagged: ${dest_image}"

    # 3. Push ke target registry (dengan spinner)
    (
      docker push "${dest_image}" > /dev/null 2>&1
    ) &
    spinner_run $! "Pushing ${dest_image}"

    # 4. Hapus image lokal (original + tagged)
    docker rmi -f "${src_image}" "${dest_image}" > /dev/null 2>&1
    echo "🧹 Removed local images"
    echo
done < "${list}"

echo "🎉 Selesai memproses semua image dari ${list}"
