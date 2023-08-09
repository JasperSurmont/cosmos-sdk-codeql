## Result type
1. True positive: Found by query and is an actual vulnerability
2. False positive: Found by query but is not an actual vulnerability
3. True negative: Not found by query but is an actual vulnerability

## Reasons for false positives
1. Not in an ABCI path (e.g. present in test or simulation packages)
2. Never used (e.g. a function that is never called)
3. Not what query author intended (query too broad)
4. Does not perform deterministic-dependent actions (e.g. cloning a map in range over map, or goroutines with only prints)
5. Protobuf (or other auto generated) files should be ignored
6. Genesis related code can be ignored?
7. Bech32 constant is later passed to the config
8. Int is a small constant value which does not affect architectures

## Reasons for unknow
1. The code is not understood well enough to make a decision
2. Unsure whether the result can be nondeterministic


## Rule ID
1. BeginEndBlock Panic
2. Map Iteration
3. Bech32 
4. Goroutine
5. Floating Point
6. System time
7. Sensitive Import
8. Platform Dependent types 