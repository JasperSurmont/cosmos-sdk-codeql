/**
 * @name Using platform dependent types
 * @description Using platform dependent types might introduce non determinism: https://github.com/crytic/building-secure-contracts/tree/master/not-so-smart-contracts/cosmos/non_determinism
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id jaspersurmont/platform-dependent-types
 * @tags correctness
 */

import go
import abci

from ConsensusCriticalFuncDecl f, Variable v, Type t
where
  t = v.getType() and
  // these three types are platform dependent: https://go.dev/ref/spec (section 'Numeric types')
  (t instanceof IntType or t instanceof UintType or t instanceof UintptrType) and 
  v.getARead().getRoot() = f and
  // protobuf generated files often use int as intermediate values
  not f.getFile().getBaseName().matches("%.pb.%") and
  // ignore variables that are declared short-hand (:=), as these are often iterators or other simple (small) variables
  not exists(DefineStmt def | v.getDeclaration() = def.getAnLhs()) and
  // RangeStmt with := do not count as DefineStmt apparantly
  not exists(RangeStmt range | v.getDeclaration() = range.getKey()) 
  // We also ignore (int) variables that are assigned the result of len() as this value will not exceed 32 bits
  and not exists(Function len | len.getName() = "len" and v.getAWrite().getRhs() = len.getACall())
select v.getDeclaration(), "Using platform dependent types in ABCI methods might introduce non determinism"
