FROM docker.io/archlinux:base-devel

RUN pacman -Syu --noconfirm \
    grml-zsh-config \
    zsh \
    zsh-autosuggestions \
    zsh-completions \
    zsh-doc \
    zsh-history-substring-search \
    zsh-lovers \
    zsh-syntax-highlighting \
    docker \
    docker-compose \
    && pacman -Scc --noconfirm

ENTRYPOINT ["sh", "-c", "setpriv --inh-caps=-all --reuid=$USER --regid=$USER --init-groups --reset-env \"$@\"", "entrypoint"]
CMD ["zsh"]
