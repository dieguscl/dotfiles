# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'
alias decompress='tar -xzf'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias c='opencode'
alias cx='printf "\033[2J\033[3J\033[H" && claude --allow-dangerously-skip-permissions'
alias d='docker'
alias t='tmux attach || tmux new -s Work'

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# Kubernetes
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgd='kubectl get deployments'
alias kgs='kubectl get services'
alias kgn='kubectl get nodes'
alias kgns='kubectl get namespaces'
alias kgi='kubectl get ingress'
alias kgcm='kubectl get configmaps'
alias kgsec='kubectl get secrets'
alias kgpv='kubectl get pv'
alias kgpvc='kubectl get pvc'
alias kgsc='kubectl get storageclass'
alias kgsts='kubectl get statefulsets'
alias kgds='kubectl get daemonsets'
alias kgj='kubectl get jobs'
alias kgcj='kubectl get cronjobs'
alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kdd='kubectl describe deployment'
alias kds='kubectl describe service'
alias kdn='kubectl describe node'
alias kdel='kubectl delete'
alias kdelp='kubectl delete pod'
alias ka='kubectl apply -f'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias ke='kubectl exec -it'
alias kctx='kubectl config current-context'
alias kns='kubectl config set-context --current --namespace'
alias ktop='kubectl top'
alias ktopp='kubectl top pods'
alias ktopn='kubectl top nodes'
alias krs='kubectl rollout status'
alias krr='kubectl rollout restart'
alias kpf='kubectl port-forward'
alias ksc='kubectl scale'

# Transpara
alias longhorn-expose="kubectl port-forward --namespace longhorn-system svc/longhorn-frontend 9000:80 --address 0.0.0.0"
# Release state per version: <version>  <state>  <last transition at>.
# Usage: relstate [index.yaml]  (no arg = pull live tinstaller-channels:stable)
relstate() {
  local f=$1 d=
  if [ -z "$f" ]; then
    d=$(mktemp -d) || return
    oras pull -o "$d" registry.transpara.com/transpara/artifacts/tinstaller-channels:stable >/dev/null || { rm -rf "$d"; return 1; }
    f=$d/index.yaml
  fi
  yq '.versions | to_entries[] | [.key, .value.state, .value.history[-1].at] | join("  ")' "$f"
  [ -n "$d" ] && rm -rf "$d"
}

# Tailscale
alias tsm="sudo tailscale switch myself"
alias tsw="sudo tailscale switch work"

# Editors
alias vi="nvim"
alias vim="nvim"

# Tmux
alias tms="tmux-sessionizer"
alias tmw="tmux-windowizer"
