#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2154,SC2086
# =============================================================================
#  ai_modelsetting.sh  -  modul "absolute-ai" untuk Equinox Terminal V2
#
#  Berkas ini di-source OTOMATIS oleh Equinox-Core-System.bash (lihat fungsi
#  eqx_load_companion_modules) jika ada di folder yang sama dengan inti
#  Equinox. Kalau berkas ini tidak ada, fitur absolute-ai cuma melapor
#  "modul belum ditemukan" - sisanya tetap berjalan normal.
#
#  APA INI, DAN APA BUKAN:
#    - Ini BUKAN AI bawaan. Equinox tidak menyertakan model AI apa pun.
#    - Ini wadah ringan untuk mengobrol lewat API Anda SENDIRI (OpenAI,
#      Anthropic, atau server yang kompatibel dengan salah satu format itu),
#      dibungkus 4 alias yang bisa Anda pakai lewat `xxq absolute-ai-<alias>`.
#    - Equinox TIDAK PERNAH menyimpan API key Anda. Key dibaca dari variabel
#      lingkungan yang NAMANYA Anda tentukan sendiri saat konfigurasi.
#    - `xxq absolute-ai-information` selalu jujur menampilkan provider,
#      endpoint, dan model asli di balik tiap alias - tidak ada penyamaran.
# =============================================================================

if [[ -n "${EQX_AAI_LOADED:-}" ]]; then return 0 2>/dev/null || exit 0; fi
EQX_AAI_LOADED=1

declare -gA EQX_AAI_LABEL=( [mno]="Mono V1" [mvx]="Mono VX" [chb]="Chatbox 5" [qdx]="Qodex" )
EQX_AAI_ORDER=(mno mvx chb qdx)

eqx_aai_installed() { [[ -f "$EQX_HOME/.absolute-ai" ]]; }
eqx_aai_file()      { printf '%s' "$EQX_HOME/ai-models.tsv"; }

# Baca satu baris konfigurasi alias -> set AAI_LABEL AAI_PROVIDER AAI_ENDPOINT
# AAI_MODEL AAI_ENVVAR. Return 1 jika alias tidak dikenal.
eqx_aai_read_row() { # alias
  local alias="$1" f line
  f="$(eqx_aai_file)"
  [[ -f "$f" ]] || return 1
  line="$(awk -F'\t' -v a="$alias" '$1==a{print; exit}' "$f")"
  [[ -n "$line" ]] || return 1
  IFS=$'\t' read -r _ AAI_LABEL AAI_PROVIDER AAI_ENDPOINT AAI_MODEL AAI_ENVVAR <<<"$line"
  return 0
}

eqx_aai_write_row() { # alias label provider endpoint model envvar
  local f tmp
  f="$(eqx_aai_file)"; tmp="$f.tmp.$$"
  awk -F'\t' -v a="$1" 'BEGIN{OFS="\t"} $1!=a' "$f" >"$tmp" 2>/dev/null
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" "$5" "$6" >>"$tmp"
  mv -f "$tmp" "$f"
}

eqx_aai_json_escape() { # teks -> string JSON berkutip aman
  if eqx_have jq; then
    jq -Rs . <<<"$1"
  else
    local s="$1"
    s="${s//\\/\\\\}"; s="${s//\"/\\\"}"; s="${s//$'\n'/\\n}"; s="${s//$'\t'/\\t}"
    printf '"%s"' "$s"
  fi
}

