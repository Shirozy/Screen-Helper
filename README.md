# Screen-Starter
A simple Shell Script function to start a screen session and run a tool or program. 

## Prerequisites
screen (must be installed and available on your system)

### Download screen on Debian or Ubuntu:
```
sudo apt install screen
```
### Download Screen On Arch:
```
sudo pacman -S screen
```

# What does the function do?
Starts a new detached screen session with a specified name, path, and command.
    
    This function checks for the correct number of arguments and verifies that the
    specified directory exists. It ensures that a screen session with the given name
    does not already exist, and if these conditions are met, it creates a new
    detached screen session in the specified directory and runs the provided command.
    The session's output is logged to a temporary file.

    Arguments:
    screen_name (str): The name of the screen session to be created.
    path (str): The directory path where the command should be executed.
    command (str): The command to execute in the new screen session.

    Returns:
    int: Returns 1 if any error occurs (wrong number of arguments, non-existent directory,
         existing screen session, or failure to start the session); otherwise, it provides
         informative messages about the success or failure of the session creation.

## How To Use: (Example)
```sh
start_screen "screen_name" "path/to/directory" "command_to_run"
```
