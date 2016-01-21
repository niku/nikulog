# パスワード確認なしに sudo を実行する
sudo sh -c "cat << EOS > /etc/sudoers.d/nopasswd
${USER} ALL=(ALL) NOPASSWD:ALL
EOS
" && \
sudo chmod 0440 /etc/sudoers.d/nopasswd
# ssh ポートをデフォルトから変更する
sudo sed -i -e "s/^Port .*$/Port 2929/" /etc/ssh/sshd_config
# root アカウントでの ssh ログイン禁止
sudo sed -i -e "s/^PermitRootLogin .*$/PermitRootLogin no/" /etc/ssh/sshd_config
# パスワード認証での  ssh ログイン禁止
sudo sed -i -e "s/^PasswordAuthentication .*$/PasswordAuthentication no/" /etc/ssh/sshd_config
sudo sed -i -e "s/^ChallengeResponseAuthentication .*$/ChallengeResponseAuthentication no/" /etc/ssh/sshd_config
# IPv6 無効化
sudo sh -c "cat << EOS > /etc/sysctl.d/disable_ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.eth0.disable_ipv6 = 1
EOS"
# Exim4 設定ファイル内にある IPv6 設定無効化
sudo sed -i -e "s/^dc_local_interfaces=.*$/dc_local_interfaces='127.0.0.1'/" /etc/exim4/update-exim4.conf.conf
sudo update-exim4.conf
sudo service exim4 restart
# IP spoofing 対策
sudo sh -c "cat << EOS > /etc/sysctl.d/enable_ip_spooof_protection.conf
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter=1
EOS"
# firewall 設定
sudo apt-get update -q && \
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install iptables-persistent && \
sudo sh -c "cat << EOS > /etc/iptables/rules.v4
*filter

# Allows all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
-A INPUT -i lo -j ACCEPT
-A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

# Accepts all established inbound connections
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allows all outbound traffic
# You could modify this to only allow certain traffic
-A OUTPUT -j ACCEPT

# Allows HTTP and HTTPS connections from anywhere (the normal ports for websites)
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT

# Allows HTTP connections (original ports)
-A INPUT -p tcp --dport 4000 -j ACCEPT

# Allows SSH connections
# The --dport number is the same as in /etc/ssh/sshd_config
-A INPUT -p tcp -m state --state NEW --dport 2929 -j ACCEPT

# Now you should read up on iptables rules and consider whether ssh access
# for everyone is really desired. Most likely you will only allow access from certain IPs.

# Allow ping
#  note that blocking other types of icmp packets is considered a bad idea by some
#  remove -m icmp --icmp-type 8 from this line to allow all kinds of icmp:
#  https://security.stackexchange.com/questions/22711
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

# log iptables denied calls (access via 'dmesg' command)
-A INPUT -m limit --limit 5/min -j LOG --log-prefix \"iptables denied: \" --log-level 7

# Reject all other inbound - default deny unless explicitly allowed policy:
-A INPUT -j REJECT
-A FORWARD -j REJECT

COMMIT
EOS"
# パッケージ自動更新
sudo sudo apt-get update -q && \
sudo apt-get install -y -qq cron-apt && \
sudo sh -c "cat << EOS > /etc/cron-apt/action.d/5-upgrade
upgrade -y -o APT::Get::Show-Upgraded=true
EOS"
# Docker のインストール
sudo sh -c "cat << EOS > /etc/apt/sources.list.d/jessie-backports.list
deb http://ftp.jp.debian.org/debian jessie-backports main
EOS" && \
sudo sudo apt-get update -q && \
sudo apt-get install -y -qq docker.io