eqx_install_absolute_ai() {
  eqx_title "Pemasangan absolute-ai"
  if eqx_aai_installed; then
    eqx_ok "absolute-ai sudah terpasang."
  else
    mkdir -p "$EQX_HOME"
    local f a
    f="$(eqx_aai_file)"; : >"$f"
    for a in "${EQX_AAI_ORDER[@]}"; do
      printf '%s\t%s\t\t\t\t\n' "$a" "${EQX_AAI_LABEL[$a]}" >>"$f"
    done
    : >"$EQX_HOME/.absolute-ai"
    aai_register_xxq
    eqx_ok "absolute-ai terpasang. 4 slot siap dikonfigurasi: ${EQX_AAI_ORDER[*]}"
  fi
  cat <<'EOF'

  absolute-ai TIDAK menyertakan AI bawaan apa pun - ini wadah ringan untuk
  mengobrol lewat API Anda SENDIRI (OpenAI, Anthropic, atau server yang
  kompatibel), dengan 4 alias yang bisa dipakai:

    mno = Mono V1       mvx = Mono VX
    chb = Chatbox 5      qdx = Qodex

  1) Atur salah satu slot, contoh untuk OpenAI:
     xxq absolute-ai-config mno openai https://api.openai.com/v1/chat/completions gpt-4o-mini MNO_API_KEY

     atau untuk Anthropic:
     xxq absolute-ai-config mvx anthropic https://api.anthropic.com/v1/messages claude-3-5-haiku-20241022 MVX_API_KEY

  2) Simpan API key Anda SENDIRI sebagai variabel lingkungan (Equinox tidak
     pernah menyimpannya untuk Anda):
     export MNO_API_KEY="sk-xxxxxxxx"      # taruh baris ini di ~/.bashrc agar permanen

  3) Mulai ngobrol:
     xxq absolute-ai-mno Prompt=halo, apa kabar?

  Lihat status & konfigurasi semua slot: xxq absolute-ai-information
EOF
}

aai_register_xxq() {
  xxq_reg absolute-ai-mno         "Chat dengan slot \"Mono V1\" (API milik Anda sendiri)" "xxq absolute-ai-mno Prompt=<teks>"
  xxq_reg absolute-ai-mvx         "Chat dengan slot \"Mono VX\" (API milik Anda sendiri)" "xxq absolute-ai-mvx Prompt=<teks>"
  xxq_reg absolute-ai-chb         "Chat dengan slot \"Chatbox 5\" (API milik Anda sendiri)" "xxq absolute-ai-chb Prompt=<teks>"
  xxq_reg absolute-ai-qdx         "Chat dengan slot \"Qodex\" (API milik Anda sendiri)" "xxq absolute-ai-qdx Prompt=<teks>"
  xxq_reg absolute-ai-information "Lihat konfigurasi & status semua slot absolute-ai (jujur, tanpa penyamaran)" "xxq absolute-ai-information"
  xxq_reg absolute-ai-config      "Atur provider/endpoint/model/env-key satu slot" \
    "xxq absolute-ai-config <alias> <openai|anthropic> <endpoint> <model> <ENV_VAR>"
}

