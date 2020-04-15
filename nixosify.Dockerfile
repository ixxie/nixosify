# iso build environment

FROM nixos/nix AS builder

RUN nix-channel --add https://nixos.org/channels/nixos-unstable nixos
RUN nix-channel --update

RUN mkdir /kexec
ADD kexec /kexec

RUN cd / && nix-build '<nixpkgs/nixos>' -Q -j auto \
  -A config.system.build.kexec_tarball \
  -I nixos-config="/kexec/kexec-config.nix"

# actual image

FROM nixos/nix

RUN nix-env -i bash openssh

COPY --from=builder /result/tarball/nixos-system-x86_64-linux.tar.xz /
