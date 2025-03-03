#!/bin/bash

function tcp_parser() {
  awk $([[ $(awk --version) = GNU* ]] && echo --non-decimal-data) '
    function hex2addr(hex) {
      split(hex, data, ":");
      l = length(data[1]);
      dec_ip = sprintf("%d", "0x" substr(data[1], l - 1, 2));
      for(i = 1; i < 4; i++){
        dec_ip = sprintf("%s.%d", dec_ip, "0x" substr(data[1], l - (i * 2 + 1), 2))
      };
      return sprintf("%s:%d", dec_ip, "0x" data[2]);
    }
    {
      if ($1 == "sl") {
        printf "%-5s | %-25s | %-25s | %-15s\n", "#", "Source", "Destination", "Status";
        printf "%-5s-+-%-25s-+-%-25s-+-%-15s\n", "-----", "-------------------------", "-------------------------", "---------------";
      } else {
        split($1, conn, ":");
        src = hex2addr($2);
        dst = hex2addr($3);
        status_str = "TCP_ESTABLISHED,TCP_SYN_SENT,TCP_SYN_RECV,TCP_FIN_WAIT1,TCP_FIN_WAIT2,TCP_TIME_WAIT,TCP_CLOSE,TCP_CLOSE_WAIT,TCP_LAST_ACK,TCP_LISTEN,TCP_CLOSING,TCP_NEW_SYN_RECV,TCP_MAX_STATES";
        split(status_str, status, ",");
        status_index = sprintf("%d", "0x" $4)
        printf "%-5s | %-25s | %-25s | %-15s\n", conn[1], src, dst, status[status_index];
      }
    }' "$1"
}

for file in /proc/net/tcp /proc/net/tcp6 /proc/net/udp /proc/net/udp6; do
  protocol=$(basename "$file" | tr '[:lower:]' '[:upper:]')
  echo -e "\n[${protocol}]"
  echo -e "-------------------------------------------------------------------------------"
  tcp_parser "$file"
done