export ZSH="/Users/$USER/.oh-my-zsh"
export CLICOLOR=1
source $ZSH/oh-my-zsh.sh
export PROMPT="%1~ > "
ZSH_THEME="robbyrussell"

# Use the right arrow for auto completion
plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    brew
    vi-mode
)

alias setupzsh="\
export PATH=$HOME/bin:/usr/local/bin:$PATH && \
sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions"

alias setupgit="\
git config --global user.name <name> && \
git config --global user.email <name>@<domain> && \
git config --global pager.branch false && \
git config --global commit.gpgsign true"

alias setupvimpkg="\
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
cd ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go && \
git clone https://github.com/tpope/vim-surround.git ~/.vim/bundle/vim-surround && \
git clone https://github.com/vim-airline/vim-airline.git ~/.vim/bundle/vim-airline && \
git clone https://github.com/preservim/nerdcommenter.git ~/.vim/bundle/nerd-commenter && \
git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree && \
git clone https://github.com/ackyshake/Spacegray.vim.git ~/.vim/bundle/spacegray.vim && \
git clone https://github.com/vim-scripts/bash-support.vim ~/.vim/bundle/bash-support.vim && \
git clone https://github.com/valloric/youcompleteme ~/.vim/bundle/youcompleteme && \
git submodule update --init --recursive && python3 install.py --go-completer"

alias setupvimrc="cat > ~/.vimrc << 'EOF'
execute pathogen#infect()

\" Core
set rnu number nowrap tabstop=4 shiftwidth=4 expandtab \"lazyredraw
\"colorscheme spacegray \" Light-ish grey, less harsh contrast
set mouse=a 		  \" Allow using mouse
syntax on 			  \" Syntax highlighting
set backspace=indent,eol,start \" Allow backspacing at the start of a line
set undofile \" Maintain undo history between sessions
set undodir=~/.vim/undodir \" Need to mkdir beforehand

\" Quick escape mode without leaving home row. Note the 'i' in inoremap means
\" it only pplies to insert mode
inoremap jj <c-c>\`^
inoremap jk <c-c>\`^

\" Comment only in normal mode
\" Use 'gcc' to toggle comment/uncomment
filetype plugin on
noremap cc <C-o>:call NERDCommenterComment(0,"toggle")<CR>
let g:NERDCreateDefaultMappings = 1
let mapleader="g"

\" File manager: nerd-tree
filetype plugin indent on
map <C-n> :NERDTreeToggle<CR>

\" Go programming: vim-go
\" See :help vim-go (may need to run :helptags ALL)
\" https://gist.github.com/krlvi/d22bdcb66566261ea8e8da36f796fa0a
\" Show auto complete when you type dot or ctrl+n, ctrl+n selects next, ctrl+p selects previous, ctrl+w closes the window.
\" Use gd or ctrl+] jumps to the definition of a function or object and ctrl+t to go back
\" Use :GoCoverage to show red/green functions in a test file, :GoCoverageClear, :GoCoverageToggle
\" Use :GoAlternate to switch between the file and its _test.go
\" Use :GoCallers to see function usages
\" shift+t shows you the method signature
\" Use :'<,'>GoFreevars to extract a function or visual select then :GoFreevars
\"       (Getting \"guru cannot find module providing package\")
\" Use :GoRename to refactor
\" Use [[ or ]] to skip to the next/prev function
\"
\" Close windowsplit
nnoremap <leader>x <C-w>c

\"autocmd FileType go nmap <leader>r <Plug>(go-rename)
\"autocmd FileType go nmap <leader>t <Plug>(go-test-func)
au filetype go inoremap <buffer> . .<C-x><C-o>
let g:go_guru_scope=["/Users/<name>/proj/go/src/"]
\"let g:go_fmt_command = "goimports" \" Auto run imports on each save
let g:go_auto_type_info = 1 \" Automatically get signature/type info for object under cursor
let g:go_auto_sameids = 1 \" Automatically highlight the same variable in scope
au BufWritePost *.go !gofmt -w %
EOF"

alias setupnewmachine="setupzsh && setupgit && setupvimpkg && setupvimrc"

# Dev
export GPG_TTY=$(tty)
export GOPATH=~/proj/go/
alias pip="pip3"

# Git
alias gaa="git add --all"
alias gcom="git checkout main"
alias gl="git log"
alias gst="git stash"
alias gstp="git stash pop"
alias gc="git commit -m"
alias gs="git status"
alias gp="git pull --rebase origin main"
alias gps="git push origin main"
alias gb="git branch"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gd="git diff HEAD"
alias gbl="git blame --date short"

# Terminal
alias ls='ls --color=always'
alias ll='ls -lah --color=always'
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'

# Docker
alias dcl="docker system prune --all" # BE CAREFUL WITH THIS
alias dps="docker ps"
alias dec="docker exec -it"
alias dk="docker kill"

# Kubernetes
#export KUBECONFIG=~/.kube/configs/dev/config
alias kcx="kubectl config set-context --current --namespace"
alias kgp="kubectl get pods"
alias wkgp="watch kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'"
alias ka='kubectl apply -f'
alias kc='kubectl create -f'
alias kr='kubectl replace -f'
alias kd='kubectl delete -f'
alias kl='kubectl logs'
alias kt='kubectl top'
alias ke='kubectl exec -it'
# BE CAREFUL WITH THIS! - Clears everything in my namespace
alias kcl='kubectl delete deploy,cm,po,svc,rc,rs,sts --all --namespace $USER'
# Get pods and sort by number of restarts ascending
alias kgpn='kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName'
