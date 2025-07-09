import subprocess
import os
import sys
import tempfile

def extract_and_run():
    # Get the directory where the executable is running
    if getattr(sys, 'frozen', False):
        exe_dir = os.path.dirname(sys.executable)
    else:
        exe_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Path to the batch file (will be virtualized)
    batch_file = os.path.join(exe_dir, "quest 3 debloater.bat")
    
    # Run the batch file
    try:
        subprocess.run([batch_file], shell=True, check=True)
    except Exception as e:
        print(f"Error running batch file: {e}")
        input("Press Enter to exit...")

if __name__ == "__main__":
    extract_and_run()