[![Githbu actions build status](https://img.shields.io/github/workflow/status/jappeace/persistent-eventsource/Test)](https://github.com/jappeace/persistent-eventsource/actions)
[![Hackage version](https://img.shields.io/hackage/v/template.svg?label=Hackage)](https://hackage.haskell.org/package/persistent-eventsource) 

Persistent based event sourcing.

TODO:

+ [x] Add event ordering code.
+ [ ] Prove correctness of event ordering.
+ [ ] I'd like to also add the reapply in a transaction
      code, we'd need to refactor so the tables are known
      by the system so we can automatically generate a truncate query.
+ [ ] Upstream Database.Esqueleto.* to the right package

## Usage

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
