[![Githbu actions build status](https://img.shields.io/github/workflow/status/jappeace/persistent-event-source/Test)](https://github.com/jappeace/haskell-template-project/actions)
[![Hackage version](https://img.shields.io/hackage/v/template.svg?label=Hackage)](https://hackage.haskell.org/package/persistent-event-source) 

Persistent based event sourcing.

TODO:

+ [ ] Add event ordering code.
+ [ ] Prove correctness of event ordering.

## Usage

### Modifying for your project
Assuming the name of your new project is `new-project`.

```
git clone git@github.com:jappeace/persistent-event-source.git new-project
cd new-project
```

### Tools
Enter the nix shell.
```
nix-shell
```
You can checkout the makefile to see what's available:
```
cat makefile
```

### Running
```
make run
```

### Fast filewatch which runs tests
```
make ghcid
```
