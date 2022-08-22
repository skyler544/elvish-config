use str

set edit:prompt = {
    put '[';
    tilde-abbr $pwd;
    put '] ';
}

set paths = [
    $@paths
    /Users/skyler.mayfield/homebrew/bin
    /Users/skyler.mayfield/.emacs.d/bin
    /usr/local/texlive/2022/bin/universal-darwin
]

# git branch in the work repo
fn branch {
  put (git rev-parse --abbrev-ref HEAD)
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
  # if ?(test -d .git) {
  if (str:contains (pwd) '/ps') {
    styled (truncBranch) inverse;
  } else {
    styled (whoami)@(hostname) inverse;
  }
}
