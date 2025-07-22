# Windows 11 Setup Scripts

A collection of scripts designed to automate and customize the setup of Windows 11 machines. These scripts help streamline the process of removing unwanted features, enhancing privacy, installing essential software, and preparing development environments.

---

## 🔧 Features

### ✅ System Configuration Tweaks
- Disables Windows telemetry and web search suggestions.
- Prevents automatic restarts for updates while users are logged in.

### 🗑 App and Bloatware Removal
- Uninstalls OneDrive and deletes residual folders.
- Removes preinstalled Microsoft Store apps like:
  - Microsoft To-Do
  - Office Hub
  - Outlook for Windows
  - Solitaire Collection
  - Clipchamp
  - Quick Assist
- Silently removes Microsoft Teams via `winget`.

---

## 🚀 Usage

For Callum's setup (dev)
```powershell
powershell -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/howzitcal/quick11/refs/heads/main/callum_start.bat' -OutFile '$env:TEMP\temp_script.bat'; Start-Process '$env:TEMP\temp_script.bat'"
```

---

## 🧠 Philosophy

These scripts are opinionated and aim to reduce clutter while preparing a machine for daily or development use. They follow a "less is more" approach: remove what you don’t need, install what you do.

> _"Remember that you came from dust, and to dust you shall return. Make it count."_

---
