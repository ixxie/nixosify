# nixosify

Remotely converts a target Ubuntu/Debian system to NixOS using [Clever's kexec scripts](https://github.com/cleverca22/nix-tests/tree/master/kexec).

To achieve this, nixosify runs in a container on the deployment machine, running ssh commands on the target and polling it as it undergoes phases of the installation.

## usage

You can use nixosify in two ways: as a _Github Action_ or as a _local script_. The action is suitable for use in CI/CD workflows in Github, while the local script is handy for quick experiments or ad-hoc imperative conversion.

**Either way, nixosify needs a private/public key pair, which has been added to authorized keys of the target**.

### Parameters

There are four parameters for this script:
 - **target** - the IP address or URL of the machine to be converted
 - **tempkey** - the private temporary key uses during the install process
 - **tempkey_pub** - the public key corresponding to *tempkey* (must be on target autherized key list)
 - **authkeys** - a public key to be added to the autherized keys list of the resulting NixOS machine.

### Github Action

To use the Github Action, add the necessary keys to your repository as secrets, and use the action usual way in your workflow:

```
- name: Nixosify target
  uses: sparkletco/nixosify@master
  with:
    target: ${{ env.target_ip }}
    tempkey: ${{ secrets.workflow_key }}
    tempkey_pub: ${{ secrets.workflow_key_pub }}
    authkeys: ${{ env.authkey_pub }}
```

### local script

To run locally, make sure the appropriate key files needed as parameters are available and run the following:

```
git clone https://github.com/sparkletco/nixosify.git
cd ./nixosify
./nixosify-cli --target <target ip> --key <private key path> --pubkey <public key path> --authkey <authkey path>
```

The arguments of the `nixosify-cli` script also have single letter shorthands (`-t`, `-k`, `-p` and `-a` respectively).