/**
 * @name Iteration over map
 * @description Iteration over map is non-deterministic and could cause issues in consensus-critical code: https://go.dev/blog/maps#iteration-order
 * @kind problem
 * @precision low
 * @problem.severity warning
 * @id jaspersurmont/map-iteration
 * @tags correctness
 */

import go
import abci

from RangeStmt loop, ConsensusCriticalFuncDecl f
where
  f = loop.getEnclosingFunction() and

  loop.getDomain().getType() instanceof MapType and
  // ignore iterations over maps where keys are subsequently sorted
  not exists(
    Assignment a, CallExpr sort, VariableName unsorted, VariableName sorted, VariableName key
  |
    loop.getBody().getAChild*() = a and
    sort.getTarget().getQualifiedName().prefix(4) = "sort" and
    a.getAnRhs().getAChild*() = key and
    key.getTarget() = loop.getKey().(VariableName).getTarget() and
    a.getAnLhs() = unsorted and
    sort.getAnArgument() = sorted and
    unsorted.getTarget() = sorted.getTarget() and
    loop.getParent*().getAChild*() = sort
  )
select loop, "Iteration over map may be a possible source of non-determinism"
