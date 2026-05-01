

# ====== Project: Daily Linux (macOS) System Report ======
# 📄 Description: This script collects basic system info, compresses it into a report, and stores it for review.

# === Step 1: Setup Variables ===
LOG_DIR="$HOME/linux_reports"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="system_report_$DATE.txt"
ARCHIVE_FILE="system_report_$DATE.tar.gz"

# === Step 2: Create Report Directory if it doesn't exist ===
mkdir -p "$LOG_DIR"

# === Step 3: Generate the System Report ===
{
  echo "===================================="
  echo "🖥️  System Report - $DATE"
  echo "===================================="
  echo "👤 User        : $(whoami)"
  echo "💻 Hostname    : $(hostname)"
  echo "🧠 OS Info     : $(uname -a)"
  echo "⏱️ Uptime      : $(uptime)"
  
  # Fix for macOS memory (Pages free * 4096 bytes → MB)
  FREE_PAGES=$(vm_stat | awk '/Pages free/ {gsub(/\./, "", $3); print $3}')
  FREE_MB=$((FREE_PAGES * 4096 / 1024 / 1024))
  echo "🧮 Memory Free : ${FREE_MB} MB"

  echo "💽 Disk Space  : $(df -h / | awk 'NR==2 {print $4 " free of " $2}')"
  
  echo "🔥 Top 5 Processes by Memory:"
  ps aux | sort -nk 4 | tail -n 5

  echo "⚙️ Top 5 Processes by CPU:"
  ps aux | sort -nk 3 | tail -n 5

  echo "🕘 Recent Terminal Commands:"
  tail -n 10 ~/.zsh_history

  echo "===================================="
} > "$LOG_DIR/$REPORT_FILE"

# === Step 4: Compress the Report File ===
tar -czf "$LOG_DIR/$ARCHIVE_FILE" -C "$LOG_DIR" "$REPORT_FILE"

# === Step 5: Delete the original (uncompressed) report ===
rm "$LOG_DIR/$REPORT_FILE"

# === Done ===
echo "✅ Report generated and archived at: $LOG_DIR/$ARCHIVE_FILE"






