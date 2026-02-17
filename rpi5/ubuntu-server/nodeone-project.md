# 1. Hardware
## NodeOne
- Raspberry Pi 5
- Raspberry Pi NVME HAT+
- Raspberry Pi NVME 2230
- Raspberry Pi 5 Cooling Fan
- Power Supply 5V 27W
- Connection through Ethernet

# 2. OS
## NodeOne
+ Ubuntu Server

# 3. Services
## Ubuntu Server
+ Docker
+ AdGuard
+ Tailscale
+ Watchtower
+ Vaultwarden

Typ ataku,Skuteczność przeciwko Twojemu setupowi,Dlaczego?
Sniffing na Wi-Fi,🛑 Zablokowane,Ruch leci w tunelu WireGuard.
DNS Spoofing,🛑 Zablokowane,MagicDNS weryfikuje tożsamość węzłów.
SSL Stripping,🛑 Zablokowane,Wymuszasz HTTPS + HSTS (przeglądarka nie pozwoli na HTTP).
Skanowanie Portów,🛑 Zablokowane,Brak publicznego IP / otwartych portów na WAN.
