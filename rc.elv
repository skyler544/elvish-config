#############################################
##### imports
#############################################
use str;

#############################################
##### Environment
#############################################
set paths = [
    $@paths
    /Users/skyler.mayfield/.local/bin
    /Users/skyler.mayfield/homebrew/opt/php/bin
    /Users/skyler.mayfield/homebrew/bin
    /Users/skyler.mayfield/homebrew/sbin
    /Users/skyler.mayfield/.emacs.d/bin
    /usr/local/texlive/2022/bin/universal-darwin
    /Users/skyler.mayfield/.composer/vendor/bin
]

#############################################
##### Alias functions
#############################################
fn ls { | @dir |
    if (eq $dir []) {
        put (pwd)
        e:ls -G;
    } else {
        var flag;
        for d $dir {
            if (str:has-prefix $d -) {
                set flag = $d;
            } else {
                put $d;
                if (eq $nil $flag) {
                    e:ls -G $d;
                } else {
                    e:ls -G $flag $d;
                }
            }
        }
    }
}

fn m { | @arg |
    if (eq $arg []) {
        make -f Makefile.local
    } else {
        for a $arg {
            make -f Makefile.local $a
        }
    }
}

#############################################
##### Left Prompt = Current directory
#############################################
set edit:prompt = {
    put '[';
    tilde-abbr $pwd;
    put '] ';
}

#############################################
##### Right Prompt = Git Branch
#############################################
fn branch {
    put '['(git rev-parse --abbrev-ref HEAD)']';
}

fn splitter {
    str:split '-' (branch);
}

fn truncBranch {
    var @fullName = (splitter);
    var @identifier = (take 2 $fullName);
    var length = (count $identifier);
    var shortName = "wilderness";

    if (== $length 2) {
        set shortName = $identifier[0]'-'$identifier[1];
    }

    put $shortName;
}

set edit:rprompt = {
    if ?(test -d .git) {
        # if (str:contains (pwd) '/ps') {
        # styled (truncBranch) inverse;
        styled (branch) inverse;
    } else {
        # styled (whoami)@(hostname) inverse;
        styled '[sm'@'new-work]' inverse;
    }
}
