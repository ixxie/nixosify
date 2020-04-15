# action dockerfile

FROM sparkletco/nixosify:v2.0

RUN mkdir /kit
ADD kit /kit

COPY configuration.nix /configuration.nix
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
