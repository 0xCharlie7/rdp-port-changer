# RDP Port Changer for Windows

A simple and efficient tool to change the Remote Desktop Protocol (RDP) port on Windows systems with automatic administrator elevation and firewall configuration.

## 📋 Features

- ✅ **Automatic Administrator Elevation** - No need to manually run as admin
- ✅ **Current Port Display** - Shows your current RDP port before making changes
- ✅ **Input Validation** - Ensures only valid port numbers (1-65535) are entered
- ✅ **Automatic Firewall Configuration** - Creates firewall rules for the new port
- ✅ **Restart Option** - Option to restart immediately or later
- ✅ **User-Friendly Interface** - Color-coded messages and clear instructions
- ✅ **No External Dependencies** - Uses only built-in Windows tools

## 🚀 Quick Start

1. Download `rdpPortChanger.bat`
2. Double-click the file
3. Accept the UAC prompt for administrator privileges
4. Enter your desired port number
5. Choose whether to restart now or later

## 📦 Requirements

- Windows 10/11 or Windows Server 2016+
- Administrator privileges (automatically requested)
- PowerShell (pre-installed on modern Windows)

## 🔧 How It Works

1. **Elevation Check**: Automatically requests administrator privileges if not already running as admin
2. **Registry Modification**: Updates the RDP port in the Windows Registry at:
```
   HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp
```
3. **Firewall Configuration**: Creates an inbound rule for the new port
4. **Restart Prompt**: Offers to restart the computer to apply changes

## 💡 Usage Example
```
========================================
  Change RDP Port on Windows
========================================

Current RDP port: 3389

Enter the new RDP port (e.g.: 3389, 3390, etc): 3390

Changing RDP port to: 3390...
Configuring firewall rule for port 3390...

========================================
  Port changed to 3390
========================================

IMPORTANT: You need to restart the computer
for the changes to take effect.

Firewall rule created automatically.

Do you want to restart the computer now? (Y/N):
```

## ⚠️ Important Notes

### After Changing the Port

When connecting to your computer via RDP after changing the port, you must specify the new port:
```
hostname:port
```

**Examples:**
- `192.168.1.100:3390`
- `mycomputer.domain.com:3390`
- `DESKTOP-ABC123:3390`

### Router/Firewall Configuration

If you're connecting from outside your local network, remember to:
- Forward the new port on your router
- Update any external firewall rules
- Inform users about the port change

### Security Considerations

- **Don't use common ports**: Avoid well-known ports to reduce automated attacks
- **Recommended ports**: 49152-65535 (Dynamic/Private port range)
- **Document your choice**: Keep a record of your custom port
- **Use strong passwords**: A custom port is not a replacement for strong authentication

## 🛠️ Troubleshooting

### Script Won't Run
If you get an execution policy error, open PowerShell as Administrator and run:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Can't Connect After Port Change
1. Verify the port was changed: Check Registry Editor at the path mentioned above
2. Ensure you restarted the computer
3. Check firewall rules in Windows Firewall settings
4. Use the format `hostname:port` when connecting

### Revert to Default Port
Run the script again and enter `3389` (Windows default RDP port)

## 📝 Technical Details

**Registry Key Modified:**
```
HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp
Value: PortNumber
Type: DWORD
```

**Firewall Rule Created:**
- Display Name: `RDP Port [port_number]`
- Direction: Inbound
- Protocol: TCP
- Action: Allow

## 🤝 Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## 📄 License

This project is free to use and modify. No warranty provided.

## ⚡ Version History

- **v1.0** - Initial release
  - Basic port changing functionality
  - Automatic admin elevation
  - Firewall configuration
  - Restart option

## 👤 Author

Created for system administrators and IT professionals who need to quickly change RDP ports on Windows systems.

## 🔗 Related Resources

- [Microsoft RDP Documentation](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/welcome-to-rds)
- [Windows Firewall Configuration](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-firewall/windows-firewall-with-advanced-security)

---

**⚠️ Disclaimer**: Always test in a non-production environment first. Ensure you have physical or alternative remote access before changing RDP ports on remote systems.