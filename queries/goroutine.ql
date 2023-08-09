/**
 * @name Spawning a Go routine
 * @kind problem
 * @description The execution order of Go routines may cause a non-deterministic behavior and should not be used in consensus-critical code.
 * See: https://github.com/crytic/building-secure-contracts/tree/master/not-so-smart-contracts/cosmos/non_determinism
 * @precision low
 * @problem.severity recommendation
 * @id jaspersurmont/goroutine
 * @tags correctness
 */

import go
import abci

from ConsensusCriticalFuncDecl f, GoStmt goroutine
where
  //TODO: are protobuf files safe to use goroutines in?
  f = goroutine.getEnclosingFunction()
select goroutine, "Spawning a Go routine may be a possible source of non-determinism"
