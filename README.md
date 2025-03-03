# Network Connection Parser Script

This Bash script parses active TCP and UDP connections on Linux by reading `/proc/net/` files. It converts hex-encoded IP addresses and ports into human-readable format and shows connection statuses.  

## Requirements  
- **Bash**  
- **GNU awk**  

## Usage  
This script is useful for pentesting when standard network tools like `ss`, `netstat`, or `lsof` are unavailable. It provides a quick view of active sockets without external utilities.  

To run:  
```bash
bash network_parser.sh
```
