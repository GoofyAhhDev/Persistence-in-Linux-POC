#!/bin/bash

# === CONFIG ===
ATTACKER_KEY_ID="SSH key from persistance.sh"
CRON_IDENTIFIER="bash -i >& /dev/tcp"
SYSTEMD_SERVICE="/etc/systemd/system/update-check.service"
HIDDEN_PAYLOAD="/dev/shm/.cachelog"

echo "[*] Reverting root-level persistence..."

# === 1. Remove SSH key ===
echo "[+] Cleaning up SSH key..."
if [ -f /root/.ssh/authorized_keys ]; then
    ESCAPED_KEY=$(echo "$ATTACKER_KEY_ID" | sed 's/[&/\]/\\&/g') 
    sed -i "/$ESCAPED_KEY/d" /root/.ssh/authorized_keys

    [ ! -s /root/.ssh/authorized_keys ] && rm -f /root/.ssh/authorized_keys
fi

# === 2. Remove cronjob ===
echo "[+] Cleaning up /etc/crontab..."
if [ -f /etc/crontab ]; then
    ESCAPED_CRON_IDENTIFIER=$(echo "$CRON_IDENTIFIER" | sed 's/[&/\]/\\&/g')
    sed -i "/$ESCAPED_CRON_IDENTIFIER/d" /etc/crontab
fi

# === 3. Remove systemd backdoor ===
echo "[+] Removing systemd backdoor service..."
if [ -f "$SYSTEMD_SERVICE" ]; then
    systemctl disable update-check.service
    systemctl stop update-check.service
    rm -f "$SYSTEMD_SERVICE"
    systemctl daemon-reload
fi

# === 4. Remove .bashrc reverse shell ===
echo "[+] Cleaning up /root/.bashrc..."
if [ -f /root/.bashrc ]; then
    ESCAPED_CRON_IDENTIFIER=$(echo "$CRON_IDENTIFIER" | sed 's/[&/\]/\\&/g')
    ESCAPED_CRON_IDENTIFIER=$(echo "$ESCAPED_CRON_IDENTIFIER" | sed 's/[.^$*]/\\&/g')
    sed -i "/$ESCAPED_CRON_IDENTIFIER/d" /root/.bashrc
fi