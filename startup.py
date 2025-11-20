import os
import readline
import atexit
import sys

if "PYTHONHISTFILE" in os.environ:
    history = os.path.expanduser(os.environ["PYTHONHISTFILE"])
elif "XDG_STATE_HOME" in os.environ:
    history = os.path.join(
        os.path.expanduser(os.environ["XDG_STATE_HOME"]), "python", "history"
    )
else:
    history = os.path.join(os.path.expanduser("~"), ".python_history")

history = os.path.abspath(history)
_dir, _ = os.path.split(history)
os.makedirs(_dir, exist_ok=True)

try:
    readline.read_history_file(history)
except IOError:
    pass

atexit.register(readline.write_history_file, history)
