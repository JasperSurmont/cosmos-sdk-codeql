/**
 * @name Sensitive package import
 * @kind problem
 * @description Certain system packages may cause a non-deterministic behavior and should be avoided when possible
 * @problem.severity recommendation
 * @precision low
 * @id jaspersurmont/sensitive-import
 * @tags correctness
 */

import go
import abci

predicate isSensitiveImport(string packageName) {
  packageName = "unsafe" or
  packageName = "rand" or
  packageName = "reflect" or
  packageName = "runtime"
}


from ImportSpec imp, ConsensusCriticalFuncDecl f
where
  isSensitiveImport(imp.getPath()) and
  f = imp.getFile().getADecl()
select imp,
  "Certain system packages contain functions which may be a possible source of non-determinism"
