# action dockerfile

FROM sparkletco/nixosify:v2.0

COPY configuration.nix /configuration.nix
COPY lib.sh /lib.sh
COPY nixosify /nixosify

ENTRYPOINT ["/nixosify"]
