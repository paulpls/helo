#
#   Todo-extraction utility
#



from os import path
import subprocess
from sys import stdout



# Setup
inpath = "*.lua"
pattern = "TODO"
cmd = f"grep -n {pattern} {inpath}"
outpath = "TODO.md"
outhead = "# TODO\n"
outfmt = "- [ ] [{}]({}#L{}):{}\n" # Not a forkbomb I promise
autoCommit = False
note = "_NOTE: This file should be auto-generated using `todo.py`_  \n  \n"
commitMsg = "\"Updated TODO (commit performed automatically by \\`todo.py\\`)\""



if __name__ == "__main__":

    out = [outhead, note]
    success = True

    # Get list of matches
    grep = subprocess.run(cmd, shell=True, capture_output=True)

    # Decode output using system stdout's encoding
    grep = [str(b, stdout.encoding) for b in grep.stdout.split(b"\n")]

    # Iterate through matches
    for m in grep: 
        # Skip any blanks that appear
        if not m:
            continue
        # Split the string into file, line, and contents
        s = m.split(":")
        f = s[0]
        l = s[1]
        c = s[-1].split("TODO")[-1]
        # Add to output using the provided format
        out.append(outfmt.format(f,f,l,c))

    # Remove old file if there are differences
    if path.exists(outpath):
        # Check for differences
        with open(outpath, "r") as f:
            lines = f.readlines()
            try:
                same = [out[ln] == lines[ln] for ln in range(len(out))]
            except IndexError as e:
                same = [False]
                pass
        diff = not all(same)
        # Remove the file
        if diff:
            rm = subprocess.run(f"rm {outpath}", shell=True, capture_output=True)
            success = rm.returncode == 0
        else:
            print("Files are the same; no changes to write.")

    # Add to new output file if successful thus far
    if success:
        with open(outpath, "w") as f:
            f.writelines(out)

        # Auto-commit if enabled
        if autoCommit:
            # Grep the output of git status for any added changes
            cmd = "git status | grep -q 'Changes to be committed:'"
            # If the quiet grep returns 0 we're no good
            clean = not subprocess.run(cmd, shell=True).returncode
            # If no changes have been added, auto-commit the output file
            if clean:
                add = f"git add {outpath}"
                commit = f"git commit -m {commitMsg}"
                subprocess.run(add, shell=True)
                subprocess.run(commit, shell=True)
            # Skip auto-commit if there are previous changes to commit
            else:
                print(f"Git working tree is not clean!\nSkipping auto-commit for {outpath}")
    


