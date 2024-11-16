# Screen-Starter v2

A Bash script to manage GNU `screen` sessions with logging, restart, and cleanup functionalities.

## Features
- **Start a new screen session**:
  Automatically creates a detached `screen` session in a specified directory and runs a command.
- **Logging**:
  Tracks all started sessions in `.screensHistory.log` and active sessions in `.screensActive.log`.
- **Restart sessions**:
  Restart all active sessions listed in `.screensActive.log`.
- **Remove sessions**:
  Terminate all active sessions and clean up their temporary log files.
- **Help menu**:
  A detailed help option to guide usage.

---

## Prerequisites
Ensure `screen` is installed and available on your system.

### Install `screen` on Debian or Ubuntu:
```sh
sudo apt install screen
```

### Install `screen` on Arch Linux:
```sh
sudo pacman -S screen
```

---

## Usage
### 1. Start a new screen session:
```sh
./startScreen.sh <screen_name> <path> <command>
```
- **`screen_name`**: Name of the screen session.
- **`path`**: Directory where the command will execute.
- **`command`**: Command to run in the screen session.

Example:
```sh
./startScreen.sh my_session /home/user/project "python3 script.py"
```

### 2. Restart all active sessions:
```sh
./startScreen.sh -Re
```
- Reads `.screensActive.log`, terminates active sessions, and restarts them using the directory and command logged in `.screensHistory.log`.

### 3. Remove all active sessions:
```sh
./startScreen.sh -rm
```
- Terminates all sessions listed in `.screensActive.log` and deletes related temporary logs.

### 4. Display help menu:
```sh
./startScreen.sh -h
```
- Prints usage instructions and options.

---

## Logs
1. **`.screensHistory.log`**:
   - Tracks all screen sessions ever started with details of the directory and command.
2. **`.screensActive.log`**:
   - Tracks currently active screen sessions.

Both log files are created in the script's directory.

---

## Key Features Explained
- **Session Management**:
  Automatically ensures no duplicate session names are created and validates paths before starting sessions.
- **Temporary Logs**:
  Each session's output is logged to `/tmp/<screen_name>.log` for easy debugging and monitoring.
- **Automation**:
  Restart or remove all active sessions with a single command.

---

## Example Scenarios
1. **Start a screen session**:
   ```sh
   ./startScreen.sh my_server /var/www "npm start"
   ```
   This starts a session named `my_server` in `/var/www` and runs `npm start`.

2. **Restart all sessions**:
   ```sh
   ./startScreen.sh -Re
   ```
   Restarts all active sessions, preserving the original command and directory.

3. **Remove all sessions**:
   ```sh
   ./startScreen.sh -rm
   ```
   Terminates all active sessions and cleans up logs.

---

## Notes
- Ensure proper permissions for the script and log files.
- Always verify the validity of the directory and command arguments.

---

### Contribute
Feel free to submit issues or pull requests to improve functionality or add features.
