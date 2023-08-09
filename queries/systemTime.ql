/**
 * @name Calling the system time
 * @description Calling the system time is non-deterministic and could cause issues in consensus-critical code.
 * @kind problem
 * @problem.severity warning
 * @id jaspersurmont/system-time
 * @precision medium
 * @tags correctness
 * 
 * See https://github.com/crypto-com/cosmos-sdk-codeql for original source
 */

import go
import abci


from CallExpr call, ConsensusCriticalFuncDecl f
where
  call.getTarget().getQualifiedName() = "time.Now" and
  // string formatting is usually a false positive (used in logging etc.),
  // but there could be false negatives (if the string formatting output is written to a consensus state)
  not (
    call.getParent().(CallExpr).getTarget().getQualifiedName() =
      "github.com/cosmos/cosmos-sdk/types.FormatTimeBytes" or
    call.getParent*().(CallExpr).getTarget().getQualifiedName().matches("fmt.Sprintf")
  ) and
  f = call.getEnclosingFunction() and
  // Telemetry is used to gather analytics about the application, and can be ignored: https://docs.cosmos.network/main/core/telemetry
  not exists(DataFlow::CallNode telemetryCall |
    telemetryCall
        .getExpr()
        .(CallExpr)
        .getTarget()
        .getQualifiedName()
        .matches("github.com/cosmos/cosmos-sdk/telemetry%")
  |
    DataFlow::localFlow(DataFlow::exprNode(call), telemetryCall.getAnArgument())
  )
select call, "Calling the system time may be a possible source of non-determinism"
