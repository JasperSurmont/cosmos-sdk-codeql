/**
 * @name Panic in BeginBock or EndBlock consensus methods
 * @description Panics in BeginBlocker and EndBlocker could cause a chain halt: https://github.com/crytic/building-secure-contracts/tree/master/not-so-smart-contracts/cosmos/abci_panic
 * @kind path-problem
 * @precision high
 * @problem.severity warning
 * @id jaspersurmont/beginendblock-panic
 * @tags correctness
 */

import go
import abci

query predicate edges(CallNode a, CallNode b) {
  a.getACallee() = b.getRoot()
}


from CallNode panic, CallNode src
where
  panic.getTarget().mustPanic() and
  edges*(src, panic) and
  // panics are often desired in these packages
  not panic.getFile().getPackageName().matches(["crisis", "upgrade", "%mock%"]) and
  src.getEnclosingCallable().asFunction() = getABeginEndBlockFunc()
select panic, src, panic, 
  "Possible panics in BeginBock- or EndBlock-related consensus methods could cause a chain halt"
