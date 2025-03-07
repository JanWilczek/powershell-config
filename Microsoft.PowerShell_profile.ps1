if ($IsMacOS) {
    $HOMEBREW_PREFIX = '/opt/homebrew'
    # Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$($HOMEBREW_PREFIX/bin/brew shellenv) | Invoke-Expression'
    $env:PATH += ':$HOMEBREW_PREFIX/bin'
    $env:PATH += ':/Users/jawi/dev/flutter/bin'
}

# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\unicorn.omp.json" | Invoke-Expression

oh-my-posh init pwsh --config "$PSScriptRoot/ohmyposh.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons

# fzf options
Set-PsFzfOption -EnableAliasFuzzyEdit -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r' -EnableAliasFuzzyGitStatus
# This does not work for some reason: crashes the prompt
# $env:EDITOR = "nvim"

# Set Some Option for PSReadLine to show the history of our typed commands
Import-Module -Name CompletionPredictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
# Set-PSReadLineOption -PredictionSource None

# Utility Command that tells you where the absolute path of commandlets are
function which ($command) {
 Get-Command -Name $command -ErrorAction SilentlyContinue |
 Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Add utilities to the Path but only in the terminal
if ($IsWindows) {
    $env:Path += ';D:\IT\Rust Projects\next_weeks_dates\target\release'
    $env:Path += ';C:\Users\admin\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-7.1-full_build\bin'

    function plantuml {
        java -jar 'D:\Programy\bin\plantuml.jar' $args
    }

    # From https://github.com/majkinetor/posh/blob/master/MM_Admin/Invoke-Environment.ps1
    function Invoke-Environment {
        param
        (
            # Any cmd shell command, normally a configuration batch file.
            [Parameter(Mandatory=$true)]
            [string] $Command
        )

        $Command = "`"" + $Command + "`""
        cmd /c "$Command > nul 2>&1 && set" | . { process {
            if ($_ -match '^([^=]+)=(.*)') {
                [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
            }
        }}

    }

    function init_msvc {
        Invoke-Environment 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat'
    }

    # Invoke immediately
    # init_msvc

    # Use fnm for managing NodeJS version
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

# This function tells Windows Terminal what the CWD is.
# From https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory
# But it overrides the nice oh-my-posh prompt
# function prompt {
#   $loc = $executionContext.SessionState.Path.CurrentLocation;
#
#   $out = ""
#   if ($loc.Provider.Name -eq "FileSystem") {
#     $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
#   }
#   $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
#   return $out
# }

# Disable ugly (venv) display
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# Aliases
Set-Alias e explorer
Set-Alias l ls
# Set-Alias ls ls --show-control-chars -F --color
# Set-Alias vi vim
# Set-Alias cbuild cmake -S . -B build 
# Set-Alias cmake2 C:\Android\Sdk\cmake\3.18.1\bin\cmake.exe 
# Set-Alias - cd -
function ... { cd ..\.. }
function .... { cd ..\..\.. }
# Set-Alias .... ../../..
# Set-Alias ..... ../../../..
# Set-Alias ...... ../../../../..
# Set-Alias 1 cd -1
# Set-Alias 2 cd -2
# Set-Alias 3 cd -3
# Set-Alias 4 cd -4
# Set-Alias 5 cd -5
# Set-Alias 6 cd -6
# Set-Alias 7 cd -7
# Set-Alias 8 cd -8
# Set-Alias 9 cd -9
# Set-Alias g git
function ga { git add $args }
# Set-Alias gaa git add --all
# Set-Alias gam git am
# Set-Alias gama git am --abort
# Set-Alias gamc git am --continue
# Set-Alias gams git am --skip
# Set-Alias gamscp git am --show-current-patch
# Set-Alias gap git apply
# Set-Alias gapa git add --patch
# Set-Alias gapt git apply --3way
# Set-Alias gau git add --update
# Set-Alias gav git add --verbose
function gb { git branch $args }
function gbD { git branch -D $args }
function gba { git branch -a $args }
function gbd { git branch -d $args }
# Set-Alias gbl git blame -b -w
# Set-Alias gbnm git branch --no-merged
# Set-Alias gbr git branch --remote
# Set-Alias gbs git bisect
# Set-Alias gbsb git bisect bad
# Set-Alias gbsg git bisect good
# Set-Alias gbsr git bisect reset
# Set-Alias gbss git bisect start
# Set-Alias gc git commit -v
# Set-Alias gc! git commit -v --amend
# Set-Alias gca git commit -v -a
# Set-Alias gca! git commit -v -a --amend
function gcam { git commit -a -m $args }
# Set-Alias gcan! git commit -v -a --no-edit --amend
# Set-Alias gcans! git commit -v -a -s --no-edit --amend
# Set-Alias gcas git commit -a -s
# Set-Alias gcasm git commit -a -s -m
# Set-Alias gcb git checkout -b
# # Set-Alias gcd git checkout $(git_develop_branch)
# Set-Alias gcf git config --list
# Set-Alias gcl git clone --recurse-submodules
# Set-Alias gclean git clean -id
# # Set-Alias gcm git checkout $(git_main_branch)
function gcmsg { git commit -m $args }
# Set-Alias gcn! git commit -v --no-edit --amend
function gco { git checkout $args }
# Set-Alias gcor git checkout --recurse-submodules
# Set-Alias gcount git shortlog -sn
# Set-Alias gcp git cherry-pick
# Set-Alias gcpa git cherry-pick --abort
# Set-Alias gcpc git cherry-pick --continue
# Set-Alias gcs git commit -S
# Set-Alias gcsm git commit -s -m
# Set-Alias gcss git commit -S -s
# Set-Alias gcssm git commit -S -s -m
function gd { git diff $args }
# Set-Alias gdca git diff --cached
# Set-Alias gdcw git diff --cached --word-diff
function gds { git diff --staged $args }
# Set-Alias gdt git diff-tree --no-commit-id --name-only -r
# # Set-Alias gdup git diff @{upstream}
# Set-Alias gdw git diff --word-diff
# Set-Alias gf git fetch
# Set-Alias gfa git fetch --all --prune --jobs=10
# Set-Alias gfg git ls-files | grep
function gfo { git fetch origin $args }
# Set-Alias gg git gui citool
# Set-Alias gga git gui citool --amend
# # Set-Alias ggpull git pull origin "$(git_current_branch)"
# Set-Alias ggpur ggu
# # Set-Alias ggpush git push origin "$(git_current_branch)"
# # Set-Alias ggsup git branch --set-upstream-to=origin/$(git_current_branch)
# Set-Alias ghh git help
# Set-Alias gignore git update-index --assume-unchanged
# # Set-Alias gignored git ls-files -v | grep "^[[:lower:]]"
# # Set-Alias gk \gitk --all --branches &!
# # Set-Alias gke \gitk --all $(git log -g --pretty=%h) &!
function gll { git pull $args }
# Set-Alias glg git log --stat
# Set-Alias glgg git log --graph
# Set-Alias glgga git log --graph --decorate --all
# Set-Alias glgm git log --graph --max-count=10
# Set-Alias glgp git log --stat -p
# Set-Alias glo git log --oneline --decorate
# Set-Alias globurl noglob urlglobber
# Set-Alias glog git log --oneline --decorate --graph
# Set-Alias gloga git log --oneline --decorate --graph --all
# Set-Alias glp _git_log_prettily
# Set-Alias glum git pull upstream $(git_main_branch)
function gme { git merge $args }
# Set-Alias gma git merge --abort
# Set-Alias gmom git merge origin/$(git_main_branch)
# Set-Alias gmtl git mergetool --no-prompt
# Set-Alias gmtlvim git mergetool --no-prompt --tool=vimdiff
# Set-Alias gmum git merge upstream/$(git_main_branch)
function gph { git push }
# Set-Alias gpd git push --dry-run
# Set-Alias gpf git push --force-with-lease
# Set-Alias gpf! git push --force
# Set-Alias gpoat git push origin --all && git push origin --tags
# Set-Alias gpr git pull --rebase
# Set-Alias gpristine git reset --hard && git clean -dffx
# Set-Alias gpsup git push --set-upstream origin $(git_current_branch)
# Set-Alias gpu git push upstream
# Set-Alias gpv git push -v
# Set-Alias gr git remote
# Set-Alias gra git remote add
# Set-Alias grb git rebase
# Set-Alias grba git rebase --abort
# Set-Alias grbc git rebase --continue
# Set-Alias grbd git rebase $(git_develop_branch)
# Set-Alias grbi git rebase -i
# Set-Alias grbm git rebase $(git_main_branch)
# Set-Alias grbo git rebase --onto
# Set-Alias grbom git rebase origin/$(git_main_branch)
# Set-Alias grbs git rebase --skip
# # Set-Alias grep grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}
# Set-Alias grev git revert
# Set-Alias grh git reset
# Set-Alias grhh git reset --hard
# Set-Alias grm git rm
# Set-Alias grmc git rm --cached
# Set-Alias grmv git remote rename
# Set-Alias groh git reset origin/$(git_current_branch) --hard
# Set-Alias grrm git remote remove
# Set-Alias grs git restore
# Set-Alias grset git remote set-url
# Set-Alias grss git restore --source
# Set-Alias grst git restore --staged
# Set-Alias grt cd "$(git rev-parse --show-toplevel || echo .)"
# Set-Alias gru git reset --
# Set-Alias grup git remote update
# Set-Alias grv git remote -v
# Set-Alias gsb git status -sb
# Set-Alias gsd git svn dcommit
# Set-Alias gsh git show
# Set-Alias gsi git submodule init
# Set-Alias gsps git show --pretty=short --show-signature
# Set-Alias gsr git svn rebase
# Set-Alias gss git status -s
function gst { git status }
function gsta { git stash push }
function gstaa { git stash apply }
# Set-Alias gstall git stash --all
# Set-Alias gstc git stash clear
# Set-Alias gstd git stash drop
# Set-Alias gstl git stash list
# Set-Alias gstp git stash pop
# Set-Alias gsts git stash show --text
# Set-Alias gstu gsta --include-untracked
# Set-Alias gsu git submodule update
# Set-Alias gsw git switch
# Set-Alias gswc git switch -c
# Set-Alias gswd git switch $(git_develop_branch)
# Set-Alias gswm git switch $(git_main_branch)
# Set-Alias gts git tag -s
# Set-Alias gtv git tag | sort -v
# Set-Alias gunignore git update-index --no-assume-unchanged
# Set-Alias gunwip git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset head~1
# Set-Alias gup git pull --rebase
# Set-Alias gupa git pull --rebase --autostash
# Set-Alias gupav git pull --rebase --autostash -v
# Set-Alias gupv git pull --rebase -v
# Set-Alias gwch git whatchanged -p --abbrev-commit --pretty=medium
# Set-Alias gwip git add -a; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify  --no-gpg-sign -m "--wip-- [skip ci]"
# Set-Alias history omz_history
# Set-Alias l ls -lah
# Set-Alias la ls -lah
# Set-Alias ll ls -lh
# Set-Alias ls ls --color=tty
# Set-Alias lsa ls -lah
# Set-Alias md mkdir -p
# Set-Alias rd rmdir
# Set-Alias run-help man
# Set-Alias which-command whence
# Set-Alias vs call "c:\program files (x86)\microsoft visual studio\2019\professional\vc\auxiliary\build\vcvarsall.bat" x86_amd64 && set preferredtoolarchitecture=x64 && devenv
function mmj { Set-Location C:\Projects\music-maker-jam\ }
function mmj1 { Set-Location C:\Projects\MMJ-copy\ }
function mmj2 { Set-Location C:\Projects\MMJ-copy2\ }
function mmj3 { Set-Location C:\Projects\MMJ3\ }
function mmj4 { Set-Location C:\Projects\MMJ4\ }
function mmj5 { Set-Location C:\Projects\MMJ5\ }
# Set-Alias nvim-qt "c:\program files\neovim\bin\nvim-qt.exe"
# Set-Alias nvim "c:\program files\neovim\bin\nvim.exe"
function reload { . $PROFILE }
function settings { code $PROFILE }
# Set-Alias fnd C:\Tools\cmder_mini\vendor\git-for-windows\usr\bin\find.exe

function wolfsound { cd "~\Documents\Jan\WolfSound" }
Set-Alias grep Select-String

function cmb { cmake --build build $args }
function cmc { cmake -S . -B build $args }
function cmcp { cmake --preset $args }
function cmcpd { cmake --preset default $args }
function ctp { ctest --preset $args }
function lg { lazygit $args }

# Git helper must come after the aliases
Import-Module posh-git

