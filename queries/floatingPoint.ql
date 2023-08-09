/**
 * @name Floating point arithmetic
 * @kind problem
 * @description Floating point operations are not associative and may lead to surprising situations: https://github.com/crytic/building-secure-contracts/tree/master/not-so-smart-contracts/cosmos/non_determinism
 * @problem.severity warning
 * @precision low
 * @id jaspersurmont/floating-point
 * @tags correctness
 */

import go
import abci

from ConsensusCriticalFuncDecl f, ArithmeticBinaryExpr e
where
  (
    e.getLeftOperand().getType() instanceof FloatType or
    e.getRightOperand().getType() instanceof FloatType
  ) and
  f = e.getEnclosingFunction()
select e,
  "Floating point arithmetic operations are not associative and a possible source of non-determinism"
