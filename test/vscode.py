import vscode

# Get the currently active VSCode window
win = vscode.window.active_window

# Get a list of currently open text editors
editors = win.visible_text_editors

# Print the file names of the open editors
for editor in editors:
    print(editor.document.uri.fs_path)