xxq_mod_absolute_ai_config() { # alias provider endpoint model envvar
  eqx_aai_installed || { eqx_err "modul absolute-ai belum terpasang. Jalankan: eqx install absolute-ai"; return 1; }
  local alias="${1:-}" provider="${2:-}" endpoint="${3:-}" model="${4:-}" envvar="${5:-}"
  [[ -n "${EQX_AAI_LABEL[$alias]:-}" ]] || { eqx_err "alias tidak dikenal: $alias (pilihan: ${EQX_AAI_ORDER[*]})"; return 1; }
  [[ "$provider" =~ ^(openai|anthropic)$ ]] || { eqx_err "provider: openai | anthropic"; return 1; }
  [[ "$endpoint" =~ ^https:// ]] || { eqx_err "endpoint harus URL https://..."; return 1; }
  [[ -n "$model" ]] || { eqx_err "nama model wajib diisi"; return 1; }
  [[ "$envvar" =~ ^[A-Z_][A-Z0-9_]*$ ]] || { eqx_err "nama variabel env tidak valid (huruf besar/underscore, mis. MNO_API_KEY)"; return 1; }
  eqx_aai_write_row "$alias" "${EQX_AAI_LABEL[$alias]}" "$provider" "$endpoint" "$model" "$envvar"
  eqx_ok "'$alias' (${EQX_AAI_LABEL[$alias]}) dikonfigurasi -> $provider $endpoint ($model)"
  eqx_dim "  Pastikan env var $envvar berisi API key Anda, mis: export $envvar=\"sk-...\"  di ~/.bashrc"
}

xxq_mod_absolute_ai_information() {
  eqx_aai_installed || { eqx_err "modul absolute-ai belum terpasang. Jalankan: eqx install absolute-ai"; return 1; }
  eqx_title "absolute-ai - informasi model"
  local a
  for a in "${EQX_AAI_ORDER[@]}"; do
    if eqx_aai_read_row "$a"; then
      printf '\n  %s%s%s  (%sxxq absolute-ai-%s%s)\n' "$C_B$C_P" "$AAI_LABEL" "$C_R" "$C_D" "$a" "$C_R"
      if [[ -n "$AAI_ENDPOINT" ]]; then
        eqx_kv "provider" "$AAI_PROVIDER" 13
        eqx_kv "endpoint" "$AAI_ENDPOINT" 13
        eqx_kv "model" "$AAI_MODEL" 13
        eqx_kv "api key dari" "\$$AAI_ENVVAR ($( [[ -n "${!AAI_ENVVAR:-}" ]] && echo "terset" || echo "BELUM diset" ))" 13
      else
        eqx_dim "  belum dikonfigurasi - atur: xxq absolute-ai-config $a <openai|anthropic> <endpoint> <model> <ENV_VAR>"
      fi
    fi
  done
  printf '\n'
  eqx_dim "  Equinox tidak pernah menyimpan API key; semua kunci dibaca dari variabel lingkungan Anda sendiri."
}

eqx_aai_chat() { # alias prompt...
  local alias="$1"; shift
  eqx_aai_installed || { eqx_err "modul absolute-ai belum terpasang. Jalankan: eqx install absolute-ai"; return 1; }
  local prompt="$*"
  prompt="${prompt#Prompt=}"; prompt="${prompt#prompt=}"
  [[ -n "$prompt" ]] || { eqx_err "pakai: xxq absolute-ai-$alias <prompt>   (atau: Prompt=<teks>)"; return 1; }
  eqx_aai_read_row "$alias" || { eqx_err "alias tidak dikenal: $alias"; return 1; }
  if [[ -z "$AAI_ENDPOINT" ]]; then
    eqx_warn "'$alias' ($AAI_LABEL) belum dikonfigurasi."
    eqx_dim "  Atur dulu: xxq absolute-ai-config $alias <openai|anthropic> <endpoint-url> <model> <NAMA_ENV_API_KEY>"
    return 1
  fi
  local key="${!AAI_ENVVAR:-}"
  if [[ -z "$key" ]]; then
    eqx_err "variabel lingkungan $AAI_ENVVAR kosong/tidak diset."
    eqx_dim "  Equinox tidak pernah menyimpan API key Anda - set sendiri: export $AAI_ENVVAR=\"...\""
    return 1
  fi
  eqx_need curl || return 1
  eqx_info "($AAI_LABEL via $AAI_PROVIDER: $AAI_MODEL) mengirim prompt..."
  local body resp
  body="$(eqx_aai_json_escape "$prompt")"
  case "$AAI_PROVIDER" in
    openai)
      resp="$(curl -fsS --max-time 30 "$AAI_ENDPOINT" \
        -H "Authorization: Bearer $key" -H "Content-Type: application/json" \
        -d "{\"model\":\"$AAI_MODEL\",\"messages\":[{\"role\":\"user\",\"content\":$body}]}" 2>/dev/null)" \
        || { eqx_err "gagal menghubungi $AAI_ENDPOINT"; return 1; }
      if eqx_have jq; then
        jq -r '.choices[0].message.content // .error.message // "(tidak ada respons)"' <<<"$resp"
      else
        printf '%s' "$resp" | grep -o '"content":"[^"]*"' | head -n1 | sed -e 's/^"content":"//' -e 's/"$//' -e 's/\\n/\n/g'
      fi ;;
    anthropic)
      resp="$(curl -fsS --max-time 30 "$AAI_ENDPOINT" \
        -H "x-api-key: $key" -H "anthropic-version: 2023-06-01" -H "Content-Type: application/json" \
        -d "{\"model\":\"$AAI_MODEL\",\"max_tokens\":1024,\"messages\":[{\"role\":\"user\",\"content\":$body}]}" 2>/dev/null)" \
        || { eqx_err "gagal menghubungi $AAI_ENDPOINT"; return 1; }
      if eqx_have jq; then
        jq -r '.content[0].text // .error.message // "(tidak ada respons)"' <<<"$resp"
      else
        printf '%s' "$resp" | grep -o '"text":"[^"]*"' | head -n1 | sed -e 's/^"text":"//' -e 's/"$//' -e 's/\\n/\n/g'
      fi ;;
  esac
}

xxq_mod_absolute_ai_mno() { eqx_aai_chat mno "$@"; }
xxq_mod_absolute_ai_mvx() { eqx_aai_chat mvx "$@"; }
xxq_mod_absolute_ai_chb() { eqx_aai_chat chb "$@"; }
xxq_mod_absolute_ai_qdx() { eqx_aai_chat qdx "$@"; }
