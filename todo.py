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
outfmt = "- [ ] ({})[{}#L{}]:{}\n" # Not a forkbomb I promise
autoCommit = True
commitMsg = f"Updated TODO (commit performed automatically by `todo.py`)"



if __name__ == "__main__":

    out = [outhead]

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

    # Remove old output file
    if path.exists(outpath):
        rm = subprocess.run(f"rm {outpath}", capture_output=True)

    # Add to new output file
    with open(outpath, "w") as f:
        f.writelines(out)

    # Auto-commit enabled
    if autoCommit:
        # Grep the output of git status for any added changes
        cmd = "grep -q 'Changes to be committed:' <(git status)"
        # If the quiet grep returns 0 it's no-go
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
    # Auto-commit disabled
    else:
        print("".join(out))
    


