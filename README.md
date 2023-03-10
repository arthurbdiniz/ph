# ph (Patch Helper)

**ph** is a tool that helps manage patches separated from the upstream code. This documentation will guide you on how to use and install **ph**.

## Dependencies

**ph** has two dependencies, `curl` and `git`. Ensure that you have these two installed before using **ph**.

## Install

To install **ph**, run the following command in your terminal:

```bash
curl -sOL https://raw.githubusercontent.com/arthurbdiniz/ph/main/ph | sudo mv ph /usr/local/bin/
```

## Commands

Here are the available commands in **ph**:

```bash
Usage: ph [command] [option]
Commands:
  start     Prepare patching branch applying pre existent patches
  pack      Save created patches to a folder and checkout to patches branch
  --help
```

## Branches

There are three branches in **ph**:

- `main`: Stores the upstream code as is and should not be modified.
- `patches`: Orphan branch that doesn't have the history from main and is responsible for versioning patch files.
- `patching`: Temporary branch to work and test new patches, this branch will have the old patches applied.


```
o---o---o  main
         \
          o---o---o  patching
         /
o-------o  patches (orphan)
```

## Start

The `start` command is responsible for creating a new branch called `patching` containing commits from `main` and `patches` branch rebased on top. Then all patches inside `patches/*` folder will be applied to the code one by one. After that, you are ready to start modifying the code. Don't forget that every commit will become a patch.

## Pack

The `pack` command will do the reverse process from start, packing patch commits made into `patches/` folder, and then checking out to the `patches` branch to be possible to version the modifications made.

Once in the patches branch, you can run:

```bash
git add patches/
git commit -m "Initial patch"
git push origin patches
```

## License

**ph** is licensed under the Apache 2 License. For more details, please see [LICENSE](https://github.com/arthurbdiniz/ph/blob/main/LICENSE).